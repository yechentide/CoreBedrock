import LvDBWrapper

extension LvDB {
    public func getChunkKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKey.makeSubChunkKeyPrefix(x: x, z: z, dimension: dimension)
        return getChunkKeys(with: keyPrefix)
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
            let prefix = LvDBKey.makeSubChunkKeyPrefix(x: $0.x, z: $0.z, dimension: dimension)
            removeSubChunkKeys(with: prefix)
            removeActorAndDigpKeys(with: prefix)
        }
    }
}
