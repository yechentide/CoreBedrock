//
// Created by yechentide on 2024/10/04
//

import Foundation

public enum LvDBKeyType: Equatable, Sendable {
    case subChunk(Int32, Int32, MCDimension, LvDBChunkKeyType, Int8!)
    case string(LvDBStringKeyType)       // "\(key string)"
    case player(Data)                    // "\(key string)"
    case map(Data)                       // "map_\(id)"
    case village(Data)                   // "VILLAGE_\(name)"
    case structure(Data)                 // "structuretemplate_mystructure:\(name)"
    case actorprefix(Data)               // "actorprefix\(id)"
    case digp(Int32, Int32, MCDimension) // "digp\(x)\(z)\(dimension)"
    case unknown(Data)

    public static func parse(data: Data) -> Self {
        if let type = LvDBStringKeyType.parse(data: data) {
            return .string(type)
        }

        if data.count > 4, let prefix = String(data: data[0...3], encoding: .utf8) {
            if prefix == "play" && data.count > 7 { // player_
                return Self.player(data)
            }
            if prefix == "map_" && data.count > 4 { // map_
                return Self.map(data[4...])
            }
            if prefix == "VILL" && data.count > 8 { // VILLAGE_
                return Self.village(data[8...])
            }
            if prefix == "stru" && data.count > 30 { // structuretemplate_mystructure:
                return Self.structure(data[30...])
            }
            if prefix == "acto" && data.count > 11 { // actorprefix
                return Self.actorprefix(data[11...])
            }
            if prefix == "digp" && [12, 16].contains(data.count) { // digp
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
            return Self.unknown(data)
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
                return Self.unknown(data)
            }
        }

        guard let chunkType = LvDBChunkKeyType(rawValue: data[index]) else {
            return Self.unknown(data)
        }
        if chunkType != .subChunkPrefix {
            return Self.subChunk(chunkX, chunkZ, dimension, chunkType, nil)
        }
        guard [10, 14].contains(data.count) else {
            return Self.unknown(data)
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
