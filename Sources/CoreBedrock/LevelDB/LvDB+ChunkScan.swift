//
// Created by yechentide on 2025/04/30
//

import Foundation

public extension KeyValueStore {
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
        // Pre-1.0 LevelDB worlds can have a full terrain record without either
        // version marker. Do not treat malformed version data as a valid chunk.
        let legacyTerrainKey = LvDBKeyFactory.makeChunkKey(
            x: chunkX, z: chunkZ, dimension: dimension, type: .legacyTerrain
        )
        return (try? self.data(forKey: legacyTerrainKey))?.isEmpty == false
    }

    func scanExistingChunks(dimension: MCDimension, handler: @escaping (Int32, Int32) -> Bool) -> Bool {
        guard let iterator = try? self.makeIterator() else {
            return false
        }

        var seen = Set<Pos2Di32>()

        defer {
            iterator.close()
        }
        iterator.moveToFirst()
        while iterator.isValid {
            guard !Task.isCancelled else {
                return true
            }

            defer {
                iterator.moveToNext()
            }
            guard let keyData = iterator.currentKey,
                  let chunkKey = LvDBChunkKey(data: keyData),
                  chunkKey.dimension == dimension,
                  chunkKey.tag == LvDBChunkKeyType.chunkVersion.rawValue ||
                  chunkKey.tag == LvDBChunkKeyType.legacyChunkVersion.rawValue ||
                  chunkKey.tag == LvDBChunkKeyType.legacyTerrain.rawValue
            else {
                continue
            }
            guard seen.insert(.init(x: chunkKey.x, z: chunkKey.z)).inserted else {
                continue
            }

            let result = handler(chunkKey.x, chunkKey.z)
            if result == false {
                return false
            }
        }
        return true
    }
}
