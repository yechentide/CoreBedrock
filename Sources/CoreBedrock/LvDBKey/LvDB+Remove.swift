//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

public extension LvDB {
    func deleteAllChunks(in dimension: MCDimension) throws {
        try autoreleasepool {
            let iter = try self.makeIterator()
            let batch = LvDBWriteBatch()

            iter.seekToFirst()
            while iter.valid() {
                if Task.isCancelled {
                    throw CancellationError()
                }
                defer {
                    iter.next()
                }
                guard let key = iter.key() else {
                    break
                }

                autoreleasepool { [batch, iter] in
                    let lvdbKey = LvDBKey.parse(data: key)
                    if case let LvDBKey.subChunk(_, _, d, _, _) = lvdbKey, d == dimension {
                        batch.remove(key)
                    }
                    if case let LvDBKey.digp(_, _, d) = lvdbKey, d == dimension {
                        batch.remove(key)
                        if let digpData = iter.value(), !digpData.isEmpty, digpData.count % 8 == 0 {
                            for i in 0..<digpData.count / 8 {
                                let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
                                batch.remove(actorprefixKey)
                            }
                        }
                    }
                }

                if Task.isCancelled {
                    throw CancellationError()
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

    func deleteChunksWithinRange(
        in dimension: MCDimension,
        fromChunkX startX: Int32, fromChunkZ startZ: Int32,
        toChunkX endX: Int32, toChunkZ endZ: Int32
    ) throws {
        try autoreleasepool {
            let xRange = min(startX, endX)...max(startX, endX)
            let zRange = min(startZ, endZ)...max(startZ, endZ)
            let batch = LvDBWriteBatch()

            for x in xRange {
                if Task.isCancelled {
                    throw CancellationError()
                }
                try autoreleasepool {
                    for z in zRange {
                        autoreleasepool { [batch] in
                            let prefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
                            self.removeChunkKeys(keyPrefix: prefix, batch: batch)
                            self.removeActorAndDigpKeys(keyPrefix: prefix, batch: batch)
                        }
                        if batch.approximateSize() > 20000 {
                            if Task.isCancelled {
                                throw CancellationError()
                            }
                            try self.writeBatch(batch)
                            batch.clear()
                        }
                    }
                    if Task.isCancelled {
                        throw CancellationError()
                    }
                    try self.writeBatch(batch)
                    batch.clear()
                }
            }
        }
    }

    func deleteChunksOutsideRange(
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
                if Task.isCancelled {
                    throw CancellationError()
                }
                defer {
                    iter.next()
                }
                guard let key = iter.key() else {
                    break
                }

                autoreleasepool { [batch, iter, key, dimension] in
                    let lvdbKey = LvDBKey.parse(data: key)
                    if case let LvDBKey.subChunk(cx, cz, d, _, _) = lvdbKey,
                       d == dimension, !xRange.contains(cx) || !zRange.contains(cz) {
                        batch.remove(key)
                    }
                    if case let LvDBKey.digp(cx, cz, d) = lvdbKey,
                       d == dimension, !xRange.contains(cx) || !zRange.contains(cz) {
                        batch.remove(key)
                        if let digpData = iter.value(), !digpData.isEmpty, digpData.count % 8 == 0 {
                            for i in 0..<digpData.count / 8 {
                                let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
                                batch.remove(actorprefixKey)
                            }
                        }
                    }
                }

                if Task.isCancelled {
                    throw CancellationError()
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
        for yIndex in Int8(-4)...Int8(20) {
            let key = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            batch.remove(key)
        }
        for chunkKeyType in LvDBChunkKeyType.allCases {
            guard chunkKeyType != .subChunkPrefix else {
                continue
            }

            let key = keyPrefix + chunkKeyType.rawValue.data
            batch.remove(key)
        }
    }

    private func removeActorAndDigpKeys(keyPrefix: Data, batch: LvDBWriteBatch) {
        let digpKey = Data("digp".utf8) + keyPrefix

        guard let digpData = try? get(digpKey), !digpData.isEmpty, digpData.count % 8 == 0 else {
            return
        }

        for i in 0..<digpData.count / 8 {
            let actorprefixKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
            batch.remove(actorprefixKey)
        }
        batch.remove(digpKey)
    }
}
