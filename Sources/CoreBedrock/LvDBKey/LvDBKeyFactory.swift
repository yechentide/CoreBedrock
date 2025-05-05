//
// Created by yechentide on 2025/04/19
//

import Foundation

public enum LvDBKeyFactory {
    public static func makeBaseChunkKey(x: Int32, z: Int32, dimension: MCDimension) -> Data {
        var data = x.data + z.data
        if dimension != .overworld {
            data += dimension.rawValue.data
        }
        return data
    }

    public static func makeChunkKey(base: Data, type: LvDBChunkKeyType, yIndex: Int8? = nil) -> Data {
        var data = base + type.rawValue.data
        if type == .subChunkPrefix, let yIndex = yIndex {
            data += yIndex.data
        }
        return data
    }

    public static func makeChunkKey(
        x: Int32, z: Int32, dimension: MCDimension, type: LvDBChunkKeyType, yIndex: Int8? = nil
    ) -> Data {
        let baseKey = makeBaseChunkKey(x: x, z: z, dimension: dimension)
        return makeChunkKey(base: baseKey, type: type, yIndex: yIndex)
    }

    public static func makeDigpKey(base: Data) -> Data {
        let data = "digp".data(using: .utf8)!
        return data + base
    }

    public static func makeDigpKey(x: Int32, z: Int32, dimension: MCDimension) -> Data {
        let base = makeBaseChunkKey(x: x, z: z, dimension: dimension)
        return makeDigpKey(base: base)
    }

    public static func makeActorKey(id: Data) -> Data {
        return "actorprefix".data(using: .utf8)! + id
    }

    public static func makeMapKey(id: Int64) -> Data {
        var data = "map_".data(using: .utf8)!
        data += id.data
        return data
    }
}
