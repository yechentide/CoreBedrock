//
// Created by yechentide on 2025/08/11
//

import Foundation

internal struct Data3DParser {
    private let binaryReader: CBBinaryReader

    public init(data: Data) {
        self.binaryReader = CBBinaryReader(data: data)
    }

    private func parseHeightMap() throws -> [Int16] {
        // 1ブロック2バイトなので、16*16ブロックは512バイト
        var heightMap: [Int16] = []
        for _ in 0..<MCChunk.viewSize {
            let height = try binaryReader.readInt16()
            heightMap.append(height)
        }
        return heightMap
    }

    private func parseSubChunkBiome() throws -> [Int32]? {
        let header = try binaryReader.readUInt8()
        if header == 0xFF {
            // まだロードされていないSubChunk
            return nil
        }

        let bitsPerBlock = Int(header >> 1)
        if bitsPerBlock == 0 {
            let singleBiomeID = try binaryReader.readInt32()
            return .init(repeating: singleBiomeID, count: MCSubChunk.totalBlockCount)
        }

        let byteLength = MCSubChunk.totalBlockCount * (bitsPerBlock / 8)
        let paletteData = try binaryReader.readBytes(byteLength)
        let paletteCount = try binaryReader.readInt32()

        var biomePalette: [Int32] = []
        for _ in 0..<paletteCount {
            let biomeID = try binaryReader.readInt32()
            biomePalette.append(biomeID)
        }

        var biomeList: [Int32] = []

        return biomeList
    }

    public func parse() throws {
        guard binaryReader.remainingByteCount > 512 else {
            return
        }
        let heightMap: [Int16] = try parseHeightMap()
        print(heightMap)
    }

    public func extractTopLayer() throws {
        let heightMap: [Int16] = try parseHeightMap()
        print(heightMap)
    }
}
