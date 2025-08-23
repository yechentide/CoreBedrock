//
// Created by yechentide on 2025/08/23
//

import Testing
import Foundation
@testable import LvDBWrapper

struct LvDBTests {
    @Test(.withTemporaryDatabase)
    func initDBWithValidPath() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        #expect(db.isClosed == false)
        db.close()
    }

    @Test(.withTemporaryDatabase)
    func initDBWithValidPathMultiTimes() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        for _ in 0..<10 {
            let db = try LvDB(dbPath: dbPath)
            #expect(db.isClosed == false)
            db.close()
        }
    }

    @Test(.withEmptyDirectory)
    func initWithNonExistentPathWithoutCreateIfMissingSucceeds() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: false)
        #expect(db.isClosed == true)
        db.close()
    }

    @Test(.withEmptyDirectory)
    func initWithNonExistentPathWithCreateIfMissingSucceeds() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        #expect(db.isClosed == false)
        db.close()
    }

    @Test(.withEmptyDirectory)
    func initWithNonExistentPathWithCreateIfMissingMultiTimes() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        #expect(db.isClosed == false)
        db.close()
        for _ in 0..<10 {
            let db = try LvDB(dbPath: directoryPath, createIfMissing: false)
            #expect(db.isClosed == false)
            db.close()
        }
    }

    @Test(.withTemporaryDatabase)
    func isClosedReturnsTrueAfterClose() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        for _ in 0..<10 {
            let db = try LvDB(dbPath: dbPath)
            #expect(db.isClosed == false)
            db.close()
            #expect(db.isClosed == true)
        }
    }

    @Test(.withEmptyDirectory)
    func multipleCloseCallsAreSafe() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        for _ in 0..<10 {
            db.close()
            #expect(db.isClosed == true)
        }
    }

    @Test(.withEmptyDirectory)
    func databaseOperationsThrowErrorAfterClose() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        let key = "key001".data(using: .utf8)!
        let value = "value001".data(using: .utf8)!
        try db.put(key, value)
        #expect(db.contains(key) == true)
        db.close()
        #expect(db.contains(key) == false)

        let shouldThrowDBClosedError = { (function: () throws -> Void) in
            let e = #expect(throws: (any Error).self) {
                try function()
            }
            if let nsError = e as? NSError {
                #expect(nsError.code == -1 && nsError.localizedDescription == "DB Closed")
            } else {
                Issue.record()
            }
        }
        shouldThrowDBClosedError { let _ = try db.get(key) }
        shouldThrowDBClosedError { let _ = try db.put(key, value) }
        shouldThrowDBClosedError { let _ = try db.remove(key) }
        shouldThrowDBClosedError {
            let batch = LvDBWriteBatch()
            try db.writeBatch(batch)
        }
    }

    @Test(.withEmptyDirectory)
    func putAndGetKeyValue() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        let value = "value001".data(using: .utf8)!
        try db.put(key, value)

        let actualValue = try db.get(key)
        #expect(actualValue == value)
    }

    @Test(.withEmptyDirectory)
    func getNonExistentKeyReturnsNilOrEmptyData() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        #expect {
            let _ = try db.get(key)
        } throws: { error in
            let nsError = error as NSError
            return nsError.code == 1 && nsError.localizedDescription.hasPrefix("NotFound")
        }
    }

    @Test(.withEmptyDirectory)
    func putUpdatesExistingKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        let oldValue = "value001".data(using: .utf8)!
        let newValue = "value002".data(using: .utf8)!
        try db.put(key, oldValue)
        try db.put(key, newValue)

        let actualValue = try db.get(key)
        #expect(actualValue == newValue)
    }

    @Test(.withEmptyDirectory)
    func containsReturnsTrueForExistingKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        let value = "value001".data(using: .utf8)!
        try db.put(key, value)

        let result = db.contains(key)
        #expect(result == true)
    }

    @Test(.withEmptyDirectory)
    func containsReturnsFalseForNonExistentKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        let result = db.contains(key)
        #expect(result == false)
    }

    @Test(.withEmptyDirectory)
    func removeDeletesKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        let value = "value001".data(using: .utf8)!
        try db.put(key, value)
        try db.remove(key)
        #expect(db.contains(key) == false)
    }

    @Test(.withEmptyDirectory)
    func removeNonExistentKeyDoesNotCrash() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = "key001".data(using: .utf8)!
        try db.remove(key)
        #expect(db.contains(key) == false)
    }

    @Test(.withEmptyDirectory)
    func writeBatchWithMultiplePuts() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = "key001".data(using: .utf8)!
        let key2 = "key002".data(using: .utf8)!
        let value1 = "value001".data(using: .utf8)!
        let value2 = "value002".data(using: .utf8)!

        let batch = LvDBWriteBatch()
        batch.put(key1, value: value1)
        batch.put(key2, value: value2)
        try db.writeBatch(batch)

        let actualValue1 = try db.get(key1)
        let actualValue2 = try db.get(key2)
        #expect(actualValue1 == value1)
        #expect(actualValue2 == value2)
    }

    @Test(.withEmptyDirectory)
    func writeBatchWithRemoveOperation() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = "key001".data(using: .utf8)!
        let key2 = "key002".data(using: .utf8)!
        let value1 = "value001".data(using: .utf8)!
        let value2 = "value002".data(using: .utf8)!
        try db.put(key1, value1)
        try db.put(key2, value2)

        let batch = LvDBWriteBatch()
        batch.remove(key1)
        batch.remove(key2)
        try db.writeBatch(batch)

        #expect(db.contains(key1) == false)
        #expect(db.contains(key2) == false)
    }

    @Test(.withEmptyDirectory)
    func writeBatchClearResetsBatch() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = "key001".data(using: .utf8)!
        let key2 = "key002".data(using: .utf8)!
        let value1 = "value001".data(using: .utf8)!
        let value2 = "value002".data(using: .utf8)!

        let batch = LvDBWriteBatch()
        batch.put(key1, value: value1)
        batch.put(key2, value: value2)
        batch.clear()
        try db.writeBatch(batch)

        #expect(db.contains(key1) == false)
        #expect(db.contains(key2) == false)
    }

//    @Test(.withEmptyDirectory)
//    func compactRangeWithNilRangeCompactsEntireDB() async throws {}
//
//    @Test(.withEmptyDirectory)
//    func compactRangeWithSpecificRange() async throws {}
}
