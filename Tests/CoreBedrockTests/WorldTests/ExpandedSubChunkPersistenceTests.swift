//
// Created by OpenAI on 2026/08/20
//

@testable import CoreBedrock
import Foundation
import Testing

struct ExpandedSubChunkPersistenceTests {
    @Test
    func realPersistedV9FixtureRoundTripsByteForByte() throws {
        let path = try #require(Bundle.module.path(
            forResource: "TestData/subChunkDataV9",
            ofType: nil
        ))
        let original = try Data(contentsOf: URL(filePath: path))
        #expect(original.prefix(4) == Data([0x09, 0x01, 0x00, 0x08]))

        let expanded = try ExpandedSubChunk(data: original, chunkY: 0)
        let encoded = try expanded.toData()

        #expect(encoded == original)
        #expect(encoded[3] & 0x01 == 0)
    }

    @Test
    func version8And9UseTheSamePersistentStorageHeader() throws {
        let palette = try [
            Self.block(name: "minecraft:air"),
            Self.block(name: "minecraft:stone"),
            Self.block(name: "minecraft:dirt"),
        ]
        var indices = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
        indices[1] = 1
        indices[2] = 2
        let layer = ExpandedBlockLayer(palette: palette, indices: indices)

        let version8 = try ExpandedSubChunk(version: 8, chunkY: 4, blockLayer: layer).toData()
        let version9 = try ExpandedSubChunk(version: 9, chunkY: 4, blockLayer: layer).toData()

        #expect(version8[2] == 0x04)
        #expect(version9[3] == 0x04)
        #expect(try ExpandedSubChunk(data: version8, chunkY: 4).blockLayer.indices == indices)
        #expect(try ExpandedSubChunk(data: version9, chunkY: 4).blockLayer.indices == indices)
    }

    @Test
    func legacyMisflaggedRuntimeHeaderIsReadAndRewrittenAsPersistent() throws {
        let palette = try (0..<257).map { index in
            try Self.block(name: "minecraft:legacy_\(index)")
        }
        var indices = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
        for index in palette.indices {
            indices[index] = UInt16(index)
        }
        let subchunk = ExpandedSubChunk(
            version: 9,
            chunkY: 0,
            blockLayer: .init(palette: palette, indices: indices)
        )
        let persistent = try subchunk.toData()
        #expect(persistent[3] == 0x20)

        var legacyMisflagged = persistent
        legacyMisflagged[3] = 0x21
        let rescued = try ExpandedSubChunk(data: legacyMisflagged, chunkY: 0)
        let repaired = try rescued.toData()

        #expect(repaired[3] == 0x20)
        #expect(repaired == persistent)
    }

    @Test
    func persistedPaletteWidthsRoundUpToBedrockSupportedValues() throws {
        let cases: [(paletteCount: Int, expectedBitWidth: UInt8)] = [
            (1, 1),
            (2, 1),
            (3, 2),
            (5, 3),
            (9, 4),
            (17, 5),
            (33, 6),
            (65, 8),
            (257, 16),
        ]

        for testCase in cases {
            let palette = try (0..<testCase.paletteCount).map { index in
                try Self.block(name: "minecraft:test_\(index)")
            }
            var indices = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
            for index in palette.indices {
                indices[index] = UInt16(index)
            }
            let subchunk = ExpandedSubChunk(
                version: 9,
                chunkY: 4,
                blockLayer: .init(palette: palette, indices: indices)
            )

            let encoded = try subchunk.toData()
            let storageHeader = encoded[3]
            #expect(storageHeader & 0x01 == 0)
            #expect(storageHeader >> 1 == testCase.expectedBitWidth)

            let decoded = try ExpandedSubChunk(data: encoded, chunkY: 4)
            #expect(decoded.blockLayer.palette.count == testCase.paletteCount)
        }
    }

    @Test
    func structurallyEquivalentAndUnusedPaletteEntriesAreCompacted() throws {
        let first = try Self.block(name: "minecraft:test", reversedStateOrder: false)
        let stone = try Self.block(name: "minecraft:stone")
        let duplicate = try Self.block(name: "minecraft:test", reversedStateOrder: true)
        let unused = try Self.block(name: "minecraft:unused")
        var indices = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
        indices[1] = 1
        indices[2] = 2
        var layer = ExpandedBlockLayer(palette: [first, stone, duplicate, unused], indices: indices)

        let equivalentPlacement = try Self.block(name: "minecraft:test", reversedStateOrder: true)
        layer.place(localX: 0, localY: 3, localZ: 0, block: equivalentPlacement)
        #expect(layer.palette.count == 4)

        let encoded = try ExpandedSubChunk(version: 9, chunkY: 0, blockLayer: layer).toData()
        #expect(encoded[3] == 0x02)

        let decoded = try ExpandedSubChunk(data: encoded, chunkY: 0)
        #expect(decoded.blockLayer.palette.count == 2)
        #expect(decoded.blockLayer.indices[0] == decoded.blockLayer.indices[2])
        #expect(decoded.blockLayer.indices[0] == decoded.blockLayer.indices[3])
        #expect(decoded.blockLayer.indices[0] != decoded.blockLayer.indices[1])
    }

    private static func block(name: String, reversedStateOrder: Bool = false) throws -> CompoundTag {
        let states: [NBT] = if reversedStateOrder {
            [
                StringTag(name: "axis", "y"),
                ByteTag(name: "powered", 0),
            ]
        } else {
            [
                ByteTag(name: "powered", 0),
                StringTag(name: "axis", "y"),
            ]
        }
        return try CompoundTag([
            StringTag(name: "name", name),
            IntTag(name: "version", 18_168_865),
            CompoundTag(name: "states", states),
        ])
    }
}
