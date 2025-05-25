//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct ExtractTests {
    @Test
    func testGetStringKey() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create LevelDB instance")
            return
        }
        defer { db.close() }

        // Prepare test data
        let keyType = LvDBStringKeyType.localPlayer
        let value = "1.20.0"
        db.put(keyType.rawValue.data(using: .utf8)!, value.data(using: .utf8)!)

        // Execute test
        let result = db.getStringKey(type: keyType)
        #expect(result != nil)
        #expect(result == keyType.rawValue.data(using: .utf8))
    }

    @Test
    func testGetAllStringKeys() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create LevelDB instance")
            return
        }
        defer { db.close() }

        // Prepare test data
        let testKeys = [
            LvDBStringKeyType.localPlayer,
            LvDBStringKeyType.overworld,
            LvDBStringKeyType.scoreboard
        ]

        for key in testKeys {
            db.put(key.rawValue.data(using: .utf8)!, "test".data(using: .utf8)!)
        }

        // Execute test
        let keys = db.getAllStringKeys()
        #expect(keys.count == testKeys.count)

        // Test exclusion
        let excludeKeys = db.getAllStringKeys(exclude: [.localPlayer])
        #expect(excludeKeys.count == testKeys.count - 1)
    }

    @Test
    func testGetPointerAndActorKeys() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create LevelDB instance")
            return
        }
        defer { db.close() }

        // Prepare test data
        let x: Int32 = 0
        let z: Int32 = 0
        let dimension = MCDimension.overworld
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)

        let digpKey = "digp".data(using: .utf8)! + keyPrefix
        let actorData = Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        db.put(digpKey, actorData)

        let actorKey = "actorprefix".data(using: .utf8)! + actorData
        db.put(actorKey, "test".data(using: .utf8)!)

        // Execute test
        let keys = db.getPointerAndActorKeys(x: x, z: z, dimension: dimension)
        #expect(keys.count == 2)
        #expect(keys.contains(digpKey))
        #expect(keys.contains(actorKey))
    }

    @Test
    func testGetChunkKeys() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create LevelDB instance")
            return
        }
        defer { db.close() }

        // Prepare test data
        let x: Int32 = 0
        let z: Int32 = 0
        let dimension = MCDimension.overworld
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)

        // Add sub-chunk data
        let yIndex: Int8 = 0
        let subChunkKey = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
        db.put(subChunkKey, "test".data(using: .utf8)!)

        // Add other chunk data
        let finalizedStateKey = keyPrefix + LvDBChunkKeyType.finalizedState.rawValue.data
        db.put(finalizedStateKey, "test".data(using: .utf8)!)

        // Execute test
        let keys = db.getChunkKeys(x: x, z: z, dimension: dimension)
        #expect(keys.count == 2)
        #expect(keys.contains(subChunkKey))
        #expect(keys.contains(finalizedStateKey))
    }

    @Test
    func testGetPrefixedKeys() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }

        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create LevelDB instance")
            return
        }
        defer { db.close() }

        // Prepare test data
        let prefix = "test".data(using: .utf8)!
        let key1 = prefix + "1".data(using: .utf8)!
        let key2 = prefix + "2".data(using: .utf8)!
        let otherKey = "other".data(using: .utf8)!

        db.put(key1, "value1".data(using: .utf8)!)
        db.put(key2, "value2".data(using: .utf8)!)
        db.put(otherKey, "value3".data(using: .utf8)!)

        // Execute test
        let keys = db.getPrefixedKeys(with: prefix)
        #expect(keys.count == 2)
        #expect(keys.contains(key1))
        #expect(keys.contains(key2))
    }
}
