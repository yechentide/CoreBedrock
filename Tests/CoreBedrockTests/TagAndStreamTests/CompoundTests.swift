//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct CompoundTests {
    @Test
    func testInitializingCompoundFromCollection() async throws {
        // let allNamed: [NBT] = [
        //     ShortTag(name: "allNamed1", 1),
        //     LongTag(name: "allNamed2", 2),
        //     IntTag(name: "allNamed3", 3)
        // ]

        let someUnnamed: [NBT] = [
            IntTag(name: "someUnnamed", 1),
            IntTag(2),
            IntTag(name: "someUnnamed", 3)
        ]

        let dupeNames: [NBT] = [
            IntTag(name: "dupeNames1", 1),
            IntTag(name: "dupeNames2", 2),
            IntTag(name: "dupeNames1", 3)
        ]

        // var allNamedTest = CompoundTag()
        // XCTAssertNoThrow(allNamedTest = try CompoundTag(name: "allNamedTest", allNamed))
        // Need a way to compare collections...
        // Test if allNamed == allNamedTest

        #expect(throws: CBStreamError.argumentError("Only named tags are allowed in Compound tags.")) {
            try CompoundTag(name: "someUnnamedTest", someUnnamed)
        }
        #expect(throws: CBStreamError.argumentError("A tag with the same name has already been added.")) {
            try CompoundTag(name: "dupeNamesTest", dupeNames)
        }
    }

    @Test
    func testGettersAndSetters() async throws {
        // construct a compound for testing
        let nestedChild = CompoundTag(name: "NestedChild")
        var nestedInt = IntTag(1)
        let nestedChildList = try ListTag(name: "NestedChildList", [nestedInt])
        let child = try CompoundTag(name: "Child", [
            nestedChild,
            nestedChildList
        ])
        let childList = try ListTag(name: "ChildList", [IntTag(1)])
        let parent = try CompoundTag(name: "Parent", [
            child,
            childList
        ])

        // Accessing nested compound tags using indexers
        #expect(nestedChild == (parent["Child"] as! CompoundTag)["NestedChild"])
        #expect(nestedChildList == (parent["Child"] as! CompoundTag)["NestedChildList"])
        #expect(nestedInt == ((parent["Child"] as! CompoundTag)["NestedChildList"] as! ListTag)[0])

        // Accessing nested compound tags using get
        #expect(parent.get("NonExistingChild") == nil)
        #expect(parent.get("NonExistingChild") as? CompoundTag == nil)
        #expect(nestedChild == (parent.get("Child") as? CompoundTag)?.get("NestedChild"))
        #expect(nestedChild == (parent.get("Child") as? CompoundTag)?.get("NestedChild") as? CompoundTag)
        #expect(nestedChildList == (parent.get("Child") as? CompoundTag)?.get("NestedChildList"))
        #expect(nestedChildList == (parent.get("Child") as? CompoundTag)?.get("NestedChildList") as? ListTag)
        #expect(nestedInt == ((parent.get("Child") as? CompoundTag)?.get("NestedChildList") as? ListTag)?[0])

        // Accessing get with an invalid given type
        #expect(parent.get("Child") as? IntTag == nil)

        // Using get<T>
        var dummyTag: NBT?
        #expect(!parent.get("NonExistingChild", result: &dummyTag))
        #expect(dummyTag == nil)
        #expect(parent.get("Child", result: &dummyTag))
        #expect(dummyTag == child)

        var dummyCompoundTag: CompoundTag?
        #expect(!parent.get("NonExistingChild", result: &dummyCompoundTag))
        #expect(dummyCompoundTag == nil)
        #expect(parent.get("ChildList", result: &dummyCompoundTag))
        #expect(dummyCompoundTag == nil)
        #expect(parent.get("Child", result: &dummyCompoundTag))
        #expect(dummyCompoundTag == child)

        //
        // TODO: Enable these when Swift support throwing from subscripts
        //
        // Use integer indexers on non-NbtList tags
        //XCTAssertThrowsError(parent[0] = nestedInt)
        //XCTAssertThrowsError(nestedInt[0] = nestedInt)

        // Use string indexers on non-NbtCompound tags
        //XCTAssertThrowsError(childList["test"] = nestedInt)
        //XCTAssertThrowsError(nestedInt["test"] = nestedInt)

        // Get a non-existing element by name
        #expect(parent.get("NonExistingTag") == nil)
        #expect(parent["NonExistingTag"] == nil)

        //
        // TODO: Enable these when Swift support throwing from subscripts
        //
        // Out-of-range indices on NbtList
        //XCTAssertThrowsError(nestedInt = childList[-1] as! NbtInt)
        //XCTAssertThrowsError(childList[-1] = NbtInt(1))
        #expect(throws: (any Error).self) {
            nestedInt = try childList.get(at: -1) as! IntTag
        }
        //XCTAssertThrowsError(nestedInt = try childList[childList.count] as! NbtInt)
        #expect(throws: (any Error).self) {
            nestedInt = try childList.get(at: childList.count) as! IntTag
        }

        // Using setter correctly
        #expect(throws: Never.self) {
            parent["NewChild"] = ByteTag(name: "NewChild")
        }

        // Using setter incorrectly
        //XCTAssertThrowsError(parent["Child"] = nil)
        //XCTAssertNotNil(parent["Child"])
        //XCTAssertThrowsError(parent["Child"] = NbtByte(name: "NotChild"))

        // Try adding tag to self
        // let selfTest = CompoundTag(name: "SelfTest")
        //XCTAssertThrowsError(selfTest["SelfTest"] = selfTest)

        // Try adding a tag that already has a parent
        //XCTAssertThrowsError(selfTest[child.name!] = child)
    }

    @Test
    func testRenaming() async throws {
        let tagToRename = IntTag(name: "DifferentName", 1)
        let compound = try CompoundTag([
            IntTag(name: "SameName", 1),
            tagToRename
        ])

        // Proper renaming, should not throw
        #expect(throws: Never.self) {
            tagToRename.name = "SomeOtherName"
        }

        // Attempting to use a duplicate name
        // ❌ XCTAssertThrowsError(tagToRename.name = "SameName")
        #expect(throws: (any Error).self) {
            try compound.renameTag(oldName: tagToRename.name!, newName: "SameName")
        }

        // Assigning a nil name to a tag inside a compound; should throw
        // ❌ XCTAssertThrowsError(tagToRename.name = nil)

        // Assigning a nil name to a tag that's been removed; should not throw
        _ = try compound.remove(tagToRename)
        #expect(throws: Never.self) {
            tagToRename.name = nil
        }
    }

    @Test
    func testAddingAndRemoving() async throws {
        let foo = IntTag(name: "Foo")
        let test = try CompoundTag([
            foo
        ])

        // Add duplicate object
        #expect(throws: (any Error).self) {
            try test.append(foo)
        }

        // Add duplicate name
        #expect(throws: (any Error).self) {
            try test.append(ByteTag(name: "Foo"))
        }

        // Add unnamed tag
        #expect(throws: (any Error).self) {
            try test.append(IntTag())
        }

        // Add tag to self
        #expect(throws: (any Error).self) {
            try test.append(test)
        }

        // Contains existing name/object
        #expect(test.contains("Foo"))
        #expect(try test.contains(foo))

        // Contains a non-existent name
        #expect(!test.contains("Bar"))

        // Contains existing name/different objects
        #expect(!(try test.contains(IntTag(name: "Foo"))))

        // Remove non-/existing name
        #expect(!test.remove(forKey: "Bar"))
        #expect(test.remove(forKey: "Foo"))
        #expect(!test.remove(forKey: "Bar"))

        // Re-add object
        #expect(throws: Never.self) {
            try test.append(foo)
        }

        // Remove existing object
        #expect(try test.remove(foo))
        #expect(!(try test.remove(foo)))

        // Clear empty NbtCompound
        #expect(test.count == 0)
        test.removeAll()

        // Re-add after clearing
        #expect(throws: Never.self) {
            try test.append(foo)
        }
        #expect(test.count == 1)

        // Clear non-empty NbtCompound
        test.removeAll()
        #expect(test.count == 0)
    }

    @Test
    func testUtilityMethods() async throws {
        let testThings: [NBT] = [
            ShortTag(name: "Name1", 1),
            IntTag(name: "Name2", 2),
            LongTag(name: "Name3", 3)
        ]
        let compound = CompoundTag()

        // Add range
        #expect(throws: Never.self) {
            try compound.append(contentsOf: testThings)
        }

        // Add range with duplicates
        #expect(throws: (any Error).self) {
            try compound.append(contentsOf: testThings)
        }
    }

    @Test
    func testKeyDictionary() async throws {
        let compound = try CompoundTag([
            IntTag(name: "tag-a", 1),
            IntTag(name: "tag-b", 2),
        ])

        #expect(compound.names.sorted() == ["tag-a", "tag-b"])
        #expect(compound.tags.map{ $0.name! } == ["tag-a", "tag-b"])
        #expect(compound["tag-a"]?.intValue == 1)
        #expect(compound["tag-b"]?.intValue == 2)

        try compound.append(IntTag(name: "tag-c", 3))
        #expect(compound.names.sorted() == ["tag-a", "tag-b", "tag-c"])
        #expect(compound.tags.map{ $0.name! } == ["tag-a", "tag-b", "tag-c"])
        #expect(compound["tag-c"]?.intValue == 3)

        try compound.insert(IntTag(name: "tag-d", 4), at: 2)
        #expect(compound.names.sorted() == ["tag-a", "tag-b", "tag-c", "tag-d"])
        #expect(compound.tags.map{ $0.name! } == ["tag-a", "tag-b", "tag-d", "tag-c"])
        #expect(compound["tag-d"]?.intValue == 4)

        _ = compound.remove(forKey: "tag-d")
        #expect(compound.names.sorted() == ["tag-a", "tag-b", "tag-c"])
        #expect(compound.tags.map{ $0.name! } == ["tag-a", "tag-b", "tag-c"])
        #expect(compound["tag-d"] == nil)

        try compound.insert(IntTag(name: "tag-d", 4), at: 0)
        #expect(compound.names.sorted() == ["tag-a", "tag-b", "tag-c", "tag-d"])
        #expect(compound.tags.map{ $0.name! } == ["tag-d", "tag-a", "tag-b", "tag-c"])
        #expect(compound["tag-d"]?.intValue == 4)
    }
}
