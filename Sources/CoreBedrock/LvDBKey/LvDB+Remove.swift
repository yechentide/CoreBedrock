//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

extension LvDB {
    public func removeChunkKeys(keyPrefix: Data, completion: ((Data, Bool) -> Void)? = nil) {
        (Int8(-4)...Int8(20)).forEach { yIndex in
            let key = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            guard contains(key) else {
                return
            }
            let result = remove(key)
            completion?(key, result)
        }
        LvDBChunkKeyType.allCases.forEach { chunkKeyType in
            guard chunkKeyType != .subChunkPrefix else {
                return
            }
            let key = keyPrefix + chunkKeyType.rawValue.data
            guard contains(key) else {
                return
            }
            let result = remove(key)
            completion?(key, result)
        }
    }

    public func removeActorAndDigpKeys(keyPrefix: Data, completion: ((Data, Bool) -> Void)? = nil) {
        let digpKey = "digp".data(using: .utf8)! + keyPrefix

        guard let digpData = get(digpKey), digpData.count > 0, digpData.count % 8 == 0 else {
            return
        }
        for i in 0..<digpData.count/8 {
            let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
            let result = remove(actorprefixKey)
            completion?(actorprefixKey, result)
        }
        let result = remove(digpKey)
        completion?(digpKey, result)
    }

    public func removeChunks(
        posIndexs: [Pos2Di32], dimension: MCDimension, completion: ((Data, Bool) -> Void)? = nil
    ) {
        posIndexs.forEach {
            let prefix = LvDBKeyFactory.makeBaseChunkKey(x: $0.x, z: $0.z, dimension: dimension)
            removeChunkKeys(keyPrefix: prefix, completion: completion)
            removeActorAndDigpKeys(keyPrefix: prefix, completion: completion)
            completion?(Data(), true)
        }
    }
}
