//
// Created by yechentide on 2025/09/21
//

import OSLog
import LvDBWrapper

struct NewRGBA: Hashable, Equatable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: UInt8
}

struct BlockDataTables {
    let color: BlockAttributeAtlas<NewRGBA>
    let liquid: BlockAttributeAtlas<Bool>
    let opaque: BlockAttributeAtlas<Bool>
    let plant: BlockAttributeAtlas<Bool>
}

public final class ChunkTextureLoader {
    private let iterator: LvDBIterator
    private let dimension: MCDimension
    private let chunkX: Int32
    private let chunkZ: Int32
    private let blockDataTables: BlockDataTables

    private let defaultPixel = TexturePixelData(height: 0, waterDepth: 0, blockPaletteIndex: 0, biomeID: 0)
    private var subChunkCache: [Int:MCSubChunkStorage] = [:]
    private var noExistsSubChunks: Set<Int> = []

    init(iterator: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32, blockDataTables: BlockDataTables) {
        self.iterator = iterator
        self.dimension = dimension
        self.chunkX = chunkX
        self.chunkZ = chunkZ
        self.blockDataTables = blockDataTables
    }

    public func extractChunkData(texturePixels: inout [TexturePixelData]) async {
        guard let data3DData = getDataFromDB(type: .data3D) else {
            return
        }
        let chunkXInRegion = Int(convertPos(from: chunkX, .chunkToIndexInRegion))
        let chunkZInRegion = Int(convertPos(from: chunkZ, .chunkToIndexInRegion))
        let blockIndexOffset = chunkZInRegion * MCChunk.sideLength * MCRegion.sideLength + chunkXInRegion * MCChunk.sideLength

        do {
            let data3DParser = Data3DParser(data: data3DData)
            let biomeStorage = try data3DParser.lightParse(dimension: dimension)

            texturePixels.withUnsafeMutableBufferPointer { buffer in
                for blockZInChunk in 0..<MCChunk.sideLength {
                    guard !Task.isCancelled else {
                        return
                    }
                    for blockXInChunk in 0..<MCChunk.sideLength {
                        let blockIndexInRegion = blockIndexOffset + blockZInChunk * MCRegion.sideLength + blockXInChunk
                        if noExistsSubChunks.count == dimension.chunkYRange.count {
                            buffer[blockIndexInRegion] = defaultPixel
                            continue
                        }
                        processBlockColumn(
                            localX: blockXInChunk,
                            localZ: blockZInChunk,
                            biome: biomeStorage,
                            write: { pixel in
                                buffer[blockIndexInRegion] = pixel
                            }
                        )
                    }
                }
            }
        } catch {
            CBLogger.warning("Chunk (\(chunkX),\(chunkZ)): \(error.localizedDescription)")
            texturePixels.withUnsafeMutableBufferPointer { buffer in
                for i in blockIndexOffset ..< blockIndexOffset+MCChunk.viewSize {
                    buffer[i] = defaultPixel
                }
            }
        }
    }

    private func processBlockColumn(
        localX: Int, localZ: Int, biome: MCBiomeStorage, write: (TexturePixelData) -> Void
    ) {
        var water: UInt8 = 0
        var foundOpaque = false
        var pixel = defaultPixel

        let maxChunkY: Int = if let height = biome.highestBlockY(atLocalX: localX, localZ: localZ) {
            convertPos(from: dimension.blockYRange.lowerBound + Int(height), .blockToChunk)
        } else {
            Int(dimension.chunkYRange.upperBound)
        }
        let minChunkY = Int(dimension.chunkYRange.lowerBound)

        for cy in stride(from: maxChunkY, through: minChunkY, by: -1) {
            guard !noExistsSubChunks.contains(cy) else { continue }
            let sc: MCSubChunkStorage
            if let cached = subChunkCache[cy] {
                sc = cached
            } else if let loaded = try? loadSubChunk(chunkY: cy) {
                subChunkCache[cy] = loaded
                sc = loaded
            } else {
                noExistsSubChunks.insert(cy)
                continue
            }

            var done = false
            sc.blockLayer.unsafeEnumerateColumnDescendingY(atLocalX: localX, localZ: localZ) { localY, block in
                if blockDataTables.liquid.value(for: block) {
                    water &+= 1
                    foundOpaque = true
                    return false
                }
                if !blockDataTables.opaque.value(for: block) || blockDataTables.plant.value(for: block) {
                    return false
                }
                foundOpaque = true
                let blockY = cy * MCChunk.sideLength + localY
                let h = min(max(blockY - dimension.blockYRange.lowerBound, 0), 511)
                let colorIdx = blockDataTables.color.paletteIndex(for: block)
                let biomeID = UInt32(biome.biomeValue(atLocalX: localX, y: blockY, localZ: localZ) ?? 0)
                pixel = TexturePixelData(
                    height: h,
                    waterDepth: Int(water),
                    blockPaletteIndex: UInt32(colorIdx),
                    biomeID: biomeID
                )
                done = true
                return true
            }
            if done { break }
        }

        if foundOpaque {
            write(pixel)
        } else if water > 0 {
            write(TexturePixelData(
                height: 0,
                waterDepth: Int(water),
                blockPaletteIndex: UInt32(blockDataTables.color.indexOfWater),
                biomeID: 0
            ))
        } else {
            write(TexturePixelData(
                height: 0,
                waterDepth: 0,
                blockPaletteIndex: UInt32(blockDataTables.color.indexOfAir),
                biomeID: 0
            ))
        }
    }

    @inline(__always)
    private func loadSubChunk(chunkY: Int) throws -> MCSubChunkStorage? {
        let chunkY = Int8(truncatingIfNeeded: chunkY)
        guard let subChunkData = getDataFromDB(type: .subChunkPrefix, yIndex: chunkY) else {
            return nil
        }
        let parser = SubChunkParser(data: subChunkData, chunkY: chunkY)
        let subChunkStorage = try parser.lightParse()
        subChunkCache[Int(chunkY)] = subChunkStorage
        return subChunkStorage
    }

    @inline(__always)
    private func getDataFromDB(type: LvDBChunkKeyType, yIndex: Int8? = nil) -> Data? {
        let chunkBaseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        let key = LvDBKeyFactory.makeChunkKey(base: chunkBaseKey, type: type, yIndex: yIndex)
        iterator.seek(key)
        if iterator.key() == key, let data = iterator.value() {
            return data
        }
        if dimension == .overworld, chunkBaseKey.count == 8 {
            let fallbackKey = chunkBaseKey + MCDimension.overworld.rawValue.data
            let fallbackChunkKey = LvDBKeyFactory.makeChunkKey(base: fallbackKey, type: type, yIndex: yIndex)
            iterator.seek(fallbackChunkKey)
            if iterator.key() == fallbackChunkKey, let data = iterator.value() {
                return data
            }
        }
        return nil
    }
}
