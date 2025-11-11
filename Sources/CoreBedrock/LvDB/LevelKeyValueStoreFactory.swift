//
// Created by yechentide on 2025/11/12
//

import LvDBWrapper

public enum LevelKeyValueStoreFactory {
    static func makeDefault(dbPath: String, createIfMissing: Bool) throws -> LevelKeyValueStore {
        try LvDB(dbPath: dbPath, createIfMissing: createIfMissing)
    }
}
