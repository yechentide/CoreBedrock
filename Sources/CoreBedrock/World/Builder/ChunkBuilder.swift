//
// Created by yechentide on 2025/04/29
//

import LvDBWrapper

public enum ChunkBuilder {
    public static func build(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension, options: MCChunkReadOptions) -> MCChunk? {
        guard let iter = db.makeIterator() else {
            return nil
        }
        defer {
            iter.destroy()
        }

        let baseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        iter.seek(baseKey)

        guard let chunkVersion = loadChunkVersion(iter: iter, baseKey: baseKey) else {
            return nil
        }

        var minChunkY = 0
        let subChunks: [MCSubChunk] = options.contains(.block)
            ? loadSubChunks(iter: iter, baseKey: baseKey, dimension: dimension, minChunkY: &minChunkY)
            : []

        let blockEntities: [Pos3Di32: CompoundTag] = options.contains(.biome)
            ? loadBlockEntities(iter: iter, baseKey: baseKey)
            : [:]

        let entities: [CompoundTag] = options.contains(.entities)
            ? loadEntities(db: db, iter: iter, baseKey: baseKey)
            : []

        var currentTick: Int32 = 0
        let pendingTicks: [MCPendingTick] = options.contains(.pendingTicks)
            ? loadPendingTicks(iter: iter, baseKey: baseKey, currentTick: &currentTick)
            : []

        let biomes: MCBiomeColumn
        if options.contains(.biome), let result = loadBiomes(iter: iter, baseKey: baseKey, chunkY: 0) {
            biomes = result
        } else {
            biomes = MCBiomeColumn(minChunkY: minChunkY, sections: [])
        }

        return MCChunk(
            loadOption: options,
            chunkX: chunkX,
            chunkZ: chunkZ,
            minChunkY: Int32(truncatingIfNeeded: minChunkY),
            version: chunkVersion,
            subChunks: subChunks,
            blockEntities: blockEntities,
            entities: entities,
            pendingTicks: pendingTicks,
            biomes: biomes
        )
    }

    private static func loadBiomes(iter: LvDBIterator, baseKey: Data, chunkY: Int) -> MCBiomeColumn? {
        let data3DKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .data3D)
        iter.seek(data3DKey)
        if let data3DData = iter.value() {
            let parser = BiomeDataParser(data: data3DData)
            return try? parser.parse(minChunkY: chunkY)
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

    private static func loadPendingTicks(iter: LvDBIterator, baseKey: Data, currentTick: inout Int32) -> [MCPendingTick] {
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

    private static func loadEntities(db: LvDB, iter: LvDBIterator, baseKey: Data) -> [CompoundTag] {
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

    private static func loadBlockEntities(iter: LvDBIterator, baseKey: Data) -> [Pos3Di32: CompoundTag] {
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

    private static func loadSubChunks(iter: LvDBIterator, baseKey: Data, dimension: MCDimension, minChunkY: inout Int) -> [MCSubChunk] {
        var subChunks = [MCSubChunk]()
        var actualMinChunkY: Int8 = 0
        let expectKeyLength = dimension == .overworld ? 10 : 14
        let firstKey = LvDBKeyFactory.makeChunkKey(base: baseKey, type: .subChunkPrefix, yIndex: 0)
        iter.seek(firstKey)
        while iter.valid() {
            defer {
                iter.next()
            }
            guard let key = iter.key(), key.count == expectKeyLength, let subChunkData = iter.value() else {
                break
            }
            let chunkY = key[key.count-1].data.int8
            let parser = BlockDataParser(data: subChunkData, chunkY: chunkY)
            guard let subChunk = try? parser.parse() else {
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

    private static func loadChunkVersion(iter: LvDBIterator, baseKey: Data) -> UInt8? {
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

}
