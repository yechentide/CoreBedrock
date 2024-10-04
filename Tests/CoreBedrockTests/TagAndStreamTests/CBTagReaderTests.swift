//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct CBTagReaderTests {
    @Test
    func testPrintBigFileUncompressed() throws {
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let stream = CBBuffer(data)
        let reader = CBTagReader(stream: stream, useLittleEndian: false)

        #expect(reader.baseStream === stream)
        while try reader.readToFollowing() {
            print("@\(reader.tagStartOffset) ")
            print(reader.description)
        }
        #expect(reader.rootName == "Level")
    }

    @Test
    func testPrintBigFileUncompressedNoSkip() async throws {
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let stream = CBBuffer(data)
        let reader = CBTagReader(stream: stream, useLittleEndian: false)
        reader.skipEndTags = false

        #expect(stream === reader.baseStream)
        while try reader.readToFollowing() {
            print("@\(reader.tagStartOffset) ")
            print(reader.description)
        }
        #expect(reader.rootName == "Level")
    }

    @Test
    func testCacheTagValues() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        #expect(!reader.cacheTagValues)
        reader.cacheTagValues = true
        #expect(try reader.readToFollowing()) // root

        #expect(try reader.readToFollowing()) // byte
        #expect(try reader.readValue() as? UInt8 == 1)
        #expect(try reader.readValue() as? UInt8 == 1)
        #expect(try reader.readToFollowing()) // short
        #expect(try reader.readValue() as? Int16 == 2)
        #expect(try reader.readValue() as? Int16 == 2)
        #expect(try reader.readToFollowing()) // int
        #expect(try reader.readValue() as? Int32 == 3)
        #expect(try reader.readValue() as? Int32 == 3)
        #expect(try reader.readToFollowing()) // long
        #expect(try reader.readValue() as? Int64 == 4)
        #expect(try reader.readValue() as? Int64 == 4)
        #expect(try reader.readToFollowing()) // float
        #expect(try reader.readValue() as? Float == 5)
        #expect(try reader.readValue() as? Float == 5)
        #expect(try reader.readToFollowing()) // double
        #expect(try reader.readValue() as? Double == 6)
        #expect(try reader.readValue() as? Double == 6)
        #expect(try reader.readToFollowing()) // byteArray
        let byteArray: [UInt8] = [10, 11, 12]
        #expect(try reader.readValue() as? [UInt8] == byteArray)
        #expect(try reader.readValue() as? [UInt8] == byteArray)
        #expect(try reader.readToFollowing()) // intArray
        let intArray: [Int32] = [20, 21, 22]
        #expect(try reader.readValue() as? [Int32] == intArray)
        #expect(try reader.readValue() as? [Int32] == intArray)
        #expect(try reader.readToFollowing()) // longArray
        let longArray: [Int64] = [30, 31, 32]
        #expect(try reader.readValue() as? [Int64] == longArray)
        #expect(try reader.readValue() as? [Int64] == longArray)
        #expect(try reader.readToFollowing()) // string
        #expect(try reader.readValue() as? String == "123")
        #expect(try reader.readValue() as? String == "123")
    }

    @Test
    func testNestedList() async throws {
        let root = try CompoundTag(name: "root", [
            ListTag(name: "OuterList", [
                ListTag([
                    ByteTag()
                ]),
                ListTag([
                    ShortTag()
                ]),
                ListTag([
                    IntTag()
                ])
            ])
        ])
        var buffer = Data()
        let file = try NBTFile(rootTag: root, useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        while try reader.readToFollowing() {
            print(reader.toString(includeValue: true, indentString: NBT.defaultIndentString))
        }
    }

    @Test
    func testProperties() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        #expect(reader.depth == 0)
        #expect(reader.tagsRead == 0)

        #expect(try reader.readToFollowing())
        #expect(reader.tagName == "root")
        #expect(reader.tagType == TagType.compound)
        #expect(reader.listType == TagType.unknown)
        #expect(!reader.hasValue)
        #expect(reader.isCompound)
        #expect(!reader.isList)
        #expect(!reader.isListElement)
        #expect(!reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 1)
        #expect(reader.parentName == nil)
        #expect(reader.parentTagType == TagType.unknown)
        #expect(reader.parentTagLength == 0)
        #expect(reader.tagLength == 0)
        #expect(reader.tagsRead == 1)

        #expect(try reader.readToFollowing())
        #expect(reader.tagName == "first")
        #expect(reader.tagType == TagType.int)
        #expect(reader.listType == TagType.unknown)
        #expect(reader.hasValue)
        #expect(!reader.isCompound)
        #expect(!reader.isList)
        #expect(!reader.isListElement)
        #expect(!reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 2)
        #expect(reader.parentName == "root")
        #expect(reader.parentTagType == TagType.compound)
        #expect(reader.parentTagLength == 0)
        #expect(reader.tagLength == 0)
        #expect(reader.tagsRead == 2)

        #expect(try reader.readToFollowing("fourth-list"))
        #expect(reader.tagName == "fourth-list")
        #expect(reader.tagType == TagType.list)
        #expect(reader.listType == TagType.list)
        #expect(!reader.hasValue)
        #expect(!reader.isCompound)
        #expect(reader.isList)
        #expect(!reader.isListElement)
        #expect(reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 2)
        #expect(reader.parentName == "root")
        #expect(reader.parentTagType == TagType.compound)
        #expect(reader.parentTagLength == 0)
        #expect(reader.tagLength == 3)
        #expect(reader.tagsRead == 8)

        #expect(try reader.readToFollowing()) // first list element, itself a list
        #expect(reader.tagName == nil)
        #expect(reader.tagType == TagType.list)
        #expect(reader.listType == TagType.compound)
        #expect(!reader.hasValue)
        #expect(!reader.isCompound)
        #expect(reader.isList)
        #expect(reader.isListElement)
        #expect(reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 3)
        #expect(reader.parentName == "fourth-list")
        #expect(reader.parentTagType == TagType.list)
        #expect(reader.parentTagLength == 3)
        #expect(reader.tagLength == 1)
        #expect(reader.tagsRead == 9)

        #expect(try reader.readToFollowing()) // first nested list element, compound
        #expect(reader.tagName == nil)
        #expect(reader.tagType == TagType.compound)
        #expect(reader.listType == TagType.unknown)
        #expect(!reader.hasValue)
        #expect(reader.isCompound)
        #expect(!reader.isList)
        #expect(reader.isListElement)
        #expect(!reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 4)
        #expect(reader.parentName == nil)
        #expect(reader.parentTagType == TagType.list)
        #expect(reader.parentTagLength == 1)
        #expect(reader.tagLength == 0)
        #expect(reader.tagsRead == 10)

        #expect(try reader.readToFollowing("fifth"))
        #expect(reader.tagName == "fifth")
        #expect(reader.tagType == TagType.int)
        #expect(reader.listType == TagType.unknown)
        #expect(reader.hasValue)
        #expect(!reader.isCompound)
        #expect(!reader.isList)
        #expect(!reader.isListElement)
        #expect(!reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 2)
        #expect(reader.parentName == "root")
        #expect(reader.parentTagType == TagType.compound)
        #expect(reader.parentTagLength == 0)
        #expect(reader.tagLength == 0)
        #expect(reader.tagsRead == 18)

        #expect(try reader.readToFollowing())
        #expect(reader.tagName == "hugeArray")
        #expect(reader.tagType == TagType.byteArray)
        #expect(reader.listType == TagType.unknown)
        #expect(reader.hasValue)
        #expect(!reader.isCompound)
        #expect(!reader.isList)
        #expect(!reader.isListElement)
        #expect(reader.hasLength)
        #expect(reader.listIndex == 0)
        #expect(reader.depth == 2)
        #expect(reader.parentName == "root")
        #expect(reader.parentTagType == TagType.compound)
        #expect(reader.parentTagLength == 0)
        #expect(reader.tagLength == 1024*1024)
        #expect(reader.tagsRead == 19)
    }

    @Test
    func testReadToSibling() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        #expect(try reader.readToFollowing())
        #expect(reader.tagName == "root")
        #expect(try reader.readToFollowing())
        #expect(reader.tagName == "first")
        #expect(try reader.readToNextSibling("third-comp"))
        #expect(reader.tagName == "third-comp")
        #expect(try reader.readToNextSibling())
        #expect(reader.tagName == "fourth-list")
        #expect(try reader.readToNextSibling())
        #expect(reader.tagName == "fifth")
        #expect(try reader.readToNextSibling())
        #expect(reader.tagName == "hugeArray")
        #expect(!(try reader.readToNextSibling()))
        // Test twice, since we hit different paths through the code
        #expect(!(try reader.readToNextSibling()))
    }

    @Test
    func testReadToSibling2() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        #expect(try reader.readToFollowing("inComp1"))
        // Expect all siblings to be read while we search for a non-existent one
        #expect(!(try reader.readToNextSibling("no such tag")))
        // Expect to pop out of "third-comp" by now
        #expect(reader.tagName == "fourth-list")
    }

    @Test
    func testReadToFollowingNotFound() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        #expect(try reader.readToFollowing()) // at "root"
        #expect(!(try reader.readToFollowing("no such tag")))
        #expect(!(try reader.readToFollowing("not this one either")))
        #expect(reader.isAtStreamEnd)
    }

    @Test
    func testReadToDescendant() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        #expect(try reader.readToDescendant("third-comp"))
        #expect(reader.tagName == "third-comp")
        #expect(try reader.readToDescendant("inComp2"))
        #expect(reader.tagName == "inComp2")
        #expect(!(try reader.readToDescendant("derp")))
        #expect(reader.tagName == "inComp3")
        _ = try reader.readToFollowing() // at fourth-list
        #expect(try reader.readToDescendant("inList2"))
        #expect(reader.tagName == "inList2")

        // Ensure ReadToDescendant return false when at end-of-stream
        while try reader.readToFollowing() { }
        #expect(!(try reader.readToDescendant("*")))
    }

    @Test
    func testSkip() async throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        _ = try reader.readToFollowing() // at root
        _ = try reader.readToFollowing() // at first
        _ = try reader.readToFollowing() // at second
        _ = try reader.readToFollowing() // at third-comp
        _ = try reader.readToFollowing() // at inComp1
        #expect(reader.tagName == "inComp1")
        #expect(try reader.skip() == 2)
        #expect(reader.tagName == "fourth-list")
        #expect(try reader.skip() == 11)
        #expect(!(try reader.readToFollowing()))
        #expect(try reader.skip() == 0)
    }

    @Test
    func testReadAsTag1() async throws {
        let reader = try CBTagReader(TestData.makeReaderTest())
        _ = try reader.readToFollowing() // skip "root"
        while !reader.isAtStreamEnd {
            _ = try reader.readAsTag()
        }
        #expect(throws: (any Error).self) {
            try reader.readAsTag()
        }
    }

    @Test
    func testReadAsTag2() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)

        var reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        var root = try reader.readAsTag() as! CompoundTag
        try TestData.assertValueTest(NBTFile(rootTag: root, useLittleEndian: false))

        // Try the same test but with end tag skipping disabled
        reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        reader.skipEndTags = false
        root = try reader.readAsTag() as! CompoundTag
        try TestData.assertValueTest(NBTFile(rootTag: root, useLittleEndian: false))
    }

    @Test
    func testReadAsTag3() async throws {
        // read values as tags
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        let root = CompoundTag(name: "root")

        // skip root
        _ = try reader.readToFollowing()
        _ = try reader.readToFollowing()

        while !reader.isAtStreamEnd {
            try root.append(reader.readAsTag())
        }

        try TestData.assertValueTest(NBTFile(rootTag: root, useLittleEndian: false))
    }

    @Test
    func testReadAsTag4() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)

        // first, read everything all at once
        var reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        while !reader.isAtStreamEnd {
            try print(reader.readAsTag())
        }

        // next, read each list individually
        reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        _ = try reader.readToFollowing() // read to root
        _ = try reader.readToFollowing() // read to first list tag
        while !reader.isAtStreamEnd {
            try print(reader.readAsTag())
        }
    }

    @Test
    func testListAsArray() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // Atempt to read value before we're in a list
        #expect(throws: (any Error).self) {
            try reader.readListAsArray() as [Int32]
        }

        // test byte values
        _ = try reader.readToFollowing("ByteList")
        let bytes = try reader.readListAsArray() as [UInt8]
        #expect(bytes == [UInt8]([100, 20, 3]))

        // test double values
        _ = try reader.readToFollowing("DoubleList")
        let doubles = try reader.readListAsArray() as [Double]
        #expect(doubles == [Double]([1, 2000, -3000000]))

        // test float values
        _ = try reader.readToFollowing("FloatList")
        let floats = try reader.readListAsArray() as [Float]
        #expect(floats == [Float]([1, 2000, -3000000]))

        // test int values
        _ = try reader.readToFollowing("IntList")
        let ints = try reader.readListAsArray() as [Int32]
        #expect(ints == [Int32]([1, 2000, -3000000]))

        // test long values
        _ = try reader.readToFollowing("LongList")
        let longs = try reader.readListAsArray() as [Int64]
        #expect(longs == [Int64]([1, 2000, -3000000]))

        // test short values
        _ = try reader.readToFollowing("ShortList")
        let shorts = try reader.readListAsArray() as [Int16]
        #expect(shorts == [Int16]([1, 200, -30000]))

        // test string values
        _ = try reader.readToFollowing("StringList")
        let strings = try reader.readListAsArray() as [String]
        #expect(strings == [String](["one", "two thousand", "negative three million"]))

        // try reading list of compounds (should fail)
        _ = try reader.readToFollowing("CompoundList")
        #expect(throws: (any Error).self) {
            try reader.readListAsArray() as [CompoundTag]
        }

        // skip to the end of the stream
        while try reader.readToFollowing() { }
        #expect(throws: CBStreamError.endOfStream) {
            try reader.readListAsArray() as [Int32]
        }
    }

    @Test
    func testReadListAsArrayRecast() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // test bytes as shorts
        _ = try reader.readToFollowing("ByteList")
        let bytes = try reader.readListAsArray() as [Int16]
        #expect(bytes == [Int16]([100, 20, 3]))
    }

    @Test
    func testReadValueTest() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest(), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        #expect(try reader.readToFollowing()) // root

        #expect(try reader.readToFollowing()) // byte
        #expect(try reader.readValue() as! UInt8 == UInt8(1))
        #expect(try reader.readToFollowing()) // short
        #expect(try reader.readValue() as! Int16 == Int16(2))
        #expect(try reader.readToFollowing()) // int
        #expect(try reader.readValue() as! Int32 == Int32(3))
        #expect(try reader.readToFollowing()) // long
        #expect(try reader.readValue() as! Int64 == 4)
        #expect(try reader.readToFollowing()) // float
        #expect(try reader.readValue() as! Float == Float(5))
        #expect(try reader.readToFollowing()) // double
        #expect(try reader.readValue() as! Double == Double(6))
        #expect(try reader.readToFollowing()) // byteArray
        #expect(try reader.readValue() as! [UInt8] == [UInt8]([10, 11, 12]))
        #expect(try reader.readToFollowing()) // intArray
        #expect(try reader.readValue() as! [Int32] == [Int32]([20, 21, 22]))
        #expect(try reader.readToFollowing()) // longArray
        #expect(try reader.readValue() as! [Int64] == [Int64]([30, 31, 32]))
        #expect(try reader.readToFollowing()) // string
        #expect(try reader.readValue() as! String == "123")

        // Skip to very end and make sure we can't read any more values
        _ = try reader.readToFollowing()
        #expect(throws: CBStreamError.endOfStream) {
            try reader.readValue()
        }
    }

    @Test
    func testError() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: CompoundTag(name: "root"), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)

        // corrupt the data
        buffer[0] = 123
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // Attempt to use ReadValue when not at value
        #expect(throws: CBStreamError.invalidOperation("Value already read, or no value to read.")) {
            try reader.readValue()
        }
        reader.cacheTagValues = true
        #expect(throws: CBStreamError.invalidOperation("No value to read.")) {
            try reader.readValue()
        }

        // Attempt to read from a corrupt stream
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 123")) {
            try reader.readToFollowing()
        }

        // Make sure we've properly entered the error state
        #expect(reader.isInErrorState)
        #expect(!reader.hasName)
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.readToFollowing()
        }
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.readListAsArray() as [Int32]
        }
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.readToNextSibling()
        }
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.readToDescendant("derp")
        }
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.readAsTag()
        }
        #expect(throws: CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!")) {
            try reader.skip()
        }
    }

    private func tryReadBadFile(_ buffer: Data, useLittleEndian: Bool) throws {
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: useLittleEndian)
        do {
            while try reader.readToFollowing() { }
        }
        catch {
            #expect(reader.isInErrorState)
            throw error
        }
    }

    @Test
    func testCorruptFileRead() async throws {
        let emptyFile = Data()
        #expect(throws: CBStreamError.endOfStream) {
            try tryReadBadFile(emptyFile, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.endOfStream) {
            try NBTFile(useLittleEndian: false).load(contentsOf: emptyFile, compression: .none)
        }

        let badHeader = Data([
            0x02, // TAG_Short ID (instead of TAG_Compound ID)
            0x00, 0x01, 0x66, // Root name: "f"
            0x00 // end tag
        ])
        #expect(throws: CBStreamError.invalidFormat("Given NBT stream does not start with TAG_Compound.")) {
            try tryReadBadFile(badHeader, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.invalidFormat("Given NBT stream does not start with TAG_Compound.")) {
            try NBTFile(useLittleEndian: false).load(contentsOf: badHeader, compression: .none)
        }

        let badStringLength = Data([
            0x0A, // Compound tag
            0xFF, 0xFF, 0x66, // Root name "f" (with string length given as "-1")
            0x00 // end tag
        ])
        #expect(throws: CBStreamError.invalidFormat("Negative string length given!")) {
            try tryReadBadFile(badStringLength, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.invalidFormat("Negative string length given!")) {
            try NBTFile(useLittleEndian: false).load(contentsOf: badStringLength, compression: .none)
        }

        let abruptStringEnd = Data([
            0x0A, // Compound tag
            0x00, 0xFF, 0x66, // Root name "f" (string length given as 5
            0x00 // premature end tag
        ])
        #expect(throws: CBStreamError.endOfStream) {
            try tryReadBadFile(abruptStringEnd, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.endOfStream) {
            try NBTFile(useLittleEndian: false).load(contentsOf: abruptStringEnd, compression: .none)
        }

        let badSecondTag = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0xFF, 0x01, 0x4E, 0x7F, 0xFF, // Short tag named 'N' with invalid tag ID (0xFF instead of 0x02)
            0x00 // end tag
        ])
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 255")) {
            try tryReadBadFile(badSecondTag, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 255")) {
            try NBTFile(useLittleEndian: false).load(contentsOf: badSecondTag, compression: .none)
        }

        let badListType = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0x09, // List tag
            0x00, 0x01, 0x66, // List tag name: 'g'
            0xFF // invalid list tag type (-1)
        ])
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 255")) {
            try tryReadBadFile(badListType, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.invalidFormat("NBT tag type out of range: 255")) {
            try NBTFile(useLittleEndian: false).load(contentsOf: badListType, compression: .none)
        }

        let badListSize = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0x09, // List tag
            0x00, 0x01, 0x66, // List tag name: 'g'
            0x01, // List type: Byte
            0xFF, 0xFF, 0xFF, 0xFF, // List size: -1
        ])
        #expect(throws: CBStreamError.invalidFormat("Negative tag length given: -1")) {
            try tryReadBadFile(badListSize, useLittleEndian: false)
        }
        #expect(throws: CBStreamError.invalidFormat("Negative list size given.")) {
            try NBTFile(useLittleEndian: false).load(contentsOf: badListSize, compression: .none)
        }
    }

    @Test
    func testEndTag() async throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: CompoundTag(name: "root", [
            IntTag(name: "test", 0)
        ]), useLittleEndian: false)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        reader.skipEndTags = false

        _ = try reader.readToDescendant("test")
        #expect(reader.tagType == TagType.int)
        #expect(try reader.readToNextSibling())

        // Should be at root's end tag now
        #expect(reader.tagType == TagType.end)
        #expect(!reader.isInErrorState)
        #expect(!reader.isAtStreamEnd)
        #expect(!reader.isCompound)
        #expect(!reader.isList)
        #expect(!reader.isListElement)
        #expect(!reader.hasValue)
        #expect(!reader.hasName)
        #expect(!reader.hasLength)
        #expect(throws: CBStreamError.invalidOperation("Value already read, or no value to read.")) {
            try reader.readAsTag()
        }

        #expect(!(try reader.readToFollowing()))
        #expect(reader.isAtStreamEnd)
    }
}
