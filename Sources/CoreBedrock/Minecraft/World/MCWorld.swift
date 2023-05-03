import Foundation
import LvDBWrapper

public class MCWorld {
    public let dirURL: URL
    public let db: LvDB

    public var metaData: Data
    public var name = "???"
    public var keysCount: UInt64 = 0

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

        readWorldNameFile()

        db.seekToFirst()
        while db.valid() {
            keysCount += 1
            db.next()
        }
    }

    public func closeDB() {
        db.close()
    }

    public func readWorldNameFile() {
        let nameFileURL = dirURL.appendingPathComponent("levelname.txt", isDirectory: false)
        name = (try? String(contentsOf: nameFileURL, encoding: .utf8)) ?? "???"
    }

    public func updateMetaData(with newTag: CompoundTag) {
        do {
            let ms = CBBuffer()
            let writer = try CBWriter(stream: ms, rootTagName: "")
            for tag in newTag {
                try writer.writeTag(tag: tag)
            }
            try writer.endCompound()
            try writer.finish()
            let tagData = Data(ms.toArray())
            metaData = version.data + Int32(tagData.count).data + tagData

            let metaDataURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
            try metaData.write(to: metaDataURL)
        } catch {
            fatalError("Error: can not save meta data")
        }
    }

    public func updateWorldNameFile() {
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
