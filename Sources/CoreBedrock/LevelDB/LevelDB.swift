//
// Created by yechentide on 2025/11/12
//

public import Foundation
import LevelDBObjC

public final class LevelDB: KeyValueStore, @unchecked Sendable {
    private let db: LevelDBBridge

    public init(dbPath: String, createIfMissing: Bool) throws {
        self.db = try LevelDBBridge(dbPath: dbPath, createIfMissing: createIfMissing)
    }

    public var isClosed: Bool {
        self.db.isClosed
    }

    public func close() {
        self.db.close()
    }

    public func containsKey(_ key: Data) -> Bool {
        self.db.has(key)
    }

    public func data(forKey key: Data) throws -> Data {
        try self.db.get(key)
    }

    public func putData(_ data: Data, forKey key: Data) throws {
        try self.db.put(key, data)
    }

    public func removeValue(forKey key: Data) throws {
        try self.db.remove(key)
    }

    public func makeIterator() throws -> any KeyValueStoreIterator {
        try LevelDBIterator(self.db.newIterator())
    }

    public func writeBatch(_ batch: any KeyValueWriteBatch) throws {
        guard let lvdbBatch = batch as? LevelDBWriteBatch else {
            throw LvDBError.invalidArgument("Expected LevelDBWriteBatch")
        }

        try self.db.write(lvdbBatch.batch)
    }

    public func compactRange(from begin: Data?, to end: Data?) throws {
        try self.db.compactRange(begin, end)
    }
}
