import Foundation
import LvDBWrapper

public class MCWorld {
    public let dirURL: URL
    public let db: LvDB

    public var levelData: MCLevelData
    public private(set) var keysCount: UInt64 = 0

    public init(from dirURL: URL) throws {
        guard let db = LvDB(dbPath: dirURL.appendingPathComponent("db", isDirectory: true).path) else {
            throw CBLvDBError.failedOpenWorld(dirURL)
        }

        self.dirURL = dirURL
        self.db = db
        self.levelData = try MCLevelData(srcURL: dirURL.appendingPathComponent("level.dat", isDirectory: false))
        db.seekToFirst()
        while db.valid() {
            keysCount += 1
            db.next()
        }
    }

    public var worldName: String {
        get {
            levelData.worldName
        }
        set {
            guard newValue.count > 0, worldName != newValue else { return }
            let levelDataURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
            let nameFileURL = dirURL.appendingPathComponent("levelname.txt", isDirectory: false)
            levelData.worldName = newValue
            levelData.save(to: levelDataURL)
            try? newValue.write(to: nameFileURL, atomically: true, encoding: .utf8)
        }
    }

//    public func loadChunSection(x: Int32, z: Int32, dimension: MCDimension = .overworld) {
//        let keyPrefix: Data
//        if dimension == .overworld {
//            keyPrefix = x.data + z.data
//        } else {
//            keyPrefix = x.data + z.data + dimension.rawValue.data
//        }
//        var keyList = [Data]()
//        db.seek(keyPrefix)
//        while true {
//            defer {
//                db.next()
//            }
//            guard let keyData = db.key(), keyData[0..<keyPrefix.count] == keyPrefix else {
//                break
//            }
//            guard keyData.count == keyPrefix.count + 2 else { continue }
//            keyList.append(keyData)
//        }
//    }
}

//extension MCWorld {
//    public func decode(nbtData: Data) throws -> CompoundTag {
//        let reader = CBReader(CBBuffer(nbtData))
//        return try reader.readAsTag() as! CompoundTag
//    }
//
//    public func put(lvdbKey: Data, value: Data) -> Bool {
//        return db.put(lvdbKey, value)
//    }
//
//    public func remove(lvdbKey: Data) -> Bool {
//        return db.remove(lvdbKey)
//    }
//
//    public func removeChunks(_ dimension: MCDimension, xRange: ClosedRange<Int32>, zRange: ClosedRange<Int32>) {
//        print("\n========== ========== ========== ========== ========== ==========")
//        print("Delete data from \(dirURL.path)/db")
//        print("    \(dimension) ==> xRange: \(xRange), zRange: \(zRange)")
//
//        for x in xRange {
//            for z in zRange {
//                print("========== ========== ========== ========== ==========")
//                print("Delete chunk (\(x), \(z))")
//                let prefix = (dimension == .overworld) ? x.data + z.data : x.data + z.data + dimension.rawValue.data
//                let start = prefix + Data([MCChunkKeyType.keyTypeStartWith])
//                db.seek(start)
//                while db.valid() {
//                    guard let key = db.key(), key[0..<prefix.count] == prefix else { break }
//
//                    if db.remove(key) {
//                        print("    Delete key: \(key.hexString)")
//                    } else {
//                        print("    Error ==> Delete key: \(key.hexString)")
//                    }
//                    db.next()
//                }
//
//                print("Delete digp & actorprefix in chunk (\(x), \(z))")
//                let digpKey = "digp".data(using: .utf8)! + prefix
//                if let digpData = db.get(digpKey), digpData.count > 0, digpData.count % 8 == 0 {
//                    for i in 0..<digpData.count/8 {
//                        let actorprefixKey = "actorprefix".data(using: .utf8)! + digpData[i*8...i*8+7]
//                        if db.remove(actorprefixKey) {
//                            print("    Delete actorprefix: \(actorprefixKey.hexString)")
//                        } else {
//                            print("    Error ==> Delete actorprefix: \(actorprefixKey.hexString)")
//                        }
//                    }
//                    if db.remove(digpKey) {
//                        print("    Delete digp: \(digpKey.hexString)")
//                    } else {
//                        print("    Delete digp: \(digpKey.hexString)")
//                    }
//                }
//
//                print("")
//            }
//        }
//
//    }
//}
