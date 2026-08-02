//
// Created by yechentide on 2026/08/02
//

//
// Read-only decoders for pre-1.2 Bedrock terrain records.
//

public import Foundation

public struct LegacyBlock: Sendable, Hashable {
    public let id: UInt8
    public let data: UInt8
}

public struct LegacySubChunk: Sendable {
    public static let blockCount = 16 * 16 * 16
    public let version: UInt8
    public let blocks: [UInt8]
    public let metadata: [UInt8]
    public let skyLight: [UInt8]?
    public let blockLight: [UInt8]?

    public func block(localX: Int, localY: Int, localZ: Int) -> LegacyBlock? {
        guard let index = MCSubChunk.linearIndex(localX, localY, localZ) else { return nil }

        let nibble = self.metadata[index / 2]
        return .init(id: self.blocks[index], data: index.isMultiple(of: 2) ? nibble & 0x0F : nibble >> 4)
    }
}

public struct LegacyChunkTerrain: Sendable {
    public static let width = 16
    public static let height = 128
    public let blocks: [UInt8]
    public let metadata: [UInt8]
    public let skyLight: [UInt8]
    public let blockLight: [UInt8]
    public let heightmap: [UInt8]
    /// Each entry is biome ID, grass red, green, blue in X/Z order.
    public let biomeData: [UInt8]
}

public enum LegacyTerrainParser {
    private static let subChunkBlocks = LegacySubChunk.blockCount
    private static let nibbleBytes = subChunkBlocks / 2
    private static let fullChunkBlocks = 16 * 16 * 128
    private static let fullNibbleBytes = fullChunkBlocks / 2
    private static let fullTerrainLength = fullChunkBlocks + fullNibbleBytes * 3 + 16 * 16 + 16 * 16 * 4

    /// Decodes legacy `0x2F` storage versions (0/1). It never writes these formats.
    public static func parseSubChunk(_ data: Data) throws -> LegacySubChunk {
        guard data.count >= 1 + self.subChunkBlocks + self.nibbleBytes else {
            throw CBError.invalidDataLength(data.count)
        }

        let bytes = [UInt8](data)
        let version = bytes[0]
        let blockStart = 1
        let metadataStart = blockStart + self.subChunkBlocks
        let skyStart = metadataStart + self.nibbleBytes
        let blockLightStart = skyStart + self.nibbleBytes
        guard data.count == metadataStart + self.nibbleBytes ||
            data.count == skyStart + self.nibbleBytes ||
            data.count == blockLightStart + self.nibbleBytes
        else {
            throw CBStreamError.invalidFormat("Invalid legacy subchunk length: \(data.count)")
        }

        return .init(
            version: version,
            blocks: Array(bytes[blockStart..<metadataStart]),
            metadata: Array(bytes[metadataStart..<skyStart]),
            skyLight: data.count >= skyStart + self.nibbleBytes
                ? Array(bytes[skyStart..<blockLightStart])
                : nil,
            blockLight: data.count >= blockLightStart + self.nibbleBytes
                ? Array(bytes[blockLightStart..<blockLightStart + self.nibbleBytes])
                : nil
        )
    }

    /// Decodes the pre-1.0 `0x30` full-chunk terrain payload.
    public static func parseFullChunk(_ data: Data) throws -> LegacyChunkTerrain {
        guard data.count == self.fullTerrainLength else { throw CBError.invalidDataLength(data.count) }

        let bytes = [UInt8](data)
        let metadataStart = self.fullChunkBlocks
        let skyStart = metadataStart + self.fullNibbleBytes
        let blockLightStart = skyStart + self.fullNibbleBytes
        let heightmapStart = blockLightStart + self.fullNibbleBytes
        let biomeStart = heightmapStart + 16 * 16
        return .init(
            blocks: Array(bytes[0..<metadataStart]),
            metadata: Array(bytes[metadataStart..<skyStart]),
            skyLight: Array(bytes[skyStart..<blockLightStart]),
            blockLight: Array(bytes[blockLightStart..<heightmapStart]),
            heightmap: Array(bytes[heightmapStart..<biomeStart]),
            biomeData: Array(bytes[biomeStart..<bytes.count])
        )
    }
}
