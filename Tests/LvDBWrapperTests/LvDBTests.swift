//
// Created by yechentide on 2025/08/23
//

import Foundation
@testable import LvDBWrapper
import Testing

// swiftlint:disable type_body_length

struct LvDBTests {
    @Test(.withEmptyDirectory)
    func throwsWhenTryingToOpenNonDbDirectoryAndCreateIfMissingIsFalse() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        #expect {
            _ = try LvDB(dbPath: directoryPath, createIfMissing: false)
        } throws: { error in
            let nsError = error as NSError
            return nsError.localizedDescription.hasPrefix("Invalid argument:")
        }
    }

    @Test(.withEmptyDirectory)
    func throwsWhenParentDirectoryDoesNotExist() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath + "/NonExistentDir/db"
        #expect {
            _ = try LvDB(dbPath: directoryPath, createIfMissing: true)
        } throws: { error in
            let nsError = error as NSError
            return nsError.localizedDescription.hasPrefix("NotFound:")
        }
    }

    @Test(.withTemporaryDatabase)
    func succeedsWithValidPath() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        #expect(db.isClosed == false)
        db.close()
    }

    @Test(.withTemporaryDatabase)
    func succeedsWhenOpenedMultipleTimes() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        for _ in 0..<10 {
            let db = try LvDB(dbPath: dbPath)
            #expect(db.isClosed == false)
            db.close()
        }
    }

    @Test(.withEmptyDirectory)
    func opensDbWhenDbPathDoesNotExistAndCreateIfMissingIsTrue() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        #expect(db.isClosed == false)
        db.close()
    }

    @Test(.withEmptyDirectory)
    func canOpenDbMultipleTimesWithCreateIfMissing() throws {
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
    func reportsClosedAfterClose() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        for _ in 0..<10 {
            let db = try LvDB(dbPath: dbPath)
            #expect(db.isClosed == false)
            db.close()
            #expect(db.isClosed == true)
        }
    }

    @Test(.withEmptyDirectory)
    func allowsMultipleCloseCallsWithoutError() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        for _ in 0..<10 {
            db.close()
            #expect(db.isClosed == true)
        }
    }

    @Test(.withEmptyDirectory)
    func throwsWhenOperationsAfterClose() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        let key = Data("key001".utf8)
        let value = Data("value001".utf8)
        try db.put(key, value)
        #expect(db.contains(key) == true)
        db.close()
        #expect(db.contains(key) == false)

        let shouldThrowDBClosedError = { (function: () throws -> Void) in
            let e = #expect(throws: (any Error).self) {
                try function()
            }
            if let nsError = e as? NSError {
                #expect(nsError.localizedDescription == "DB Closed")
            } else {
                Issue.record()
            }
        }
        shouldThrowDBClosedError { _ = try db.get(key) }
        shouldThrowDBClosedError { _ = try db.put(key, value) }
        shouldThrowDBClosedError { _ = try db.remove(key) }
        shouldThrowDBClosedError {
            let batch = LvDBWriteBatch()
            try db.writeBatch(batch)
        }
    }

    @Test(.withEmptyDirectory)
    func storesAndRetrievesKeyValue() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        let value = Data("value001".utf8)
        try db.put(key, value)

        let actualValue = try db.get(key)
        #expect(actualValue == value)
    }

    @Test(.withEmptyDirectory)
    func throwsOrReturnsNilForNonExistentKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        #expect {
            _ = try db.get(key)
        } throws: { error in
            let nsError = error as NSError
            return nsError.localizedDescription.hasPrefix("NotFound")
        }
    }

    @Test(.withEmptyDirectory)
    func overwritesExistingKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        let oldValue = Data("value001".utf8)
        let newValue = Data("value002".utf8)
        try db.put(key, oldValue)
        try db.put(key, newValue)

        let actualValue = try db.get(key)
        #expect(actualValue == newValue)
    }

    @Test(.withEmptyDirectory)
    func containsReturnsTrueForStoredKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        let value = Data("value001".utf8)
        try db.put(key, value)

        let result = db.contains(key)
        #expect(result == true)
    }

    @Test(.withEmptyDirectory)
    func containsReturnsFalseForMissingKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        let result = db.contains(key)
        #expect(result == false)
    }

    @Test(.withEmptyDirectory)
    func removesExistingKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        let value = Data("value001".utf8)
        try db.put(key, value)
        try db.remove(key)
        #expect(db.contains(key) == false)
    }

    @Test(.withEmptyDirectory)
    func removingNonExistentKeyIsSafe() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key = Data("key001".utf8)
        try db.remove(key)
        #expect(db.contains(key) == false)
    }

    @Test(.withEmptyDirectory)
    func appliesBatchWithMultiplePuts() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = Data("key001".utf8)
        let key2 = Data("key002".utf8)
        let value1 = Data("value001".utf8)
        let value2 = Data("value002".utf8)

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
    func appliesBatchWithRemovals() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = Data("key001".utf8)
        let key2 = Data("key002".utf8)
        let value1 = Data("value001".utf8)
        let value2 = Data("value002".utf8)
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
    func clearingBatchPreventsWrites() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }
        let key1 = Data("key001".utf8)
        let key2 = Data("key002".utf8)
        let value1 = Data("value001".utf8)
        let value2 = Data("value002".utf8)

        let batch = LvDBWriteBatch()
        batch.put(key1, value: value1)
        batch.put(key2, value: value2)
        batch.clear()
        try db.writeBatch(batch)

        #expect(db.contains(key1) == false)
        #expect(db.contains(key2) == false)
    }

//    @Test(.withEmptyDirectory)
//    func compactsEntireDbWhenRangeIsNil() async throws {}
//
//    @Test(.withEmptyDirectory)
//    func compactsDbWithinSpecifiedRange() async throws {}

    @Test(.withEmptyDirectory)
    func destroysAllActiveIteratorsOnClose() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)

        // Create some test data
        let keys = ["apple", "banana", "cherry"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

        // Create multiple iterators
        let iter1 = try db.makeIterator()
        let iter2 = try db.makeIterator()
        let iter3 = try db.makeIterator()

        // Position iterators
        iter1.seekToFirst()
        iter2.seek(keys[1])
        iter3.seekToLast()

        // Verify iterators are valid
        #expect(iter1.isDestroyed == false)
        #expect(iter2.isDestroyed == false)
        #expect(iter3.isDestroyed == false)
        #expect(iter1.valid() == true)
        #expect(iter2.valid() == true)
        #expect(iter3.valid() == true)

        // Close the database
        db.close()

        // All iterators should be destroyed
        #expect(iter1.isDestroyed == true)
        #expect(iter2.isDestroyed == true)
        #expect(iter3.isDestroyed == true)
    }

    @Test(.withEmptyDirectory)
    func handlesIteratorDestroyedBeforeDbClose() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)

        // Create some test data
        try db.put(Data("key".utf8), Data("value".utf8))

        // Create iterators
        let iter1 = try db.makeIterator()
        let iter2 = try db.makeIterator()

        // Manually destroy one iterator before closing the database
        iter1.destroy()
        #expect(iter1.isDestroyed == true)
        #expect(iter2.isDestroyed == false)

        // Close should only destroy the remaining active iterator
        db.close()

        #expect(iter1.isDestroyed == true)
        #expect(iter2.isDestroyed == true)
    }

    @Test(.withEmptyDirectory)
    func handlesMultipleCloseCallsWithActiveIterators() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)

        // Create some test data
        try db.put(Data("key".utf8), Data("value".utf8))

        // Create iterators
        let iter1 = try db.makeIterator()
        let iter2 = try db.makeIterator()

        iter1.seekToFirst()
        iter2.seekToFirst()

        #expect(iter1.isDestroyed == false)
        #expect(iter2.isDestroyed == false)

        // First close destroys all iterators
        db.close()

        #expect(iter1.isDestroyed == true)
        #expect(iter2.isDestroyed == true)

        // Second close should not cause any issues
        db.close()

        #expect(iter1.isDestroyed == true)
        #expect(iter2.isDestroyed == true)
    }

    @Test(.withEmptyDirectory)
    func allowsManualIteratorDestroyAfterDbClose() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)

        try db.put(Data("key".utf8), Data("value".utf8))

        let iter = try db.makeIterator()
        iter.seekToFirst()

        // Close destroys the iterator
        db.close()
        #expect(iter.isDestroyed == true)

        // Calling destroy again should be safe
        iter.destroy()
        #expect(iter.isDestroyed == true)
    }
}

// swiftlint:enable type_body_length
