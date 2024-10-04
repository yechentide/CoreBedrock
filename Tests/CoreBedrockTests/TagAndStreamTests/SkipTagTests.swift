//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct SkipTagTests {
    @Test
    func testSkippingTagsOnFileLoad() async throws {
        let loadedFile = NBTFile()
        loadedFile.littleEndian = false
        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            if tag.name != nil {
                return tag.name! == "nested compound test"
            }
            return false
        }
        #expect(!loadedFile.rootTag.contains("nested compound test"))
        #expect(loadedFile.rootTag.contains("listTest (long)"))

        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return tag.tagType == .float && (tag.parent != nil && tag.parent!.name != nil && tag.parent!.name! == "Level")
        }
        #expect(!loadedFile.rootTag.contains("floatTest"))
        #expect(loadedFile.rootTag["nested compound test"]?["ham"]?["value"]?.floatValue == Float(0.75))

        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return tag.name != nil && tag.name! == "listTest (long)"
        }
        #expect(!loadedFile.rootTag.contains("listTest (long"))
        #expect(loadedFile.rootTag.contains("byteTest"))

        _ = try loadedFile.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .none) { tag in
            return true // skips all tags
        }
        #expect(loadedFile.rootTag.count == 0)
    }

    @Test
    func testSkippingLists() async throws {
        var file = try NBTFile(rootTag: TestData.makeTestList())
        var savedFile = try file.saveToBuffer(compression: .none)
        _ =  try file.load(contentsOf: savedFile, compression: .none) { tag in
            return tag.tagType == .list
        }
        #expect(file.rootTag.count == 0)

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
        #expect(file.rootTag.count == 1)
    }

    @Test
    func testSkippingValuesInCompound() async throws {
        let root = try TestData.makeValueTest()
        let nestedComp = try TestData.makeValueTest()
        nestedComp.name = "NestedComp"
        try root.append(nestedComp)

        let file = try NBTFile(rootTag: root)
        let savedFile = try file.saveToBuffer(compression: .none)
        _ = try file.load(contentsOf: savedFile, compression: .none) { tag in
            return true // skip all tags
        }
        #expect(file.rootTag.count == 0)
    }
}
