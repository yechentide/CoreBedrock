//
// Created by yechentide on 2025/11/20
//

public import Foundation

private func blockPaletteEntriesAreEquivalent(_ lhs: CompoundTag, _ rhs: CompoundTag) -> Bool {
    nbtTagsAreStructurallyEquivalent(lhs, rhs)
}

// swiftlint:disable cyclomatic_complexity
/// NBT's public Equatable conformance intentionally uses object identity. Palette
/// entries need value semantics so repeated placement of the same block state does
/// not append a duplicate entry for every block.
private func nbtTagsAreStructurallyEquivalent(_ lhs: NBT, _ rhs: NBT) -> Bool {
    guard lhs.tagType == rhs.tagType, lhs.name == rhs.name else { return false }

    switch (lhs, rhs) {
    case let (lhs as ByteTag, rhs as ByteTag):
        return lhs.value == rhs.value
    case let (lhs as ShortTag, rhs as ShortTag):
        return lhs.value == rhs.value
    case let (lhs as IntTag, rhs as IntTag):
        return lhs.value == rhs.value
    case let (lhs as LongTag, rhs as LongTag):
        return lhs.value == rhs.value
    case let (lhs as FloatTag, rhs as FloatTag):
        return lhs.value.bitPattern == rhs.value.bitPattern
    case let (lhs as DoubleTag, rhs as DoubleTag):
        return lhs.value.bitPattern == rhs.value.bitPattern
    case let (lhs as StringTag, rhs as StringTag):
        return lhs.value == rhs.value
    case let (lhs as ByteArrayTag, rhs as ByteArrayTag):
        return lhs.value == rhs.value
    case let (lhs as IntArrayTag, rhs as IntArrayTag):
        return lhs.value == rhs.value
    case let (lhs as LongArrayTag, rhs as LongArrayTag):
        return lhs.value == rhs.value
    case let (lhs as ListTag, rhs as ListTag):
        guard lhs.listType == rhs.listType, lhs.count == rhs.count else { return false }

        return zip(lhs.tags, rhs.tags).allSatisfy(nbtTagsAreStructurallyEquivalent)
    case let (lhs as CompoundTag, rhs as CompoundTag):
        guard lhs.count == rhs.count else { return false }

        return lhs.allSatisfy { child in
            guard let name = child.name, let other = rhs[name] else { return false }

            return nbtTagsAreStructurallyEquivalent(child, other)
        }
    default:
        return false
    }
}

// swiftlint:enable cyclomatic_complexity

public struct ExpandedSubChunk {
    private struct NormalizedBlockLayer {
        let palette: [CompoundTag]
        let indices: [UInt16]
    }

    private static let persistedPaletteBitWidths = [1, 2, 3, 4, 5, 6, 8, 16]

    public let version: Int
    public let chunkY: Int8

    public var blockLayer: ExpandedBlockLayer
    public var liquidLayer: ExpandedBlockLayer?

    public init(version: Int, chunkY: Int8, blockLayer: ExpandedBlockLayer, liquidLayer: ExpandedBlockLayer? = nil) {
        self.version = version
        self.chunkY = chunkY
        self.blockLayer = blockLayer
        self.liquidLayer = liquidLayer
    }

    public init(data: Data, chunkY: Int8) throws {
        let subchunkParser = SubChunkParser(data: data, chunkY: chunkY)
        guard let packed = try subchunkParser.parsePackedLayer() else {
            throw CBError.failedParseSubchunk
        }

        self.init(packed: packed)
    }

    public init(packed: PackedSubChunk) {
        self.version = packed.version
        self.chunkY = packed.chunkY
        self.blockLayer = ExpandedBlockLayer(packedLayer: packed.blockLayer)

        guard let packedLiquidLayer = packed.liquidLayer,
              !packedLiquidLayer.palette.isEmpty
        else {
            self.liquidLayer = nil
            return
        }

        self.liquidLayer = ExpandedBlockLayer(packedLayer: packedLiquidLayer)
    }

    public func toData() throws -> Data {
        let writer = CBBinaryWriter()

        // Determine layer count
        let hasLiquid = self.liquidLayer != nil
            && !(self.liquidLayer?.palette.isEmpty ?? true)
            && !(self.liquidLayer?.indices.isEmpty ?? true)
        let layerCount: UInt8 = hasLiquid ? 2 : 1

        // Write header
        try writer.write(UInt8(self.version))
        try writer.write(layerCount)
        if self.version == 9 {
            try writer.write(self.chunkY)
        }

        // Write block layer
        try Self.writeLayer(self.blockLayer, to: writer)

        // Write liquid layer if present
        if hasLiquid, let liquid = liquidLayer {
            try Self.writeLayer(liquid, to: writer)
        }

        return writer.data
    }

    private static func writeLayer(_ layer: ExpandedBlockLayer, to writer: CBBinaryWriter) throws {
        // Block storage layout shared by persisted subchunk versions 8 and 9:
        // https://gist.github.com/Tomcc/a96af509e275b1af483b25c543cfbf37#block-storage-format
        let normalized = try self.normalize(layer)
        let bitWidth = try self.persistedPaletteBitWidth(paletteCount: normalized.palette.count)

        // Pack indices into bytes
        let indicesBytes = try Self.packIndices(
            normalized.indices,
            bitWidth: bitWidth,
            palette: normalized.palette
        )

        // The least-significant bit distinguishes runtime palettes (1) from
        // persistent palettes (0). Both V8 and V9 LevelDB subchunks store NBT
        // block states, so only the packing width is shifted into this header.
        let typeByte = UInt8(bitWidth << 1)
        try writer.write(typeByte)

        // Write packed indices
        try writer.write(indicesBytes)

        // Write palette count
        try writer.write(UInt32(normalized.palette.count))

        // Write each block tag inline (CBTagReader expects inline tags, not separate buffers)
        let tagWriter = CBTagWriter()
        for block in normalized.palette {
            try tagWriter.write(tag: block)
        }
        let tagData = tagWriter.toData()
        try writer.write([UInt8](tagData))
    }

    private static func persistedPaletteBitWidth(paletteCount: Int) throws -> Int {
        guard 1...MCSubChunk.totalBlockCount ~= paletteCount else {
            throw CBStreamError.argumentOutOfRange(
                "paletteCount",
                "Palette count out of range: \(paletteCount)"
            )
        }

        // Bedrock has no 7, 9, or other intermediate storage types. Round the
        // required width up to a type understood by the game.
        let maximumIndex = UInt16(paletteCount - 1)
        let requiredBitWidth = max(1, UInt16.bitWidth - maximumIndex.leadingZeroBitCount)
        guard let bitWidth = self.persistedPaletteBitWidths.first(where: { $0 >= requiredBitWidth }) else {
            throw CBStreamError.invalidFormat("Invalid palette bit width: \(requiredBitWidth)")
        }

        return bitWidth
    }

    private static func normalize(_ layer: ExpandedBlockLayer) throws -> NormalizedBlockLayer {
        guard layer.indices.count == MCSubChunk.totalBlockCount else {
            throw CBStreamError.argumentError("Indices count must be \(MCSubChunk.totalBlockCount)")
        }

        var usedPaletteIndices = Set<Int>()
        for rawIndex in layer.indices {
            let paletteIndex = Int(rawIndex)
            guard layer.palette.indices.contains(paletteIndex) else {
                throw CBStreamError.argumentOutOfRange(
                    "paletteIndex",
                    "Index \(paletteIndex) out of bounds for palette of size \(layer.palette.count)"
                )
            }

            usedPaletteIndices.insert(paletteIndex)
        }

        var normalizedPalette = [CompoundTag]()
        var normalizedIndicesBySourceIndex = [Int: Int]()
        var candidateIndicesByName = [String: [Int]]()
        normalizedPalette.reserveCapacity(usedPaletteIndices.count)
        normalizedIndicesBySourceIndex.reserveCapacity(usedPaletteIndices.count)

        // Preserve source palette order. Only unused entries and exact structural
        // duplicates are removed, and every block index is remapped below.
        for sourceIndex in layer.palette.indices where usedPaletteIndices.contains(sourceIndex) {
            let block = layer.palette[sourceIndex]
            let name = (block["name"] as? StringTag)?.value ?? ""
            let candidateIndices = candidateIndicesByName[name] ?? []
            if let existingIndex = candidateIndices.first(where: {
                blockPaletteEntriesAreEquivalent(normalizedPalette[$0], block)
            }) {
                normalizedIndicesBySourceIndex[sourceIndex] = existingIndex
                continue
            }

            let normalizedIndex = normalizedPalette.count
            normalizedPalette.append(block)
            normalizedIndicesBySourceIndex[sourceIndex] = normalizedIndex
            candidateIndicesByName[name, default: []].append(normalizedIndex)
        }

        let normalizedIndices: [UInt16] = try layer.indices.map { rawIndex in
            let sourceIndex = Int(rawIndex)
            guard let normalizedIndex = normalizedIndicesBySourceIndex[sourceIndex],
                  let result = UInt16(exactly: normalizedIndex)
            else {
                throw CBStreamError.argumentOutOfRange(
                    "paletteIndex",
                    "Unable to remap palette index \(sourceIndex)"
                )
            }

            return result
        }
        return .init(palette: normalizedPalette, indices: normalizedIndices)
    }

    private static func packIndices(
        _ indices: [UInt16],
        bitWidth: Int,
        palette: [CompoundTag]
    ) throws -> [UInt8] {
        guard indices.count == MCSubChunk.totalBlockCount else {
            throw CBStreamError.argumentError("Indices count must be \(MCSubChunk.totalBlockCount)")
        }

        let valuesPerWord = CBBinaryReader.wordBitSize / bitWidth
        let wordCount = (MCSubChunk.totalBlockCount + valuesPerWord - 1) / valuesPerWord
        var indicesBytes = [UInt8](repeating: 0, count: wordCount * 4)

        let mask: UInt32 = (1 << bitWidth) - 1

        for linear in 0..<MCSubChunk.totalBlockCount {
            let paletteIndex = Int(indices[linear])

            // Validate palette index
            guard paletteIndex < palette.count else {
                throw CBStreamError.argumentOutOfRange(
                    "paletteIndex",
                    "Index \(paletteIndex) out of bounds for palette of size \(palette.count)"
                )
            }

            let wordIndex = linear / valuesPerWord
            let indexInWord = linear % valuesPerWord
            let bitOffset = indexInWord * bitWidth
            let byteOffset = wordIndex * 4

            // Read existing word (little-endian)
            var word: UInt32 = 0
            for i in 0..<4 {
                word |= UInt32(indicesBytes[byteOffset + i]) << (i * 8)
            }

            // Clear and set bits
            let clearMask = ~(mask << bitOffset)
            word = (word & clearMask) | (UInt32(paletteIndex) << bitOffset)

            // Write word back (little-endian)
            for i in 0..<4 {
                indicesBytes[byteOffset + i] = UInt8((word >> (i * 8)) & 0xFF)
            }
        }

        return indicesBytes
    }
}

public struct ExpandedBlockLayer {
    public private(set) var palette: [CompoundTag]
    public private(set) var indices: [UInt16]
    private var nameCache: [String: [Int]]

    public init(palette: [CompoundTag], indices: [UInt16]) {
        precondition(!palette.isEmpty)
        precondition(indices.count == MCSubChunk.totalBlockCount)
        precondition(indices.allSatisfy { Int($0) < palette.count })
        self.palette = palette
        self.indices = indices
        self.nameCache = [:]
    }

    public init(packedLayer: PackedBlockLayer) {
        self.palette = packedLayer.palette
        self.nameCache = [:]

        if let indices = packedLayer.unpackPaletteIndices() {
            self.indices = indices
        } else {
            self.indices = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
        }
    }

    public func block(localX: Int, localY: Int, localZ: Int) -> CompoundTag? {
        guard let linearIndex = MCSubChunk.linearIndex(localX, localY, localZ) else {
            return nil
        }

        let paletteIndex = Int(indices[linearIndex])
        guard paletteIndex < self.palette.count else {
            return nil
        }

        return self.palette[paletteIndex]
    }

    public mutating func place(localX: Int, localY: Int, localZ: Int, block: CompoundTag) {
        guard let linearIndex = MCSubChunk.linearIndex(localX, localY, localZ) else { return }

        let paletteIndex = self.ensurePaletteIndex(for: block)
        guard paletteIndex <= UInt16.max else { return }

        self.indices[linearIndex] = UInt16(paletteIndex)
    }

    // MARK: - Private Helpers

    private mutating func rebuildCacheIfNeeded() {
        guard self.nameCache.isEmpty else { return }

        var cache: [String: [Int]] = [:]
        for (index, block) in self.palette.enumerated() {
            guard let nameTag = block["name"] as? StringTag else { continue }

            let name = nameTag.value
            cache[name, default: []].append(index)
        }
        self.nameCache = cache
    }

    private mutating func ensurePaletteIndex(for block: CompoundTag) -> Int {
        self.rebuildCacheIfNeeded()

        // Try to find existing block by name first
        if let nameTag = block["name"] as? StringTag {
            let name = nameTag.value
            if let candidateIndices = nameCache[name] {
                // Only iterate the cached indices for this name
                for paletteIndex in candidateIndices where blockPaletteEntriesAreEquivalent(
                    self.palette[paletteIndex],
                    block
                ) {
                    return paletteIndex
                }
            }

            // Not found, add to palette
            let newIndex = self.palette.count
            self.palette.append(block)
            self.nameCache[name, default: []].append(newIndex)
            return newIndex
        }

        // No name, just append
        let newIndex = self.palette.count
        self.palette.append(block)
        return newIndex
    }
}
