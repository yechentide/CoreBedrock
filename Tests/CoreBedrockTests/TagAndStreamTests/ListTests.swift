//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct ListTests {
    @Test
    func testInitializingListFromCollection() async throws {
        // Auto-detect list type
        let test1 = try ListTag(name: "Test1", [
            IntTag(1),
            IntTag(2),
            IntTag(3)
        ])
        #expect(test1.listType == TagType.int)

        // Correct explicitly-given list type
        #expect(throws: Never.self) {
            try ListTag(name: "Test2", [
                IntTag(1),
                IntTag(2),
                IntTag(3)
            ], listType: .int)
        }

        // Wrong explicitly-given list type
        #expect(throws: (any Error).self) {
            try ListTag(name: "Test3", [
                IntTag(1),
                IntTag(2),
                IntTag(3)
            ], listType: .float)
        }

        // Auto-detecting mixed list
        #expect(throws: (any Error).self) {
            try ListTag(name: "Test4", [
                FloatTag(1),
                ByteTag(2),
                IntTag(3)
            ])
        }

        // Using append with range
        #expect(throws: Never.self) {
            try ListTag().append(contentsOf: [
                IntTag(1),
                IntTag(2),
                IntTag(3)
            ])
        }
    }

    @Test
    func testManipulatingList() async throws {
        let sameTags: [NBT] = [
            IntTag(0),
            IntTag(1),
            IntTag(2)
        ]

        let list = try ListTag(name: "Test1", sameTags)

        // Test enumerator, indexer, contains, indexOf
        var j = 0
        for tag in list {
            #expect(list.contains(sameTags[j]))
            #expect(tag == sameTags[j])
            #expect(list.firstIndex(of: tag) == j)
            j += 1
        }

        // Adding an item of correct type
        #expect(throws: Never.self) {
            try list.append(IntTag(3))
        }
        #expect(throws: Never.self) {
            try list.insert(IntTag(4), at: 3)
        }

        // Adding an item of wrong type
        #expect(throws: (any Error).self) {
            try list.append(StringTag())
        }
        #expect(throws: (any Error).self) {
            try list.insert(StringTag(), at: 3)
        }

        // Test array contents
        for i in 0..<sameTags.count {
            #expect(list[i] == sameTags[i])
            #expect(Int((list[i] as! IntTag).value) == i)
        }

        // Test removal
        #expect(!list.remove(IntTag(5)))
        #expect(list.remove(sameTags[0]))
        #expect(throws: Never.self) {
            try list.remove(at: 0)
        }
        #expect(throws: (any Error).self) {
            try list.remove(at: 10)
        }

        // Test some failure scenarios for Add:
        // Add list to itself
        let loopList = ListTag()
        #expect(loopList.listType == TagType.unknown)
        #expect(throws: (any Error).self) {
            try loopList.append(loopList)
        }

        // Add same tag to multiple lists
        #expect(throws: (any Error).self) {
            try loopList.append(list[0])
        }
        #expect(throws: (any Error).self) {
            try loopList.insert(list[0], at: 0)
        }

        // Make sure that all those failed adds didn't affect the tag
        #expect(loopList.count == 0)
        #expect(loopList.listType == TagType.unknown)
    }

    @Test
    func testChangingListType() async throws {
        let list = ListTag()

        // Failing to add or insert a tag should not change teh list type
        #expect(throws: (any Error).self) {
            try list.insert(IntTag(), at: -1)
        }
        #expect(throws: (any Error).self) {
            try list.append(IntTag(name: "namedTagWhereUnnamedIsExpected"))
        }
        #expect(list.listType == TagType.unknown)

        // Changing the type of an empty list to .end is allowed
        #expect(throws: Never.self) {
            try list.setListType(.end)
        }
        #expect(TagType.end == list.listType)

        // Changing the type of an empty list to .unknown is allowed
        #expect(throws: Never.self) {
            try list.setListType(.unknown)
        }
        #expect(TagType.unknown == list.listType)

        // Adding the first element should set the tag type
        #expect(throws: Never.self) {
            try list.append(IntTag())
        }
        #expect(TagType.int == list.listType)

        // Setting correct type for a non-empty list
        #expect(throws: Never.self) {
            try list.setListType(.int)
        }

        // Changing list type to incorrect type
        #expect(throws: (any Error).self) {
            try list.setListType(.short)
        }

        // After list is cleared, change the tag type
        list.removeAll()
        #expect(throws: Never.self) {
            try list.setListType(.short)
        }
    }

    @Test
    func testSerializingWithoutListType() async throws {
        let root = try CompoundTag(name: "root", [
            ListTag(name: "List")
        ])
        let file = try NBTFile(rootTag: root)
        var buffer = Data()
        #expect(throws: (any Error).self) {
            try file.save(to: &buffer, compression: .none)
        }
    }

    @Test
    func testSerializing() async throws {
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
        #expect(buffer.count == bytesWritten)

        // Test loading
        let readFile = NBTFile()
        var bytesRead = try readFile.load(contentsOf: buffer, compression: .none)
        #expect(buffer.count == bytesRead)

        // Check contents of loaded file
        #expect(readFile.rootTag["Entities"] is ListTag)
        let readList = readFile.rootTag["Entities"] as! ListTag
        #expect(readList.listType == writtenList.listType)
        #expect(readList.count == writtenList.count)

        // Check contents of loaded list
        #expect(throws: Never.self) {
            for i in 0..<elements {
                let a = try (readList.get(at: i) as! IntTag).value
                let b = try (writtenList.get(at: i) as! IntTag).value
                #expect(a == b)
            }
        }

        // Check saving/loading lists of all possible value types
        let testFile = try NBTFile(rootTag: TestData.makeTestList())
        bytesWritten = try testFile.save(to: &buffer, compression: .none)
        bytesRead = try testFile.load(contentsOf: buffer, compression: .none)
        #expect(buffer.count == bytesRead)
    }

    @Test
    func testSerializingEmpty() async throws {
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
        #expect(list1.count == 0)
        #expect(list1.listType == TagType.end)

        let list2 = testFile.rootTag.get("listyList") as! ListTag
        #expect(list2.count == 1)
        #expect(list2.listType == TagType.list)
        #expect((try list2.get(at: 0) as? ListTag)?.count == 0)
        #expect((try list2.get(at: 0) as? ListTag)?.listType == TagType.end)
    }

    @Test
    func testNestedListAndCompound() async throws {
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
        #expect(buffer.count == bytesRead)
        #expect((file.rootTag.get("OuterList") as? ListTag)?.count == 1)
        #expect(throws: Never.self) {
            let listTag = file.rootTag.get("OuterList") as? ListTag
            let compoundTag = try listTag?.get(at: 0) as? CompoundTag
            let childListTag = compoundTag?.get("InnerList") as? ListTag
            let childCompoundTag = try childListTag?.get(at: 0) as? CompoundTag
            #expect(compoundTag?.name == nil)
            #expect(childListTag?.count == 1)
            #expect(childCompoundTag?.name == nil)
        }

    }

    @Test
    func testFirstInsert() async throws {
        let list = ListTag()
        #expect(list.listType == TagType.unknown)
        #expect(throws: Never.self) {
            try list.insert(IntTag(123), at: 0)
        }
        // Inserting a tag should set ListType
        #expect(list.listType == TagType.int)
    }
}
