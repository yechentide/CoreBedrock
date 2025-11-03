//
// Created by yechentide on 2024/10/04
//

@testable import CoreBedrock
import Foundation
import Testing

// swiftlint:disable colon
// swiftformat:disable consecutiveSpaces spaceAroundOperators

struct DataTests {
    @Test
    func testHexString() {
        let testCases: [Data:String] = [
            Data([0x00])                : "00",
            Data([0x00, 0x1C])          : "00_1C",
            Data([0xFF])                : "FF",
            Data([0x00, 0xFF, 0xCC])    : "00_FF_CC",
        ]
        for (key, value) in testCases {
            #expect(key.hexString == value)
        }
    }

    @Test
    func uInt8() {
        let testCases: [Data:UInt8] = [
            Data([0x00])                : UInt8.min,
            Data([0xFF])                : UInt8.max,
            Data([0x00, 0xCC])          : UInt8.min,
            Data([0xFF, 0xCC])          : UInt8.max,
        ]
        for (key, value) in testCases {
            #expect(key.uint8 == value)
        }
    }

    @Test
    func testInt8() {
        let testCases: [Data:Int8] = [
            Data([0x80])                : Int8.min,
            Data([0xFF])                : -1,
            Data([0x7F])                : Int8.max,
        ]
        for (key, value) in testCases {
            #expect(key.int8 == value)
        }
    }

    @Test
    func uInt16() {
        let testCases: [Data:UInt16] = [
            Data([0x00, 0x00])          : UInt16.min,
            Data([0xFF, 0xFF])          : UInt16.max,
            Data([0x34, 0x12])          : 0x1234, // little endian
        ]
        for (key, value) in testCases {
            #expect(key.uint16 == value)
        }
    }

    @Test
    func testInt16() {
        let testCases: [Data:Int16] = [
            Data([0x00, 0x80])          : Int16.min,
            Data([0xFF, 0xFF])          : -1,
            Data([0xFF, 0x7F])          : Int16.max,
        ]
        for (key, value) in testCases {
            #expect(key.int16 == value)
        }
    }

    @Test
    func uInt32() {
        let testCases: [Data:UInt32?] = [
            Data([0x00, 0x00, 0x00, 0x00])  : UInt32.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF])  : UInt32.max,
            Data([0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            #expect(key.uint32 ?? nil == value ?? nil)
        }
    }

    @Test
    func testInt32() {
        let testCases: [Data:Int32?] = [
            Data([0x00, 0x00, 0x00, 0x80])  : Int32.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF])  : -1,
            Data([0xFF, 0xFF, 0xFF, 0x7F])  : Int32.max,
            Data([0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            #expect(key.int32 ?? nil == value ?? nil)
        }
    }

    @Test
    func uInt64() {
        let testCases: [Data:UInt64?] = [
            Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])  : UInt64.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])  : UInt64.max,
            Data([0x78, 0x56, 0x34, 0x12, 0x78, 0x56, 0x34, 0x12])  : 0x1234_5678_1234_5678, // little endian
            Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            #expect(key.uint64 ?? nil == value ?? nil)
        }
    }

    @Test
    func testInt64() {
        let testCases: [Data:Int64?] = [
            Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80])  : Int64.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])  : -1,
            Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F])  : Int64.max,
            Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            #expect(key.int64 ?? nil == value ?? nil)
        }
    }

    // MARK: - Misaligned Access Tests

    @Test
    func uInt16Misaligned() {
        // Create data with 1-byte offset to test misaligned access
        let data = Data([0xFF, 0x34, 0x12, 0xFF])
        let slice = data[1..<3]
        #expect(slice.uint16 == 0x1234)
    }

    @Test
    func int16Misaligned() {
        let data = Data([0xFF, 0x00, 0x80, 0xFF])
        let slice = data[1..<3]
        #expect(slice.int16 == Int16.min)
    }

    @Test
    func uInt32Misaligned() {
        // Test with various offsets
        let data = Data([0xFF, 0xFF, 0xFF, 0x78, 0x56, 0x34, 0x12, 0xFF])
        let slice = data[3..<7]
        #expect(slice.uint32 == 0x1234_5678)
    }

    @Test
    func int32Misaligned() {
        let data = Data([0xFF, 0x00, 0x00, 0x00, 0x80, 0xFF])
        let slice = data[1..<5]
        #expect(slice.int32 == Int32.min)
    }

    @Test
    func uInt64Misaligned() {
        // Test with odd offset (not aligned to 8 bytes)
        let data = Data([0xFF, 0xFF, 0xFF, 0x78, 0x56, 0x34, 0x12, 0x78, 0x56, 0x34, 0x12, 0xFF])
        let slice = data[3..<11]
        #expect(slice.uint64 == 0x1234_5678_1234_5678)
    }

    @Test
    func int64Misaligned() {
        // Test with various non-8-byte-aligned offsets
        let data = Data([0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xFF])
        let slice = data[1..<9]
        #expect(slice.int64 == Int64.min)
    }

    @Test
    func multipleMisalignedReads() {
        // Simulate real-world scenario: reading from LvDB key with string prefix
        let prefix = "map_"
        let prefixData = Data(prefix.utf8)
        let int64Data = Data([0x39, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        let fullData = prefixData + int64Data

        // This simulates what happens in LvDBKey.parseMapKey
        let slice = fullData[prefixData.count...]
        #expect(slice.int64 == 12345)
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
// swiftlint:enable colon
