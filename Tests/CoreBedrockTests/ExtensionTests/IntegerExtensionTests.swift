//
// Created by yechentide on 2024/06/02
//

import XCTest
@testable import CoreBedrock

final class IntegerExtensionTests: XCTestCase {
    func testData() {
        // All data is little endian
        XCTAssertEqual(Int8.min.data,           Data([0x80]))
        XCTAssertEqual(Int8(10).data,           Data([0x0A]))
        XCTAssertEqual(Int8.max.data,           Data([0x7F]))
        
        XCTAssertEqual(UInt8.min.data,          Data([0x00]))
        XCTAssertEqual(UInt8(10).data,          Data([0x0A]))
        XCTAssertEqual(UInt8.max.data,          Data([0xFF]))
        
        XCTAssertEqual(Int16.min.data,          Data([0x00, 0x80]))
        XCTAssertEqual(Int16(16706).data,       Data([0x42, 0x41]))
        XCTAssertEqual(Int16.max.data,          Data([0xFF, 0x7F]))
        
        XCTAssertEqual(UInt16.min.data,         Data([0x00, 0x00]))
        XCTAssertEqual(UInt16(16706).data,      Data([0x42, 0x41]))
        XCTAssertEqual(UInt16.max.data,         Data([0xFF, 0xFF]))
        
        XCTAssertEqual(Int32.min.data,          Data([0x00, 0x00, 0x00, 0x80]))
        XCTAssertEqual(Int32(2376002).data,     Data([0x42, 0x41, 0x24, 0x00]))
        XCTAssertEqual(Int32.max.data,          Data([0xFF, 0xFF, 0xFF, 0x7F]))
        
        XCTAssertEqual(UInt32.min.data,         Data([0x00, 0x00, 0x00, 0x00]))
        XCTAssertEqual(UInt32(2376002).data,    Data([0x42, 0x41, 0x24, 0x00]))
        XCTAssertEqual(UInt32.max.data,         Data([0xFF, 0xFF, 0xFF, 0xFF]))

        XCTAssertEqual(Int64.min.data,          Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80]))
        XCTAssertEqual(Int64(1965310274).data,  Data([0x42, 0x41, 0x24, 0x75, 0x00, 0x00, 0x00, 0x00]))
        XCTAssertEqual(Int64.max.data,          Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F]))
        
        XCTAssertEqual(UInt64.min.data,         Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
        XCTAssertEqual(UInt64(1965310274).data, Data([0x42, 0x41, 0x24, 0x75, 0x00, 0x00, 0x00, 0x00]))
        XCTAssertEqual(UInt64.max.data,         Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]))
    }
    
    func testBinaryString() {
        // All data is little endian
        XCTAssertEqual(Int8.min.binaryString,           "10000000")
        XCTAssertEqual(Int8(10).binaryString,           "00001010")
        XCTAssertEqual(Int8.max.binaryString,           "01111111")
        
        XCTAssertEqual(UInt8.min.binaryString,          "00000000")
        XCTAssertEqual(UInt8(10).binaryString,          "00001010")
        XCTAssertEqual(UInt8.max.binaryString,          "11111111")

        XCTAssertEqual(Int16.min.binaryString,          "00000000_10000000")
        XCTAssertEqual(Int16(16706).binaryString,       "01000010_01000001")
        XCTAssertEqual(Int16.max.binaryString,          "11111111_01111111")

        XCTAssertEqual(UInt16.min.binaryString,         "00000000_00000000")
        XCTAssertEqual(UInt16(16706).binaryString,      "01000010_01000001")
        XCTAssertEqual(UInt16.max.binaryString,         "11111111_11111111")

        XCTAssertEqual(Int32.min.binaryString,          "00000000_00000000_00000000_10000000")
        XCTAssertEqual(Int32(2376002).binaryString,     "01000010_01000001_00100100_00000000")
        XCTAssertEqual(Int32.max.binaryString,          "11111111_11111111_11111111_01111111")

        XCTAssertEqual(UInt32.min.binaryString,         "00000000_00000000_00000000_00000000")
        XCTAssertEqual(UInt32(2376002).binaryString,    "01000010_01000001_00100100_00000000")
        XCTAssertEqual(UInt32.max.binaryString,         "11111111_11111111_11111111_11111111")

        XCTAssertEqual(Int64.min.binaryString,          "00000000_00000000_00000000_00000000_00000000_00000000_00000000_10000000")
        XCTAssertEqual(Int64(1965310274).binaryString,  "01000010_01000001_00100100_01110101_00000000_00000000_00000000_00000000")
        XCTAssertEqual(Int64.max.binaryString,          "11111111_11111111_11111111_11111111_11111111_11111111_11111111_01111111")

        XCTAssertEqual(UInt64.min.binaryString,         "00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000")
        XCTAssertEqual(UInt64(1965310274).binaryString, "01000010_01000001_00100100_01110101_00000000_00000000_00000000_00000000")
        XCTAssertEqual(UInt64.max.binaryString,         "11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111")
    }
    
    func testBitOnOff() {
        // Little Endian: 0b01000010_01000001
        var num = Int16(16706)
        
        // Little Endian: 0b01000011_01000001
        num.bitOn(offset: 0)
        XCTAssertEqual(num, 16707)
        
        // Little Endian: 0b01000001_01000001
        num.bitOff(offset: 1)
        XCTAssertEqual(num, 16705)
        
        // Little Endian: 0b01000101_01000001
        num.bitOn(offset: 2)
        XCTAssertEqual(num, 16709)

        // Little Endian: 0b01001101_01000001
        num.bitOn(offset: 3)
        XCTAssertEqual(num, 16717)

        // Little Endian: 0b01011101_01000001
        num.bitOn(offset: 4)
        XCTAssertEqual(num, 16733)

        // Little Endian: 0b01111101_01000001
        num.bitOn(offset: 5)
        XCTAssertEqual(num, 16765)

        // Little Endian: 0b00111101_01000001
        num.bitOff(offset: 6)
        XCTAssertEqual(num, 16701)

        // Little Endian: 0b10111101_01000001
        num.bitOn(offset: 7)
        XCTAssertEqual(num, 16829)

        // Little Endian: 0b10111101_01000000
        num.bitOff(offset: 8)
        XCTAssertEqual(num, 16573)
    }
    
    func testIsBitOn() {
        // Little Endian: 0b01000010_01000001
        let num = Int16(16706)
        let ans = [0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]
        
        for i in 0..<num.bitWidth {
            XCTAssertEqual(num.isBitOn(offset: UInt8(i)), ans[i] == 1)
        }
    }
    
    func testBitArray() {
        // Little Endian: 0b01000010_01000001
        let num = Int16(16706)
        let ans: [UInt8] = [0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]
        XCTAssertEqual(num.bitArray, ans)
    }
}
