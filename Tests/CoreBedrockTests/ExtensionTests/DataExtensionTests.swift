//
// Created by yechentide on 2024/06/02
//

import XCTest
@testable import CoreBedrock

final class DataExtensionTests: XCTestCase {
    func testHexString() {
        let testCases: [Data:String] = [
            Data([0x00])                : "00",
            Data([0x00, 0x1C])          : "00_1C",
            Data([0xFF])                : "FF",
            Data([0x00, 0xFF, 0xCC])    : "00_FF_CC",
        ]
        for (key, value) in testCases {
            XCTAssertEqual(key.hexString, value)
        }
    }
    
    func testUInt8() {
        let testCases: [Data:UInt8] = [
            Data([0x00])                : UInt8.min,
            Data([0xFF])                : UInt8.max,
            Data([0x00, 0xCC])          : UInt8.min,
            Data([0xFF, 0xCC])          : UInt8.max,
        ]
        for (key, value) in testCases {
            XCTAssertEqual(key.uint8, value)
        }
    }
    
    func testInt8() {
        let testCases: [Data:Int8] = [
            Data([0x80])                : Int8.min,
            Data([0xFF])                : -1,
            Data([0x7F])                : Int8.max,
        ]
        for (key, value) in testCases {
            XCTAssertEqual(key.int8, value)
        }
    }

    func testUInt32() {
        let testCases: [Data:UInt32?] = [
            Data([0x00, 0x00, 0x00, 0x00])  : UInt32.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF])  : UInt32.max,
            Data([0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            XCTAssertEqual(key.uint32 ?? nil, value ?? nil)
        }
    }
    
    func testInt32() {
        let testCases: [Data:Int32?] = [
            Data([0x00, 0x00, 0x00, 0x80])  : Int32.min,
            Data([0xFF, 0xFF, 0xFF, 0xFF])  : -1,
            Data([0xFF, 0xFF, 0xFF, 0x7F])  : Int32.max,
            Data([0xFF, 0xFF, 0xFF])        : nil,
        ]
        for (key, value) in testCases {
            XCTAssertEqual(key.int32 ?? nil, value ?? nil)
        }
    }
}
