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
    public var serverPlayers   = Set<MCPlayer>()
    public var maps            = [Data]()
    public var villages        = [Data]()
    public var structures      = [Data]()
    
    public private(set) var keysCount: UInt64 = 0
    
    // MARK: Don't store these keys because there are too many keys in a big world
    // public var overworld: [String:MCChunkKey] = [:]
    // public var theNether: [String:MCChunkKey] = [:]
    // public var theEnd: [String:MCChunkKey] = [:]
    // public var actorprefix     = [Data]()
    // public var digp            = [Data]()
    
    public init(from dirURL: URL, storeKeys: Bool = true) throws {
        guard let db = LvDB(dbPath: dirURL.appendingPathComponent("db", isDirectory: true).path) else {
            throw CBLvDBError.failedOpenWorld(dirURL)
        }
        
        self.dirURL = dirURL
        self.db = db
        self.levelData = try LevelData(srcURL: dirURL.appendingPathComponent("level.dat", isDirectory: false))
        
        if storeKeys {
            storeWellKnownKeys()
            storePrefixedKeys()
        } else {
            db.seekToFirst()
            while db.valid() {
                keysCount += 1
                db.next()
            }
        }
    }
    
    private func storeWellKnownKeys() {
        for key in MCWellKnownKey.allCases {
            guard let keyData = key.rawValue.data(using: .utf8) else { continue }
            db.seek(keyData)
            if let _ = db.value() {
                wellKnownKeys.insert(key)
            }
        }
    }
    
    private func storePrefixedKeys() {
        db.seekToFirst()
        while db.valid() {
            defer {
                keysCount += 1
                db.next()
            }
            guard let key = db.key() else { continue }
            
            let prefix = String(data: key[0...2], encoding: .utf8)
            if prefix == "pla", let value = db.value(), value.count == 166 {
                let msaID = String(data: value[13...48], encoding: .utf8)!
                let signedID = String(data: value[66...101], encoding: .utf8)!
                let serverID = String(data: value[115...164], encoding: .utf8)!
                let player = MCPlayer(msaID: msaID, signedID: signedID, serverID: serverID)
                serverPlayers.insert(player)
            } else if prefix == "map" {
                maps.append(key)
            } else if prefix == "VIL" {
                villages.append(key)
            } else if prefix == "str" {
                structures.append(key)
            }
        }
    }
    
    public func changeWorldName(newName: String) {
        guard newName.count > 0 else { return }
        levelData.worldName = newName
        levelData.saveChanges()
    }
    
}

extension MCWorld {
    public func decode(nbtData: Data) throws -> CompoundTag {
        let reader = CBReader(CBBuffer(nbtData))
        return try reader.readAsTag() as! CompoundTag
    }
    
    public func put(lvdbKey: Data, value: Data) -> Bool {
        return db.put(lvdbKey, value)
    }
    
    public func remove(lvdbKey: Data) -> Bool {
        return db.remove(lvdbKey)
    }
    
    public func removeChunks(_ dimension: MCDimension, xRange: ClosedRange<Int32>, zRange: ClosedRange<Int32>) {
        print("\n========== ========== ========== ========== ========== ==========")
        print("Delete data from \(dirURL.path)/db")
        print("    \(dimension) ==> xRange: \(xRange), zRange: \(zRange)")
        
        for x in xRange {
            for z in zRange {
                print("========== ========== ========== ========== ==========")
                print("Delete chunk (\(x), \(z))")
                let prefix = (dimension == .overworld) ? x.data + z.data : x.data + z.data + dimension.rawValue.data
                let start = prefix + Data([MCChunkKeyType.keyTypeStartWith])
                db.seek(start)
                while db.valid() {
                    guard let key = db.key(), key[0..<prefix.count] == prefix else { break }
                    
                    if db.remove(key) {
                        print("    Delete key: \(key.hexString)")
                    } else {
                        print("    Error ==> Delete key: \(key.hexString)")
                    }
                    db.next()
                }
                
                print("Delete digp & actorprefix in chunk (\(x), \(z))")
                let digp = "digp".data(using: .utf8)! + prefix
                if let digpData = db.get(digp), digpData.count > 0, digpData.count % 8 == 0 {
                    for i in 0..<digpData.count/8 {
                        let actorprefix = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
                        if db.remove(actorprefix) {
                            print("    Delete actorprefix: \(actorprefix.hexString)")
                        } else {
                            print("    Error ==> Delete actorprefix: \(actorprefix.hexString)")
                        }
                    }
                    if db.remove(digp) {
                        print("    Delete digp: \(digp.hexString)")
                    } else {
                        print("    Delete digp: \(digp.hexString)")
                    }
                }
                
                print("")
            }
        }

    }
}
