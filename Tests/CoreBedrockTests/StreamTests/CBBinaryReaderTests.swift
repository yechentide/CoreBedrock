//
// Created by yechentide on 2025/05/31
//

@testable import CoreBedrock
import Foundation
import Testing

struct CBBinaryReaderTests {
    @Test
    func initialization() throws {
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04]

        var reader = CBBinaryReader(bytes: bytes)
        #expect(reader.remainingByteCount == 4)
        _ = try reader.readUInt8()
        #expect(reader.remainingByteCount == 3)

        reader = CBBinaryReader(buffer: CBBuffer(data: Data(bytes)))
        #expect(reader.remainingByteCount == 4)
        _ = try reader.readUInt8()
        #expect(reader.remainingByteCount == 3)

        reader = CBBinaryReader(bytes: bytes)
        #expect(reader.remainingByteCount == 4)
    }

    @Test
    func skipBytes() throws {
        let data: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05]
        let reader = CBBinaryReader(bytes: data)

        try reader.skip(2)
        #expect(reader.remainingByteCount == 3)
        #expect(try reader.readUInt8() == 0x03)

        try reader.skip(0) // Skipping zero bytes should be a no-op
        #expect(reader.remainingByteCount == 2)

        // Test skipping beyond end of stream
        #expect(throws: CBStreamError.outOfBounds.self) {
            try reader.skip(5)
        }
        #expect(reader.remainingByteCount == 2) // Position should be at the end

        // Test skipping negative count
        let reader2 = CBBinaryReader(bytes: data)
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Non-negative number required.").self) {
            try reader2.skip(-1)
        }
    }

    @Test
    func testReadBytes() throws {
        let data: [UInt8] = [0xDE, 0xAD, 0xBE, 0xEF, 0xCA, 0xFE]
        let reader = CBBinaryReader(bytes: data)

        let read1 = try reader.readBytes(2)
        #expect(read1 == [0xDE, 0xAD])
        #expect(reader.remainingByteCount == 4)

        let read2 = try reader.readBytes(0) // Reading zero bytes
        #expect(read2 == [])
        #expect(reader.remainingByteCount == 4)

        let read3 = try reader.readBytes(4)
        #expect(read3 == [0xBE, 0xEF, 0xCA, 0xFE])
        #expect(reader.remainingByteCount == 0)

        // Test reading beyond end of stream
        #expect(throws: CBStreamError.endOfStream.self) {
            _ = try reader.readBytes(1)
        }

        // Test reading negative count
        let reader2 = CBBinaryReader(bytes: data)
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Non-negative number required.")) {
            _ = try reader2.readBytes(-1)
        }
    }

    @Test
    func testReadAllBytes() throws {
        let data: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        let reader = CBBinaryReader(bytes: data)
        let allBytes = try reader.readAllBytes()
        #expect(allBytes == data)
        #expect(reader.remainingByteCount == 0)

        let emptyReader = CBBinaryReader(bytes: [])
        let noBytes = try emptyReader.readAllBytes()
        #expect(noBytes == [])
        #expect(emptyReader.remainingByteCount == 0)
    }

    @Test
    func readIntegersLittleEndian() throws {
        // UInt8
        var reader = CBBinaryReader(bytes: [0xFA])
        #expect(try reader.readUInt8() == 0xFA)

        // Int8
        reader = CBBinaryReader(bytes: [0x8F]) // -113
        #expect(try reader.readInt8() == -113)

        // UInt16
        reader = CBBinaryReader(bytes: [0x34, 0x12]) // 0x1234
        #expect(try reader.readUInt16() == 0x1234)

        // Int16
        reader = CBBinaryReader(bytes: [0xCD, 0xAB]) // 0xABCD -> -21555
        #expect(try reader.readInt16() == -21555)

        // UInt32
        reader = CBBinaryReader(bytes: [0x78, 0x56, 0x34, 0x12]) // 0x12345678
        #expect(try reader.readUInt32() == 0x1234_5678)

        // Int32
        reader = CBBinaryReader(bytes: [0xEF, 0xCD, 0xAB, 0x89]) // 0x89ABCDEF -> -1985229329
        #expect(try reader.readInt32() == -1_985_229_329)

        // UInt64
        reader = CBBinaryReader(bytes: [0xBC, 0x9A, 0x78, 0x56, 0x34, 0x12, 0xF0, 0xDE]) // 0xDEF0123456789ABC
        #expect(try reader.readUInt64() == 0xDEF0_1234_5678_9ABC)

        // Int64
        reader = CBBinaryReader(bytes: [0x45, 0x23, 0x01, 0xEF, 0xCD, 0xAB, 0x89, 0xF7]) // 0xF789ABCDEF012345
        #expect(try reader.readInt64() == Int64(bitPattern: 0xF789_ABCD_EF01_2345))
    }

    @Test
    func readIntegersBigEndian() throws {
        // UInt16
        var reader = CBBinaryReader(bytes: [0x12, 0x34], littleEndian: false) // 0x1234
        #expect(try reader.readUInt16() == 0x1234)

        // Int16
        reader = CBBinaryReader(bytes: [0xAB, 0xCD], littleEndian: false) // 0xABCD -> -21555
        #expect(try reader.readInt16() == -21555)

        // UInt32
        reader = CBBinaryReader(bytes: [0x12, 0x34, 0x56, 0x78], littleEndian: false) // 0x12345678
        #expect(try reader.readUInt32() == 0x1234_5678)

        // Int32
        reader = CBBinaryReader(bytes: [0x89, 0xAB, 0xCD, 0xEF], littleEndian: false) // 0x89ABCDEF -> -1985229329
        #expect(try reader.readInt32() == -1_985_229_329)

        // UInt64
        reader = CBBinaryReader(
            bytes: [0xDE, 0xF0, 0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC], // 0xDEF0123456789ABC
            littleEndian: false
        )
        #expect(try reader.readUInt64() == 0xDEF0_1234_5678_9ABC)

        // Int64
        reader = CBBinaryReader(
            bytes: [0xF7, 0x89, 0xAB, 0xCD, 0xEF, 0x01, 0x23, 0x45], // 0xF789ABCDEF012345
            littleEndian: false
        )
        #expect(try reader.readInt64() == Int64(bitPattern: 0xF789_ABCD_EF01_2345))
    }

    @Test
    func readFloatsLittleEndian() throws {
        // Float (3.1415927)
        // Bytes for 3.1415927f in little-endian: 0xDB 0x0F 0x49 0x40
        let floatData: [UInt8] = [0xDB, 0x0F, 0x49, 0x40]
        var reader = CBBinaryReader(bytes: floatData)
        #expect(try reader.readFloat() == Float(3.1415927))

        // Double (3.215000000007247)
        // Bytes for 3.215000000007247 in little-endian: 0x77, 0x5E, 0x85, 0xEB, 0x51, 0xB8, 0x09, 0x40
        let doubleData: [UInt8] = [0x77, 0x5E, 0x85, 0xEB, 0x51, 0xB8, 0x09, 0x40]
        reader = CBBinaryReader(bytes: doubleData)
        #expect(try reader.readDouble() == Double(3.215000000007247))
    }

    @Test
    func readFloatsBigEndian() throws {
        // Float (3.1415927)
        // Bytes for 3.1415927f in big-endian: 0x40 0x49 0x0F 0xDB
        let floatData: [UInt8] = [0x40, 0x49, 0x0F, 0xDB]
        var reader = CBBinaryReader(bytes: floatData, littleEndian: false)
        #expect(try reader.readFloat() == Float(3.1415927))

        // Double (3.215000000007247)
        // Bytes for 3.215000000007247 in big-endian: 0x40, 0x09, 0xB8, 0x51, 0xEB, 0x85, 0x5E, 0x77
        let doubleData: [UInt8] = [0x40, 0x09, 0xB8, 0x51, 0xEB, 0x85, 0x5E, 0x77]
        reader = CBBinaryReader(bytes: doubleData, littleEndian: false)
        #expect(try reader.readDouble() == Double(3.215000000007247))
    }

    @Test
    func testReadNBTString() throws {
        // "Hello" in UTF-8: [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        // Length (UInt16 Little Endian): 0x05, 0x00
        let helloData: [UInt8] = [0x05, 0x00, 0x48, 0x65, 0x6C, 0x6C, 0x6F]
        var reader = CBBinaryReader(bytes: helloData)
        #expect(try reader.readNBTString() == "Hello")
        #expect(reader.remainingByteCount == 0)

        // Empty string
        let emptyStringData: [UInt8] = [0x00, 0x00]
        reader = CBBinaryReader(bytes: emptyStringData)
        #expect(try reader.readNBTString() == "")
        #expect(reader.remainingByteCount == 0)

        // String with non-UTF8 (ISO Latin 1 as fallback) "Mötorhead"
        // "Mötorhead" in ISO Latin 1: [0x4D, 0xF6, 0x74, 0x6F, 0x72, 0x68, 0x65, 0x61, 0x64]
        // Length (9): 0x09, 0x00
        let latin1Data: [UInt8] = [0x09, 0x00, 0x4D, 0xF6, 0x74, 0x6F, 0x72, 0x68, 0x65, 0x61, 0x64]
        reader = CBBinaryReader(bytes: latin1Data)
        #expect(try reader.readNBTString() == "Mötorhead")
        #expect(reader.remainingByteCount == 0)

        // Insufficient data for string length
        let shortData: [UInt8] = [0x05, 0x00, 0x48, 0x65] // Length 5, but only 2 bytes of string
        reader = CBBinaryReader(bytes: shortData)
        do {
            _ = try reader.readNBTString()
            Issue.record("Should have thrown endOfStream error")
        } catch CBStreamError.endOfStream {
            // Expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func testSkipNBTString() throws {
        // Length (UInt16 LE): 0x05, 0x00, String: "Hello"
        let data: [UInt8] = [0x05, 0x00, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0xAA, 0xBB]
        let reader = CBBinaryReader(bytes: data)
        try reader.skipNBTString()
        #expect(reader.remainingByteCount == 2) // AA, BB should remain
        #expect(try reader.readBytes(2) == [0xAA, 0xBB])

        // Skip empty string
        let emptyData: [UInt8] = [0x00, 0x00, 0xCC]
        let reader2 = CBBinaryReader(bytes: emptyData)
        try reader2.skipNBTString()
        #expect(reader2.remainingByteCount == 1)
        #expect(try reader2.readUInt8() == 0xCC)

        // Insufficient data for string length
        let shortData: [UInt8] = [0x05, 0x00, 0x48, 0x65]
        let reader3 = CBBinaryReader(bytes: shortData)
        #expect(throws: CBStreamError.outOfBounds.self) {
            try reader3.skipNBTString()
        }

        // Negative length
        let negativeLengthData: [UInt8] = [0xFF, 0xFF] // -1 as Int16
        let reader4 = CBBinaryReader(bytes: negativeLengthData)
        #expect(throws: CBStreamError.invalidFormat("Negative string length given!").self) {
            try reader4.skipNBTString()
        }
    }

    @Test
    func testReadTagType() throws {
        // Valid TagType (e.g., TAG_Int = 3)
        var reader = CBBinaryReader(bytes: [0x03])
        #expect(try reader.readTagType() == .int)

        // Valid TagType (TAG_Long_Array = 12)
        reader = CBBinaryReader(bytes: [0x0C])
        #expect(try reader.readTagType() == .longArray)

        // Invalid TagType (out of range, e.g., 13)
        reader = CBBinaryReader(bytes: [0x0D])
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 13").self) {
            _ = try reader.readTagType()
        }

        // End of stream when reading TagType
        reader = CBBinaryReader(bytes: [])
        #expect(throws: CBStreamError.endOfStream.self) {
            _ = try reader.readTagType()
        }
    }
}
