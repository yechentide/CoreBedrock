//
// Created by yechentide on 2025/11/12
//

public enum KeyValueStoreFactory {
    public static func open(dbPath: String, createIfMissing: Bool) throws -> any KeyValueStore {
        try LevelDB(dbPath: dbPath, createIfMissing: createIfMissing)
    }
}
