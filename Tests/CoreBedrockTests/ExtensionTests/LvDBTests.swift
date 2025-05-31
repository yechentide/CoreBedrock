//
// Created by yechentide on 2025/05/31
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct LvDBTests {
    // Helper function to create a temporary path for LevelDB
    private func temporaryDBPath() -> String {
        let tempDir = FileManager.default.temporaryDirectory
        let dbName = "testDB-\(UUID().uuidString)"
        return tempDir.appendingPathComponent(dbName).path
    }

    // Helper function to clean up the database
    private func cleanupDB(at path: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
        }
    }

    @Test
    func testChunkExists_withVersionKey() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let chunkX: Int32 = 1
        let chunkZ: Int32 = 2
        let dimension: MCDimension = .overworld
        let versionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .chunkVersion)
        let versionData = Data([0x03])
        #expect(db.put(versionKey, versionData))
        #expect(db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: dimension))
    }

    @Test
    func testChunkExists_withLegacyVersionKey() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let chunkX: Int32 = 1
        let chunkZ: Int32 = 2
        let dimension: MCDimension = .overworld
        let legacyVersionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .legacyChunkVersion)
        let versionData = Data([0x03])
        #expect(db.put(legacyVersionKey, versionData))
        let result = db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: dimension)
        #expect(result == true)
    }

    @Test
    func testChunkExists_whenDoesNotExist() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let chunkX: Int32 = 1
        let chunkZ: Int32 = 2
        let dimension: MCDimension = .overworld
        #expect(!db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: dimension))
    }

    @Test
    func testChunkExists_withInvalidData() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let chunkX: Int32 = 1
        let chunkZ: Int32 = 2
        let dimension: MCDimension = .overworld
        let versionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .chunkVersion)
        let invalidData = Data([0x01, 0x02])
        #expect(db.put(versionKey, invalidData))
        #expect(!db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: dimension))
    }

    @Test
    func testChunkExists_inDifferentDimension() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let chunkX: Int32 = 1
        let chunkZ: Int32 = 2
        let versionData = Data([0x03])
        let otherDimensionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: .theNether, type: .chunkVersion)
        #expect(db.put(otherDimensionKey, versionData))
        #expect(!db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: .overworld)) // Should not find it in overworld
        #expect(db.chunkExists(chunkX: Int(chunkX), chunkZ: Int(chunkZ), dimension: .theNether)) // Should find it in nether
    }

    @Test
    func testScanExistingChunks_overworld() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }

        let versionData = Data([0x03])
        let overworldChunk1Key = LvDBKeyFactory.makeChunkKey(x: 1, z: 1, dimension: .overworld, type: .chunkVersion)
        let overworldChunk2Key = LvDBKeyFactory.makeChunkKey(x: 1, z: 2, dimension: .overworld, type: .legacyChunkVersion)
        // Add a key for another dimension to ensure it's not picked up
        let netherChunkKey = LvDBKeyFactory.makeChunkKey(x: 2, z: 1, dimension: .theNether, type: .chunkVersion)
        // Add a non-chunk version key to ensure it's ignored
        // This key should represent a type that scanExistingChunks is NOT looking for.
        let nonChunkVersionKey = LvDBKeyFactory.makeChunkKey(x: 3, z: 3, dimension: .overworld, type: .subChunkPrefix, yIndex: 0)


        #expect(db.put(overworldChunk1Key, versionData))
        #expect(db.put(overworldChunk2Key, versionData))
        #expect(db.put(netherChunkKey, versionData))
        #expect(db.put(nonChunkVersionKey, Data([0x01,0x02,0x03])))


        var foundOverworldChunks = [(Int32, Int32)]()
        let scanResult = db.scanExistingChunks(dimension: .overworld) { x, z in
            foundOverworldChunks.append((x, z))
            return true
        }
        #expect(scanResult)
        #expect(foundOverworldChunks.count == 2)
        #expect(foundOverworldChunks.contains(where: { $0 == (1, 1) }))
        #expect(foundOverworldChunks.contains(where: { $0 == (1, 2) }))
    }

    @Test
    func testScanExistingChunks_nether() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }
        let versionData = Data([0x03])
        let overworldChunkKey = LvDBKeyFactory.makeChunkKey(x: 1, z: 1, dimension: .overworld, type: .chunkVersion)
        let netherChunk1Key = LvDBKeyFactory.makeChunkKey(x: 2, z: 1, dimension: .theNether, type: .chunkVersion)
        let netherChunk2Key = LvDBKeyFactory.makeChunkKey(x: 2, z: 2, dimension: .theNether, type: .legacyChunkVersion)
         // Add a non-chunk version key to ensure it's ignored
        // This key should represent a type that scanExistingChunks is NOT looking for.
        let nonChunkVersionKey = LvDBKeyFactory.makeChunkKey(x: 3, z: 3, dimension: .theNether, type: .subChunkPrefix, yIndex: 0)


        #expect(db.put(overworldChunkKey, versionData))
        #expect(db.put(netherChunk1Key, versionData))
        #expect(db.put(netherChunk2Key, versionData))
        #expect(db.put(nonChunkVersionKey, Data([0x01,0x02,0x03])))

        var foundNetherChunks = [(Int32, Int32)]()
        let scanResult = db.scanExistingChunks(dimension: .theNether) { x, z in
            foundNetherChunks.append((x, z))
            return true
        }
        #expect(scanResult)
        #expect(foundNetherChunks.count == 2)
        #expect(foundNetherChunks.contains(where: { $0 == (2, 1) }))
        #expect(foundNetherChunks.contains(where: { $0 == (2, 2) }))
    }

    @Test
    func testScanExistingChunks_handlerStopsEarly() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }
        let versionData = Data([0x03])
        // Add multiple chunks to ensure the handler can stop early
        let overworldChunk1Key = LvDBKeyFactory.makeChunkKey(x: 1, z: 1, dimension: .overworld, type: .chunkVersion)
        let overworldChunk2Key = LvDBKeyFactory.makeChunkKey(x: 1, z: 2, dimension: .overworld, type: .legacyChunkVersion)
        #expect(db.put(overworldChunk1Key, versionData))
        #expect(db.put(overworldChunk2Key, versionData))

        var processedCount = 0
        let scanResult = db.scanExistingChunks(dimension: .overworld) { x, z in
            processedCount += 1
            return false // Stop after the first one
        }
        #expect(!scanResult) // scanExistingChunks should return false if handler returned false
        #expect(processedCount == 1)
    }

    @Test
    func testScanExistingChunks_emptyDimension() {
        let dbPath = temporaryDBPath()
        guard let db = LvDB(dbPath: dbPath, createIfMissing: true) else {
            Issue.record("Failed to create database")
            return
        }
        defer {
            db.close()
            cleanupDB(at: dbPath)
        }
        // Add a chunk to a different dimension to ensure it's not picked up
        let versionData = Data([0x03])
        let netherChunkKey = LvDBKeyFactory.makeChunkKey(x: 2, z: 1, dimension: .theNether, type: .chunkVersion)
        #expect(db.put(netherChunkKey, versionData))

        var foundTheEndChunks = [(Int32, Int32)]()
        let scanResult = db.scanExistingChunks(dimension: .theEnd) { x, z in
            foundTheEndChunks.append((x, z))
            return true
        }
        #expect(scanResult)
        #expect(foundTheEndChunks.isEmpty)
    }
}
