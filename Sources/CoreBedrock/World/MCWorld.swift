//
// Created by yechentide on 2024/07/14
//

import Foundation
import LvDBWrapper

public class MCWorld {
    public let dirURL: URL
    public let db: LvDB

    public var worldName = "???"
    public var meta: MCWorldMeta

    public var levelDatURL: URL {
        dirURL.appendingPathComponent("level.dat", isDirectory: false)
    }

    public var nameFileURL: URL {
        dirURL.appendingPathComponent("levelname.txt", isDirectory: false)
    }

    public init(from dirURL: URL, meta: MCWorldMeta? = nil) throws {
        let dbPath = dirURL.appendingPathComponent("db", isDirectory: true).path
        guard let db = LvDB(dbPath: dbPath) else {
            throw CBError.failedOpenWorld(dirURL)
        }

        self.dirURL = dirURL
        self.db = db

        if let metaArg = meta {
            self.meta = metaArg
        } else {
            let levelDatURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
            self.meta = try MCWorldMeta(from: levelDatURL)
        }
        if let name = self.meta.worldName {
            self.worldName = name
        }
    }

    public func closeDB() {
        db.close()
    }

    public func reloadMetaFile() throws {
        self.meta = try MCWorldMeta(from: levelDatURL)
    }

    public func updateMetaFile() throws {
        let tagData = try meta.toData()
        let metaRawData = meta.version.data + Int32(tagData.count).data + tagData
        try metaRawData.write(to: levelDatURL)
        try updateWorldNameFile()
    }

    public func updateMetaFile(with newTag: CompoundTag) throws {
        meta.tag = newTag
        try updateMetaFile()
    }

    public func updateWorldNameFile() throws {
        guard let newWorldName = meta.worldName, newWorldName != worldName else {
            return
        }
        self.worldName = newWorldName
        try newWorldName.write(to: nameFileURL, atomically: true, encoding: .utf8)
    }
}
