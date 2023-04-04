import LvDBWrapper

extension LvDB {
    func getChunkKeys(x: Int32, z: Int32, dimension: MCDimension) -> [Data] {
        let keyPrefix = LvDBKey.makeSubChunkKeyPrefix(x: x, z: z, dimension: dimension)
        let start = keyPrefix + MCChunkKeyType.keyTypeStartWith.data

        var keyList = [Data]()
        seek(start)
        while valid() {
            guard let key = key(), key[0..<keyPrefix.count] == keyPrefix else {
                break
            }
            keyList.append(key)
            next()
        }
        return keyList
    }
}
