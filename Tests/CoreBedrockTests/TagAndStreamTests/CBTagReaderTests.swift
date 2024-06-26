import XCTest
@testable import CoreBedrock

class CBTagReaderTests: XCTestCase {
    override func setUpWithError() throws {
        NBTFile.littleEndianByDefault = false
    }
    
    func testPrintBigFileUncompressed() throws {
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let stream = CBBuffer(data)
        let reader = CBTagReader(stream: stream, useLittleEndian: false)

        XCTAssert(stream === reader.baseStream)
        while try reader.readToFollowing() {
            print("@\(reader.tagStartOffset) ")
            print(reader.description)
        }
        XCTAssertEqual("Level", reader.rootName)
    }
    
    func testPrintBigFileUncompressedNoSkip() throws {
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let stream = CBBuffer(data)
        let reader = CBTagReader(stream: stream, useLittleEndian: false)
        reader.skipEndTags = false
        
        XCTAssert(stream === reader.baseStream)
        while try reader.readToFollowing() {
            print("@\(reader.tagStartOffset) ")
            print(reader.description)
        }
        XCTAssertEqual("Level", reader.rootName)
    }
    
    func testCacheTagValues() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest())
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        XCTAssertFalse(reader.cacheTagValues)
        reader.cacheTagValues = true
        try XCTAssertTrue(reader.readToFollowing()) // root
        
        XCTAssertTrue(try reader.readToFollowing()) // byte
        XCTAssertEqual(1, try reader.readValue() as? UInt8)
        XCTAssertEqual(1, try reader.readValue() as? UInt8)
        XCTAssertTrue(try reader.readToFollowing()) // short
        XCTAssertEqual(2, try reader.readValue() as? Int16)
        XCTAssertEqual(2, try reader.readValue() as? Int16)
        XCTAssertTrue(try reader.readToFollowing()) // int
        XCTAssertEqual(3, try reader.readValue() as? Int32)
        XCTAssertEqual(3, try reader.readValue() as? Int32)
        XCTAssertTrue(try reader.readToFollowing()) // long
        XCTAssertEqual(4, try reader.readValue() as? Int64)
        XCTAssertEqual(4, try reader.readValue() as? Int64)
        XCTAssertTrue(try reader.readToFollowing()) // float
        XCTAssertEqual(5, try reader.readValue() as? Float)
        XCTAssertEqual(5, try reader.readValue() as? Float)
        XCTAssertTrue(try reader.readToFollowing()) // double
        XCTAssertEqual(6, try reader.readValue() as? Double)
        XCTAssertEqual(6, try reader.readValue() as? Double)
        XCTAssertTrue(try reader.readToFollowing()) // byteArray
        let byteArray: [UInt8] = [10, 11, 12]
        XCTAssertEqual(byteArray, try reader.readValue() as? [UInt8])
        XCTAssertEqual(byteArray, try reader.readValue() as? [UInt8])
        XCTAssertTrue(try reader.readToFollowing()) // intArray
        let intArray: [Int32] = [20, 21, 22]
        XCTAssertEqual(intArray, try reader.readValue() as? [Int32])
        XCTAssertEqual(intArray, try reader.readValue() as? [Int32])
        XCTAssertTrue(try reader.readToFollowing()) // longArray
        let longArray: [Int64] = [30, 31, 32]
        XCTAssertEqual(longArray, try reader.readValue() as? [Int64])
        XCTAssertEqual(longArray, try reader.readValue() as? [Int64])
        XCTAssertTrue(try reader.readToFollowing()) // string
        XCTAssertEqual("123", try reader.readValue() as? String)
        XCTAssertEqual("123", try reader.readValue() as? String)
    }
    
    func testNestedList() throws {
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
        let file = try NBTFile(rootTag: root)
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        while try reader.readToFollowing() {
            print(reader.toString(includeValue: true, indentString: NBT.defaultIndentString))
        }
    }
    
    func testProperties() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        XCTAssertEqual(0, reader.depth)
        XCTAssertEqual(0, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing())
        XCTAssertEqual("root", reader.tagName)
        XCTAssertEqual(TagType.compound, reader.tagType)
        XCTAssertEqual(TagType.unknown, reader.listType)
        XCTAssertFalse(reader.hasValue)
        XCTAssertTrue(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertFalse(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(1, reader.depth)
        XCTAssertNil(reader.parentName)
        XCTAssertEqual(TagType.unknown, reader.parentTagType)
        XCTAssertEqual(0, reader.parentTagLength)
        XCTAssertEqual(0, reader.tagLength)
        XCTAssertEqual(1, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing())
        XCTAssertEqual("first", reader.tagName)
        XCTAssertEqual(TagType.int, reader.tagType)
        XCTAssertEqual(TagType.unknown, reader.listType)
        XCTAssertTrue(reader.hasValue)
        XCTAssertFalse(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertFalse(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(2, reader.depth)
        XCTAssertEqual("root", reader.parentName)
        XCTAssertEqual(TagType.compound, reader.parentTagType)
        XCTAssertEqual(0, reader.parentTagLength)
        XCTAssertEqual(0, reader.tagLength)
        XCTAssertEqual(2, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing("fourth-list"))
        XCTAssertEqual("fourth-list", reader.tagName)
        XCTAssertEqual(TagType.list, reader.tagType)
        XCTAssertEqual(TagType.list, reader.listType)
        XCTAssertFalse(reader.hasValue)
        XCTAssertFalse(reader.isCompound)
        XCTAssertTrue(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertTrue(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(2, reader.depth)
        XCTAssertEqual("root", reader.parentName)
        XCTAssertEqual(TagType.compound, reader.parentTagType)
        XCTAssertEqual(0, reader.parentTagLength)
        XCTAssertEqual(3, reader.tagLength)
        XCTAssertEqual(8, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing()) // first list element, itself a list
        XCTAssertEqual(nil, reader.tagName)
        XCTAssertEqual(TagType.list, reader.tagType)
        XCTAssertEqual(TagType.compound, reader.listType)
        XCTAssertFalse(reader.hasValue)
        XCTAssertFalse(reader.isCompound)
        XCTAssertTrue(reader.isList)
        XCTAssertTrue(reader.isListElement)
        XCTAssertTrue(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(3, reader.depth)
        XCTAssertEqual("fourth-list", reader.parentName)
        XCTAssertEqual(TagType.list, reader.parentTagType)
        XCTAssertEqual(3, reader.parentTagLength)
        XCTAssertEqual(1, reader.tagLength)
        XCTAssertEqual(9, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing()) // first nested list element, compound
        XCTAssertEqual(nil, reader.tagName)
        XCTAssertEqual(TagType.compound, reader.tagType)
        XCTAssertEqual(TagType.unknown, reader.listType)
        XCTAssertFalse(reader.hasValue)
        XCTAssertTrue(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertTrue(reader.isListElement)
        XCTAssertFalse(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(4, reader.depth)
        XCTAssertEqual(nil, reader.parentName)
        XCTAssertEqual(TagType.list, reader.parentTagType)
        XCTAssertEqual(1, reader.parentTagLength)
        XCTAssertEqual(0, reader.tagLength)
        XCTAssertEqual(10, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing("fifth"))
        XCTAssertEqual("fifth", reader.tagName)
        XCTAssertEqual(TagType.int, reader.tagType)
        XCTAssertEqual(TagType.unknown, reader.listType)
        XCTAssertTrue(reader.hasValue)
        XCTAssertFalse(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertFalse(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(2, reader.depth)
        XCTAssertEqual("root", reader.parentName)
        XCTAssertEqual(TagType.compound, reader.parentTagType)
        XCTAssertEqual(0, reader.parentTagLength)
        XCTAssertEqual(0, reader.tagLength)
        XCTAssertEqual(18, reader.tagsRead)
        
        XCTAssertTrue(try reader.readToFollowing())
        XCTAssertEqual("hugeArray", reader.tagName)
        XCTAssertEqual(TagType.byteArray, reader.tagType)
        XCTAssertEqual(TagType.unknown, reader.listType)
        XCTAssertTrue(reader.hasValue)
        XCTAssertFalse(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertTrue(reader.hasLength)
        XCTAssertEqual(0, reader.listIndex)
        XCTAssertEqual(2, reader.depth)
        XCTAssertEqual("root", reader.parentName)
        XCTAssertEqual(TagType.compound, reader.parentTagType)
        XCTAssertEqual(0, reader.parentTagLength)
        XCTAssertEqual(1024*1024, reader.tagLength)
        XCTAssertEqual(19, reader.tagsRead)
    }
    
    func testReadToSibling() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        XCTAssertTrue(try reader.readToFollowing())
        XCTAssertEqual("root", reader.tagName)
        XCTAssertTrue(try reader.readToFollowing())
        XCTAssertEqual("first", reader.tagName)
        XCTAssertTrue(try reader.readToNextSibling("third-comp"))
        XCTAssertEqual("third-comp", reader.tagName)
        XCTAssertTrue(try reader.readToNextSibling())
        XCTAssertEqual("fourth-list", reader.tagName)
        XCTAssertTrue(try reader.readToNextSibling())
        XCTAssertEqual("fifth", reader.tagName)
        XCTAssertTrue(try reader.readToNextSibling())
        XCTAssertEqual("hugeArray", reader.tagName)
        XCTAssertFalse(try reader.readToNextSibling())
        // Test twice, since we hit different paths through the code
        XCTAssertFalse(try reader.readToNextSibling())
    }
    
    func testReadToSibling2() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        XCTAssertTrue(try reader.readToFollowing("inComp1"))
        // Expect all siblings to be read while we search for a non-existent one
        XCTAssertFalse(try reader.readToNextSibling("no such tag"))
        // Expect to pop out of "third-comp" by now
        XCTAssertEqual("fourth-list", reader.tagName)
    }
    
    func testReadToFollowingNotFound() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        XCTAssertTrue(try reader.readToFollowing()) // at "root"
        XCTAssertFalse(try reader.readToFollowing("no such tag"))
        XCTAssertFalse(try reader.readToFollowing("not this one either"))
        XCTAssertTrue(reader.isAtStreamEnd)
    }
    
    func testReadToDescendant() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        XCTAssertTrue(try reader.readToDescendant("third-comp"))
        XCTAssertEqual("third-comp", reader.tagName)
        XCTAssertTrue(try reader.readToDescendant("inComp2"))
        XCTAssertEqual("inComp2", reader.tagName)
        XCTAssertFalse(try reader.readToDescendant("derp"))
        XCTAssertEqual("inComp3", reader.tagName)
        _ = try reader.readToFollowing() // at fourth-list
        XCTAssertTrue(try reader.readToDescendant("inList2"))
        XCTAssertEqual("inList2", reader.tagName)
        
        // Ensure ReadToDescendant return false when at end-of-stream
        while try reader.readToFollowing() { }
        XCTAssertFalse(try reader.readToDescendant("*"))
    }
    
    func testSkip() throws {
        let reader = try CBTagReader(stream: TestData.makeReaderTest(), useLittleEndian: false)
        _ = try reader.readToFollowing() // at root
        _ = try reader.readToFollowing() // at first
        _ = try reader.readToFollowing() // at second
        _ = try reader.readToFollowing() // at third-comp
        _ = try reader.readToFollowing() // at inComp1
        XCTAssertEqual("inComp1", reader.tagName)
        XCTAssertEqual(2, try reader.skip())
        XCTAssertEqual("fourth-list", reader.tagName)
        XCTAssertEqual(11, try reader.skip())
        XCTAssertFalse(try reader.readToFollowing())
        XCTAssertEqual(0, try reader.skip())
    }
    
    func testReadAsTag1() throws {
        let reader = try CBTagReader(TestData.makeReaderTest())
        _ = try reader.readToFollowing() // skip "root"
        while !reader.isAtStreamEnd {
            _ = try reader.readAsTag()
        }
        XCTAssertThrowsError(try reader.readAsTag())
    }
    
    func testReadAsTag2() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest())
        _ = try file.save(to: &buffer, compression: .none)
        
        var reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        var root = try reader.readAsTag() as! CompoundTag
        try TestData.assertValueTest(NBTFile(rootTag: root))
        
        // Try the same test but with end tag skipping disabled
        reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        reader.skipEndTags = false
        root = try reader.readAsTag() as! CompoundTag
        try TestData.assertValueTest(NBTFile(rootTag: root))
    }
    
    func testReadAsTag3() throws {
        // read values as tags
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest())
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        let root = CompoundTag(name: "root")
        
        // skip root
        _ = try reader.readToFollowing()
        _ = try reader.readToFollowing()
        
        while !reader.isAtStreamEnd {
            try root.append(reader.readAsTag())
        }
        
        try TestData.assertValueTest(NBTFile(rootTag: root))
    }
    
    func testReadAsTag4() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList())
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
    
    func testListAsArray() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList())
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // Atempt to read value before we're in a list
        XCTAssertThrowsError(try reader.readListAsArray() as [Int32])
        
        // test byte values
        _ = try reader.readToFollowing("ByteList")
        let bytes = try reader.readListAsArray() as [UInt8]
        XCTAssertEqual([UInt8]([100, 20, 3]), bytes)
        
        // test double values
        _ = try reader.readToFollowing("DoubleList")
        let doubles = try reader.readListAsArray() as [Double]
        XCTAssertEqual([Double]([1, 2000, -3000000]), doubles)
        
        // test float values
        _ = try reader.readToFollowing("FloatList")
        let floats = try reader.readListAsArray() as [Float]
        XCTAssertEqual([Float]([1, 2000, -3000000]), floats)
        
        // test int values
        _ = try reader.readToFollowing("IntList")
        let ints = try reader.readListAsArray() as [Int32]
        XCTAssertEqual([Int32]([1, 2000, -3000000]), ints)
        
        // test long values
        _ = try reader.readToFollowing("LongList")
        let longs = try reader.readListAsArray() as [Int64]
        XCTAssertEqual([Int64]([1, 2000, -3000000]), longs)
        
        // test short values
        _ = try reader.readToFollowing("ShortList")
        let shorts = try reader.readListAsArray() as [Int16]
        XCTAssertEqual([Int16]([1, 200, -30000]), shorts)
        
        // test string values
        _ = try reader.readToFollowing("StringList")
        let strings = try reader.readListAsArray() as [String]
        XCTAssertEqual([String](["one", "two thousand", "negative three million"]), strings)
        
        // try reading list of compounds (should fail)
        _ = try reader.readToFollowing("CompoundList")
        XCTAssertThrowsError(try reader.readListAsArray() as [CompoundTag])
        
        // skip to the end of the stream
        while try reader.readToFollowing() { }
        XCTAssertThrowsError(try reader.readListAsArray() as [Int32]) { error in
            XCTAssertEqual(error as? CBStreamError, CBStreamError.endOfStream)
        }
    }
    
    func testReadListAsArrayRecast() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeTestList())
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // test bytes as shorts
        _ = try reader.readToFollowing("ByteList")
        let bytes = try reader.readListAsArray() as [Int16]
        XCTAssertEqual([Int16]([100, 20, 3]), bytes)
    }
    
    func testReadValueTest() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: TestData.makeValueTest())
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        XCTAssertTrue(try reader.readToFollowing()) // root
        
        XCTAssertTrue(try reader.readToFollowing()) // byte
        XCTAssertEqual(UInt8(1), try reader.readValue() as! UInt8)
        XCTAssertTrue(try reader.readToFollowing()) // short
        XCTAssertEqual(Int16(2), try reader.readValue() as! Int16)
        XCTAssertTrue(try reader.readToFollowing()) // int
        XCTAssertEqual(Int32(3), try reader.readValue() as! Int32)
        XCTAssertTrue(try reader.readToFollowing()) // long
        XCTAssertEqual(4, try reader.readValue() as! Int64)
        XCTAssertTrue(try reader.readToFollowing()) // float
        XCTAssertEqual(Float(5), try reader.readValue() as! Float)
        XCTAssertTrue(try reader.readToFollowing()) // double
        XCTAssertEqual(Double(6), try reader.readValue() as! Double)
        XCTAssertTrue(try reader.readToFollowing()) // byteArray
        XCTAssertEqual([UInt8]([10, 11, 12]), try reader.readValue() as! [UInt8])
        XCTAssertTrue(try reader.readToFollowing()) // intArray
        XCTAssertEqual([Int32]([20, 21, 22]), try reader.readValue() as! [Int32])
        XCTAssertTrue(try reader.readToFollowing()) // longArray
        XCTAssertEqual([Int64]([30, 31, 32]), try reader.readValue() as! [Int64])
        XCTAssertTrue(try reader.readToFollowing()) // string
        XCTAssertEqual("123", try reader.readValue() as! String)
        
        // Skip to very end and make sure we can't read any more values
        _ = try reader.readToFollowing()
        XCTAssertThrowsError(try reader.readValue()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.endOfStream)
        }
    }
    
    func testError() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: CompoundTag(name: "root"))
        _ = try file.save(to: &buffer, compression: .none)
        
        // corrupt the data
        buffer[0] = 123
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)

        // Attempt to use ReadValue when not at value
        XCTAssertThrowsError(try reader.readValue()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidOperation("Value already read, or no value to read."))
        }
        reader.cacheTagValues = true
        XCTAssertThrowsError(try reader.readValue()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidOperation("No value to read."))
        }
        
        // Attempt to read from a corrupt stream
        XCTAssertThrowsError(try reader.readToFollowing()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("NBT tag type out of range: 123"))
        }
        
        // Make sure we've properly entered the error state
        XCTAssertTrue(reader.isInErrorState)
        XCTAssertFalse(reader.hasName)
        XCTAssertThrowsError(try reader.readToFollowing()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
        XCTAssertThrowsError(try reader.readListAsArray() as [Int32]) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
        XCTAssertThrowsError(try reader.readToNextSibling()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
        XCTAssertThrowsError(try reader.readToDescendant("derp")) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
        XCTAssertThrowsError(try reader.readAsTag()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
        XCTAssertThrowsError(try reader.skip()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidReaderState("CBTagReader is in an erroneous state!"))
        }
    }
    
    func testCorruptFileRead() throws {
        let emptyFile = Data()
        XCTAssertThrowsError(try tryReadBadFile(emptyFile, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.endOfStream)
        }
        XCTAssertThrowsError(try NBTFile().load(contentsOf: emptyFile, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.endOfStream)
        }
        
        let badHeader = Data([
            0x02, // TAG_Short ID (instead of TAG_Compound ID)
            0x00, 0x01, 0x66, // Root name: "f"
            0x00 // end tag
        ])
        XCTAssertThrowsError(try tryReadBadFile(badHeader, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Given NBT stream does not start with TAG_Compound."))
        }
        XCTAssertThrowsError(try NBTFile().load(contentsOf: badHeader, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Given NBT stream does not start with TAG_Compound."))
        }
        
        let badStringLength = Data([
            0x0A, // Compound tag
            0xFF, 0xFF, 0x66, // Root name "f" (with string length given as "-1")
            0x00 // end tag
        ])
        XCTAssertThrowsError(try tryReadBadFile(badStringLength, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Negative string length given!"))
        }
        XCTAssertThrowsError(try NBTFile().load(contentsOf: badStringLength, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Negative string length given!"))
        }
        
        let abruptStringEnd = Data([
            0x0A, // Compound tag
            0x00, 0xFF, 0x66, // Root name "f" (string length given as 5
            0x00 // premature end tag
        ])
        XCTAssertThrowsError(try tryReadBadFile(abruptStringEnd, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.endOfStream)
        }
        XCTAssertThrowsError(try NBTFile(useLittleEndian: false).load(contentsOf: abruptStringEnd, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.endOfStream)
        }
        
        let badSecondTag = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0xFF, 0x01, 0x4E, 0x7F, 0xFF, // Short tag named 'N' with invalid tag ID (0xFF instead of 0x02)
            0x00 // end tag
        ])
        XCTAssertThrowsError(try tryReadBadFile(badSecondTag, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("NBT tag type out of range: 255"))
        }
        XCTAssertThrowsError(try NBTFile(useLittleEndian: false).load(contentsOf: badSecondTag, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("NBT tag type out of range: 255"))
        }
        
        NBTFile.littleEndianByDefault = false
        let badListType = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0x09, // List tag
            0x00, 0x01, 0x66, // List tag name: 'g'
            0xFF // invalid list tag type (-1)
        ])
        XCTAssertThrowsError(try tryReadBadFile(badListType, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("NBT tag type out of range: 255"))
        }
        XCTAssertThrowsError(try NBTFile().load(contentsOf: badListType, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("NBT tag type out of range: 255"))
        }
        
        let badListSize = Data([
            0x0A, // Compound tag
            0x00, 0x01, 0x66, // Root name: 'f'
            0x09, // List tag
            0x00, 0x01, 0x66, // List tag name: 'g'
            0x01, // List type: Byte
            0xFF, 0xFF, 0xFF, 0xFF, // List size: -1
        ])
        XCTAssertThrowsError(try tryReadBadFile(badListSize, useLittleEndian: false)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Negative tag length given: -1"))
        }
        XCTAssertThrowsError(try NBTFile().load(contentsOf: badListSize, compression: .none)) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidFormat("Negative list size given."))
        }
    }
    
    func testEndTag() throws {
        var buffer = Data()
        let file = try NBTFile(rootTag: CompoundTag(name: "root", [
            IntTag(name: "test", 0)
        ]))
        _ = try file.save(to: &buffer, compression: .none)
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: false)
        reader.skipEndTags = false
        
        _ = try reader.readToDescendant("test")
        XCTAssertEqual(TagType.int, reader.tagType)
        XCTAssertTrue(try reader.readToNextSibling())
        
        // Should be at root's end tag now
        XCTAssertEqual(TagType.end, reader.tagType)
        XCTAssertFalse(reader.isInErrorState)
        XCTAssertFalse(reader.isAtStreamEnd)
        XCTAssertFalse(reader.isCompound)
        XCTAssertFalse(reader.isList)
        XCTAssertFalse(reader.isListElement)
        XCTAssertFalse(reader.hasValue)
        XCTAssertFalse(reader.hasName)
        XCTAssertFalse(reader.hasLength)
        XCTAssertThrowsError(try reader.readAsTag()) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.invalidOperation("Value already read, or no value to read."))
        }
        
        XCTAssertFalse(try reader.readToFollowing())
        XCTAssertTrue(reader.isAtStreamEnd)
    }
    
    private func tryReadBadFile(_ buffer: Data, useLittleEndian: Bool) throws {
        let reader = CBTagReader(stream: CBBuffer(buffer), useLittleEndian: useLittleEndian)
        do {
            while try reader.readToFollowing() { }
        }
        catch {
            XCTAssertTrue(reader.isInErrorState)
            throw error
        }
    }
}
