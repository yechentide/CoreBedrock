//
// Created by yechentide on 2025/09/19
//

import Foundation

public struct PackedBiomeHeightColumn {
    private let heightBytes: [UInt8] // 1 block = 2 bytes
    private let biomeSections: [PackedBiomeSection]

    public init(heightBytes: [UInt8], biomeSections: [PackedBiomeSection]) {
        self.heightBytes = heightBytes
        self.biomeSections = biomeSections
    }

    @inline(__always)
    public func highestBlockY(atLocalX localX: Int, localZ: Int) -> UInt16? {
        guard MCSubChunk.localPosRange ~= localX, MCSubChunk.localPosRange ~= localZ else {
            return nil
        }

        let byteOffset = ((localX << 4) + localZ) << 1
        guard byteOffset + 1 < self.heightBytes.count else { return nil }

        return UInt16(self.heightBytes[byteOffset]) | (UInt16(self.heightBytes[byteOffset + 1]) << 8)
    }

    public func biomeValue(atLocalX localX: Int, y: Int, localZ: Int) -> Int32? {
        let chunkY = Int8(truncatingIfNeeded: y >> 4)
        guard let subChunkBiome = biomeSections.first(where: { $0.chunkY == chunkY }) else {
            return nil
        }

        let localY = y % MCChunk.sideLength
        return subChunkBiome.paletteValue(localX: localX, localY: localY, localZ: localZ)
    }

    public struct PackedBiomeSection: PackedPaletteReadable {
        public let chunkY: Int8
        public let bitWidth: Int
        public let palette: [Int32]
        public let indicesBytes: [UInt8]
    }
}
