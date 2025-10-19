//
// Created by yechentide on 2025/08/23
//

import Foundation
@testable import LvDBWrapper
import Testing

// swiftlint:disable type_body_length

struct LvDBIteratorTests {
    @Test(.withTemporaryDatabase)
    func positionsAtFirstKeyWhenSeekToFirst() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToFirst()
        #expect(iter.valid() == true)
    }

    @Test(.withTemporaryDatabase)
    func positionsAtLastKeyWhenSeekToLast() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToLast()
        #expect(iter.valid() == true)
    }

    @Test(.withTemporaryDatabase)
    func positionsAtGivenKeyWhenSeek() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }
        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        let key = Data("~local_player".utf8)
        iter.seek(key)
        #expect(iter.valid() == true)
    }

    @Test(.withEmptyDirectory)
    func positionsAtNextGreaterKeyWhenSeekingNonExistentKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"]
        for key in keys {
            try db.put(Data(key.utf8), Data())
        }

        let iter = try db.makeIterator()

        // Seek to an existing key
        let bananaKey = Data("banana".utf8)
        iter.seek(bananaKey)
        #expect(iter.key() == bananaKey)

        // Seek to a non-existent key ("blueberry") → moves to next greater key ("cherry")
        let blueberryKey = Data("blueberry".utf8)
        let cherryKey = Data("cherry".utf8)
        iter.seek(blueberryKey)
        #expect(iter.key() == cherryKey)

        // Seek to a key beyond all existing keys → iterator becomes invalid
        let zzzKey = Data("zzz".utf8)
        iter.seek(zzzKey)
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func movesForwardWithNext() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

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
    func movesBackwardWithPrev() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

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
    func reportsInvalidWhenExhausted() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

        let iter = try db.makeIterator()

        #expect(iter.valid() == false)
        iter.seekToFirst()
        #expect(iter.valid() == true)
        iter.next()
        #expect(iter.valid() == false)
    }

    @Test(.withEmptyDirectory)
    func returnsCurrentKey() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let key = Data("apple".utf8)
        try db.put(key, Data())

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.key() == key)
    }

    @Test(.withEmptyDirectory)
    func returnsCurrentValue() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let key = Data("apple".utf8)
        let value = Data("fruit".utf8)
        try db.put(key, value)

        let iter = try db.makeIterator()

        iter.seekToFirst()
        #expect(iter.value() == value)
    }

    @Test(.withEmptyDirectory)
    func iteratesOverAllKeys() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

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
    func reportsDestroyedAfterDestroy() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }

        let iter = try db.makeIterator()
        #expect(iter.isDestroyed == false)
        iter.destroy()
        #expect(iter.isDestroyed == true)
    }

    @Test(.withTemporaryDatabase)
    func iteratorIsSafeAfterDestroy() throws {
        let dbPath = TemporaryDatabaseTrait.Context.dbPath
        let db = try LvDB(dbPath: dbPath)
        defer { db.close() }

        let iter = try db.makeIterator()
        iter.destroy()
        #expect(iter.valid() == false)
        #expect(iter.key() == nil)
        #expect(iter.value() == nil)
        iter.next() // no crash
        iter.prev() // no crash
        iter.seekToFirst() // no crash
        iter.seekToLast() // no crash
    }

    @Test(.withEmptyDirectory)
    func remainsValidAfterDbCompaction() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keys = ["apple", "banana", "cherry"].map { Data($0.utf8) }
        for key in keys {
            try db.put(key, Data())
        }

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
    func doesNotSeeNewKeysAfterPut() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let iter = try db.makeIterator()

        let newKey = Data("newKey".utf8)
        let newValue = Data("newValue".utf8)
        try db.put(newKey, newValue)

        iter.seek(newKey)
        #expect(iter.valid() == false)
        #expect(db.contains(newKey) == true)
    }

    @Test(.withEmptyDirectory)
    func doesNotSeeRemovedKeysAfterDelete() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        let keyToRemove = Data("deleteMe".utf8)
        let value = Data("value".utf8)
        try db.put(keyToRemove, value)

        let iter = try db.makeIterator()

        try db.remove(keyToRemove)

        iter.seek(keyToRemove)
        #expect(iter.valid() == true)
        #expect(iter.key() == keyToRemove)
        #expect(db.contains(keyToRemove) == false)
    }

    @Test(.withEmptyDirectory)
    func deregistersFromParentDbOnManualDestroy() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        try db.put(Data("key".utf8), Data("value".utf8))

        let iter1 = try db.makeIterator()
        let iter2 = try db.makeIterator()

        // Manually destroy iter1
        iter1.destroy()
        #expect(iter1.isDestroyed == true)

        // iter2 should still work normally
        iter2.seekToFirst()
        #expect(iter2.valid() == true)
        #expect(iter2.isDestroyed == false)
    }

    @Test(.withEmptyDirectory)
    func allowsMultipleDestroyCallsSafely() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)
        defer { db.close() }

        try db.put(Data("key".utf8), Data("value".utf8))

        let iter = try db.makeIterator()
        iter.seekToFirst()

        // First destroy
        iter.destroy()
        #expect(iter.isDestroyed == true)

        // Second destroy should be safe
        iter.destroy()
        #expect(iter.isDestroyed == true)

        // Third destroy should also be safe
        iter.destroy()
        #expect(iter.isDestroyed == true)
    }

    @Test(.withEmptyDirectory)
    func iteratorRemainsDestroyedAfterParentDbClose() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let db = try LvDB(dbPath: directoryPath, createIfMissing: true)

        try db.put(Data("key".utf8), Data("value".utf8))

        let iter = try db.makeIterator()
        iter.seekToFirst()
        #expect(iter.isDestroyed == false)

        // Close DB, which destroys the iterator
        db.close()
        #expect(iter.isDestroyed == true)

        // Iterator should remain destroyed
        #expect(iter.valid() == false)
        #expect(iter.key() == nil)
        #expect(iter.value() == nil)
    }
}

// swiftlint:enable type_body_length
