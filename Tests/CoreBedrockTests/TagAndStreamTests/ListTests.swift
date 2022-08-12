import XCTest
@testable import CoreBedrock

class ListTests: XCTestCase {
    func testSubscripts() throws {
        //
        // TODO: Implement tests once subscripts can throw errors
        //
    }
    
    func testInitializingListFromCollection() throws {
        // Auto-detect list type
        let test1 = try ListTag(name: "Test1", [
            IntTag(1),
            IntTag(2),
            IntTag(3)
        ])
        XCTAssertEqual(TagType.int, test1.listType)
        
        // Correct explicitly-given list type
        XCTAssertNoThrow(try ListTag(name: "Test2", [
            IntTag(1),
            IntTag(2),
            IntTag(3)
        ], listType: .int))
        
        // Wrong explicitly-given list type
        XCTAssertThrowsError(try ListTag(name: "Test3", [
            IntTag(1),
            IntTag(2),
            IntTag(3)
        ], listType: .float))
        
        // Auto-detecting mixed list
        XCTAssertThrowsError(try ListTag(name: "Test4", [
            FloatTag(1),
            ByteTag(2),
            IntTag(3)
        ]))
        
        // Using append with range
        XCTAssertNoThrow(try ListTag().append(contentsOf: [
            IntTag(1),
            IntTag(2),
            IntTag(3)
        ]))
    }
    
    func testManipulatingList() throws {
        let sameTags: [NBT] = [
            IntTag(0),
            IntTag(1),
            IntTag(2)
        ]
        
        let list = try ListTag(name: "Test1", sameTags)
        
        // Test enumerator, indexer, contains, indexOf
        var j = 0
        for tag in list {
            XCTAssertTrue(list.contains(sameTags[j]))
            XCTAssertEqual(sameTags[j], tag)
            XCTAssertEqual(j, list.firstIndex(of: tag))
            j += 1
        }
        
        // Adding an item of correct type
        XCTAssertNoThrow(try list.append(IntTag(3)))
        XCTAssertNoThrow(try list.insert(IntTag(4), at: 3))
        
        // Adding an item of wrong type
        XCTAssertThrowsError(try list.append(StringTag()))
        XCTAssertThrowsError(try list.insert(StringTag(), at: 3))
        
        // Test array contents
        for i in 0..<sameTags.count {
            XCTAssertEqual(sameTags[i], list[i])
            XCTAssertEqual(i, Int((list[i] as! IntTag).value))
        }
        
        // Test removal
        XCTAssertFalse(list.remove(IntTag(5)))
        XCTAssertTrue(list.remove(sameTags[0]))
        XCTAssertNoThrow(try list.remove(at: 0))
        XCTAssertThrowsError(try list.remove(at: 10))
        
        // Test some failure scenarios for Add:
        // Add list to itself
        let loopList = ListTag()
        XCTAssertEqual(TagType.unknown, loopList.listType)
        XCTAssertThrowsError(try loopList.append(loopList))
        
        // Add same tag to multiple lists
        XCTAssertThrowsError(try loopList.append(list[0]))
        XCTAssertThrowsError(try loopList.insert(list[0], at: 0))
        
        // Make sure that all those failed adds didn't affect the tag
        XCTAssertEqual(0, loopList.count)
        XCTAssertEqual(TagType.unknown, loopList.listType)
    }
    
    func testChangingListType() throws {
        let list = ListTag()
                
        // Failing to add or insert a tag should not change teh list type
        XCTAssertThrowsError(try list.insert(IntTag(), at: -1))
        XCTAssertThrowsError(try list.append(IntTag(name: "namedTagWhereUnnamedIsExpected")))
        XCTAssertEqual(TagType.unknown, list.listType)
        
        // Changing the type of an empty list to .end is allowed
        XCTAssertNoThrow(try list.setListType(.end))
        XCTAssertEqual(list.listType, TagType.end)
        
        // Changing the type of an empty list to .unknown is allowed
        XCTAssertNoThrow(try list.setListType(.unknown))
        XCTAssertEqual(list.listType, TagType.unknown)
        
        // Adding the first element should set the tag type
        XCTAssertNoThrow(try list.append(IntTag()))
        XCTAssertEqual(list.listType, TagType.int)
        
        // Setting correct type for a non-empty list
        XCTAssertNoThrow(try list.setListType(.int))
        
        // Changing list type to incorrect type
        XCTAssertThrowsError(try list.setListType(.short))
        
        // After list is cleared, change the tag type
        list.removeAll()
        XCTAssertNoThrow(try list.setListType(.short))
    }
    
    func testSerializingWithoutListType() throws {
        let root = try CompoundTag(name: "root", [
            ListTag(name: "List")
        ])
        let file = try NBTFile(rootTag: root)
        var buffer = Data()
        XCTAssertThrowsError(try file.save(to: &buffer, compression: .none))
    }
    
    func testSerializing() throws {
        let expectedListType = TagType.int
        let elements = 10
        
        // Construct NBT File
        let writtenFile = try NBTFile(rootTag: CompoundTag(name: "ListTypeTest"))
        let writtenList = try ListTag(name: "Entities", listType: expectedListType)
        for i in 0..<elements {
            try writtenList.append(IntTag(Int32(i)))
        }
        try writtenFile.rootTag.append(writtenList)
        
        // Test saving
        var buffer = Data()
        var bytesWritten = try writtenFile.save(to: &buffer, compression: .none)
        XCTAssertEqual(bytesWritten, buffer.count)
        
        // Test loading
        let readFile = NBTFile()
        var bytesRead = try readFile.load(contentsOf: buffer, compression: .none)
        XCTAssertEqual(bytesRead, buffer.count)
        
        // Check contents of loaded file
        XCTAssert(readFile.rootTag["Entities"] is ListTag)
        let readList = readFile.rootTag["Entities"] as! ListTag
        XCTAssertEqual(writtenList.listType, readList.listType)
        XCTAssertEqual(writtenList.count, readList.count)
        
        // Check contents of loaded list
        for i in 0..<elements {
            try XCTAssertEqual((readList.get(at: i) as! IntTag).value, (writtenList.get(at: i) as! IntTag).value)
        }
        
        // Check saving/loading lists of all possible value types
        let testFile = try NBTFile(rootTag: TestData.makeTestList())
        bytesWritten = try testFile.save(to: &buffer, compression: .none)
        bytesRead = try testFile.load(contentsOf: buffer, compression: .none)
        XCTAssertEqual(bytesRead, buffer.count)
    }
    
    func testSerializingEmpty() throws {
        // Check saving/loading lists of empty lists
        let testFile = try NBTFile(rootTag: CompoundTag(name: "root", [
            ListTag(name: "emptyList", listType: .end),
            ListTag(name: "listyList", [
                ListTag(listType: .end)
            ], listType: .list)
        ]))
        var buffer = Data()
        _ = try testFile.save(to: &buffer, compression: .none)
        
        let list1 = testFile.rootTag.get("emptyList") as! ListTag
        XCTAssertEqual(list1.count, 0)
        XCTAssertEqual(list1.listType, TagType.end)
        
        let list2 = testFile.rootTag.get("listyList") as! ListTag
        XCTAssertEqual(list2.count, 1)
        XCTAssertEqual(list2.listType, TagType.list)
        XCTAssertEqual((try list2.get(at: 0) as? ListTag)?.count, 0)
        XCTAssertEqual((try list2.get(at: 0) as? ListTag)?.listType, TagType.end)
    }
    
    func testNestedListAndCompound() throws {
        var buffer = Data()
        
        let root = CompoundTag(name: "Root")
        let outerList = try ListTag(name: "OuterList", listType: .compound)
        let outerCompound = CompoundTag()
        let innerList = try ListTag(name: "InnerList", listType: .compound)
        let innerCompound = CompoundTag()
        
        try innerList.append(innerCompound)
        try outerCompound.append(innerList)
        try outerList.append(outerCompound)
        try root.append(outerList)
        
        var file = try NBTFile(rootTag: root)
        _ = try file.save(to: &buffer, compression: .none)
        
        file = NBTFile()
        let bytesRead = try file.load(contentsOf: buffer, compression: .none)
        XCTAssertEqual(bytesRead, buffer.count)
        XCTAssertEqual(1, (file.rootTag.get("OuterList") as? ListTag)?.count)
        try XCTAssertEqual(nil, ((file.rootTag.get("OuterList") as? ListTag)?.get(at: 0) as? CompoundTag)?.name)
        try XCTAssertEqual(1, (((file.rootTag
                                    .get("OuterList") as? ListTag)?
                                    .get(at: 0) as? CompoundTag)?
                                    .get("InnerList") as? ListTag)?
                                    .count)
        try XCTAssertEqual(nil, ((((file.rootTag
                                    .get("OuterList") as? ListTag)?
                                    .get(at: 0) as? CompoundTag)?
                                    .get("InnerList") as? ListTag)?
                                    .get(at: 0) as? CompoundTag)?
                                    .name)
        
    }
    
    func testFirstInsert() throws {
        let list = ListTag()
        XCTAssertEqual(TagType.unknown, list.listType)
        XCTAssertNoThrow(try list.insert(IntTag(123), at: 0))
        // Inserting a tag should set ListType
        XCTAssertEqual(TagType.int, list.listType)
    }
}
