//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import LvDBWrapper
import Testing

struct LvDBKeyTests {
    // Test parsing of subChunk key
    @Test
    func parseSubChunkKey() throws {
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

    // Test parsing of string key
    @Test
    func parseStringKey() throws {
        let data = Data("VILLAGE_test".utf8)
        let key = LvDBKey.parse(data: data)
        if case let .village(villageData) = key {
            #expect(String(data: villageData, encoding: .utf8) == "test")
        } else {
            Issue.record("Failed to parse village key")
        }
    }

    // Test isNBTKey property
    @Test
    func testIsNBTKey() throws {
        let blockEntityKey = LvDBKey.subChunk(0, 0, .overworld, .blockEntity, nil)
        #expect(blockEntityKey.isNBTKey == true)

        let dataKey = LvDBKey.subChunk(0, 0, .overworld, .data3D, nil)
        #expect(dataKey.isNBTKey == false)

        let villageKey = LvDBKey.village(Data("test".utf8))
        #expect(villageKey.isNBTKey == true)
    }

    // Test isCompoundListKey property
    @Test
    func testIsCompoundListKey() throws {
        let entityKey = LvDBKey.subChunk(0, 0, .overworld, .entity, nil)
        #expect(entityKey.isCompoundListKey == true)

        let blockEntityKey = LvDBKey.subChunk(0, 0, .overworld, .blockEntity, nil)
        #expect(blockEntityKey.isCompoundListKey == true)

        let dataKey = LvDBKey.subChunk(0, 0, .overworld, .data3D, nil)
        #expect(dataKey.isCompoundListKey == false)
    }

    // Test keyData generation
    @Test
    func keyDataGeneration() throws {
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
        let villageKey = LvDBKey.village(Data("test".utf8))
        let expectedVillageData = Data("VILLAGE_test".utf8)
        #expect(villageKey.data == expectedVillageData)
    }
}
