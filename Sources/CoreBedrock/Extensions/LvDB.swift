import LvDBWrapper

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
        seek(prefix)
        while valid() {
            defer {
                next()
            }
            guard let keyData = key(),
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

    private func removeSubChunkKeys(with prefix: Data) {
        getPrefixedKeys(with: prefix).forEach { key in
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
