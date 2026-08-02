//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import Testing

struct LvDBKeyTests {
    /// Test parsing of subChunk key
    @Test
    func parseSubChunkKey() {
        // Test subChunk key without dimension (9 bytes)
        let keyType1 = LvDBChunkKeyType.subChunkPrefix.rawValue
        let data1 = Data([
            0x01, 0x00, 0x00, 0x00, // chunkX = 1
            0x02, 0x00, 0x00, 0x00, // chunkZ = 2
            keyType1, // subChunkType = Data
        ])
        let key1 = LvDBKey.parse(data: data1)
        if case let .unknown(data) = key1 {
            #expect(data == data1)
        } else {
            Issue.record("Failed to parse unknown key")
        }

        // Test subChunk key with dimension and Y (14 bytes)
        let keyType2 = LvDBChunkKeyType.subChunkPrefix.rawValue
        let data2 = Data([
            0x01, 0x00, 0x00, 0x00, // chunkX = 1
            0x02, 0x00, 0x00, 0x00, // chunkZ = 2
            0x01, 0x00, 0x00, 0x00, // dimension = theNether
            keyType2, // subChunkType = SubChunkPrefix
            0x03, // y = 3
        ])
        let key2 = LvDBKey.parse(data: data2)
        if case let .subChunk(x, z, d, t, y) = key2 {
            #expect(x == 1)
            #expect(z == 2)
            #expect(d == .theNether)
            #expect(t == .subChunkPrefix)
            #expect(y == 3)
        } else {
            Issue.record("Failed to parse subChunk key with dimension")
        }
    }

    /// Test parsing of string key
    @Test
    func parseStringKey() {
        let data = Data(LvDBStringKeyType.localPlayer.rawValue.utf8)
        let key = LvDBKey.parse(data: data)
        if case let .string(type) = key {
            #expect(type == .localPlayer)
        } else {
            Issue.record("Failed to parse village key")
        }
    }

    @Test
    func parseVillageKeyWithDimension() {
        let villageID = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        let data = Data("VILLAGE_Overworld_\(villageID)_INFO".utf8)
        let key = LvDBKey.parse(data: data)

        if case let .village(dimension, id, type) = key {
            #expect(dimension == "Overworld")
            #expect(id == villageID)
            #expect(type == "INFO")
        } else {
            Issue.record("Failed to parse village key with dimension")
        }
    }

    @Test
    func parseLegacyOverworldVillageKeyWithoutDimension() {
        let villageID = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        let legacyData = Data("VILLAGE_\(villageID)_INFO".utf8)
        let key = LvDBKey.parse(data: legacyData)

        if case let .legacyVillage(id, type) = key {
            #expect(id == villageID)
            #expect(type == "INFO")
            #expect(key.data == legacyData)
        } else {
            Issue.record("Failed to parse legacy overworld village key without dimension")
        }
    }

    /// Test isNBTKey property
    @Test
    func testIsNBTKey() {
        let blockEntityKey = LvDBKey.subChunk(0, 0, .overworld, .blockEntity, nil)
        #expect(blockEntityKey.isNBTKey == true)

        let dataKey = LvDBKey.subChunk(0, 0, .overworld, .data3D, nil)
        #expect(dataKey.isNBTKey == false)

        let villageKey = LvDBKey.village("Overworld", "XXXXXXXX", "INFO")
        #expect(villageKey.isNBTKey == true)
    }

    /// Test isCompoundListKey property
    @Test
    func testIsCompoundListKey() {
        let entityKey = LvDBKey.subChunk(0, 0, .overworld, .entity, nil)
        #expect(entityKey.isCompoundListKey == true)

        let blockEntityKey = LvDBKey.subChunk(0, 0, .overworld, .blockEntity, nil)
        #expect(blockEntityKey.isCompoundListKey == true)

        let dataKey = LvDBKey.subChunk(0, 0, .overworld, .data3D, nil)
        #expect(dataKey.isCompoundListKey == false)
    }

    @Test
    func parseActorAndPositionKeysLosslessly() {
        let actorID = Data([0xFF, 0x00, 0x01, 0x80, 0x11, 0x22, 0x33, 0x44])
        let actorKey = Data("actorprefix".utf8) + actorID
        #expect(LvDBKey.parse(data: actorKey).data == actorKey)

        let trackKey = Data("PosTrackDB-0x00000003".utf8)
        #expect(LvDBKey.parse(data: trackKey).data == trackKey)
        let lastID = Data("PositionTrackDB-LastId".utf8)
        #expect(LvDBKey.parse(data: lastID).data == lastID)

        let tickingArea = Data("tickingarea_1597ce40-382e-42da-96ed-d439af5bc6d4".utf8)
        #expect(LvDBKey.parse(data: tickingArea).data == tickingArea)
        let loadedRequest = Data("chunk_loaded_request_Overworld_0000000000".utf8)
        #expect(LvDBKey.parse(data: loadedRequest).data == loadedRequest)
        let structure = Data("structuretemplate_oreville_wb:example".utf8)
        #expect(LvDBKey.parse(data: structure).data == structure)
    }

    /// Test keyData generation
    @Test
    func keyDataGeneration() {
        // Test subChunk key
        let subChunkKey = LvDBKey.subChunk(1, 2, .overworld, .subChunkPrefix, nil)
        let keyType = LvDBChunkKeyType.subChunkPrefix.rawValue
        let expectedData = Data([
            0x01, 0x00, 0x00, 0x00, // chunkX = 1
            0x02, 0x00, 0x00, 0x00, // chunkZ = 2
            keyType, // subChunkType = Data
        ])
        #expect(subChunkKey.data == expectedData)

        // Test village key
        let villageKey = LvDBKey.village("Overworld", "XXXXXXXX", "INFO")
        let expectedVillageData = Data("VILLAGE_Overworld_XXXXXXXX_INFO".utf8)
        #expect(villageKey.data == expectedVillageData)
    }
}
