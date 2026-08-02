//
// Created by yechentide on 2024/10/04
//

public import Foundation
import OSLog

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public enum LvDBKey: Sendable, Hashable {
    case subChunk(Int32, Int32, MCDimension, LvDBChunkKeyType, Int8!)
    case string(LvDBStringKeyType)       // "\(key string)"
    case player(String, String)          // "\(type)\(id)"
    case map(Int64)                      // "map_\(id)"
    case village(String, String, String) // "VILLAGE_\(Overworld)_\(id)_\(type)"
    case legacyVillage(String, String)   // "VILLAGE_\(id)_\(type)"
    case structure(String)               // "structuretemplate_\(namespace):\(name)"
    case actorprefix(Data)               // "actorprefix\(8-byte storage key)"
    case digp(Int32, Int32, MCDimension) // "digp\(x)\(z)\(dimension)"
    case realmsStoriesData(Data)         // "RealmsStoriesData_\(id)"
    case tickingArea(String)             // "tickingarea_\(id)"
    case chunkLoadedRequest(String)      // "chunk_loaded_request_\(dimension)_\(id)"
    case positionTrack(String)           // "PosTrackDB-0xXXXXXXXX"
    case positionTrackLastID             // "PositionTrackDB-LastId"
    case unknown(Data)
}

public extension LvDBKey {
    /// - Precondition:
    ///   Key Format:
    ///   - ~local_player
    ///   - mobevents
    ///   - ......
    static func parseStringKey(data: Data) -> Self? {
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
    static func parsePlayerKey(data: Data) -> Self? {
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
    static func parseMapKey(data: Data) -> Self? {
        let prefix = "map_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let stringID = String(data: data[prefix.count...], encoding: .utf8),
              let id = Int64(stringID)
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
    static func parseVillageKey(data: Data) -> Self? {
        let prefix = "VILLAGE_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let keyString = String(data: data[prefix.count...], encoding: .utf8)
        else {
            return nil
        }

        let parts = keyString.split(separator: "_")
        if parts.count == 2 {
            return Self.legacyVillage("\(parts[0])", "\(parts[1])")
        }
        if parts.count == 3 {
            return Self.village("\(parts[0])", "\(parts[1])", "\(parts[2])")
        }

        return nil
    }

    /// - Precondition:
    ///   Key Format:
    ///   - structuretemplate_\(namespace):\(name)
    static func parseStructureKey(data: Data) -> Self? {
        let prefix = "structuretemplate_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let name = String(data: data[prefix.count...], encoding: .utf8),
              name.contains(":")
        else {
            return nil
        }

        return Self.structure(name)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - actorprefix\(id)
    ///   - id = Int64 = 0x00_00_00_06_00_00_00_01
    static func parseActorKey(data: Data) -> Self? {
        let prefix = "actorprefix"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              data.count == prefix.count + 8
        else {
            return nil
        }

        return Self.actorprefix(Data(data[prefix.count...]))
    }

    /// - Precondition:
    ///   Key Format:
    ///   - digp\(chunkX)\(chunkZ)\(dimension)?
    static func parseDigpKey(data: Data) -> Self? {
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
    static func parseRealmsStoriesDataKey(data: Data) -> Self? {
        let prefix = "RealmsStoriesData_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8)
        else {
            return nil
        }

        let idData = data[prefix.count...]
        return Self.realmsStoriesData(idData)
    }

    static func parsePositionTrackKey(data: Data) -> Self? {
        let lastID = Data("PositionTrackDB-LastId".utf8)
        if data == lastID {
            return .positionTrackLastID
        }

        let prefix = "PosTrackDB-"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let id = String(data: data[prefix.count...], encoding: .utf8)
        else {
            return nil
        }

        return .positionTrack(id)
    }

    static func parseTickingAreaKey(data: Data) -> Self? {
        let prefix = "tickingarea_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let id = String(data: data[prefix.count...], encoding: .utf8)
        else { return nil }

        return .tickingArea(id)
    }

    static func parseChunkLoadedRequestKey(data: Data) -> Self? {
        let prefix = "chunk_loaded_request_"
        guard data.count > prefix.count,
              prefix == String(data: data[..<prefix.count], encoding: .utf8),
              let id = String(data: data[prefix.count...], encoding: .utf8)
        else { return nil }

        return .chunkLoadedRequest(id)
    }

    /// - Precondition:
    ///   Key Format:
    ///   - \(chunkX)\(chunkZ)\(dimension)?\(chunkType)\(subChunkPrefix)?
    static func parseChunkKey(data: Data) -> Self? {
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

    static func parse(data: Data) -> Self {
        let parsers: [(Data) -> Self?] = [
            Self.parseStringKey,
            Self.parsePlayerKey,
            Self.parseMapKey,
            Self.parseVillageKey,
            Self.parseStructureKey,
            Self.parseActorKey,
            Self.parseDigpKey,
            Self.parseRealmsStoriesDataKey,
            Self.parsePositionTrackKey,
            Self.parseTickingAreaKey,
            Self.parseChunkLoadedRequestKey,
            Self.parseChunkKey,
        ]
        if let key = parsers.lazy.compactMap({ $0(data) }).first {
            return key
        }
        CBLogger.warning("Unknown Leveldb Key: \(data.hexString)")
        return Self.unknown(data)
    }

    var isNBTKey: Bool {
        switch self {
        case let .subChunk(_, _, _, subChunkType, _):
            switch subChunkType {
            case .blockEntity, .entity, .pendingTicks, .randomTicks, .biomeState:
                true
            default:
                false
            }
        case let .string(strType):
            switch strType {
            case .localPlayer, .autonomousEntities, .biomeData,
                 .levelChunkMetaDataDictionary, .mobevents,
                 .overworld, .nether, .theEnd, .schedulerWT, .scoreboard,
                 .dynamicProperties, .worldClocks:
                true
            default:
                false
            }
        case .player, .map, .village, .legacyVillage, .structure, .actorprefix,
             .positionTrack, .positionTrackLastID:
            true
        case .tickingArea, .chunkLoadedRequest:
            true
        default:
            false
        }
    }

    var isCompoundListKey: Bool {
        if case let .subChunk(_, _, _, subChunkType, _) = self {
            switch subChunkType {
            case .entity, .blockEntity: return true
            default: return false
            }
        }
        return false
    }

    var data: Data {
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
        case let .legacyVillage(id, type):
            return Data("VILLAGE_\(id)_\(type)".utf8)
        case let .structure(name):
            return Data("structuretemplate_\(name)".utf8)
        case let .actorprefix(id):
            return Data("actorprefix".utf8) + id
        case let .digp(x, z, d):
            var keyData = Data("digp".utf8) + x.data + z.data
            if d != .overworld {
                keyData += d.rawValue.data
            }
            return keyData
        case let .realmsStoriesData(data):
            return Data("RealmsStoriesData_".utf8) + data
        case let .tickingArea(id):
            return Data("tickingarea_\(id)".utf8)
        case let .chunkLoadedRequest(id):
            return Data("chunk_loaded_request_\(id)".utf8)
        case let .positionTrack(id):
            return Data("PosTrackDB-\(id)".utf8)
        case .positionTrackLastID:
            return Data("PositionTrackDB-LastId".utf8)
        case let .unknown(data):
            return data
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
