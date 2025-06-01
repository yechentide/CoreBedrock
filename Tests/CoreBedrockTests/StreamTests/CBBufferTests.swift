//
// Created by yechentide on 2025/05/31
//

import Testing
import Foundation
@testable import CoreBedrock

struct CBBufferTests {
    @Test
    func testInitializationWithCapacity() throws {
        let buffer = CBBuffer(capacity: 10)
        #expect(buffer.count == 10)
        #expect(buffer.currentPosition == 0)
    }

    @Test
    func testInitializationWithData() throws {
        let data = Data([0x01, 0x02, 0x03])
        let buffer = CBBuffer(data: data)
        #expect(buffer.count == 3)
        #expect(buffer.currentPosition == 0)
        #expect(buffer.toArray() == [0x01, 0x02, 0x03])
    }

    @Test
    func testInitializationWithBytes() throws {
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let buffer = CBBuffer(bytes: bytes)
        #expect(buffer.count == 3)
        #expect(buffer.currentPosition == 0)
        #expect(buffer.toArray() == bytes)
    }

    @Test
    func testWriteAndReadBytes() throws {
        let buffer = CBBuffer()
        let bytesToWrite: [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05]

        try buffer.write([])
        #expect(buffer.count == 0)
        #expect(buffer.currentPosition == 0)

        try buffer.write(bytesToWrite)
        #expect(buffer.count == 6)
        #expect(buffer.currentPosition == 6)

        try buffer.write([])
        #expect(buffer.count == 6)
        #expect(buffer.currentPosition == 6)

        try buffer.seek(to: 0, from: .begin)
        #expect(buffer.currentPosition == 0)

        var readCount = 0
        var readBytes = [UInt8](repeating: 0, count: 2)

        readCount = try buffer.read(into: &readBytes, count: 0)
        #expect(readCount == 0)
        #expect(buffer.currentPosition == 0)
        #expect(readBytes == [])

        readCount = try buffer.read(into: &readBytes, count: 3)
        #expect(readCount == 3)
        #expect(buffer.currentPosition == 3)
        #expect(readBytes == [0x00, 0x01, 0x02])

        readCount = try buffer.read(into: &readBytes, count: 0)
        #expect(readCount == 0)
        #expect(buffer.currentPosition == 3)
        #expect(readBytes == [])

        readCount = try buffer.read(into: &readBytes, count: 3)
        #expect(readCount == 3)
        #expect(buffer.currentPosition == 6)
        #expect(readBytes == [0x03, 0x04, 0x05])
    }

    @Test
    func testSeek() async throws {
        let buffer = CBBuffer(data: Data([0x01, 0x02, 0x03, 0x04, 0x05]))
        #expect(buffer.currentPosition == 0)

        try buffer.seek(to: 0, from: .end)
        #expect(buffer.currentPosition == buffer.count)

        try buffer.seek(to: 0, from: .begin)
        #expect(buffer.currentPosition == 0)

        try buffer.seek(to: 1, from: .current)
        #expect(buffer.currentPosition == 1)

        try buffer.seek(to: buffer.count, from: .begin)
        #expect(buffer.currentPosition == buffer.count)

        #expect(throws: CBStreamError.outOfBounds.self) {
            try buffer.seek(to: -1, from: .begin)
            print(buffer.currentPosition)
        }
        #expect(throws: CBStreamError.outOfBounds.self) {
            try buffer.seek(to: buffer.count + 1, from: .begin)
            print(buffer.currentPosition)
        }
        #expect(throws: CBStreamError.outOfBounds.self) {
            try buffer.seek(to: 1, from: .end)
            print(buffer.currentPosition)
        }
        #expect(throws: CBStreamError.outOfBounds.self) {
            try buffer.seek(to: -buffer.count - 1, from: .end)
            print(buffer.currentPosition)
        }
    }

    @Test
    func testResize() throws {
        let buffer = CBBuffer(data: Data([0x01, 0x02, 0x03, 0x04, 0x05]))
        #expect(buffer.count == 5)

        // Resize to smaller
        buffer.resize(to: 3)
        #expect(buffer.count == 3)
        #expect(buffer.toArray() == [0x01, 0x02, 0x03])
        #expect(buffer.currentPosition == 0) // Position should reset if out of new bounds

        // Resize to larger
        let buffer2 = CBBuffer(data: Data([0x01, 0x02, 0x03]))
        try buffer2.seek(to: 2, from: .begin)
        buffer2.resize(to: 5)
        #expect(buffer2.count == 5)
        #expect(buffer2.toArray() == [0x01, 0x02, 0x03, 0x00, 0x00])
        #expect(buffer2.currentPosition == 2) // Position should be maintained

        // Resize when currentPosition is beyond new size
        let buffer3 = CBBuffer(data: Data([0x01, 0x02, 0x03, 0x04, 0x05]))
        try buffer3.seek(to: 4, from: .begin)
        buffer3.resize(to: 3)
        #expect(buffer3.count == 3)
        #expect(buffer3.currentPosition == 3)
    }

    @Test
    func testWriteReadIntegers() throws {
        let buffer = CBBuffer()

        let intValue: Int32 = 12345
        try buffer.writeInteger(intValue)
        #expect(buffer.count == MemoryLayout<Int32>.size)
        #expect(buffer.currentPosition == MemoryLayout<Int32>.size)

        try buffer.seek(to: 0, from: .begin)
        let readIntValue: Int32? = buffer.readInteger()
        #expect(readIntValue == intValue)
        #expect(buffer.currentPosition == MemoryLayout<Int32>.size)

        let uintValue: UInt64 = 9876543210
        try buffer.writeInteger(uintValue)
        #expect(buffer.count == MemoryLayout<Int32>.size + MemoryLayout<UInt64>.size)
        #expect(buffer.currentPosition == MemoryLayout<Int32>.size + MemoryLayout<UInt64>.size)

        try buffer.seek(to: MemoryLayout<Int32>.size, from: .begin)
        let readUintValue: UInt64? = buffer.readInteger()
        #expect(readUintValue == uintValue)
        #expect(buffer.currentPosition == MemoryLayout<Int32>.size + MemoryLayout<UInt64>.size)

        // Test reading past end
        let pastEndValue: Int16? = buffer.readInteger()
        #expect(pastEndValue == nil)
        #expect(buffer.currentPosition == MemoryLayout<Int32>.size + MemoryLayout<UInt64>.size) // Position should not change
    }

    @Test
    func testToArray() throws {
        let data = Data([0x0A, 0x0B, 0x0C])
        let buffer = CBBuffer(data: data)
        #expect(buffer.toArray() == [0x0A, 0x0B, 0x0C])
    }

    @Test
    func testWriteWithExistingData() throws {
        let initialData: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05]
        let buffer = CBBuffer(data: Data(initialData))
        #expect(buffer.count == 5)

        // Write at the beginning, overwriting existing data
        try buffer.seek(to: 0, from: .begin)
        let newData1: [UInt8] = [0xAA, 0xBB]
        try buffer.write(newData1)
        #expect(buffer.count == 5) // Count should remain the same if overwriting within bounds
        #expect(buffer.currentPosition == 2)
        #expect(buffer.toArray() == [0xAA, 0xBB, 0x03, 0x04, 0x05])

        // Write in the middle, overwriting existing data
        try buffer.seek(to: 1, from: .begin)
        let newData2: [UInt8] = [0xCC, 0xDD, 0xEE]
        try buffer.write(newData2)
        #expect(buffer.count == 5) // Count should remain the same
        #expect(buffer.currentPosition == 4)
        #expect(buffer.toArray() == [0xAA, 0xCC, 0xDD, 0xEE, 0x05])

        // Write at the end, appending data
        try buffer.seek(to: buffer.count, from: .begin)
        let newData3: [UInt8] = [0xFF, 0x11]
        try buffer.write(newData3)
        #expect(buffer.count == 7)
        #expect(buffer.currentPosition == 7)
        #expect(buffer.toArray() == [0xAA, 0xCC, 0xDD, 0xEE, 0x05, 0xFF, 0x11])

        // Write partially overwriting and appending
        let buffer2 = CBBuffer(data: Data([1,2,3,4,5]))
        try buffer2.seek(to: 3, from: .begin) // position at '4'
        let newData4: [UInt8] = [10,11,12,13]
        try buffer2.write(newData4)
        #expect(buffer2.count == 7) // 3 (original) + 4 (new)
        #expect(buffer2.currentPosition == 7)
        #expect(buffer2.toArray() == [1,2,3,10,11,12,13])
    }
}
