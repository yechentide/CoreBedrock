import Foundation
import LvDBWrapper

public class MCWorld {
    public let dirURL: URL
    public let db: LvDB

    public var metaData: Data
    public var name = "Unknown"
    public private(set) var keysCount: UInt64 = 0

    public var version: Int32 {
        metaData[0..<4].int32!
    }

    public init(from dirURL: URL) throws {
        guard let db = LvDB(dbPath: dirURL.appendingPathComponent("db", isDirectory: true).path) else {
            throw CBLvDBError.failedOpenWorld(dirURL)
        }

        self.dirURL = dirURL
        self.db = db

        let metaDataURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
        guard let metaData = try? Data(contentsOf: metaDataURL), metaData.count > 8 else {
            throw CBLvDBError.failedParseLevelData(metaDataURL)
        }
        self.metaData = metaData

        updateWorldNameFromMetaData()

        db.seekToFirst()
        while db.valid() {
            keysCount += 1
            db.next()
        }
    }

    func updateWorldNameFromMetaData() {
        // 08 09 00 4C 65 76 65 6C 4E 61 6D 65
        // LevelName
        let prefix = Data([0x08, 0x09, 0x00, 0x4C, 0x65, 0x76, 0x65, 0x6C, 0x4E, 0x61, 0x6D, 0x65])
        guard let range = metaData.firstRange(of: prefix) else {
            return
        }
        let start = range.upperBound + 1
        let reader = CBReader(CBBuffer(metaData[start...]))
        if let nameTag = try? reader.readAsTag() as? StringTag {
            name = nameTag.value
        } else {
            name = "Unknown"
        }
    }

    public func saveMetaData() {
        do {
            let metaDataURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
            let data = version.data + Int32(metaData.count).data + metaData
            try data.write(to: metaDataURL)
        } catch {
            fatalError("Error: can not save meta data")
        }
    }

    public func saveWorldNameToFile() {
        let nameFileURL = dirURL.appendingPathComponent("levelname.txt", isDirectory: false)
        try? name.write(to: nameFileURL, atomically: true, encoding: .utf8)
    }
}

extension MCWorld {
    public func removeChunks(xRange: ClosedRange<Int32>, zRange: ClosedRange<Int32>, dimension: MCDimension) {
        db.removeChunks(xRange: xRange, zRange: zRange, dimension: dimension)
    }
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
//    }
}
