//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct EnumerateTests {
    @Test
    func testInvalidDataLength() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }
        
        let lvdb = try LvDB(dbPath: dbPath, createIfMissing: true)
        let data = Data([0x01, 0x02, 0x03])  // 3 bytes
        var called = false
        
        let result = lvdb.enumerateActorKeys(digpData: data) { _, _ in
            called = true
        }
        
        #expect(!result)
        #expect(!called)
    }
    
    @Test
    func testValidData() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }
        
        let lvdb = try LvDB(dbPath: dbPath, createIfMissing: true)
        // Two actor IDs (16 bytes)
        let data = Data([
            0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
            0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18
        ])
        
        var indices: [Int] = []
        var ids: [Data] = []
        
        let result = lvdb.enumerateActorKeys(digpData: data) { index, id in
            indices.append(index)
            ids.append(id)
        }
        
        #expect(result)
        #expect(indices == [0, 1])
        #expect(ids.count == 2)
        #expect(ids[0].count == 8)
        #expect(ids[1].count == 8)
        #expect(ids[0] == Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(ids[1] == Data([0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18]))
    }
    
    @Test
    func testEmptyData() async throws {
        let dbPath = FileManager.default.temporaryDirectory.appendingPathComponent("test_lvdb_\(UUID().uuidString)").path
        defer { try? FileManager.default.removeItem(atPath: dbPath) }
        
        let lvdb = try LvDB(dbPath: dbPath, createIfMissing: true)
        let data = Data()
        var called = false
        
        let result = lvdb.enumerateActorKeys(digpData: data) { _, _ in
            called = true
        }
        
        #expect(result)
        #expect(!called)
    }
}
