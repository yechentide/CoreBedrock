//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

extension LvDB {
    public func deleteAllChunks(in dimension: MCDimension) throws {
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

            if batch.approximateSize() > 20000 {
                try self.writeBatch(batch)
                batch.clear()
            }
        }

        try self.compactRange(withBegin: nil, end: nil)
    }

    public func deleteChunksWithinRange(
        in dimension: MCDimension,
        fromX startX: Int32, fromZ startZ: Int32,
        toX endX: Int32, toZ endZ: Int32
    ) throws {
        let xRange = min(startX, endX)...max(startX, endX)
        let zRange = min(startZ, endZ)...max(startZ, endZ)
        let iter = try self.makeIterator()
        let batch = LvDBWriteBatch()

        for x in xRange {
            for z in zRange {
                let prefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
                iter.seek(prefix)
                while iter.valid() {
                    defer {
                        iter.next()
                    }
                    guard let key = iter.key() else {
                        break
                    }
                    let keyType = LvDBKeyType.parse(data: key)
                    if case LvDBKeyType.subChunk(let cx, let cz, let d, _, _) = keyType,
                       d == dimension, cx == x, cz == z
                    {
                        batch.remove(key)
                    }
                }
                let digpKey = LvDBKeyFactory.makeDigpKey(base: prefix)
                batch.remove(digpKey)
                iter.seek(digpKey)
                if iter.key() == digpKey, let digpData = iter.value(), digpData.count > 0, digpData.count % 8 == 0 {
                    for i in 0..<digpData.count/8 {
                        let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
                        batch.remove(actorprefixKey)
                    }
                }
                if batch.approximateSize() > 20000 {
                    try self.writeBatch(batch)
                    batch.clear()
                }
            }

            try self.compactRange(withBegin: nil, end: nil)
        }
    }

    public func deleteChunksOutsideRange(
        in dimension: MCDimension,
        fromX startX: Int32, fromZ startZ: Int32,
        toX endX: Int32, toZ endZ: Int32
    ) throws {
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

            if batch.approximateSize() > 20000 {
                try self.writeBatch(batch)
                batch.clear()
            }
        }

        try self.compactRange(withBegin: nil, end: nil)
    }
}
