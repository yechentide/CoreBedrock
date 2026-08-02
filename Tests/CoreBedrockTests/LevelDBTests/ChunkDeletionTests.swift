//
// Created by yechentide on 2026/08/02
//

@testable import CoreBedrock
import Foundation
import Testing

struct ChunkDeletionTests {
    @Test
    func deletingChunkRemovesChunkRecordsAndMalformedDigp() async throws {
        let path = FileManager.default.temporaryDirectory
            .appendingPathComponent("chunk-deletion-\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: path) }
        let db = try LevelDB(dbPath: path, createIfMissing: true)
        defer { db.close() }

        let x: Int32 = 12
        let z: Int32 = -3
        let subchunk = LvDBKeyFactory.makeChunkKey(
            x: x, z: z, dimension: .overworld, type: .subChunkPrefix, yIndex: 0
        )
        let blockEntities = LvDBKeyFactory.makeChunkKey(
            x: x, z: z, dimension: .overworld, type: .blockEntity
        )
        let digp = LvDBKeyFactory.makeDigpKey(x: x, z: z, dimension: .overworld)
        try db.putData(Data([0x01]), forKey: subchunk)
        try db.putData(Data([0x0A]), forKey: blockEntities)
        try db.putData(Data([0x01, 0x02, 0x03]), forKey: digp) // malformed actor list

        for try await _ in db.deleteChunksWithinRange(
            in: .overworld, fromChunkX: x, fromChunkZ: z, toChunkX: x, toChunkZ: z
        ) {}

        #expect(!db.containsKey(subchunk))
        #expect(!db.containsKey(blockEntities))
        #expect(!db.containsKey(digp))
    }

    @Test
    func deletingChunkRemovesActorsReferencedByDigp() async throws {
        let path = FileManager.default.temporaryDirectory
            .appendingPathComponent("chunk-actor-deletion-\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: path) }
        let db = try LevelDB(dbPath: path, createIfMissing: true)
        defer { db.close() }

        let x: Int32 = 7
        let z: Int32 = 9
        let actorID = Data([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88])
        let digp = LvDBKeyFactory.makeDigpKey(x: x, z: z, dimension: .overworld)
        let actor = LvDBKeyFactory.makeActorKey(id: actorID)
        try db.putData(actorID, forKey: digp)
        try db.putData(Data([0x0A]), forKey: actor)

        for try await _ in db.deleteChunksWithinRange(
            in: .overworld, fromChunkX: x, fromChunkZ: z, toChunkX: x, toChunkZ: z
        ) {}

        #expect(!db.containsKey(digp))
        #expect(!db.containsKey(actor))
    }
}
