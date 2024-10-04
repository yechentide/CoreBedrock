//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct CBTagWriterTests {
    @Test
    func testValues() async throws {
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "root", useLittleEndian: false)
        #expect(ms === writer.baseStream)

        try writer.writeByte(tagName: "byte", value: 1)
        try writer.writeShort(tagName: "short", value: 2)
        try writer.writeInt(tagName: "int", value: 3)
        try writer.writeLong(tagName: "long", value: 4)
        try writer.writeFloat(tagName: "float", value: 5)
        try writer.writeDouble(tagName: "double", value: 6)
        try writer.writeByteArray(tagName: "byteArray", data: [UInt8]([10, 11, 12]))
        try writer.writeIntArray(tagName: "intArray", data: [Int32]([20, 21, 22]))
        try writer.writeLongArray(tagName: "longArray", data: [Int64]([30, 31, 32]))
        try writer.writeString(tagName: "string", value: "123")

        #expect(!writer.isDone)
        try writer.endCompound()
        #expect(writer.isDone)
        try writer.finish()

        try ms.setPosition(0)
        let file = NBTFile(useLittleEndian: false)
        _ = try file.loadInternal(ms) { tag in
            return false
        }

        try TestData.assertValueTest(file)
    }

    @Test
    func testHugeCBWriter() async throws {
        // Test writing byte arrays that exceed the max NbtBinaryWriter chunk size
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "root", useLittleEndian: false)
        #expect(throws: Never.self) {
            try writer.writeByteArray(tagName: "payload4", data: [UInt8](repeating: 0, count: 5*1024*1024))
        }
        #expect(throws: Never.self) {
            try writer.endCompound()
        }
        #expect(throws: Never.self) {
            try writer.finish()
        }
    }

    @Test
    func testCompoundList() async throws {
        // Test writing various combinations of compound tags and list tags
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "Test", useLittleEndian: false)

        try writer.beginCompound("EmptyCompound")
        try writer.endCompound()

        try writer.beginCompound("OuterNestedCompound")
        try writer.beginCompound("InnerNestedCompound")
        try writer.writeInt(tagName: "IntTest", value: 123)
        try writer.writeString(tagName: "StringTest", value: "History is entirely created by the person who tells the story.")
        try writer.endCompound()
        try writer.endCompound()

        try writer.beginList(tagName: "ListofInts", elementType: .int, size: 3)
        try writer.writeInt(value: 1)
        try writer.writeInt(value: 2)
        try writer.writeInt(value: 3)
        try writer.endList()

        try writer.beginCompound("CompoundOfListsOfCompounds")
        try writer.beginList(tagName: "ListOfCompounds", elementType: .compound, size: 1)
        try writer.beginCompound()
        try writer.writeInt(tagName: "TestInt", value: 123)
        try writer.endCompound()
        try writer.endList()
        try writer.endCompound()

        try writer.beginList(tagName: "ListOfEmptyLists", elementType: .list, size: 3)
        try writer.beginList(elementType: .list, size: 0)
        try writer.endList()
        try writer.beginList(elementType: .list, size: 0)
        try writer.endList()
        try writer.beginList(elementType: .list, size: 0)
        try writer.endList()
        try writer.endList()

        try writer.endCompound()
        try writer.finish()

        _ = try ms.seek(to: 0, from: .begin)
        let file = NBTFile(useLittleEndian: false)
        _ = try file.loadInternal(ms) { tag in
            return false
        }
        print()
        print(file.description)
        print()
    }

    @Test
    func testList() async throws {
        // Write short (1-element) lists of every possible kind
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "Test", useLittleEndian: false)

        try writer.beginList(tagName: "LotsOfLists", elementType: .list, size: 12)

        try writer.beginList(elementType: .byte, size: 1)
        try writer.writeByte(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .byteArray, size: 1)
        try writer.writeByteArray(data: [UInt8]([ 1 ]))
        try writer.endList()

        try writer.beginList(elementType: .compound, size: 1)
        try writer.beginCompound()
        try writer.endCompound()
        try writer.endList()

        try writer.beginList(elementType: .double, size: 1)
        try writer.writeDouble(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .float, size: 1)
        try writer.writeFloat(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .int, size: 1)
        try writer.writeInt(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .intArray, size: 1)
        try writer.writeIntArray(data: [Int32]([ 1 ]))
        try writer.endList()

        try writer.beginList(elementType: .list, size: 1)
        try writer.beginList(elementType: .list, size: 0)
        try writer.endList()
        try writer.endList()

        try writer.beginList(elementType: .long, size: 1)
        try writer.writeLong(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .longArray, size: 1)
        try writer.writeLongArray(data: [Int64]([ 1 ]))
        try writer.endList()

        try writer.beginList(elementType: .short, size: 1)
        try writer.writeShort(value: 1)
        try writer.endList()

        try writer.beginList(elementType: .string, size: 1)
        try writer.writeString(value: "123")
        try writer.endList()

        try writer.endList()
        #expect(!writer.isDone)
        try writer.endCompound()
        #expect(writer.isDone)
        try writer.finish()

        try ms.setPosition(0)
        let reader = CBTagReader(stream: ms, useLittleEndian: false)
        #expect(throws: Never.self) {
            try reader.readAsTag()
        }
    }

    @Test
    func testWriteTag() async throws {
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "root", useLittleEndian: false)

        for tag in try TestData.makeValueTest() {
            try writer.writeTag(tag: tag)
        }

        try writer.endCompound()
        #expect(writer.isDone)
        try writer.finish()

        try ms.setPosition(0)
        let file = NBTFile(useLittleEndian: false)
        let bytesRead = try file.load(contentsOf: ms.toArray(), compression: .none)
        #expect(bytesRead == ms.length)
        try TestData.assertValueTest(file)
    }

    @Test
    func testErrors() async throws {
        var dummyByteArray = [UInt8]([ 1, 2, 3, 4, 5 ])
        let dummyIntArray = [Int32]([ 1, 2, 3, 4, 5 ])
        let dummyBuffer = CBBuffer([UInt8](repeating: 0, count: 1024))

        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "root", useLittleEndian: false)

        // Use Negative list size
        #expect(throws: CBStreamError.argumentOutOfRange("size", "List size may not be negative.")) {
            try writer.beginList(tagName: "list", elementType: .int, size: -1)
        }
        #expect(throws: Never.self) {
            try writer.beginList(tagName: "listOfLists", elementType: .list, size: 1)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("size", "List size may not be negative.")) {
            try writer.beginList(elementType: .int, size: -1)
        }
        #expect(throws: Never.self) {
            try writer.beginList(elementType: .int, size: 0)
        }
        #expect(throws: Never.self) {
            try writer.endList()
        }
        #expect(throws: Never.self) {
            try writer.endList()
        }

        #expect(throws: Never.self) {
            try writer.beginList(tagName: "list", elementType: .int, size: 1)
        }

        // Invalid list type
        #expect(throws: CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type.")) {
            try writer.beginList(elementType: .end, size: 0)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type.")) {
            try writer.beginList(tagName: "list", elementType: .end, size: 0)
        }

        // Call EndCompound when not in a compound
        #expect(throws: CBStreamError.invalidFormat("Not currently in a compound.")) {
            try writer.endCompound()
        }

        // End list before all elements have been written
        #expect(throws: CBStreamError.invalidFormat("Cannot end list: not all elements have been written yet. Expected: 1, written: 0")) {
            try writer.endList()
        }

        // Write the wrong kind of tag inside a list
        #expect(throws: CBStreamError.invalidFormat("Unexpected tag type (expected: TAG_Int, given: TAG_Short)")) {
            try writer.writeShort(value: 0)
        }

        // Write a named tag where an unnamed tag is expected
        #expect(throws: CBStreamError.invalidFormat("Expecting an unnamed tag.")) {
            try writer.writeInt(tagName: "NamedInt", value: 0)
        }

        // Write too many list elements
        #expect(throws: Never.self) {
            try writer.writeTag(tag: IntTag())
        }
        #expect(throws: CBStreamError.invalidFormat("Given list size exceeded.")) {
            try writer.writeInt(value: 0)
        }
        #expect(throws: Never.self) {
            try writer.endList()
        }

        // Write an unnamed tag where a named tag is expected
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: IntTag())
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeInt(value: 0)
        }

        // End a list when not in a list
        #expect(throws: CBStreamError.invalidFormat("Not currently in a list.")) {
            try writer.endList()
        }

        // Try to write arary with out-of-range offset/count
        #expect(throws: CBStreamError.argumentOutOfRange("offset", "Offset may not be negative.")) {
            try writer.writeByteArray(data: dummyByteArray, offset: -1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Count may not be negative.")) {
            try writer.writeByteArray(data: dummyByteArray, offset: 0, count: -1)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeByteArray(data: dummyByteArray, offset: 0, count: 6)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeByteArray(data: dummyByteArray, offset: 1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("offset", "Offset may not be negative.")) {
            try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: -1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Count may not be negative.")) {
            try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 0, count: -1)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 0, count: 6)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 1, count: 5)
        }

        #expect(throws: CBStreamError.argumentOutOfRange("offset", "Offset may not be negative.")) {
            try writer.writeIntArray(data: dummyIntArray, offset: -1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Count may not be negative.")) {
            try writer.writeIntArray(data: dummyIntArray, offset: 0, count: -1)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeIntArray(data: dummyIntArray, offset: 0, count: 6)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeIntArray(data: dummyIntArray, offset: 1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("offset", "Offset may not be negative.")) {
            try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: -1, count: 5)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Count may not be negative.")) {
            try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 0, count: -1)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 0, count: 6)
        }
        #expect(throws: CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")) {
            try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 1, count: 5)
        }

        // Out-of-range values for stream-reading overloads of WriteByteArray
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Value may not be negative.")) {
            try writer.writeByteArray(dataSource: dummyBuffer, count: -1)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Value may not be negative.")) {
            try writer.writeByteArray(tagName: "BadLength", dataSource: dummyBuffer, count: -1)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Value may not be negative.")) {
            try writer.writeByteArray(dataSource: dummyBuffer, count: -1, buffer: &dummyByteArray)
        }
        #expect(throws: CBStreamError.argumentOutOfRange("count", "Value may not be negative.")) {
            try writer.writeByteArray(tagName: "BadLength", dataSource: dummyBuffer, count: -1, buffer: &dummyByteArray)
        }

        // Finish too early
        #expect(throws: CBStreamError.invalidFormat("Cannot finish: not all tags have been closed yet.")) {
            try writer.finish()
        }

        try writer.endCompound()
        try writer.finish()

        // write tag after finishing
        #expect(throws: CBStreamError.invalidFormat("Cannot write any more tags: root tag has been closed.")) {
            try writer.writeTag(tag: IntTag())
        }
    }

    @Test
    func testMissingName() async throws {
        let ms = CBBuffer()
        let writer = try CBTagWriter(stream: ms, rootTagName: "test", useLittleEndian: false)
        // All tags (aside from list elements) must be named
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: ByteTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: ShortTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: IntTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: LongTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: FloatTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: DoubleTag(123))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: StringTag("value"))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: ByteArrayTag([UInt8]()))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: IntArrayTag([Int32]()))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: LongArrayTag([Int64]()))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: ListTag(listType: .byte))
        }
        #expect(throws: CBStreamError.invalidFormat("Expecting a named tag.")) {
            try writer.writeTag(tag: CompoundTag())
        }
    }
}
