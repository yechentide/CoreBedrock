//
// Created by yechentide on 2025/04/29
//

import LvDBWrapper

public enum ChunkBuilder {
    public static func build(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension, options: MCChunkReadOptions) -> MCChunk? {
        guard let chunkVersion = loadChunkVersion(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension) else {
            return nil
        }

        var minChunkY = 0
        let subChunks = loadSubChunks(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension, minChunkY: &minChunkY)

        let blockEntities: [Pos3Di32: CompoundTag] = options.contains(.biome)
        ? loadBlockEntities(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension)
        : [:]

        let entities: [CompoundTag] = options.contains(.entities)
        ? loadEntities(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension)
        : []

        var currentTick: Int32 = 0
        let pendingTicks: [MCPendingTick] = options.contains(.pendingTicks)
        ? loadPendingTicks(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension, currentTick: &currentTick)
        : []

        let biomes: MCBiomeColumn
        if options.contains(.biome), let result = loadBiomes(db: db, chunkX: chunkX, chunkY: 0, chunkZ: chunkZ, dimension: dimension) {
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

    private static func loadBiomes(db: LvDB, chunkX: Int32, chunkY: Int, chunkZ: Int32, dimension: MCDimension) -> MCBiomeColumn? {
        let data3DKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .data3D)
        if let data3DData = db.get(data3DKey) {
            let parser = BiomeDataParser(data: data3DData)
            return try? parser.parse(minChunkY: chunkY)
        }

        let data2DKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .data2D)
        guard let data2DData = db.get(data2DKey), data2DData.count >= 768 else {
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

    private static func loadPendingTicks(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension, currentTick: inout Int32) -> [MCPendingTick] {
        let lvdbKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .pendingTicks)
        guard let lvdbData = db.get(lvdbKey) else {
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

    private static func loadEntities(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension) -> [CompoundTag] {
        var entities: [CompoundTag] = []

        let entityKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .entity)
        if let entityData = db.get(entityKey) {
            let reader = CBTagReader(data: entityData)
            try? reader.readAll().forEach { tag in
                guard let rootTag = tag as? CompoundTag else {
                    return
                }
                entities.append(rootTag)
            }
        }

        let digpKey = LvDBKeyFactory.makeDigpKey(x: chunkX, z: chunkZ, dimension: dimension)
        guard let digpData = db.get(digpKey) else {
            return entities
        }
        let _ = db.enumerateActorKeys(digpData: digpData) { index, keyData in
            let lvdbKey = LvDBKeyFactory.makeActorKey(id: keyData)
            guard let entityData = db.get(lvdbKey) else {
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

    private static func loadBlockEntities(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension) -> [Pos3Di32: CompoundTag] {
        var blockEntities: [Pos3Di32: CompoundTag] = [:]

        let lvdbKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .blockEntity)
        guard let lvdbValue = db.get(lvdbKey) else {
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

    private static func loadSubChunks(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension, minChunkY: inout Int) -> [MCSubChunk] {
        var subChunks = [MCSubChunk]()
        let possibleMinChunkY: Int8 = dimension == .overworld ? -4 : 0
        let possibleMaxChunkY: Int8 = dimension == .overworld ? 19 : 15
        var actualMinChunkY: Int8 = 0

        for chunkY in possibleMinChunkY...possibleMaxChunkY {
            let subChunkKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .subChunkPrefix, yIndex: chunkY)
            guard let subChunkData = db.get(subChunkKey) else {
                continue
            }
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

    private static func loadChunkVersion(db: LvDB, chunkX: Int32, chunkZ: Int32, dimension: MCDimension) -> UInt8? {
        let versionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .chunkVersion)
        if let versionData = db.get(versionKey) {
            guard versionData.count == 1 else {
                return nil
            }
            return versionData.uint8
        }
        let legacyVersionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .legacyChunkVersion)
        if let legacyVersionData = db.get(legacyVersionKey) {
            guard legacyVersionData.count == 1 else {
                return nil
            }
            return legacyVersionData.uint8
        }
        return nil
    }

}
