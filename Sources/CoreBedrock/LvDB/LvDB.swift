//
// Created by yechentide on 2025/04/30
//

import LvDBWrapper

public extension LevelKeyValueStore {
    func chunkExists(chunkX: Int, chunkZ: Int, dimension: MCDimension) -> Bool {
        let chunkX = Int32(truncatingIfNeeded: chunkX)
        let chunkZ = Int32(truncatingIfNeeded: chunkZ)
        let versionKey = LvDBKeyFactory.makeChunkKey(x: chunkX, z: chunkZ, dimension: dimension, type: .chunkVersion)
        if let versionData = try? self.data(forKey: versionKey), versionData.count == 1 {
            return true
        }
        let legacyVersionKey = LvDBKeyFactory.makeChunkKey(
            x: chunkX, z: chunkZ, dimension: dimension, type: .legacyChunkVersion
        )
        if let legacyVersionData = try? self.data(forKey: legacyVersionKey), legacyVersionData.count == 1 {
            return true
        }
        return false
    }

    func scanExistingChunks(dimension: MCDimension, handler: @escaping (Int32, Int32) -> Bool) -> Bool {
        guard let iterator = try? self.makeIterator() else {
            return false
        }

        defer {
            iterator.close()
        }
        let expectedKeyLength = dimension == .overworld ? 9 : 13
        iterator.moveToFirst()
        while iterator.isValid {
            defer {
                iterator.moveToNext()
            }
            guard let keyData = iterator.currentKey, keyData.count == expectedKeyLength else {
                continue
            }

            let key = LvDBKey.parse(data: keyData)
            guard case let .subChunk(chunkX, chunkZ, actualDimension, type, _) = key,
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
