import Foundation

//public enum LvDBKeyType: CaseIterable {
//    case subChunk
//    case string
//    case player
//    case map
//    case village
//    case structure
//    case actorprefix
//    case digp
//}

public struct LvDBKey {
//    public let data: Data
//    public let type: LvDBKeyType

    public static func makeSubChunkKeyPrefix(x: Int32, z: Int32, dimension: MCDimension) -> Data {
        var data = x.data + z.data
        if dimension != .overworld {
            data += dimension.rawValue.data
        }
        return data
    }

    public static func makeSubChunkKey(x: Int32, z: Int32, dimension: MCDimension, type: MCChunkKeyType, yIndex: Int8? = nil) -> Data {
        var data = makeSubChunkKeyPrefix(x: x, z: z, dimension: dimension)
        data += type.rawValue.data
        if type == .subChunkPrefix, let yIndex = yIndex {
            data += yIndex.data
        }
        return data
    }

//    public static func decode(keyData: Data) -> LvDBKey? {
//        guard let prefix = String(data: keyData[0...2], encoding: .utf8) else {
//            return nil
//        }
//
//        var type: LvDBKeyType?
//        switch prefix {
//        case "pla":
//            type = .player
//        case "str":
//            type = .structure
//        case "map":
//            type = .map
//        case "VIL":
//            type = .village
//        case "act":
//            type = .actorprefix
//        case "dig":
//            type = .digp
//        default:
//            type = nil
//        }
//
//        return nil
//    }
}
