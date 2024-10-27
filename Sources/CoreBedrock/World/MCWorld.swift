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

    public init(from dirURL: URL, meta: MCWorldMeta? = nil) throws {
        let dbPath = MCDir.generatePath(for: .db, in: dirURL)
        guard let db = LvDB(dbPath: dbPath) else {
            throw CBError.failedOpenWorld(dirURL)
        }

        self.dirURL = dirURL
        self.db = db

        if let metaArg = meta {
            self.meta = metaArg
        } else {
            let levelDatURL = MCDir.generateURL(for: .levelDat, in: dirURL)
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
        let levelDatURL = MCDir.generateURL(for: .levelDat, in: dirURL)
        self.meta = try MCWorldMeta(from: levelDatURL)
    }
}
