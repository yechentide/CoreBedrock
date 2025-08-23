//
// Created by yechentide on 2025/08/23
//

import Testing
import Foundation
@testable import LvDBWrapper

struct LvDBIteratorTests {
    @Test(.withTemporaryDatabase)
    func seekToFirstPositionsAtFirstKey() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToFirst()
        #expect(iter.valid() == true)
    }

    @Test(.withTemporaryDatabase)
    func seekToLastPositionsAtLastKey() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToLast()
        #expect(iter.valid() == true)
    }

    @Test(.withTemporaryDatabase)
    func seekPositionsAtGivenKey() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        let key = "~local_player".data(using: .utf8)!
        iter.seek(key)
        #expect(iter.valid() == true)
    }

    @Test(.withEmptyDirectory)
    func seekToNonExistentKeyPositionsAtNextGreaterKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"]
        for key in keys {
            try db.put(key.data(using: .utf8)!, Data())
        }

        let iter = try db.makeIterator()

        // Seek to an existing key
        let bananaKey = "banana".data(using: .utf8)!
        iter.seek(bananaKey)
        #expect(iter.key() == bananaKey)

        // Seek to a non-existent key ("blueberry") → moves to next greater key ("cherry")
        let blueberryKey = "blueberry".data(using: .utf8)!
        let cherryKey = "cherry".data(using: .utf8)!
        iter.seek(blueberryKey)
        #expect(iter.key() == cherryKey)

        // Seek to a key beyond all existing keys → iterator becomes invalid
        let zzzKey = "zzz".data(using: .utf8)!
        iter.seek(zzzKey)
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func nextMovesForward() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { $0.data(using: .utf8)! }
        for key in keys { try db.put(key, Data()) }

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.key() == keys[0])
        iter.next()
        #expect(iter.key() == keys[1])
        iter.next()
        #expect(iter.key() == keys[2])
        iter.next()
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func prevMovesBackward() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { $0.data(using: .utf8)! }
        for key in keys { try db.put(key, Data()) }

        let iter = try db.makeIterator()

        iter.seekToLast()
        #expect(iter.key() == keys[2])
        iter.prev()
        #expect(iter.key() == keys[1])
        iter.prev()
        #expect(iter.key() == keys[0])
        iter.prev()
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func validReturnsFalseWhenIteratorIsExhausted() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple"].map { $0.data(using: .utf8)! }
        for key in keys { try db.put(key, Data()) }

        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToFirst()
        #expect(iter.valid() == true)
        iter.next()
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func keyReturnsCurrentKey() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let key = "apple".data(using: .utf8)!
        try db.put(key, Data())

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.key() == key)
    }

    @Test(.withEmptyDirectory)
    func valueReturnsCurrentValue() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let key = "apple".data(using: .utf8)!
        let value = "fruit".data(using: .utf8)!
        try db.put(key, value)

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.value() == value)
    }

    @Test(.withEmptyDirectory)
    func iterationOverAllKeys() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { $0.data(using: .utf8)! }
        for key in keys { try db.put(key, Data()) }

        let iter = try db.makeIterator()

        var collected: [Data] = []
        iter.seekToFirst()
        while iter.valid() {
            collected.append(iter.key()!)
            iter.next()
        }

        #expect(collected == keys)
    }

    @Test(.withTemporaryDatabase)
    func isDestroyedReturnsTrueAfterDestroy() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }

        let iter = try db.makeIterator()
        #expect(iter.isDestroyed == false)
        iter.destroy()
        #expect(iter.isDestroyed == true)
    }

    @Test(.withTemporaryDatabase)
    func usingIteratorAfterDestroyFails() async throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }

        let iter = try db.makeIterator()
        iter.destroy()
        #expect(iter.valid() == false)
        #expect(iter.key() == nil)
        #expect(iter.value() == nil)
        iter.next()   // no crash
        iter.prev()   // no crash
        iter.seekToFirst() // no crash
        iter.seekToLast()  // no crash
    }

    @Test(.withEmptyDirectory)
    func iteratorRemainsValidAfterDBCompaction() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { $0.data(using: .utf8)! }
        for key in keys { try db.put(key, Data()) }

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.key() == keys[0])

        // Compact the entire database
        try db.compactRange(withBegin: nil, end: nil)

        // Iterator should remain valid and point to the same key
        #expect(iter.valid() == true)
        #expect(iter.key() == keys[0])
        iter.next()
        #expect(iter.key() == keys[1])
    }

    @Test(.withEmptyDirectory)
    func iteratorDoesNotSeeUpdatesAfterPut() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let iter = try db.makeIterator()

        let newKey = "newKey".data(using: .utf8)!
        let newValue = "newValue".data(using: .utf8)!
        try db.put(newKey, newValue)

        iter.seek(newKey)
        #expect(iter.valid() == false)
        #expect(db.contains(newKey) == true)
    }

    @Test(.withEmptyDirectory)
    func iteratorDoesNotSeeRemovalsAfterDelete() async throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keyToRemove = "deleteMe".data(using: .utf8)!
        let value = "value".data(using: .utf8)!
        try db.put(keyToRemove, value)

        let iter = try db.makeIterator()

        try db.remove(keyToRemove)

        iter.seek(keyToRemove)
        #expect(iter.valid() == true)
        #expect(iter.key() == keyToRemove)
        #expect(db.contains(keyToRemove) == false)
    }
}
