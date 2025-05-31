//
// Created by yechentide on 2025/04/30
//

import LvDBWrapper

extension LvDB {
    public func chunkExists(chunkX: Int, chunkZ: Int, dimension: MCDimension) -> Bool {
        let chunkX = Int32(truncatingIfNeeded: chunkX)
        let chunkZ = Int32(truncatingIfNeeded: chunkZ)
        let versionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .chunkVersion)
        if let versionData = self.get(versionKey), versionData.count == 1{
            return true
        }
        let legacyVersionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .legacyChunkVersion)
        if let legacyVersionData = self.get(legacyVersionKey), legacyVersionData.count == 1 {
            return true
        }
        return false
    }

    public func scanExistingChunks(dimension: MCDimension, handler: @escaping (Int32, Int32) -> Bool) -> Bool {
        guard let iterator = self.makeIterator() else {
            return false
        }
        defer {
            iterator.destroy()
        }
        let expectedKeyLength = dimension == .overworld ? 9 : 13
        iterator.seekToFirst()
        while iterator.valid() {
            defer {
                iterator.next()
            }
            guard let keyData = iterator.key(), keyData.count == expectedKeyLength else {
                continue
            }
            let keyType = LvDBKeyType.parse(data: keyData)
            guard case .subChunk(let chunkX, let chunkZ, let actualDimension, let type, _) = keyType,
                  actualDimension == dimension,
                  [.chunkVersion, .legacyChunkVersion].contains(type)
            else {
                continue
            }
            let result = handler(chunkX, chunkZ)
            if result == false {
                return false
            }
        }
        return true
    }
}
