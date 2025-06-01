//
// Created by yechentide on 2025/05/10
//

import Foundation

internal struct ChunkBiomeParser {
    private static let wordBitSize = 32

    private let dimension: MCDimension
    private let binaryReader: CBBinaryReader

    public init(data: Data, dimension: MCDimension) {
        self.binaryReader = CBBinaryReader(data: data)
        self.dimension = dimension
    }

    public func parse() throws -> MCBiomeColumn? {
        let biomeColumn = MCBiomeColumn(sections: [])

        var chunkY = dimension.chunkYRange.lowerBound
        while binaryReader.remainingByteCount > 0 {
            defer {
                chunkY += 1
            }
            let format = try binaryReader.readUInt8()
            guard format != 0xFF else {
                break
            }
            guard let biomeSection = try parseBiomeSection(chunkY: chunkY) else {
                return nil
            }
            biomeColumn.append(biomeSection)
        }

        return biomeColumn
    }

    private func parseBiomeSection(chunkY: Int8) throws -> MCBiomeSection? {
        let type = try binaryReader.readUInt8()
        guard type > 0 else {
            return nil
        }

        if type == 1 {
            return try readUniformBiomeSection(chunkY: chunkY)
        }

        let bitsPerBlock = Int(type >> 1)
        return try readPalettedBiomeSection(chunkY: chunkY, bitsPerBlock: bitsPerBlock)
    }

    private func readUniformBiomeSection(chunkY: Int8) throws -> MCBiomeSection? {
        guard binaryReader.remainingByteCount >= 4 else {
            return nil
        }
        let biomeData = try binaryReader.readUInt32()
        return MCBiomeSection(chunkY: chunkY, uniform: MCBiomeType.from(biomeData))
    }

    private func readPalettedBiomeSection(chunkY: Int8, bitsPerBlock: Int) throws -> MCBiomeSection? {
        guard 1...Self.wordBitSize ~= bitsPerBlock,
              let indices = try readBiomeIndices(bitsPerBlock: bitsPerBlock) else {
            return nil
        }

        let paletteCount = try binaryReader.readUInt32()
        guard let maxIndex = indices.max(),
              maxIndex < paletteCount,
              paletteCount <= MCSubChunk.totalBlockCount else {
            return nil
        }

        let palette = try readBiomePalette(count: paletteCount)
        return MCBiomeSection(chunkY: chunkY, palette: palette, indices: indices)
    }

    private func readBiomePalette(count: UInt32) throws -> [MCBiomeType] {
        var palette = [MCBiomeType]()
        for _ in 0..<count {
            let biomeData = try binaryReader.readUInt32()
            palette.append(MCBiomeType.from(biomeData))
        }
        return palette
    }

    private func readBiomeIndices(bitsPerBlock: Int) throws -> [UInt16]? {
        let biomesPerWord = Self.wordBitSize / bitsPerBlock
        let totalWords = Int(ceil(   Double(MCSubChunk.totalBlockCount) / Double(biomesPerWord)   ))
        let totalBytes = totalWords * 4
        guard binaryReader.remainingByteCount >= totalBytes else {
            return nil
        }

        let mask: UInt32 = ~(UInt32(0xFFFF) << bitsPerBlock)
        var elements = [UInt16]()

        for _ in 0 ..< totalWords {
            let word = try binaryReader.readUInt32()
            for i in 0 ..< biomesPerWord {
                guard elements.count < MCSubChunk.totalBlockCount else { break }
                let element: UInt32 = mask & (word >> (i * bitsPerBlock))
                elements.append(UInt16(truncatingIfNeeded: element))
            }
        }

        return elements.count == MCSubChunk.totalBlockCount ? elements : nil
    }
}
