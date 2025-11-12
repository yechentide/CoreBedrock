//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

public extension LevelKeyValueStore {
    func getStringKey(type: LvDBStringKeyType) -> Data? {
        let keyData = type.rawValue.data(using: .utf8)!
        guard containsKey(keyData) else {
            return nil
        }

        return keyData
    }

    func getAllStringKeys(exclude: [LvDBStringKeyType] = []) -> [Data] {
        var keys = [Data]()
        let excludeTypes = Set(exclude)

        for strKeyType in LvDBStringKeyType.allCases {
            guard !excludeTypes.contains(strKeyType),
                  let keyData = strKeyType.rawValue.data(using: .utf8),
                  containsKey(keyData)
            else {
                continue
            }

            keys.append(keyData)
        }
        return keys
    }

    func getPointerAndActorKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
        var keys = [Data]()

        let digpKey = Data("digp".utf8) + keyPrefix
        guard containsKey(digpKey),
              let digpData = try? data(forKey: digpKey),
              !digpData.isEmpty,
              digpData.count % 8 == 0
        else {
            return keys
        }

        keys.append(digpKey)

        for i in 0..<digpData.count / 8 {
            let actorKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
            guard containsKey(actorKey) else {
                continue
            }

            keys.append(actorKey)
        }
        return keys
    }

    func getChunkKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKeyFactory.makeBaseChunkKey(x: x, z: z, dimension: dimension)
        var keys = [Data]()

        for yIndex in Int8(-4)...Int8(20) {
            let key = keyPrefix + LvDBChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            if containsKey(key) {
                keys.append(key)
            }
        }

        for type in LvDBChunkKeyType.allCases {
            guard type != .subChunkPrefix else {
                continue
            }

            let key = keyPrefix + type.rawValue.data
            if containsKey(key) {
                keys.append(key)
            }
        }

        return keys
    }

    func getPrefixedKeys(with prefix: Data) throws -> [Data] {
        var keys = [Data]()
        let iter = try makeIterator()
        defer {
            iter.close()
        }
        iter.move(to: prefix)
        while iter.isValid {
            defer {
                iter.moveToNext()
            }
            guard let keyData = iter.currentKey,
                  keyData.count >= prefix.count,
                  keyData[0..<prefix.count] == prefix
            else {
                break
            }

            if containsKey(keyData) {
                keys.append(keyData)
            }
        }
        return keys
    }
}
