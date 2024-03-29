import XCTest
@testable import CoreBedrock

class SkipTagTests: XCTestCase {
    func testSkippingTagsOnFileLoad() throws {
        let loadedFile = NBTFile()
        loadedFile.littleEndian = false
        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            if tag.name != nil {
                return tag.name! == "nested compound test"
            }
            return false
        }
        XCTAssertFalse(loadedFile.rootTag.contains("nested compound test"))
        XCTAssertTrue(loadedFile.rootTag.contains("listTest (long)"))
        
        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return tag.tagType == .float && (tag.parent != nil && tag.parent!.name != nil && tag.parent!.name! == "Level")
        }
        XCTAssertFalse(loadedFile.rootTag.contains("floatTest"))
        XCTAssertEqual(Float(0.75), loadedFile.rootTag["nested compound test"]?["ham"]?["value"]?.floatValue)
        
        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return tag.name != nil && tag.name! == "listTest (long)"
        }
        XCTAssertFalse(loadedFile.rootTag.contains("listTest (long"))
        XCTAssertTrue(loadedFile.rootTag.contains("byteTest"))
        
        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return true // skips all tags
        }
        XCTAssertEqual(0, loadedFile.rootTag.count)
    }
    
    func testSkippingLists() throws {
        var file = try NBTFile(rootTag: TestData.makeTestList())
        var savedFile = try file.saveToBuffer(compression: .none)
        _ =  try file.load(contentsOf: savedFile, compression: .none) { tag in
            return tag.tagType == .list
        }
        XCTAssertEqual(0, file.rootTag.count)
        
        // Check list-compound interaction
        let comp = try CompoundTag(name: "root", [
            CompoundTag(name: "compOfLists", [
                ListTag(name: "listOfComps", [
                    CompoundTag([
                        ListTag(name: "emptyList", listType: .compound)
                    ])
                ])
            ])
        ])
        file = try NBTFile(rootTag: comp)
        savedFile = try file.saveToBuffer(compression: .none)
        _ = try file.load(contentsOf: savedFile, compression: .none) { tag in
            return tag.tagType == .list
        }
        XCTAssertEqual(1, file.rootTag.count)
    }
    
    func testSkippingValuesInCompound() throws {
        let root = try TestData.makeValueTest()
        let nestedComp = try TestData.makeValueTest()
        nestedComp.name = "NestedComp"
        try root.append(nestedComp)
        
        let file = try NBTFile(rootTag: root)
        let savedFile = try file.saveToBuffer(compression: .none)
        _ = try file.load(contentsOf: savedFile, compression: .none) { tag in
            return true // skip all tags
        }
        XCTAssertEqual(0, file.rootTag.count)
    }
}

