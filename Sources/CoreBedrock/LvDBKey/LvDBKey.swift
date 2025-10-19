//
// Created by yechentide on 2024/10/04
//

import Foundation
import OSLog

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public enum LvDBKey: Equatable, Hashable, Sendable {
    case subChunk(Int32, Int32, MCDimension, LvDBChunkKeyType, Int8!)
    case string(LvDBStringKeyType)       // "\(key string)"
    case player(String, String)          // "\(type)\(id)"
    case map(Int64)                      // "map_\(id)"
    case village(String, String, String) // "VILLAGE_\(Overworld)\(id)\(type)"
    case structure(String)               // "structuretemplate_mystructure:\(name)"
    case actorprefix(Int64)              // "actorprefix\(id)"
    case digp(Int32, Int32, MCDimension) // "digp\(x)\(z)\(dimension)"
    case realmsStoriesData(Data)         // "RealmsStoriesData_\(id)"
    case unknown(Data)

    /// - Precondition:
    ///   Key Format:
    ///   - ~local_player
    ///   - mobevents
    ///   - ......
    public static func parseStringKey(data: Data) -> Self? {
        guard let type = LvDBStringKeyType.parse(data: data) else {
            return nil
        }

        return .string(type)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - player_AAAAAAAA-1b0c-31c2-995a-XXXXXXXXXXXX
    ///   - player_BBBBBBBB-48be-3f36-a7fd-XXXXXXXXXXXX
    ///   - player_server_CCCCCCCC-6a84-4337-83f4-XXXXXXXXXXXX
    public static func parsePlayerKey(data: Data) -> Self? {
        let prefix = "player_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let keyString = String(data: data[prefix.count...], encoding: .utf8)
        else {
            return nil
        }

        let parts = keyString.split(separator: "_")
        if parts.count == 1 {
            return Self.player("", "\(parts[0])")
        }
        if parts.count == 2 {
            return Self.player("\(parts[0])", "\(parts[1])")
        }
        return nil
    }

    /// - Precondition:
    ///   Key Format:
    ///   - map_\(id)
    ///   - id = Int64 = 0x2D_33_30_30_36_34_37_37_31_30_36_37
    public static func parseMapKey(data: Data) -> Self? {
        let prefix = "map_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let id = data[prefix.count...].int64
        else {
            return nil
        }

        return Self.map(id)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - VILLAGE_Overworld_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_DWELLERS
    ///   - VILLAGE_Overworld_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_INFO
    ///   - VILLAGE_Overworld_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_PLAYERS
    ///   - VILLAGE_Overworld_XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX_POI
    public static func parseVillageKey(data: Data) -> Self? {
        let prefix = "VILLAGE_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let keyString = String(data: data[prefix.count...], encoding: .utf8)
        else {
            return nil
        }

        let parts = keyString.split(separator: "_")
        guard parts.count == 3 else {
            return nil
        }

        return Self.village("\(parts[0])", "\(parts[1])", "\(parts[2])")
    }

    /// - Precondition:
    ///   Key Format:
    ///   - structuretemplate_mystructure:\(name)
    ///   - name = String
    public static func parseStructureKey(data: Data) -> Self? {
        let prefix = "structuretemplate_mystructure:"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let name = String(data: data[prefix.count...], encoding: .utf8)
        else {
            return nil
        }

        return Self.structure(name)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - actorprefix\(id)
    ///   - id = Int64 = 0x00_00_00_06_00_00_00_01
    public static func parseActorKey(data: Data) -> Self? {
        let prefix = "actorprefix"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let id = data[prefix.count...].int64
        else {
            return nil
        }

        return Self.actorprefix(id)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - digp\(chunkX)\(chunkZ)\(dimension)?
    public static func parseDigpKey(data: Data) -> Self? {
        let prefix = "digp"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              [12, 16].contains(data.count),
              let chunkX = data[4..<8].int32,
              let chunkZ = data[8..<12].int32
        else {
            return nil
        }

        if data.count == 12 {
            return .digp(chunkX, chunkZ, .overworld)
        }
        if let raw = data[12..<16].int32, let dimension = MCDimension(rawValue: raw) {
            return .digp(chunkX, chunkZ, dimension)
        }
        return nil
    }

    /// - Precondition:
    ///   Key Format:
    ///   - RealmsStoriesData_\(id)
    public static func parseRealmsStoriesDataKey(data: Data) -> Self? {
        let prefix = "RealmsStoriesData_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8)
        else {
            return nil
        }

        let idData = data[prefix.count...]
        return Self.realmsStoriesData(idData)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - \(chunkX)\(chunkZ)\(dimension)?\(chunkType)\(subChunkPrefix)?
    public static func parseChunkKey(data: Data) -> Self? {
        guard [9, 10, 13, 14].contains(data.count),
              let chunkX = data[0..<4].int32,
              let chunkZ = data[4..<8].int32
        else {
            return nil
        }

        var index = 8
        var dimension = MCDimension.overworld
        if data.count > 10 {
            if let raw = data[index..<(index+4)].int32, let d = MCDimension(rawValue: raw) {
                dimension = d
                index += 4
            } else {
                return nil
            }
        }

        guard let chunkType = LvDBChunkKeyType(rawValue: data[index]) else {
            return nil
        }

        if chunkType != .subChunkPrefix {
            return Self.subChunk(chunkX, chunkZ, dimension, chunkType, nil)
        }
        guard [10, 14].contains(data.count) else {
            return nil
        }

        let chunkY = dimension == .overworld ? Int8(bitPattern: data[9]) : Int8(bitPattern: data[13])
        return Self.subChunk(chunkX, chunkZ, dimension, chunkType, chunkY)
    }

    public static func parse(data: Data) -> Self {
        if let key = Self.parseStringKey(data: data) {
            return key
        }
        if let key = Self.parsePlayerKey(data: data) {
            return key
        }
        if let key = Self.parseMapKey(data: data) {
            return key
        }
        if let key = Self.parseVillageKey(data: data) {
            return key
        }
        if let key = Self.parseStructureKey(data: data) {
            return key
        }
        if let key = Self.parseActorKey(data: data) {
            return key
        }
        if let key = Self.parseDigpKey(data: data) {
            return key
        }
        if let key = Self.parseRealmsStoriesDataKey(data: data) {
            return key
        }
        if let key = Self.parseChunkKey(data: data) {
            return key
        }
        CBLogger.warning("Unknown Leveldb Key: \(data.hexString)")
        return Self.unknown(data)
    }

    public var isNBTKey: Bool {
        switch self {
        case let .subChunk(_, _, _, subChunkType, _):
            switch subChunkType {
            case .blockEntity, .pendingTicks, .randomTicks, .biomeState:
                true
            default:
                false
            }
        case let .string(strType):
            switch strType {
            case .localPlayer, .autonomousEntities, .biomeData,
                 .levelChunkMetaDataDictionary, .mobevents,
                 .overworld, .schedulerWT, .scoreboard:
                true
            default:
                false
            }
        case .player, .map, .village, .structure, .actorprefix:
            true
        default:
            false
        }
    }

    public var isCompoundListKey: Bool {
        if case let .subChunk(_, _, _, subChunkType, _) = self {
            switch subChunkType {
            case .entity, .blockEntity: return true
            default: return false
            }
        }
        return false
    }

    public var data: Data {
        switch self {
        case let .subChunk(x, z, d, t, y):
            var keyData = x.data + z.data
            if d != .overworld {
                keyData += d.rawValue.data
            }
            keyData += t.rawValue.data
            if case .subChunkPrefix = t, let y {
                keyData += y.data
            }
            return keyData
        case let .string(t):
            return t.rawValue.data(using: .utf8)!
        case let .player(type, id):
            if type.isEmpty {
                return Data("player_\(id)".utf8)
            }
            return Data("player_\(type)_\(id)".utf8)
        case let .map(id):
            return Data("map_\(id)".utf8)
        case let .village(dimension, id, type):
            return Data("VILLAGE_\(dimension)_\(id)_\(type)".utf8)
        case let .structure(name):
            return Data("structuretemplate_mystructure:\(name)".utf8)
        case let .actorprefix(id):
            return Data("actorprefix".utf8) + id.data
        case let .digp(x, z, d):
            var keyData = Data("digp".utf8) + x.data + z.data
            if d != .overworld {
                keyData += d.rawValue.data
            }
            return keyData
        case let .realmsStoriesData(data):
            return Data("RealmsStoriesData_".utf8) + data
        case let .unknown(data):
            return data
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
