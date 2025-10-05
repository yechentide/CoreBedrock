//
// Created by yechentide on 2025/04/20
//

import LvDBWrapper

public extension LvDB {
    func getStringKey(type: LvDBStringKeyType) -> Data? {
        let keyData = type.rawValue.data(using: .utf8)!
        guard contains(keyData) else {
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
                  contains(keyData)
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
        guard contains(digpKey),
              let digpData = try? get(digpKey),
              !digpData.isEmpty,
              digpData.count % 8 == 0
        else {
            return keys
        }

        keys.append(digpKey)

        for i in 0..<digpData.count / 8 {
            let actorKey = Data("actorprefix".utf8) + digpData[i * 8...i * 8 + 7]
            guard contains(actorKey) else {
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
            if contains(key) {
                keys.append(key)
            }
        }

        for type in LvDBChunkKeyType.allCases {
            guard type != .subChunkPrefix else {
                continue
            }

            let key = keyPrefix + type.rawValue.data
            if contains(key) {
                keys.append(key)
            }
        }

        return keys
    }

    func getPrefixedKeys(with prefix: Data) throws -> [Data] {
        var keys = [Data]()
        let iter = try makeIterator()
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
