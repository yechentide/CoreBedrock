//
// Created by yechentide on 2025/09/20
//

public import Foundation

public struct Data3DParser {
    private let binaryReader: CBBinaryReader

    public init(data: Data) {
        self.binaryReader = CBBinaryReader(data: data)
    }

    private func lightParseBiomeSection(chunkY: Int8) throws -> PackedBiomeHeightColumn.PackedBiomeSection? {
        let header = try binaryReader.readUInt8()
        if header == 0xFF {
            // skip chunks have not been loaded
            return nil
        }

        let bitsPerBlock = Int(header >> 1)
        if bitsPerBlock == 0 {
            let singleBiomeID = try binaryReader.readInt32()
            return .init(
                chunkY: chunkY,
                bitWidth: 0,
                palette: [singleBiomeID],
                indicesBytes: []
            )
        }

        guard 1...CBBinaryReader.wordBitSize ~= bitsPerBlock else {
            throw CBStreamError.invalidFormat("Invalid biome bit size: \(bitsPerBlock)")
        }

        // Values are packed into independent UInt32 words; unused high bits in
        // each word are not carried into the next word.
        let valuesPerWord = CBBinaryReader.wordBitSize / bitsPerBlock
        let wordCount = (MCSubChunk.totalBlockCount + valuesPerWord - 1) / valuesPerWord
        let bytesCount = wordCount * MemoryLayout<UInt32>.size
        let paletteData = try binaryReader.readBytes(bytesCount)
        let paletteCount = try binaryReader.readInt32()
        // paletteCount == 0 means the section has no biome entries (uninitialized data); skip it.
        if paletteCount < 1 {
            return nil
        }

        var biomePalette: [Int32] = []
        for _ in 0..<paletteCount {
            try Task.checkCancellation()
            let biomeID = try binaryReader.readInt32()
            biomePalette.append(biomeID)
        }
        return .init(
            chunkY: chunkY,
            bitWidth: bitsPerBlock,
            palette: biomePalette,
            indicesBytes: paletteData
        )
    }

    public func lightParse(dimension: MCDimension) throws -> PackedBiomeHeightColumn {
        let chunkYRange = dimension.chunkYRange
        let minChunkY = chunkYRange.lowerBound
        let maxChunkY = chunkYRange.upperBound

        let heightBytesCount = MCChunk.viewSize * 2
        guard self.binaryReader.remainingByteCount >= heightBytesCount + Int(maxChunkY - minChunkY) + 1 else {
            throw CBError.invalidDataLength(self.binaryReader.remainingByteCount)
        }

        let heightBytes = try binaryReader.readBytes(heightBytesCount)

        var biomeSections: [PackedBiomeHeightColumn.PackedBiomeSection] = []
        for chunkY in minChunkY...maxChunkY {
            try Task.checkCancellation()
            if let biomeSection = try lightParseBiomeSection(chunkY: chunkY) {
                biomeSections.append(biomeSection)
            }
        }

        return .init(heightBytes: heightBytes, biomeSections: biomeSections)
    }
}
