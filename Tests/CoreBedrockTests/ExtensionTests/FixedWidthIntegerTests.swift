//
// Created by yechentide on 2024/10/04
//

@testable import CoreBedrock
import Foundation
import Testing

// swiftlint:disable line_length

struct FixedWidthIntegerTests {
    @Test
    func testData() {
        // All data is little endian
        #expect(Int8.min.data == Data([0x80]))
        #expect(Int8(10).data == Data([0x0A]))
        #expect(Int8.max.data == Data([0x7F]))

        #expect(UInt8.min.data == Data([0x00]))
        #expect(UInt8(10).data == Data([0x0A]))
        #expect(UInt8.max.data == Data([0xFF]))

        #expect(Int16.min.data == Data([0x00, 0x80]))
        #expect(Int16(16706).data == Data([0x42, 0x41]))
        #expect(Int16.max.data == Data([0xFF, 0x7F]))

        #expect(UInt16.min.data == Data([0x00, 0x00]))
        #expect(UInt16(16706).data == Data([0x42, 0x41]))
        #expect(UInt16.max.data == Data([0xFF, 0xFF]))

        #expect(Int32.min.data == Data([0x00, 0x00, 0x00, 0x80]))
        #expect(Int32(2_376_002).data == Data([0x42, 0x41, 0x24, 0x00]))
        #expect(Int32.max.data == Data([0xFF, 0xFF, 0xFF, 0x7F]))

        #expect(UInt32.min.data == Data([0x00, 0x00, 0x00, 0x00]))
        #expect(UInt32(2_376_002).data == Data([0x42, 0x41, 0x24, 0x00]))
        #expect(UInt32.max.data == Data([0xFF, 0xFF, 0xFF, 0xFF]))

        #expect(Int64.min.data == Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80]))
        #expect(Int64(1_965_310_274).data == Data([0x42, 0x41, 0x24, 0x75, 0x00, 0x00, 0x00, 0x00]))
        #expect(Int64.max.data == Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F]))

        #expect(UInt64.min.data == Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
        #expect(UInt64(1_965_310_274).data == Data([0x42, 0x41, 0x24, 0x75, 0x00, 0x00, 0x00, 0x00]))
        #expect(UInt64.max.data == Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]))
    }

    @Test
    func testBinaryString() {
        // All data is little endian
        #expect(Int8.min.binaryString == "10000000")
        #expect(Int8(10).binaryString == "00001010")
        #expect(Int8.max.binaryString == "01111111")

        #expect(UInt8.min.binaryString == "00000000")
        #expect(UInt8(10).binaryString == "00001010")
        #expect(UInt8.max.binaryString == "11111111")

        #expect(Int16.min.binaryString == "00000000_10000000")
        #expect(Int16(16706).binaryString == "01000010_01000001")
        #expect(Int16.max.binaryString == "11111111_01111111")

        #expect(UInt16.min.binaryString == "00000000_00000000")
        #expect(UInt16(16706).binaryString == "01000010_01000001")
        #expect(UInt16.max.binaryString == "11111111_11111111")

        #expect(Int32.min.binaryString == "00000000_00000000_00000000_10000000")
        #expect(Int32(2_376_002).binaryString == "01000010_01000001_00100100_00000000")
        #expect(Int32.max.binaryString == "11111111_11111111_11111111_01111111")

        #expect(UInt32.min.binaryString == "00000000_00000000_00000000_00000000")
        #expect(UInt32(2_376_002).binaryString == "01000010_01000001_00100100_00000000")
        #expect(UInt32.max.binaryString == "11111111_11111111_11111111_11111111")

        #expect(Int64.min.binaryString == "00000000_00000000_00000000_00000000_00000000_00000000_00000000_10000000")
        #expect(Int64(1_965_310_274).binaryString == "01000010_01000001_00100100_01110101_00000000_00000000_00000000_00000000")
        #expect(Int64.max.binaryString == "11111111_11111111_11111111_11111111_11111111_11111111_11111111_01111111")

        #expect(UInt64.min.binaryString == "00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000")
        #expect(UInt64(1_965_310_274).binaryString == "01000010_01000001_00100100_01110101_00000000_00000000_00000000_00000000")
        #expect(UInt64.max.binaryString == "11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111")
    }

    @Test
    func bitOnOff() {
        // Little Endian: 0b01000010_01000001
        var num = Int16(16706)

        // Little Endian: 0b01000011_01000001
        num.bitOn(offset: 0)
        #expect(num == 16707)

        // Little Endian: 0b01000001_01000001
        num.bitOff(offset: 1)
        #expect(num == 16705)

        // Little Endian: 0b01000101_01000001
        num.bitOn(offset: 2)
        #expect(num == 16709)

        // Little Endian: 0b01001101_01000001
        num.bitOn(offset: 3)
        #expect(num == 16717)

        // Little Endian: 0b01011101_01000001
        num.bitOn(offset: 4)
        #expect(num == 16733)

        // Little Endian: 0b01111101_01000001
        num.bitOn(offset: 5)
        #expect(num == 16765)

        // Little Endian: 0b00111101_01000001
        num.bitOff(offset: 6)
        #expect(num == 16701)

        // Little Endian: 0b10111101_01000001
        num.bitOn(offset: 7)
        #expect(num == 16829)

        // Little Endian: 0b10111101_01000000
        num.bitOff(offset: 8)
        #expect(num == 16573)
    }

    @Test
    func testIsBitOn() {
        // Little Endian: 0b01000010_01000001
        let num = Int16(16706)
        let ans = [0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]

        for i in 0..<num.bitWidth {
            let a = num.isBitOn(offset: UInt8(i))
            let b = ans[i] == 1
            #expect(a == b)
        }
    }

    @Test
    func testBitArray() {
        // Little Endian: 0b01000010_01000001
        let num = Int16(16706)
        let ans: [UInt8] = [0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]
        #expect(num.bitArray == ans)
    }
}

// swiftlint:enable line_length
