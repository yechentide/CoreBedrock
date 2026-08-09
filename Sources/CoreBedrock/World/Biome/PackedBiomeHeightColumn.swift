//
// Created by yechentide on 2025/09/19
//

import Foundation

public struct PackedBiomeHeightColumn {
    private let heightBytes: [UInt8] // 1 block = 2 bytes
    private let biomeSectionsByChunkY: [Int8: PackedBiomeSection]

    public init(heightBytes: [UInt8], biomeSections: [PackedBiomeSection]) {
        self.heightBytes = heightBytes
        self.biomeSectionsByChunkY = Dictionary(
            biomeSections.map { ($0.chunkY, $0) },
            uniquingKeysWith: { _, later in later }
        )
    }

    @inline(__always)
    public func highestBlockY(atLocalX localX: Int, localZ: Int) -> UInt16? {
        guard MCSubChunk.localPosRange ~= localX, MCSubChunk.localPosRange ~= localZ else {
            return nil
        }

        // Bedrock's 16x16 height map is Z-major: index = z * 16 + x.
        let byteOffset = ((localZ << 4) | localX) << 1
        guard byteOffset + 1 < self.heightBytes.count else { return nil }

        return UInt16(self.heightBytes[byteOffset]) | (UInt16(self.heightBytes[byteOffset + 1]) << 8)
    }

    public func biomeValue(atLocalX localX: Int, y: Int, localZ: Int) -> Int32? {
        guard MCSubChunk.localPosRange ~= localX, MCSubChunk.localPosRange ~= localZ else {
            return nil
        }
        let chunkY = Int8(truncatingIfNeeded: y >> 4)
        guard let subChunkBiome = self.biomeSectionsByChunkY[chunkY] else {
            return nil
        }

        // Subtracting the section origin is floor-modulo and remains 0...15 for negative Y.
        let localY = y - Int(chunkY) * MCChunk.sideLength
        return subChunkBiome.paletteValue(localX: localX, localY: localY, localZ: localZ)
    }

    public struct PackedBiomeSection: PackedPaletteReadable {
        public let chunkY: Int8
        public let bitWidth: Int
        public let palette: [Int32]
        public let indicesBytes: [UInt8]
    }
}
