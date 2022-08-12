import XCTest
@testable import CoreBedrock

class CBWriterTests: XCTestCase {
    override func setUpWithError() throws {
        NBTFile.littleEndianByDefault = false
    }
    
    func testValues() throws {
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "root", useLittleEndian: false)
        XCTAssert(ms === writer.baseStream)
        
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
        
        XCTAssertFalse(writer.isDone)
        try writer.endCompound()
        XCTAssertTrue(writer.isDone)
        try writer.finish()
        
        try ms.setPosition(0)
        let file = NBTFile()
        _ = try file.loadInternal(ms) { tag in
            return false
        }
        
        try TestData.assertValueTest(file)
    }
    
    func testHugeCBWriter() throws {
        // Test writing byte arrays that exceed the max NbtBinaryWriter chunk size
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "root", useLittleEndian: false)
        XCTAssertNoThrow(try writer.writeByteArray(tagName: "payload4", data: [UInt8](repeating: 0, count: 5*1024*1024)))
        XCTAssertNoThrow(try writer.endCompound())
        XCTAssertNoThrow(try writer.finish())
    }
    
    func testCompoundList() throws {
        // Test writing various combinations of compound tags and list tags
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "Test", useLittleEndian: false)
        
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
        let file = NBTFile()
        _ = try file.loadInternal(ms) { tag in
            return false
        }
        print()
        print(file.description)
        print()
    }
    
    func testList() throws {
        // Write short (1-element) lists of every possible kind
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "Test", useLittleEndian: false)

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
        XCTAssertFalse(writer.isDone)
        try writer.endCompound()
        XCTAssertTrue(writer.isDone)
        try writer.finish()
        
        try ms.setPosition(0)
        let reader = CBReader(stream: ms, useLittleEndian: false)
        XCTAssertNoThrow(try reader.readAsTag())
    }
    
    func testWriteTag() throws {
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "root", useLittleEndian: false)

        for tag in try TestData.makeValueTest() {
            try writer.writeTag(tag: tag)
        }
        
        try writer.endCompound()
        XCTAssertTrue(writer.isDone)
        try writer.finish()
        
        try ms.setPosition(0)
        let file = NBTFile()
        let bytesRead = try file.load(contentsOf: ms.toArray(), compression: .none)
        XCTAssertEqual(bytesRead, ms.length)
        try TestData.assertValueTest(file)
    }
    
    func testErrors() throws {
        var dummyByteArray = [UInt8]([ 1, 2, 3, 4, 5 ])
        let dummyIntArray = [Int32]([ 1, 2, 3, 4, 5 ])
        let dummyBuffer = CBBuffer([UInt8](repeating: 0, count: 1024))
        
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "root", useLittleEndian: false)
        
        // Use Negative list size
        XCTAssertThrowsError(try writer.beginList(tagName: "list", elementType: .int, size: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("size", "List size may not be negative."))
        }
        XCTAssertNoThrow(try writer.beginList(tagName: "listOfLists", elementType: .list, size: 1))
        XCTAssertThrowsError(try writer.beginList(elementType: .int, size: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("size", "List size may not be negative."))
        }
        XCTAssertNoThrow(try writer.beginList(elementType: .int, size: 0))
        XCTAssertNoThrow(try writer.endList())
        XCTAssertNoThrow(try writer.endList())
        
        XCTAssertNoThrow(try writer.beginList(tagName: "list", elementType: .int, size: 1))
        
        // Invalid list type
        XCTAssertThrowsError(try writer.beginList(elementType: .end, size: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type."))
        }
        XCTAssertThrowsError(try writer.beginList(tagName: "list", elementType: .end, size: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type."))
        }
        
        // Call EndCompound when not in a compound
        XCTAssertThrowsError(try writer.endCompound()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Not currently in a compound."))
        }
        
        // End list before all elements have been written
        XCTAssertThrowsError(try writer.endList()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Cannot end list: not all elements have been written yet. Expected: 1, written: 0"))
        }
        
        // Write the wrong kind of tag inside a list
        XCTAssertThrowsError(try writer.writeShort(value: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Unexpected tag type (expected: int, given: short)"))
        }
        
        // Write a named tag where an unnamed tag is expected
        XCTAssertThrowsError(try writer.writeInt(tagName: "NamedInt", value: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting an unnamed tag."))
        }
        
        // Write too many list elements
        XCTAssertNoThrow(try writer.writeTag(tag: IntTag()))
        XCTAssertThrowsError(try writer.writeInt(value: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Given list size exceeded."))
        }
        XCTAssertNoThrow(try writer.endList())
        
        // Write an unnamed tag where a named tag is expected
        XCTAssertThrowsError(try writer.writeTag(tag: IntTag())) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeInt(value: 0)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        
        // End a list when not in a list
        XCTAssertThrowsError(try writer.endList()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Not currently in a list."))
        }
        
        // Try to write arary with out-of-range offset/count
        XCTAssertThrowsError(try writer.writeByteArray(data: dummyByteArray, offset: -1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("offset", "Offset may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(data: dummyByteArray, offset: 0, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Count may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(data: dummyByteArray, offset: 0, count: 6)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(data: dummyByteArray, offset: 1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: -1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("offset", "Offset may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 0, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Count may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 0, count: 6)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "OutOfRangeByteArray", data: dummyByteArray, offset: 1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        
        XCTAssertThrowsError(try writer.writeIntArray(data: dummyIntArray, offset: -1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("offset", "Offset may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(data: dummyIntArray, offset: 0, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Count may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(data: dummyIntArray, offset: 0, count: 6)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(data: dummyIntArray, offset: 1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: -1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("offset", "Offset may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 0, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Count may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 0, count: 6)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }
        XCTAssertThrowsError(try writer.writeIntArray(tagName: "OutOfRangeIntArray", data: dummyIntArray, offset: 1, count: 5)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length."))
        }

        // Out-of-range values for stream-reading overloads of WriteByteArray
        XCTAssertThrowsError(try writer.writeByteArray(dataSource: dummyBuffer, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Value may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "BadLength", dataSource: dummyBuffer, count: -1)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Value may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(dataSource: dummyBuffer, count: -1, buffer: &dummyByteArray)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Value may not be negative."))
        }
        XCTAssertThrowsError(try writer.writeByteArray(tagName: "BadLength", dataSource: dummyBuffer, count: -1, buffer: &dummyByteArray)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentOutOfRange("count", "Value may not be negative."))
        }
        
        // Finish too early
        XCTAssertThrowsError(try writer.finish()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Cannot finish: not all tags have been closed yet."))
        }
        
        try writer.endCompound()
        try writer.finish()
        
        // write tag after finishing
        XCTAssertThrowsError(try writer.writeTag(tag: IntTag())) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Cannot write any more tags: root tag has been closed."))
        }
    }
    
    func testMissingName() throws {
        let ms = CBBuffer()
        let writer = try CBWriter(stream: ms, rootTagName: "test", useLittleEndian: false)
        // All tags (aside from list elements) must be named
        XCTAssertThrowsError(try writer.writeTag(tag: ByteTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: ShortTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: IntTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: LongTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: FloatTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: DoubleTag(123))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: StringTag("value"))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: ByteArrayTag([UInt8]()))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: IntArrayTag([Int32]()))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: LongArrayTag([Int64]()))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: ListTag(listType: .byte))) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
        XCTAssertThrowsError(try writer.writeTag(tag: CompoundTag())) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Expecting a named tag."))
        }
    }
}
