import Foundation
import LvDBWrapper

@inlinable
public func generateMapKey(_ xPos: Int32, _ zPos: Int32) -> String {
    return "\(xPos)_\(zPos)"
}

public class MCWorld {
    public let dirURL: URL
    public let db: LvDB
    
    public var levelData: LevelData

    public var wellKnownKeys   = Set<MCWellKnownKey>()
    public var serverPlayers   = [Data]()
    public var maps            = [Data]()
    public var villages        = [Data]()
    public var structures      = [Data]()
    
    public private(set) var keysCount = 0
    
    // MARK: Don't store these keys because there are too many keys in a big world
    // public var overworld: [String:MCChunkKey] = [:]
    // public var theNether: [String:MCChunkKey] = [:]
    // public var theEnd: [String:MCChunkKey] = [:]
    // public var actorprefix     = [Data]()
    // public var digp            = [Data]()
    
    public init(from dirURL: URL) throws {
        guard let db = LvDB(dbPath: dirURL.appendingPathComponent("db", isDirectory: true).path) else {
            throw CBLvDBError.failedOpenWorld(dirURL)
        }
        guard let levelData = LevelData(srcURL: dirURL.appendingPathComponent("level.dat", isDirectory: false)) else {
            throw CBLvDBError.failedParseLevelData(dirURL)
        }
        
        self.dirURL = dirURL
        self.db = db
        self.levelData = levelData
        
        getWellKnownKeys()
        getServerPlayers()
    }
    
    private func getWellKnownKeys() {
        for key in MCWellKnownKey.allCases {
            guard let keyData = key.rawValue.data(using: .utf8) else { continue }
            db.seek(keyData)
            if let _ = db.value() {
                wellKnownKeys.insert(key)
            }
        }
    }
    
    private func getServerPlayers() {
        db.seekToFirst()
        while db.valid() {
            // prefix: player_
            if let keyData = db.value(), String(data: keyData[0...5], encoding: .utf8) == "player" {
                serverPlayers.append(keyData)
            }
            keysCount += 1
            db.next()
        }
    }
    
    public func changeWorldName(newName: String) {
        guard newName.count > 0 else { return }
        levelData.worldName = newName
        levelData.saveChanges()
    }
    
}
    
//    private func parseAllKeys() throws {
//        guard let keyDataArray = db.getAllKeys() as? [Data] else {
//            throw MCBECoreError.failedExtractKeys(dirURL)
//        }
//        for keyData in keyDataArray {
//            try parseKeyData(keyData)
//        }
//    }
//
//    private func parseKeyData(_ keyData: Data) throws {
//        let keyStr = String(data: keyData, encoding: .utf8) ?? ""
//
//        if let wellKnown = MCWellKnownKey(rawValue: keyStr) {
//            wellKnownKeys.insert(wellKnown)
//            return
//        }
//
//        switch keyStr {
//        case let str where str.hasPrefix("player_"):
//            serverPlayers.append(keyData)
//            return
//        case let str where str.hasPrefix("map_"):
//            maps.append(keyData)
//            return
//        case let str where str.hasPrefix("VILLAGE_"):
//            villages.append(keyData)
//            return
//        case let str where str.hasPrefix("structuretemplate_"):
//            structures.append(keyData)
//            return
//        default:
//            print("skipped: \(keyData.hexString)")
            // actorprefix...
//            if keyData.count > 11, let s = String(data: keyData[0...10], encoding: .utf8), s == "actorprefix" {
//                actorprefix.append(keyData)
//                return
//            }
            // digp...
//            if keyData.count > 4, let s = String(data: keyData[0...3], encoding: .utf8), s == "digp" {
//                digp.append(keyData)
//                return
//            }
            
//            guard [9, 10, 13, 14].contains(keyData.count) else {
//                throw MCBECoreError.unhandledLevelDBKey(keyData.hexString)
//            }
//            parserChunkKey(keyData)
//        }
//    }
    
//    private func parserChunkKey(_ keyData: Data) {
//        let x = keyData[0...3].int32!
//        let z = keyData[4...7].int32!
//        var typeIndex = 8
//
//        var dimension = MCDimension.overworld
//        if keyData.count > 10 {
//            dimension = MCDimension(rawValue: keyData[8...11].int32!)!
//            typeIndex = 12
//        }
//
//        let type = MCChunkKeyType(rawValue: keyData[typeIndex])!
//        let subChunkIndex: Int8? = (typeIndex >= keyData.count - 1) ? nil : keyData[typeIndex+1].data.int8
//
//        switch dimension {
//        case .overworld:
//            addChunk(to: &overworld, xIndex: x, zIndex: z, type: type, subChunkIndex: subChunkIndex)
//        case .theNether:
//            addChunk(to: &theNether, xIndex: x, zIndex: z, type: type, subChunkIndex: subChunkIndex)
//        case .theEnd:
//            addChunk(to: &theEnd, xIndex: x, zIndex: z, type: type, subChunkIndex: subChunkIndex)
//        }
//    }
    
    
//    public func addChunk(to dic: inout [String:MCChunkKey], xIndex: Int32, zIndex: Int32, type: MCChunkKeyType, subChunkIndex: Int8? = nil) {
//        let mapKey = generateMapKey(xIndex, zIndex)
//        if let _ = dic[mapKey] {
//            if type == .subChunkPrefix, let index = subChunkIndex {
//                dic[mapKey]!.addSubChunk(index: index)
//            } else {
//                dic[mapKey]!.addChunkKeyType(type: type)
//            }
//        } else {
//            var chunk = MCChunkKey(xIndex: xIndex, zIndex: zIndex)
//            if type == .subChunkPrefix, let index = subChunkIndex {
//                chunk.addSubChunk(index: index)
//            } else {
//                chunk.addChunkKeyType(type: type)
//            }
//            dic[mapKey] = chunk
//        }
//    }
    
//    public func deleteChunk(dimension: MCDimension, xIndex: Int32, zIndex: Int32) {
//        print("Delete: \(dimension)   \(xIndex), \(zIndex)")
//
//        let deletedChunk: MCChunkKey?
//        let mapKey = generateMapKey(xIndex, zIndex)
//
//        switch dimension {
//        case .overworld:
//            deletedChunk = overworld.removeValue(forKey: mapKey)
//        case .theNether:
//            deletedChunk = theNether.removeValue(forKey: mapKey)
//        case .theEnd:
//            deletedChunk = theEnd.removeValue(forKey: mapKey)
//        }
//
//        if let deletedChunk = deletedChunk {
//            for keyData in deletedChunk.generateKeyData(dimension: dimension) {
//                if db.deleteValue(keyData) {
//                    print("Delete key from lvdb: \(keyData.hexString)")
//                }
//            }
//        }
//    }
