//
// Created by yechentide on 2024/10/04
//

import Foundation

public enum LvDBKeyType: Equatable, Sendable {
    case subChunk(Int32, Int32, MCDimension, LvDBChunkKeyType, Int8!)
    case string(LvDBStringKeyType)
    case player
    case map
    case village
    case structure
    case actorprefix
    case digp(Int32, Int32, MCDimension)
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
                default:    break
            }
            if prefix == "dig" {
                let chunkX = data[4..<8].int32!
                let chunkZ = data[8..<12].int32!
                var dimension = MCDimension.overworld
                if data.count == 16, let d = MCDimension(rawValue: data[12..<16].int32!) {
                    dimension = d
                }
                return .digp(chunkX, chunkZ, dimension)
            }
        }

        guard [9, 10, 13, 14].contains(data.count) else {
            return Self.unknown
        }

        let chunkX = data[0..<4].int32!
        let chunkZ = data[4..<8].int32!
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
        if chunkType != .subChunkPrefix {
            return Self.subChunk(chunkX, chunkZ, dimension, chunkType, nil)
        }
        guard [10, 14].contains(data.count) else {
            return Self.unknown
        }
        let chunkY = dimension == .overworld ? Int8(bitPattern: data[9]) : Int8(bitPattern: data[13])
        return Self.subChunk(chunkX, chunkZ, dimension, chunkType, chunkY)
    }

    public var isNBTKey: Bool {
        switch self {
            case .subChunk(_, _, _, let subChunkType, _):
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
