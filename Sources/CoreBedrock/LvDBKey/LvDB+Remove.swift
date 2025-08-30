//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

extension LvDB {
    public func deleteAllChunks(in dimension: MCDimension) throws {
        try autoreleasepool {
            let iter = try self.makeIterator()
            let batch = LvDBWriteBatch()

            iter.seekToFirst()
            while iter.valid() {
                defer {
                    iter.next()
                }
                guard let key = iter.key() else {
                    break
                }
                autoreleasepool { [batch, iter] in
                    let keyType = LvDBKeyType.parse(data: key)
                    if case LvDBKeyType.subChunk(_, _, let d, _, _) = keyType, d == dimension {
                        batch.remove(key)
                    }
                    if case LvDBKeyType.digp(_, _, let d) = keyType, d == dimension {
                        batch.remove(key)
                        if let digpData = iter.value(), digpData.count > 0, digpData.count % 8 == 0 {
                            for i in 0..<digpData.count/8 {
                                let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
                                batch.remove(actorprefixKey)
                            }
                        }
                    }
                }

                try autoreleasepool {
                    if batch.approximateSize() > 20000 {
                        try self.writeBatch(batch)
                        batch.clear()
                    }
                }
            }
            try self.writeBatch(batch)
            batch.clear()
        }
    }

    public func deleteChunksWithinRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32
    ) throws {
        try autoreleasepool {
            let xRange = min(startX, endX)...max(startX, endX)
            let zRange = min(startZ, endZ)...max(startZ, endZ)
            let batch = LvDBWriteBatch()

            for x in xRange {
                try autoreleasepool {
                    for z in zRange {
                        autoreleasepool { [batch] in
                            let prefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
                            removeChunkKeys(keyPrefix: prefix, batch: batch)
                            removeActorAndDigpKeys(keyPrefix: prefix, batch: batch)
                        }
                        if batch.approximateSize() > 20000 {
                            try self.writeBatch(batch)
                            batch.clear()
                        }
                    }
                    try self.writeBatch(batch)
                    batch.clear()
                }
            }
        }
    }

    public func deleteChunksOutsideRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32
    ) throws {
        try autoreleasepool {
            let xRange = min(startX, endX)...max(startX, endX)
            let zRange = min(startZ, endZ)...max(startZ, endZ)
            let iter = try self.makeIterator()
            let batch = LvDBWriteBatch()

            iter.seekToFirst()
            while iter.valid() {
                defer {
                    iter.next()
                }
                guard let key = iter.key() else {
                    break
                }
                autoreleasepool { [batch, iter, key, dimension] in
                    let keyType = LvDBKeyType.parse(data: key)
                    if case LvDBKeyType.subChunk(let cx, let cz, let d, _, _) = keyType,
                       d == dimension, (!xRange.contains(cx) || !zRange.contains(cz))
                    {
                        batch.remove(key)
                    }
                    if case LvDBKeyType.digp(let cx, let cz, let d) = keyType,
                       d == dimension, (!xRange.contains(cx) || !zRange.contains(cz))
                    {
                        batch.remove(key)
                        if let digpData = iter.value(), digpData.count > 0, digpData.count % 8 == 0 {
                            for i in 0..<digpData.count/8 {
                                let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
                                batch.remove(actorprefixKey)
                            }
                        }
                    }
                }

                try autoreleasepool {
                    if batch.approximateSize() > 20000 {
                        try self.writeBatch(batch)
                        batch.clear()
                    }
                }
            }
            try self.writeBatch(batch)
            batch.clear()
        }
    }

    private func removeChunkKeys(keyPrefix: Data, batch: LvDBWriteBatch) {
        (Int8(-4)...Int8(20)).forEach { yIndex in
            let key = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            batch.remove(key)
        }
        LvDBChunkKeyType.allCases.forEach { chunkKeyType in
            guard chunkKeyType != .subChunkPrefix else {
                return
            }
            let key = keyPrefix + chunkKeyType.rawValue.data
            batch.remove(key)
        }
    }

    private func removeActorAndDigpKeys(keyPrefix: Data, batch: LvDBWriteBatch) {
        let digpKey = "digp".data(using: .utf8)! + keyPrefix

        guard let digpData = try? get(digpKey), digpData.count > 0, digpData.count % 8 == 0 else {
            return
        }
        for i in 0..<digpData.count/8 {
            let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
            batch.remove(actorprefixKey)
        }
        batch.remove(digpKey)
    }
}
