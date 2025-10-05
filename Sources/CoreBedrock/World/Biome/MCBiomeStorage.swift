//
// Created by yechentide on 2025/09/19
//

import Foundation

internal struct MCBiomeStorage {
    let heightBytes: [UInt8] // 1 block = 2 bytes
    let biomeSections: [SubChunkBiomeSection]

    @inline(__always)
    func highestBlockY(atLocalX localX: Int, localZ: Int) -> UInt16? {
        guard MCSubChunk.localPosRange ~= localX && MCSubChunk.localPosRange ~= localZ else {
            return nil
        }
        let i = ((localX << 4) + localZ) << 1
        guard i + 1 < heightBytes.count else { return nil }
        return UInt16(heightBytes[i]) | (UInt16(heightBytes[i+1]) << 8)
    }

    func biomeValue(atLocalX localX: Int, y: Int, localZ: Int) -> Int32? {
        let chunkY = Int8(truncatingIfNeeded: y >> 4)
        guard let subChunkBiome = biomeSections.first(where: { $0.chunkY == chunkY }) else {
            return nil
        }
        let localY = y % MCChunk.sideLength
        return subChunkBiome.paletteValue(localX: localX, localY: localY, localZ: localZ)
    }

    struct SubChunkBiomeSection: PaletteReadable {
        let chunkY: Int8
        let bitWidth: Int
        let palette: [Int32]
        let indicesBytes: [UInt8]
    }
}
