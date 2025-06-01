//
// Created by yechentide on 2025/05/10
//

import Foundation
import LvDBWrapper

public struct ChunkDataLoader {
    public static func loadChunkVersion(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32) -> UInt8? {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadChunkVersion(iter: iter, baseKey: baseKey)

    }
    public static func loadChunkVersion(iter: LvDBIterator, baseKey: Data) -> UInt8? {
        let versionKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .chunkVersion)
        iter.seek(versionKey)
        if iter.valid() {
            guard let versionData = iter.value(), versionData.count == 1 else {
                return nil
            }
            return versionData.uint8
        }
        let legacyVersionKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .legacyChunkVersion)
        iter.seek(legacyVersionKey)
        if iter.valid() {
            guard let versionData = iter.value(), versionData.count == 1 else {
                return nil
            }
            return versionData.uint8
        }
        return nil
    }

    public static func loadSubChunk(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkY: Int8, chunkZ: Int32) -> MCSubChunk? {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadSubChunk(iter: iter, baseKey: baseKey, chunkY: chunkY)
    }
    public static func loadSubChunk(iter: LvDBIterator, baseKey: Data, chunkY: Int8) -> MCSubChunk? {
        let destination = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .subChunkPrefix, yIndex: chunkY)
        iter.seek(destination)
        guard let key = iter.key(), key == destination, let subChunkData = iter.value() else {
            return nil
        }
        let parser = SubChunkBlockParser(data: subChunkData, chunkY: chunkY)
        guard let subChunk = try? parser.parse() else {
            return nil
        }
        return subChunk
    }

    public static func loadSubChunks(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32, minChunkY: inout Int) -> [MCSubChunk] {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadSubChunks(iter: iter, baseKey: baseKey, dimension: dimension, minChunkY: &minChunkY)
    }
    public static func loadSubChunks(iter: LvDBIterator, baseKey: Data, dimension: MCDimension, minChunkY: inout Int) -> [MCSubChunk] {
        var subChunks = [MCSubChunk]()
        var actualMinChunkY: Int8 = 0
        for chunkY in dimension.chunkYRange {
            guard let subChunk = loadSubChunk(iter: iter, baseKey: baseKey, chunkY: chunkY) else {
                continue
            }
            subChunks.append(subChunk)
            actualMinChunkY = min(actualMinChunkY, chunkY)
        }

        minChunkY = 0
        if dimension == .overworld && actualMinChunkY < 0 {
            minChunkY = -4
        }

        return subChunks
    }

    public static func loadBiomes(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32) -> MCBiomeColumn? {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadBiomes(iter: iter, baseKey: baseKey, dimension: dimension)
    }
    public static func loadBiomes(iter: LvDBIterator, baseKey: Data, dimension: MCDimension) -> MCBiomeColumn? {
        let data3DKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .data3D)
        iter.seek(data3DKey)
        if let data3DData = iter.value() {
            let parser = ChunkBiomeParser(data: data3DData, dimension: dimension)
            return try? parser.parse()
        }

        let data2DKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .data2D)
        iter.seek(data2DKey)
        guard let data2DData = iter.value(), data2DData.count >= 768 else {
            return nil
        }
        let biomeColumn = MCBiomeColumn(minChunkY: 0, maxChunkY: 15)
        let biomeBytes = data2DData.subdata(in: 512..<768) // 512+256=768
        var biomesXZ: [[MCBiomeType]] = Array(repeating: Array(repeating: .unknown, count: 16), count: 16)

        for z in 0..<16 {
            for x in 0..<16 {
                let idx = z * 16 + x
                let byte = biomeBytes[idx]
                biomesXZ[x][z] = MCBiomeType.from(UInt32(byte))
            }
        }

        biomeColumn.setColumnBiomes(biomesXZ)
        return biomeColumn
    }

    public static func loadBlockEntities(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32) -> [Pos3Di32: CompoundTag] {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadBlockEntities(iter: iter, baseKey: baseKey)
    }
    public static func loadBlockEntities(iter: LvDBIterator, baseKey: Data) -> [Pos3Di32: CompoundTag] {
        var blockEntities: [Pos3Di32: CompoundTag] = [:]

        let lvdbKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .blockEntity)
        iter.seek(lvdbKey)
        guard let lvdbValue = iter.value() else {
            return blockEntities
        }

        let reader = CBTagReader(data: lvdbValue)
        try? reader.readAll().forEach { tag in
            guard let rootTag = tag as? CompoundTag,
                  let x = rootTag["x"]?.intValue,
                  let y = rootTag["y"]?.intValue,
                  let z = rootTag["z"]?.intValue
            else {
                return
            }
            let pos = Pos3Di32(x: x, y: y, z: z)
            blockEntities[pos] = rootTag
        }

        return blockEntities
    }

    public static func loadEntities(db: LvDB, iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32) -> [CompoundTag] {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadEntities(db: db, iter: iter, baseKey: baseKey)
    }
    public static func loadEntities(db: LvDB, iter: LvDBIterator, baseKey: Data) -> [CompoundTag] {
        var entities: [CompoundTag] = []

        let entityKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .entity)
        iter.seek(entityKey)
        if let entityData = iter.value() {
            let reader = CBTagReader(data: entityData)
            try? reader.readAll().forEach { tag in
                guard let rootTag = tag as? CompoundTag else {
                    return
                }
                entities.append(rootTag)
            }
        }

        let digpKey = LvDBKeyFactory.makeDigpKey(base: baseKey)
        iter.seek(digpKey)
        guard let digpData = iter.value() else {
            return entities
        }
        let _ = db.enumerateActorKeys(digpData: digpData) { index, keyData in
            let actorKey = LvDBKeyFactory.makeActorKey(id: keyData)
            iter.seek(actorKey)
            guard let entityData = iter.value() else {
                return
            }
            let reader = CBTagReader(data: entityData)
            guard let rootTag = try? reader.readNext() as? CompoundTag else {
                return
            }
            entities.append(rootTag)
        }

        return entities
    }

    public static func loadPendingTicks(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32, currentTick: inout Int32) -> [MCPendingTick] {
        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        return loadPendingTicks(iter: iter, baseKey: baseKey, currentTick: &currentTick)
    }
    public static func loadPendingTicks(iter: LvDBIterator, baseKey: Data, currentTick: inout Int32) -> [MCPendingTick] {
        let lvdbKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .pendingTicks)
        iter.seek(lvdbKey)
        guard let lvdbData = iter.value() else {
            return []
        }

        let reader = CBTagReader(data: lvdbData)
        guard let rootTag = try? reader.readNext() as? CompoundTag,
              let currentTickTag = rootTag["currentTick"] as? IntTag,
              let tickListTag = rootTag["tickList"] as? ListTag
        else {
            return []
        }

        var pendingTicks: [MCPendingTick] = []
        currentTick = currentTickTag.value

        tickListTag.tags.forEach { tag in
            guard let rootTag = tag as? CompoundTag,
                  let pendingTick = MCPendingTick.parse(rootTag: rootTag)
            else {
                return
            }
            pendingTicks.append(pendingTick)
        }

        return pendingTicks
    }
}
