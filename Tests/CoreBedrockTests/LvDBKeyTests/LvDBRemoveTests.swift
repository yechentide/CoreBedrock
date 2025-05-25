//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct LvDBRemoveTests {
    @Test
    func testRemoveChunkKeys() async throws {
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
        var removedKeys: [Data] = []
        db.removeChunkKeys(keyPrefix: keyPrefix) { key, success in
            if success {
                removedKeys.append(key)
            }
        }

        #expect(removedKeys.count == 2)
        #expect(removedKeys.contains(subChunkKey))
        #expect(removedKeys.contains(finalizedStateKey))
        #expect(!db.contains(subChunkKey))
        #expect(!db.contains(finalizedStateKey))
    }

    @Test
    func testRemoveActorAndDigpKeys() async throws {
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
        var removedKeys: [Data] = []
        db.removeActorAndDigpKeys(keyPrefix: keyPrefix) { key, success in
            if success {
                removedKeys.append(key)
            }
        }

        #expect(removedKeys.count == 2)
        #expect(removedKeys.contains(digpKey))
        #expect(removedKeys.contains(actorKey))
        #expect(!db.contains(digpKey))
        #expect(!db.contains(actorKey))
    }

    @Test
    func testRemoveChunks() async throws {
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

        // Add chunk data
        let subChunkKey = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + Int8(0).data
        db.put(subChunkKey, "test".data(using: .utf8)!)

        // Add actor data
        let digpKey = "digp".data(using: .utf8)! + keyPrefix
        let actorData = Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        db.put(digpKey, actorData)

        let actorKey = "actorprefix".data(using: .utf8)! + actorData
        db.put(actorKey, "test".data(using: .utf8)!)

        // Execute test
        var removedKeys: [Data] = []
        db.removeChunks(posIndexs: [Pos2Di32(x: x, z: z)], dimension: dimension) { key, success in
            if success && !key.isEmpty {
                removedKeys.append(key)
            }
        }

        #expect(removedKeys.count == 3)
        #expect(removedKeys.contains(subChunkKey))
        #expect(removedKeys.contains(digpKey))
        #expect(removedKeys.contains(actorKey))
        #expect(!db.contains(subChunkKey))
        #expect(!db.contains(digpKey))
        #expect(!db.contains(actorKey))
    }
}
