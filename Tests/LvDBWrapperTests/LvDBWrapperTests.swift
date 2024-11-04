//
// Created by yechentide on 2024/10/03
//

import Testing
import Foundation
import LvDBWrapper

struct LvDBWrapperTests {
    private let testDataPath = Bundle.module.path(forResource: "TestData/db", ofType: nil)!

    private func prepareTemporaryDB() -> String {
        let tempDBDirName = "db_\(UUID().uuidString)"
        let originalURL: URL
        let tempDBURL: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            originalURL = URL(filePath: testDataPath, directoryHint: .isDirectory)
            tempDBURL = FileManager.default.temporaryDirectory.appending(component: tempDBDirName, directoryHint: .isDirectory)
        } else {
            originalURL = URL(fileURLWithPath: testDataPath, isDirectory: true)
            tempDBURL = FileManager.default.temporaryDirectory.appendingPathComponent(tempDBDirName, isDirectory: true)
        }

        do {
            try? FileManager.default.removeItem(at: tempDBURL)
            try FileManager.default.copyItem(at: originalURL, to: tempDBURL)
            print("Created test db at \(tempDBURL.path()).")
        } catch {
            Issue.record("Failed to copy the database from bundle.")
        }

        if #available(iOS 16.0, macOS 13.0, *) {
            return tempDBURL.path()
        } else {
            return tempDBURL.path
        }
    }

    private func removeTemporaryDB(_ dbPath: String) {
        print()
        do {
            try FileManager.default.removeItem(atPath: dbPath)
            print("Removed test db at \(dbPath).\n")
        } catch {
            Issue.record("Failed to remove the temporary database.\n")
        }
    }

    private func seekAndCheckDataSize(_ iterator: LvDBIterator, _ key: String, _ expectedValueSize: Int) {
        iterator.seek(key.data(using: .utf8))
        if iterator.valid(), let v = iterator.value() {
            #expect(v.count == expectedValueSize)
        } else {
            Issue.record()
        }
    }

    @Test
    func repeatOpenAndFetchFromSingleDB() async throws {
        let dbPath = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath)
        }

        let openDBAndCheckDataSize = {(key: String, expectedValueSize: Int) in
            guard let db = LvDB(dbPath: dbPath),
                  let iterator = db.makeIterator()
            else {
                Issue.record()
                return
            }
            seekAndCheckDataSize(iterator, key, expectedValueSize)
            iterator.destroy()
            #expect(db.isClosed == false)
            db.close()
            #expect(db.isClosed == true)
            db.close()
            #expect(db.isClosed == true)
        }

        openDBAndCheckDataSize("mobevents", 126)
        openDBAndCheckDataSize("~local_player", 7323)
        openDBAndCheckDataSize("BiomeData", 436)
    }

    @Test
    func multiIteratorFetchFromSingleDB() async throws {
        let dbPath = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath)
        }

        guard let db = LvDB(dbPath: dbPath),
              let iterator01 = db.makeIterator(),
              let iterator02 = db.makeIterator()
        else {
            Issue.record()
            return
        }
        defer {
            iterator01.destroy()
            iterator02.destroy()
            db.close()
        }

        seekAndCheckDataSize(iterator01, "mobevents", 126)
        seekAndCheckDataSize(iterator02, "BiomeData", 436)
    }

    @Test
    func multiIteratorFetchFromMultiDB() async throws {
        let dbPath01 = prepareTemporaryDB()
        let dbPath02 = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath01)
            removeTemporaryDB(dbPath02)
        }

        guard let db01 = LvDB(dbPath: dbPath01),
              let db02 = LvDB(dbPath: dbPath02),
              let iterator01 = db01.makeIterator(),
              let iterator02 = db02.makeIterator()
        else {
            Issue.record()
            return
        }
        defer {
            iterator01.destroy()
            iterator02.destroy()
            db01.close()
            db02.close()
        }

        seekAndCheckDataSize(iterator01, "mobevents", 126)
        seekAndCheckDataSize(iterator02, "mobevents", 126)
        seekAndCheckDataSize(iterator01, "BiomeData", 436)
        seekAndCheckDataSize(iterator02, "BiomeData", 436)
    }

    @Test
    func checkIteratorAvailability() async throws {
        let dbPath = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath)
        }
        guard let db = LvDB(dbPath: dbPath),
              let iterator = db.makeIterator()
        else {
            Issue.record()
            return
        }
        defer {
            iterator.destroy()
            db.close()
        }

        #expect(iterator.isDestroyed == false)
        #expect(iterator.valid() == false)

        iterator.seekToFirst()
        #expect(iterator.isDestroyed == false)
        #expect(iterator.valid() == true)

        iterator.destroy()
        #expect(iterator.isDestroyed == true)
        iterator.destroy()
        #expect(iterator.isDestroyed == true)
        db.close()
        #expect(iterator.isDestroyed == true)
        iterator.destroy()
        #expect(iterator.isDestroyed == true)
    }

    @Test
    func iteratorSeek() async throws {
        let dbPath = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath)
        }
        guard let db = LvDB(dbPath: dbPath),
              let iterator = db.makeIterator()
        else {
            Issue.record()
            return
        }
        defer {
            iterator.destroy()
            db.close()
        }

        var firstToLastCount = 0
        iterator.seekToFirst()
        while iterator.valid() {
            firstToLastCount += 1
            iterator.next()
        }

        var lastToFirstCount = 0
        iterator.seekToLast()
        while iterator.valid() {
            lastToFirstCount += 1
            iterator.prev()
        }

        #expect(firstToLastCount == lastToFirstCount)

        let wellKnownKey = "~local_player".data(using: .utf8)!
        iterator.seek(wellKnownKey)

        guard let key = iterator.key(), let value = iterator.value() else {
            Issue.record()
            return
        }
        let keyStr = String(data: key, encoding: .utf8)
        #expect(keyStr == "~local_player")
        #expect(value.count == 7323)
    }

    @Test
    func deleteFromDB() async throws {
        let dbPath = prepareTemporaryDB()
        defer {
            removeTemporaryDB(dbPath)
        }
        guard let db = LvDB(dbPath: dbPath),
              let iterator = db.makeIterator()
        else {
            Issue.record()
            return
        }
        defer {
            iterator.destroy()
            db.close()
        }

        var count01 = 0
        iterator.seekToFirst()
        while iterator.valid() {
            count01 += 1
            iterator.next()
        }

        db.remove("mobevents".data(using: .utf8)!)
        db.remove("~local_player".data(using: .utf8)!)
        db.remove("BiomeData".data(using: .utf8)!)

        var count02 = 0
        iterator.seekToFirst()
        while iterator.valid() {
            count02 += 1
            iterator.next()
        }

        #expect(count01 == count02)

        guard let iterator02 = db.makeIterator() else {
            Issue.record()
            return
        }
        defer {
            iterator02.destroy()
        }

        var count03 = 0
        iterator02.seekToFirst()
        while iterator02.valid() {
            count03 += 1
            iterator02.next()
        }

        #expect(count03 == count01 - 3)
    }
}
