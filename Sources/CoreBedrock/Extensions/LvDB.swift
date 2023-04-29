import LvDBWrapper

extension LvDB {
    public func getStringKey(type: MCStringKeyType) -> Data? {
        let keyData = type.rawValue.data(using: .utf8)!
        seek(keyData)
        if valid() {
            return keyData
        }
        return nil
    }

    public func getAllStringKeys(exclude: [MCStringKeyType] = []) -> [Data] {
        var keys = [Data]()
        let excludeTypes = Set(exclude)

        for strKeyType in MCStringKeyType.allCases {
            guard !excludeTypes.contains(strKeyType),
                  let keyData = strKeyType.rawValue.data(using: .utf8)
            else {
                continue
            }
            seek(keyData)
            if valid() {
                keys.append(keyData)
            }
        }
        return keys
    }

    public func getPrefixedKeys(with prefix: String) -> [Data] {
        guard let prefixData = prefix.data(using: .utf8) else {
            return []
        }
        var keys = [Data]()
        seek(prefixData)
        while valid() {
            defer {
                next()
            }
            guard let keyData = key() else {
                continue
            }
            guard keyData.count >= prefix.count,
                  keyData[0..<prefix.count] == prefixData
            else {
                break
            }
            keys.append(keyData)
        }
        return keys
    }

    public func getChunkKeys(x: Int32, z: Int32, dimension: MCDimension, includeDigp: Bool = false, includeActor: Bool = false) -> [Data] {
        var keys = [Data]()
        let keyPrefix = LvDBKey.makeChunkKeyPrefix(x: x, z: z, dimension: dimension)
        keys = getChunkKeys(with: keyPrefix)

        guard includeDigp || includeActor else {
            return keys
        }

        let digpKey = "digp".data(using: .utf8)! + keyPrefix
        guard let digpData = get(digpKey), digpData.count > 0, digpData.count % 8 == 0 else {
            return keys
        }
        if includeDigp {
            keys.append(digpKey)
        }

        guard includeActor else {
            return keys
        }

        for i in 0..<digpData.count/8 {
            let actorKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
            seek(actorKey)
            if valid() {
                keys.append(actorKey)
            }
        }
        return keys
    }

    private func getChunkKeys(with prefix: Data) -> [Data] {
        let start = prefix + MCChunkKeyType.keyTypeStartWith.data
        var keyList = [Data]()
        seek(start)
        while valid() {
            guard let key = key(), key[0..<prefix.count] == prefix else {
                break
            }
            keyList.append(key)
            next()
        }
        return keyList
    }

    private func removeSubChunkKeys(with prefix: Data) {
        getChunkKeys(with: prefix).forEach { key in
            let _ = remove(key)
        }
    }

    private func removeActorAndDigpKeys(with prefix: Data) {
        let digpKey = "digp".data(using: .utf8)! + prefix
        guard let digpData = get(digpKey), digpData.count > 0, digpData.count % 8 == 0 else {
            return
        }
        for i in 0..<digpData.count/8 {
            let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
            remove(actorprefixKey)
        }
        remove(digpKey)
    }

    public func removeChunks(xRange: ClosedRange<Int32>, zRange: ClosedRange<Int32>, dimension: MCDimension) {
        var list = [Pos2Di32]()
        for x in xRange {
            for z in zRange {
                list.append(Pos2Di32(x: x, z: z))
            }
        }
        list.forEach {
            let prefix = LvDBKey.makeChunkKeyPrefix(x: $0.x, z: $0.z, dimension: dimension)
            removeSubChunkKeys(with: prefix)
            removeActorAndDigpKeys(with: prefix)
        }
    }
}
