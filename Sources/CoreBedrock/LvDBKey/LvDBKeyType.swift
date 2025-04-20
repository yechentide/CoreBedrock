//
// Created by yechentide on 2024/10/04
//

import Foundation

public enum LvDBKeyType: Equatable, Sendable {
    case subChunk(MCDimension, LvDBChunkKeyType)
    case string(LvDBStringKeyType)
    case player
    case map
    case village
    case structure
    case actorprefix
    case digp
    case unknown

    public static func parse(data: Data) -> Self {
        if let type = LvDBStringKeyType.parse(data: data) {
            return .string(type)
        }

        if data.count > 3, let prefix = String(data: data[0...2], encoding: .utf8) {
            switch prefix {
                case "pla": return Self.player
                case "str": return Self.structure
                case "map": return Self.map
                case "VIL": return Self.village
                case "act": return Self.actorprefix
                case "dig": return Self.digp
                default:    break
            }
        }

        guard [9, 10, 13, 14].contains(data.count) else {
            return Self.unknown
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
                return Self.unknown
            }
        }

        guard let chunkType = LvDBChunkKeyType(rawValue: data[index]) else {
            return Self.unknown
        }
        if chunkType == .subChunkPrefix, [9, 13].contains(data.count) {
            // NOTE: Missing subchunk index. Data size should be either 10 or 14 bytes.
            return Self.unknown
        }
        return Self.subChunk(dimension, chunkType)
    }

    public var isNBTKey: Bool {
        switch self {
            case .subChunk(_, let subChunkType):
                switch subChunkType {
                    case .blockEntity, .pendingTicks, .randomTicks, .biomeState:
                        return true
                    default:
                        return false
                }
            case .string(let strType):
                switch strType {
                    case .localPlayer, .autonomousEntities, .biomeData,
                            .levelChunkMetaDataDictionary, .mobevents,
                            .overworld, .schedulerWT, .scoreboard:
                        return true
                    default:
                        return false
                }
            case .player, .map, .village, .structure, .actorprefix:
                return true
            default:
                return false
        }
    }
}
