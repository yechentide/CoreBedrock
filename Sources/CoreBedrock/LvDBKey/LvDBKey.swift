//
// Created by yechentide on 2024/10/04
//

import Foundation

public struct LvDBKey: Identifiable {
    public let id = UUID()
    public let data: Data
    public let type: LvDBKeyType

    public init(data: Data, type: LvDBKeyType) {
        self.data = data
        self.type = type
    }

    public static func parse(data: Data) -> LvDBKey {
        if let type = MCStringKeyType.parse(data: data) {
            return LvDBKey(data: data, type: .string(type))
        }

        if data.count > 3, let prefix = String(data: data[0...2], encoding: .utf8) {
            switch prefix {
                case "pla":     return LvDBKey(data: data, type: .player)
                case "str":     return LvDBKey(data: data, type: .structure)
                case "map":     return LvDBKey(data: data, type: .map)
                case "VIL":     return LvDBKey(data: data, type: .village)
                case "act":     return LvDBKey(data: data, type: .actorprefix)
                case "dig":     return LvDBKey(data: data, type: .digp)
                default:        break
            }
        }

        guard [9, 10, 13, 14].contains(data.count) else {
            return LvDBKey(data: data, type: .unknown)
        }

//        let x = data[0..<4].int32!
//        let z = data[4..<8].int32!
        var index = 8
        var dimension = MCDimension.overworld
        if data.count > 10 {
            if let d = MCDimension(rawValue: data[index..<(index+4)].int32!) {
                dimension = d
                index += 4
            } else {
                return LvDBKey(data: data, type: .unknown)
            }
        }

        guard let chunkType = MCChunkKeyType(rawValue: data[index]) else {
            return LvDBKey(data: data, type: .unknown)
        }
        return LvDBKey(data: data, type: .subChunk(dimension, chunkType))
    }

    public static func makeChunkKeyPrefix(x: Int32, z: Int32, dimension: MCDimension) -> Data {
        var data = x.data + z.data
        if dimension != .overworld {
            data += dimension.rawValue.data
        }
        return data
    }

    public static func makeChunkKey(
        x: Int32, z: Int32, dimension: MCDimension, type: MCChunkKeyType, yIndex: Int8? = nil
    ) -> Data {
        var data = makeChunkKeyPrefix(x: x, z: z, dimension: dimension)
        data += type.rawValue.data
        if type == .subChunkPrefix, let yIndex = yIndex {
            data += yIndex.data
        }
        return data
    }
}
