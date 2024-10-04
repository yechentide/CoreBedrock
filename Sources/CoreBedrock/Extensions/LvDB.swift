//
// Created by yechentide on 2024/10/04
//

import LvDBWrapper

// MARK: Functions to extract leveldb keys
extension LvDB {
    public func getStringKey(type: MCStringKeyType) -> Data? {
        let keyData = type.rawValue.data(using: .utf8)!
        guard contains(keyData) else {
            return nil
        }
        return keyData
    }

    public func getAllStringKeys(exclude: [MCStringKeyType] = []) -> [Data] {
        var keys = [Data]()
        let excludeTypes = Set(exclude)

        for strKeyType in MCStringKeyType.allCases {
            guard !excludeTypes.contains(strKeyType),
                  let keyData = strKeyType.rawValue.data(using: .utf8),
                  contains(keyData)
            else {
                continue
            }
            keys.append(keyData)
        }
        return keys
    }

    public func getPointerAndActorKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKey.makeChunkKeyPrefix(x: x, z: z, dimension: dimension)
        var keys = [Data]()

        let digpKey = "digp".data(using: .utf8)! + keyPrefix
        guard contains(digpKey),
              let digpData = get(digpKey),
              digpData.count > 0,
              digpData.count % 8 == 0
        else {
            return keys
        }
        keys.append(digpKey)

        for i in 0..<digpData.count/8 {
            let actorKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
            guard contains(actorKey) else {
                continue
            }
            keys.append(actorKey)
        }
        return keys
    }

    public func getChunkKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKey.makeChunkKeyPrefix(x: x, z: z, dimension: dimension)
        var keys = [Data]()

        (Int8(-4)...Int8(20)).forEach { yIndex in
            let key = keyPrefix + MCChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            if contains(key) {
                keys.append(key)
            }
        }

        MCChunkKeyType.allCases.forEach { type in
            guard type != .subChunkPrefix else {
                return
            }
            let key = keyPrefix + type.rawValue.data
            if contains(key) {
                keys.append(key)
            }
        }

        return keys
    }

    public func getPrefixedKeys(with prefix: Data) -> [Data] {
        var keys = [Data]()
        guard let iter = makeIterator() else {
            return keys
        }
        defer {
            iter.destroy()
        }
        iter.seek(prefix)
        while iter.valid() {
            defer {
                iter.next()
            }
            guard let keyData = iter.key(),
                  keyData.count >= prefix.count,
                  keyData[0..<prefix.count] == prefix
            else {
                break
            }
            if contains(keyData) {
                keys.append(keyData)
            }
        }
        return keys
    }
}

extension LvDB {
    public func removeChunkKeys(keyPrefix: Data, completion: ((Data, Bool) -> Void)? = nil) {
        (Int8(-4)...Int8(20)).forEach { yIndex in
            let key = keyPrefix + MCChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            guard contains(key) else {
                return
            }
            let result = remove(key)
            completion?(key, result)
        }
        MCChunkKeyType.allCases.forEach { chunkKeyType in
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
            let prefix = LvDBKey.makeChunkKeyPrefix(x: $0.x, z: $0.z, dimension: dimension)
            removeChunkKeys(keyPrefix: prefix, completion: completion)
            removeActorAndDigpKeys(keyPrefix: prefix, completion: completion)
            completion?(Data(), true)
        }
    }
}
