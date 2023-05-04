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
