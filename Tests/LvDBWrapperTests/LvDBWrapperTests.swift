import XCTest
@testable import LvDBWrapper

final class LvDBWrapperTests: XCTestCase {
    private let dbPath = Bundle.module.path(forResource: "world/db", ofType: nil)!
    private func prepareTemporaryDB() -> String {
        let originalURL: URL
        let tempURL: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            originalURL = URL(filePath: dbPath, directoryHint: .isDirectory)
            tempURL = FileManager.default.temporaryDirectory.appending(component: "db", directoryHint: .isDirectory)
        } else {
            originalURL = URL(fileURLWithPath: dbPath, isDirectory: true)
            tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("db", isDirectory: true)
        }

        do {
            try? FileManager.default.removeItem(at: tempURL)
            try FileManager.default.copyItem(at: originalURL, to: tempURL)
            print("Created test db at \(tempURL)")
        } catch {
            XCTFail("Failed to copy the database from bundle.")
        }

        if #available(iOS 16.0, macOS 13.0, *) {
            return tempURL.path()
        } else {
            return tempURL.path
        }
    }
    
    func testOpenDB() {
        let dbPath = prepareTemporaryDB()
        defer {
            print("\n")
        }

        print("\n")
        guard let db01 = LvDB(dbPath: dbPath),
              let iterator01 = db01.makeIterator()
        else {
            XCTFail()
            return
        }
        iterator01.seek("mobevents".data(using: .utf8)!)
        if iterator01.valid(), let v = iterator01.value() {
            XCTAssertEqual(126, v.count)
        } else {
            XCTFail()
        }
        iterator01.destroy()
        db01.close()

        print("")
        guard let db02 = LvDB(dbPath: dbPath),
              let iterator02 = db02.makeIterator()
        else {
            XCTFail()
            return
        }
        iterator02.seek("~local_player".data(using: .utf8)!)
        if iterator02.valid(), let v = iterator02.value() {
            XCTAssertEqual(7323, v.count)
        } else {
            XCTFail()
        }
        iterator02.destroy()
        db02.close()

        print("")
        guard let db03 = LvDB(dbPath: dbPath),
              let iterator03 = db03.makeIterator()
        else {
            XCTFail()
            return
        }
        iterator03.seek("BiomeData".data(using: .utf8)!)
        if iterator03.valid(), let v = iterator03.value() {
            XCTAssertEqual(436, v.count)
        } else {
            XCTFail()
        }
        iterator03.destroy()
        db03.close()
    }
    
    func testSeek() {
        let dbPath = prepareTemporaryDB()
        guard let db = LvDB(dbPath: dbPath),
              let iterator = db.makeIterator()
        else {
            XCTFail()
            return
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

        XCTAssertEqual(firstToLastCount, lastToFirstCount)

        let wellKnownKey = "~local_player".data(using: .utf8)!
        iterator.seek(wellKnownKey)

        guard let key = iterator.key(), let value = iterator.value() else {
            XCTFail()
            return
        }
        let keyStr = String(data: key, encoding: .utf8)
        XCTAssertEqual("~local_player", keyStr ?? "")
        XCTAssertEqual(7323, value.count)
    }

    func testDeleteKeysAndCountAgain() {
        let dbPath = prepareTemporaryDB()
        guard let db = LvDB(dbPath: dbPath),
              let iterator01 = db.makeIterator()
        else {
            XCTFail()
            return
        }

        var count01 = 0
        iterator01.seekToFirst()
        while iterator01.valid() {
            count01 += 1
            iterator01.next()
        }

        db.remove("mobevents".data(using: .utf8)!)
        db.remove("~local_player".data(using: .utf8)!)
        db.remove("BiomeData".data(using: .utf8)!)

        var count02 = 0
        iterator01.seekToFirst()
        while iterator01.valid() {
            count02 += 1
            iterator01.next()
        }

        XCTAssertEqual(count01, count02)

        guard let iterator02 = db.makeIterator() else {
            XCTFail()
            return
        }
        var count03 = 0
        iterator02.seekToFirst()
        while iterator02.valid() {
            count03 += 1
            iterator02.next()
        }

        XCTAssertEqual(count03, count01 - 3)

        iterator01.destroy()
        iterator02.destroy()
        db.close()
    }
}
