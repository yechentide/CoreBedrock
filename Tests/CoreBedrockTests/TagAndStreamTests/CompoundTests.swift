import XCTest
@testable import CoreBedrock

class CompoundTests: XCTestCase {
    static var allTests = [
        ("testInitializingCompoundFromCollection", testInitializingCompoundFromCollection),
        ("testGettersAndSetters", testGettersAndSetters),
        ("testRenaming", testRenaming),
        ("testAddingAndRemoving", testAddingAndRemoving),
        ("testUtilityMethods", testUtilityMethods)
    ]
    
    func testInitializingCompoundFromCollection() throws {
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
        
        XCTAssertThrowsError(try CompoundTag(name: "someUnnamedTest", someUnnamed)) { error in
            XCTAssertEqual(error as? CBStreamError, CBStreamError.argumentError("Only named tags are allowed in Compound tags."))
        }
        XCTAssertThrowsError(try CompoundTag(name: "dupeNamesTest", dupeNames)) { error in
            XCTAssertEqual(error as? CBStreamError, CBStreamError.argumentError("A tag with the same name has already been added."))
        }
    }

    func testGettersAndSetters() throws {
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
        XCTAssertEqual(nestedChild, (parent["Child"] as! CompoundTag)["NestedChild"])
        XCTAssertEqual(nestedChildList, (parent["Child"] as! CompoundTag)["NestedChildList"])
        XCTAssertEqual(nestedInt, ((parent["Child"] as! CompoundTag)["NestedChildList"] as! ListTag)[0])
        
        // Accessing nested compound tags using get
        XCTAssertNil(parent.get("NonExistingChild"))
        XCTAssertNil(parent.get("NonExistingChild") as? CompoundTag)
        XCTAssertEqual(nestedChild, (parent.get("Child") as? CompoundTag)?.get("NestedChild"))
        XCTAssertEqual(nestedChild, (parent.get("Child") as? CompoundTag)?.get("NestedChild") as? CompoundTag)
        XCTAssertEqual(nestedChildList, (parent.get("Child") as? CompoundTag)?.get("NestedChildList"))
        XCTAssertEqual(nestedChildList, (parent.get("Child") as? CompoundTag)?.get("NestedChildList") as? ListTag)
        XCTAssertEqual(nestedInt, ((parent.get("Child") as? CompoundTag)?.get("NestedChildList") as? ListTag)?[0])

        // Accessing get with an invalid given type
        XCTAssertNil(parent.get("Child") as? IntTag)
        
        // Using get<T>
        var dummyTag: NBT?
        XCTAssertFalse(parent.get("NonExistingChild", result: &dummyTag))
        XCTAssertNil(dummyTag)
        XCTAssertTrue(parent.get("Child", result: &dummyTag))
        XCTAssertEqual(dummyTag, child)
        
        var dummyCompoundTag: CompoundTag?
        XCTAssertFalse(parent.get("NonExistingChild", result: &dummyCompoundTag))
        XCTAssertNil(dummyCompoundTag)
        XCTAssertTrue(parent.get("ChildList", result: &dummyCompoundTag))
        XCTAssertNil(dummyCompoundTag)
        XCTAssertTrue(parent.get("Child", result: &dummyCompoundTag))
        XCTAssertEqual(dummyCompoundTag, child)
        
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
        XCTAssertNil(parent.get("NonExistingTag"))
        XCTAssertNil(parent["NonExistingTag"])
        
        //
        // TODO: Enable these when Swift support throwing from subscripts
        //
        // Out-of-range indices on NbtList
        //XCTAssertThrowsError(nestedInt = childList[-1] as! NbtInt)
        //XCTAssertThrowsError(childList[-1] = NbtInt(1))
        XCTAssertThrowsError(nestedInt = try childList.get(at: -1) as! IntTag)
        //XCTAssertThrowsError(nestedInt = try childList[childList.count] as! NbtInt)
        XCTAssertThrowsError(nestedInt = try childList.get(at: childList.count) as! IntTag)
        
        // Using setter correctly
        XCTAssertNoThrow(parent["NewChild"] = ByteTag(name: "NewChild"))
        
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
    
    func testRenaming() throws {
        let tagToRename = IntTag(name: "DifferentName", 1)
        let compound = try CompoundTag([
            IntTag(name: "SameName", 1),
            tagToRename
        ])
        
        // Proper renaming, should not throw
        XCTAssertNoThrow(tagToRename.name = "SomeOtherName")
        
        // Attempting to use a duplicate name
        // ❌ XCTAssertThrowsError(tagToRename.name = "SameName")
        XCTAssertThrowsError(try compound.renameTag(
            oldName: tagToRename.name!, newName: "SameName"
        ))

        // Assigning a nil name to a tag inside a compound; should throw
        // ❌ XCTAssertThrowsError(tagToRename.name = nil)

        // Assigning a nil name to a tag that's been removed; should not throw
        _ = try compound.remove(tagToRename)
        XCTAssertNoThrow(tagToRename.name = nil)
    }
    
    func testAddingAndRemoving() throws {
        let foo = IntTag(name: "Foo")
        let test = try CompoundTag([
            foo
        ])
        
        // Add duplicate object
        XCTAssertThrowsError(try test.append(foo))
        
        // Add duplicate name
        XCTAssertThrowsError(try test.append(ByteTag(name: "Foo")))
        
        // Add unnamed tag
        XCTAssertThrowsError(try test.append(IntTag()))
        
        // Add tag to self
        XCTAssertThrowsError(try test.append(test))
        
        // Contains existing name/object
        XCTAssertTrue(test.contains("Foo"))
        XCTAssertTrue(try test.contains(foo))
        
        // Contains a non-existent name
        XCTAssertFalse(test.contains("Bar"))
        
        // Contains existing name/different objects
        XCTAssertFalse(try test.contains(IntTag(name: "Foo")))
        
        // Remove non-/existing name
        XCTAssertFalse(test.remove(forKey: "Bar"))
        XCTAssertTrue(test.remove(forKey: "Foo"))
        XCTAssertFalse(test.remove(forKey: "Bar"))
        
        // Re-add object
        XCTAssertNoThrow(try test.append(foo))
        
        // Remove existing object
        XCTAssertTrue(try test.remove(foo))
        XCTAssertFalse(try test.remove(foo))
        
        // Clear empty NbtCompound
        XCTAssertEqual(0, test.count)
        test.removeAll()
        
        // Re-add after clearing
        XCTAssertNoThrow(try test.append(foo))
        XCTAssertEqual(1, test.count)
        
        // Clear non-empty NbtCompound
        test.removeAll()
        XCTAssertEqual(0, test.count)
    }
    
    func testUtilityMethods() throws {
        let testThings: [NBT] = [
            ShortTag(name: "Name1", 1),
            IntTag(name: "Name2", 2),
            LongTag(name: "Name3", 3)
        ]
        let compound = CompoundTag()
        
        // Add range
        XCTAssertNoThrow(try compound.append(contentsOf: testThings))
        
        // Add range with duplicates
        XCTAssertThrowsError(try compound.append(contentsOf: testThings))
    }

    func testKeyDictionary() throws {
        let compound = try CompoundTag([
            IntTag(name: "tag-a", 1),
            IntTag(name: "tag-b", 2),
        ])

        XCTAssertEqual(["tag-a", "tag-b"], compound.names.sorted())
        XCTAssertEqual(["tag-a", "tag-b"], compound.tags.map{ $0.name! })
        XCTAssertEqual(1, compound["tag-a"]?.intValue)
        XCTAssertEqual(2, compound["tag-b"]?.intValue)

        try compound.append(IntTag(name: "tag-c", 3))
        XCTAssertEqual(["tag-a", "tag-b", "tag-c"], compound.names.sorted())
        XCTAssertEqual(["tag-a", "tag-b", "tag-c"], compound.tags.map{ $0.name! })
        XCTAssertEqual(3, compound["tag-c"]?.intValue)

        try compound.insert(IntTag(name: "tag-d", 4), at: 2)
        XCTAssertEqual(["tag-a", "tag-b", "tag-c", "tag-d"], compound.names.sorted())
        XCTAssertEqual(["tag-a", "tag-b", "tag-d", "tag-c"], compound.tags.map{ $0.name! })
        XCTAssertEqual(4, compound["tag-d"]?.intValue)

        _ = compound.remove(forKey: "tag-d")
        XCTAssertEqual(["tag-a", "tag-b", "tag-c"], compound.names.sorted())
        XCTAssertEqual(["tag-a", "tag-b", "tag-c"], compound.tags.map{ $0.name! })
        XCTAssertEqual(nil, compound["tag-d"])

        try compound.insert(IntTag(name: "tag-d", 4), at: 0)
        XCTAssertEqual(["tag-a", "tag-b", "tag-c", "tag-d"], compound.names.sorted())
        XCTAssertEqual(["tag-d", "tag-a", "tag-b", "tag-c"], compound.tags.map{ $0.name! })
        XCTAssertEqual(4, compound["tag-d"]?.intValue)
    }
}
