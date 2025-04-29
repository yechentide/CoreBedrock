//
// Created by yechentide on 2025/04/22
//

import Foundation

public struct BiomeDataParser {
    private static let wordBitSize = 32

    private let binaryReader: CBBinaryReader

    public init(data: Data) {
        self.binaryReader = CBBinaryReader(data: data)
    }

    public func parse(minChunkY: Int) throws -> MCBiomeColumn? {
        let biomeColumn = MCBiomeColumn(minChunkY: minChunkY, sections: [])

        while binaryReader.remainingByteCount > 0 {
            let format = try binaryReader.readUInt8()
            guard format != 0xFF else {
                break
            }
            guard let biomeSection = try readBiomeSection() else {
                return nil
            }
            biomeColumn.append(biomeSection)
        }

        return biomeColumn
    }

    private func readBiomeSection() throws -> MCBiomeSection? {
        let type = try binaryReader.readUInt8()
        guard type > 0 else {
            return nil
        }

        if type == 1 {
            return try readUniformBiomeSection()
        }

        let bitsPerBlock = Int(type >> 1)
        return try readPalettedBiomeSection(bitsPerBlock: bitsPerBlock)
    }

    private func readUniformBiomeSection() throws -> MCBiomeSection? {
        guard binaryReader.remainingByteCount >= 4 else {
            return nil
        }
        let biomeData = try binaryReader.readUInt32()
        return MCBiomeSection(uniform: MCBiomeType.from(biomeData))
    }

    private func readPalettedBiomeSection(bitsPerBlock: Int) throws -> MCBiomeSection? {
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
        return MCBiomeSection(palette: palette, indices: indices)
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
