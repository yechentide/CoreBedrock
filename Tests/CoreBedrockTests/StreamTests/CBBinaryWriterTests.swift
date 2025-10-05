//
// Created by yechentide on 2025/05/31
//

@testable import CoreBedrock
import Foundation
import Testing

struct CBBinaryWriterTests {
    @Test
    func initialization() throws {
        var writer = CBBinaryWriter() // Default littleEndian = true
        #expect(writer.isEmpty)
        #expect(writer.currentPosition == 0)
        #expect(writer.data.isEmpty)

        writer = CBBinaryWriter(littleEndian: false)
        #expect(writer.isEmpty)

        let initialBuffer = CBBuffer(capacity: 100)
        writer = CBBinaryWriter(buffer: initialBuffer, littleEndian: true)
        #expect(writer.count == 100) // CBBuffer capacity, but writer.count is current content
        #expect(writer.currentPosition == 0) // Position is 0 as nothing written yet

        writer = CBBinaryWriter(capacity: 50, littleEndian: true)
        #expect(writer.count == 50)
        #expect(writer.data == Data([UInt8](repeating: 0, count: 50)))
    }

    @Test
    func writeUInt8() throws {
        let writer = CBBinaryWriter()
        let value: UInt8 = 0xAB
        try writer.write(value)
        #expect(writer.count == 1)
        #expect(writer.currentPosition == 1)
        #expect(writer.toByteArray() == [0xAB])
        #expect(writer.data == Data([0xAB]))
    }

    @Test
    func writeBytesArray() throws {
        let writer = CBBinaryWriter()
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        try writer.write(bytes)
        #expect(writer.count == 4)
        #expect(writer.currentPosition == 4)
        #expect(writer.toByteArray() == bytes)
    }

    @Test
    func writeFixedWidthIntegerLittleEndian() throws {
        let writer = CBBinaryWriter(littleEndian: true)

        let int16Val: Int16 = 0x1234 // Expected: 0x34, 0x12
        try writer.write(int16Val)
        #expect(writer.toByteArray() == [0x34, 0x12])

        let uint32Val: UInt32 = 0xABCD_EF01 // Expected: 0x01, 0xEF, 0xCD, 0xAB
        try writer.write(uint32Val)
        #expect(writer.toByteArray() == [0x34, 0x12, 0x01, 0xEF, 0xCD, 0xAB])

        let int64Val = Int64(bitPattern: 0xFEDC_BA98_7654_3210) // Expected: 0x10, 0x32...
        try writer.write(int64Val)
        #expect(writer.toByteArray().suffix(8) == [0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE])
    }

    @Test
    func writeFixedWidthIntegerBigEndian() throws {
        let writer = CBBinaryWriter(littleEndian: false)

        let int16Val: Int16 = 0x1234 // Expected: 0x12, 0x34
        try writer.write(int16Val)
        #expect(writer.toByteArray() == [0x12, 0x34])

        let uint32Val: UInt32 = 0xABCD_EF01 // Expected: 0xAB, 0xCD, 0xEF, 0x01
        try writer.write(uint32Val)
        #expect(writer.toByteArray() == [0x12, 0x34, 0xAB, 0xCD, 0xEF, 0x01])

        let int64Val = Int64(bitPattern: 0xFEDC_BA98_7654_3210) // Expected: 0xFE, 0xDC...
        try writer.write(int64Val)
        #expect(writer.toByteArray().suffix(8) == [0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10])
    }

    @Test
    func writeFloatLittleEndian() throws {
        let writer = CBBinaryWriter(littleEndian: true)
        let value: Float = 3.1415927
        try writer.write(value)
        #expect(writer.toByteArray() == [0xDB, 0x0F, 0x49, 0x40])
    }

    @Test
    func writeFloatBigEndian() throws {
        let writer = CBBinaryWriter(littleEndian: false)
        let value: Float = 3.1415927
        try writer.write(value)
        #expect(writer.toByteArray() == [0x40, 0x49, 0x0F, 0xDB])
    }

    @Test
    func writeDoubleLittleEndian() throws {
        let writer = CBBinaryWriter(littleEndian: true)
        let value = 3.215000000007247
        try writer.write(value)
        #expect(writer.toByteArray() == [0x77, 0x5E, 0x85, 0xEB, 0x51, 0xB8, 0x09, 0x40])
    }

    @Test
    func writeDoubleBigEndian() throws {
        let writer = CBBinaryWriter(littleEndian: false)
        let value = 3.215000000007247
        try writer.write(value)
        #expect(writer.toByteArray() == [0x40, 0x09, 0xB8, 0x51, 0xEB, 0x85, 0x5E, 0x77])
    }

    @Test
    func writeNBTStringLittleEndian() throws {
        let writer = CBBinaryWriter(littleEndian: true)
        let str = "Hello"
        try writer.writeNBTString(str)
        let expectedBytes: [UInt8] = [0x05, 0x00, 0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(writer.toByteArray() == expectedBytes)
        #expect(writer.currentPosition == expectedBytes.count)

        let writer2 = CBBinaryWriter(littleEndian: true)
        try writer2.writeNBTString("")
        #expect(writer2.toByteArray() == [0x00, 0x00])
    }

    @Test
    func writeNBTStringBigEndian() throws {
        let writer = CBBinaryWriter(littleEndian: false)
        let str = "Test"
        try writer.writeNBTString(str)
        let expectedBytes: [UInt8] = [0x00, 0x04, 0x54, 0x65, 0x73, 0x74]
        #expect(writer.toByteArray() == expectedBytes)
    }

    @Test
    func writeNBTStringTooLong() throws {
        let writer = CBBinaryWriter()
        let longString = String(repeating: "a", count: Int(UInt16.max) + 1)
        #expect(throws: CBStreamError.argumentOutOfRange("value", "String too long").self) {
            try writer.writeNBTString(longString)
        }
    }

    @Test
    func properties() throws {
        let writer = CBBinaryWriter() // Default little endian
        #expect(writer.isEmpty)
        #expect(writer.currentPosition == 0)
        #expect(writer.data.isEmpty)
        #expect(writer.toByteArray().isEmpty)

        // Test with a writer explicitly set to little endian for integer writing
        let writerLE = CBBinaryWriter(littleEndian: true)
        try writerLE.write(UInt8(0xAA))
        #expect(writerLE.count == 1)
        #expect(writerLE.currentPosition == 1)
        #expect(writerLE.data == Data([0xAA]))
        #expect(writerLE.toByteArray() == [0xAA])

        try writerLE.write(Int16(bitPattern: 0xBBCC)) // Writes 0xCC, 0xBB due to littleEndian=true
        #expect(writerLE.count == 1 + 2)
        #expect(writerLE.currentPosition == 1 + 2)
        #expect(writerLE.data == Data([0xAA, 0xCC, 0xBB]))
        #expect(writerLE.toByteArray() == [0xAA, 0xCC, 0xBB])

        // Test with default writer (little endian) for byte array
        let writerDefault = CBBinaryWriter() // Default is littleEndian = true
        try writerDefault.write(UInt8(0x11))
        try writerDefault.write([0xDD, 0xEE]) // Appends to the 0x11
        #expect(writerDefault.count == 1 + 2)
        #expect(writerDefault.currentPosition == 1 + 2)
        #expect(writerDefault.data == Data([0x11, 0xDD, 0xEE]))
        #expect(writerDefault.toByteArray() == [0x11, 0xDD, 0xEE])
    }
}
