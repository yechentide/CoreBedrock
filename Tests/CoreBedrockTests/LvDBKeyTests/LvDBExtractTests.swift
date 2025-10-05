//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import LvDBWrapper
import Testing

struct ExtractTests {
    @Test
    func testGetStringKey() throws {
        let dbPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_lvdb_\(UUID().uuidString)")
            .path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        let db = try LvDB(dbPath: dbPath, createIfMissing: true)
        defer { db.close() }

        // Prepare test data
        let keyType = LvDBStringKeyType.localPlayer
        let value = "1.20.0"
        try db.put(keyType.rawValue.data(using: .utf8)!, value.data(using: .utf8)!)

        // Execute test
        let result = db.getStringKey(type: keyType)
        #expect(result != nil)
        #expect(result == keyType.rawValue.data(using: .utf8))
    }

    @Test
    func testGetAllStringKeys() throws {
        let dbPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_lvdb_\(UUID().uuidString)")
            .path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        let db = try LvDB(dbPath: dbPath, createIfMissing: true)
        defer { db.close() }

        // Prepare test data
        let testKeys = [
            LvDBStringKeyType.localPlayer,
            LvDBStringKeyType.overworld,
            LvDBStringKeyType.scoreboard,
        ]

        for key in testKeys {
            try db.put(key.rawValue.data(using: .utf8)!, Data("test".utf8))
        }

        // Execute test
        let keys = db.getAllStringKeys()
        #expect(keys.count == testKeys.count)

        // Test exclusion
        let excludeKeys = db.getAllStringKeys(exclude: [.localPlayer])
        #expect(excludeKeys.count == testKeys.count - 1)
    }

    @Test
    func testGetPointerAndActorKeys() throws {
        let dbPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_lvdb_\(UUID().uuidString)")
            .path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        let db = try LvDB(dbPath: dbPath, createIfMissing: true)
        defer { db.close() }

        // Prepare test data
        let x: Int32 = 0
        let z: Int32 = 0
        let dimension = MCDimension.overworld
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)

        let digpKey = Data("digp".utf8) + keyPrefix
        let actorData = Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        try db.put(digpKey, actorData)

        let actorKey = Data("actorprefix".utf8) + actorData
        try db.put(actorKey, Data("test".utf8))

        // Execute test
        let keys = db.getPointerAndActorKeys(x: x, z: z, dimension: dimension)
        #expect(keys.count == 2)
        #expect(keys.contains(digpKey))
        #expect(keys.contains(actorKey))
    }

    @Test
    func testGetChunkKeys() throws {
        let dbPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_lvdb_\(UUID().uuidString)")
            .path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        let db = try LvDB(dbPath: dbPath, createIfMissing: true)
        defer { db.close() }

        // Prepare test data
        let x: Int32 = 0
        let z: Int32 = 0
        let dimension = MCDimension.overworld
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)

        // Add sub-chunk data
        let yIndex: Int8 = 0
        let subChunkKey = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
        try db.put(subChunkKey, Data("test".utf8))

        // Add other chunk data
        let finalizedStateKey = keyPrefix + LvDBChunkKeyType.finalizedState.rawValue.data
        try db.put(finalizedStateKey, Data("test".utf8))

        // Execute test
        let keys = db.getChunkKeys(x: x, z: z, dimension: dimension)
        #expect(keys.count == 2)
        #expect(keys.contains(subChunkKey))
        #expect(keys.contains(finalizedStateKey))
    }

    @Test
    func testGetPrefixedKeys() throws {
        let dbPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("test_lvdb_\(UUID().uuidString)")
            .path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        let db = try LvDB(dbPath: dbPath, createIfMissing: true)
        defer { db.close() }

        // Prepare test data
        let prefix = Data("test".utf8)
        let key1 = prefix + Data("1".utf8)
        let key2 = prefix + Data("2".utf8)
        let otherKey = Data("other".utf8)

        try db.put(key1, Data("value1".utf8))
        try db.put(key2, Data("value2".utf8))
        try db.put(otherKey, Data("value3".utf8))

        // Execute test
        let keys = try db.getPrefixedKeys(with: prefix)
        #expect(keys.count == 2)
        #expect(keys.contains(key1))
        #expect(keys.contains(key2))
    }
}
