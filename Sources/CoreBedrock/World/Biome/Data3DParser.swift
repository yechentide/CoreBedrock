//
// Created by yechentide on 2025/09/20
//

import Foundation

internal struct Data3DParser {
    private let binaryReader: CBBinaryReader

    public init(data: Data) {
        self.binaryReader = CBBinaryReader(data: data)
    }

    private func lightParseBiomeSection(chunkY: Int8) throws -> MCBiomeStorage.SubChunkBiomeSection? {
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
                bitWidth: CBBinaryReader.wordBitSize,
                palette: [singleBiomeID],
                indicesBytes: .init(repeating: 0, count: MCSubChunk.totalBlockCount)
            )
        }

        let bytesCount = MCSubChunk.totalBlockCount * bitsPerBlock / 8
        let paletteData = try binaryReader.readBytes(bytesCount)
        let paletteCount = try binaryReader.readInt32()

        var biomePalette: [Int32] = []
        for _ in 0..<paletteCount {
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

    public func lightParse(dimension: MCDimension) throws -> MCBiomeStorage {
        let chunkYRange = dimension.chunkYRange
        let minChunkY = chunkYRange.lowerBound
        let maxChunkY = chunkYRange.upperBound

        let heightBytesCount = MCChunk.viewSize * 2
        guard binaryReader.remainingByteCount >= heightBytesCount + Int(maxChunkY - minChunkY) else {
            throw CBError.invalidDataLength(binaryReader.remainingByteCount)
        }

        let heightBytes = try binaryReader.readBytes(heightBytesCount)

        var biomeSections: [MCBiomeStorage.SubChunkBiomeSection] = []
        for chunkY in minChunkY...maxChunkY {
            if let biomeSection = try lightParseBiomeSection(chunkY: chunkY) {
                biomeSections.append(biomeSection)
            }
        }

        return .init(heightBytes: heightBytes, biomeSections: biomeSections)
    }
}
