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

    public func removeChunks(xRange: ClosedRange<Int32>, zRange: ClosedRange<Int32>, dimension: MCDimension, completion: ((Data, Bool) -> Void)? = nil) {
        var list = [Pos2Di32]()
        for x in xRange {
            for z in zRange {
                list.append(Pos2Di32(x: x, z: z))
            }
        }
        list.forEach {
            let prefix = LvDBKey.makeChunkKeyPrefix(x: $0.x, z: $0.z, dimension: dimension)
            removeChunkKeys(keyPrefix: prefix, completion: completion)
            removeActorAndDigpKeys(keyPrefix: prefix, completion: completion)
            completion?(Data(), true)
        }
    }
}

extension LvDB {
    public func load_v9(x: Int32, z: Int32, dimension: MCDimension) -> MCChunk? {
        let keyPrefix = LvDBKey.makeChunkKeyPrefix(x: x, z: z, dimension: dimension)

        var biomeLayers = [MCBiomeLayer]()
        let data3DKey = keyPrefix + MCChunkKeyType.data3D.rawValue.data
        if contains(data3DKey), let data3D = get(data3DKey), data3D.count > 512 {
//            let heightMap = data3D[0..<512]
            if let layers = try? BiomeDecoder().decode(data: data3D, offset: 512) {
                biomeLayers = layers
            }
        }

        var subChunkKeys = [Data]()
        (Int8(-4)...Int8(20)).forEach { yIndex in
            let key = keyPrefix + MCChunkKeyType.subChunkPrefix.rawValue.data + yIndex.data
            if contains(key) {
                subChunkKeys.append(key)
            }
        }
        guard biomeLayers.count == subChunkKeys.count else { return nil }

        var subChunks = [MCSubChunk]()
        for i in 0..<subChunkKeys.count {
            guard let subChunkData = get(subChunkKeys[i]), subChunkData.count > 4 else { return nil }
            let storageVersion = subChunkData[0]
            assert(storageVersion == 9)

            let storageLayerCount = Int(subChunkData[1])
            let yIndex = subChunkData[2].data.int8

            if let layers = try? BlockDecoder().decode(data: subChunkData, offset: 3, layerCount: storageLayerCount) {
                let subChunk = MCSubChunk(x: x, yIndex: yIndex, z: z, version: storageVersion, biomeLayer: biomeLayers[i], blockLayers: layers)
                subChunks.append(subChunk)
            } else {
                return nil
            }
        }

        return MCChunk(x: x, z: z, dimension: dimension, subChunks: subChunks)
    }
}
