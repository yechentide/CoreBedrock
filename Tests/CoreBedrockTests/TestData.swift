import XCTest
@testable import CoreBedrock

enum TestFile {
    case small
    case big
    case nonUTF8(Int)
}

class TestData {
    static func makeSmallFile() throws -> NBTFile {
        let compoundTag = try CompoundTag(name: "hello world",
                                      [StringTag(name: "name", "Bananarama")])
        return try NBTFile(rootTag: compoundTag)
    }
    
    static func assertNbtSmallFile(_ file: NBTFile) throws {
        let root = file.rootTag
        XCTAssertEqual("hello world", root.name)
        XCTAssertEqual(1, root.count)
        
        XCTAssert(root["name"] is StringTag)
        
        let node = root["name"] as! StringTag
        XCTAssertEqual("name", node.name)
        XCTAssertEqual("Bananarama", node.value)
    }
    
    static func makeBigFile() throws -> NBTFile {
        let byteArrayName = "byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"
        var byteArray: [UInt8] = []
        for n in 0..<1000 {
            let byte = UInt8(  (n*n*255 + n*7) % 100  )
            byteArray.append(byte)
        }
        
        return try NBTFile(
            rootTag: CompoundTag(name: "Level", [
                LongTag(name: "longTest", 9223372036854775807),
                ShortTag(name: "shortTest", 32767),
                StringTag(name: "stringTest", "HELLO WORLD THIS IS A TEST STRING ÅÄÖ!"),
                FloatTag(name: "floatTest", 0.4982315),
                IntTag(name: "intTest", 2147483647),
                CompoundTag(name: "nested compound test", [
                    CompoundTag(name: "ham", [
                        StringTag(name: "name", "Hampus"),
                        FloatTag(name: "value", 0.75)
                    ]),
                    CompoundTag(name: "egg", [
                        StringTag(name: "name", "Eggbert"),
                        FloatTag(name: "value", 0.5)
                    ])
                ]),
                ListTag(name: "listTest (long)", [
                    LongTag(11),
                    LongTag(12),
                    LongTag(13),
                    LongTag(14),
                    LongTag(15)
                ]),
                ListTag(name: "listTest (compound)", [
                    CompoundTag([
                        StringTag(name: "name", "Compound tag #0"),
                        LongTag(name: "created-on", 1264099775885)
                    ]),
                    CompoundTag([
                        StringTag(name: "name", "Compound tag #1"),
                        LongTag(name: "created-on", 1264099775885)
                    ])
                ]),
                ByteTag(name: "byteTest", 127),
                ByteArrayTag(name: byteArrayName, byteArray),
                DoubleTag(name: "doubleTest", 0.493128713218231),
                IntArrayTag(name: "intArrayTest", [ 2058486330, 689588807, 591140869, 1039519385, 1050801872, 1120424277, 436948408, 1022844073, 1164321124, 1667817685 ]),
                LongArrayTag(name: "longArrayTest", [ -6866598452151144177, -1461874943718568068, 5217825863610607223, 1860859988227119473, -5776759366968858117, -7740952930289281811, -6188853534200571741, 4318246429499846831, -47296042280759594, -3674987599896452234, -7226131946019043057, -4289962655585463703, -995980216626770396, -3604406255970428456, 5689530171199932158, 2743453607135376494, 9105486958483704041, -8207372937485762308, 5515722376825306945, -1410484250696471474 ])
            ])
        )
    }
    
    static func assertNbtBigFile(_ file: NBTFile)  throws {
        let root = file.rootTag
        XCTAssertEqual("Level", root.name)
        XCTAssertEqual(13, root.count)
        
        XCTAssert(root["longTest"] is LongTag)
        var node = root["longTest"]!
        XCTAssertEqual("longTest", node.name)
        XCTAssertEqual(Int64(9223372036854775807), (node as! LongTag).value)
        
        XCTAssert(root["shortTest"] is ShortTag)
        node = root["shortTest"]!
        XCTAssertEqual("shortTest", node.name)
        XCTAssertEqual(Int16(32767), (node as! ShortTag).value)
        
        XCTAssert(root["stringTest"] is StringTag)
        node = root["stringTest"]!
        XCTAssertEqual("stringTest", node.name)
        XCTAssertEqual("HELLO WORLD THIS IS A TEST STRING ÅÄÖ!", (node as! StringTag).value)
        
        XCTAssert(root["floatTest"] is FloatTag)
        node = root["floatTest"]!
        XCTAssertEqual("floatTest", node.name)
        XCTAssertEqual(Float(0.4982315), (node as! FloatTag).value)
        
        XCTAssert(root["intTest"] is IntTag)
        node = root["intTest"]!
        XCTAssertEqual("intTest", node.name)
        XCTAssertEqual(Int32(2147483647), (node as! IntTag).value)
        
        XCTAssert(root["nested compound test"] is CompoundTag)
        let compoundNode = root["nested compound test"] as! CompoundTag
        XCTAssertEqual("nested compound test", compoundNode.name)
        XCTAssertEqual(2, compoundNode.count)
        
        // First nested test
        XCTAssert(compoundNode["ham"] is CompoundTag)
        var subNode = compoundNode["ham"] as! CompoundTag
        XCTAssertEqual("ham", subNode.name)
        XCTAssertEqual(2, subNode.count)
        
        // Checking sub node values
        XCTAssert(subNode["name"] is StringTag)
        XCTAssertEqual("name", subNode["name"]!.name)
        XCTAssertEqual("Hampus", (subNode["name"] as! StringTag).value)
        
        XCTAssert(subNode["value"] is FloatTag)
        XCTAssertEqual("value", subNode["value"]!.name)
        XCTAssertEqual(Float(0.75), (subNode["value"] as! FloatTag).value)
        // End sub node
        
        // Second nested test
        XCTAssert(compoundNode["egg"] is CompoundTag)
        subNode = compoundNode["egg"] as! CompoundTag
        XCTAssertEqual("egg", subNode.name)
        XCTAssertEqual(2, subNode.count)
        
        // Checking sub node values
        XCTAssert(subNode["name"] is StringTag)
        XCTAssertEqual("name", subNode["name"]!.name)
        XCTAssertEqual("Eggbert", (subNode["name"] as! StringTag).value)
        
        XCTAssert(subNode["value"] is FloatTag)
        XCTAssertEqual("value", subNode["value"]!.name)
        XCTAssertEqual(Float(0.5), (subNode["value"] as! FloatTag).value)
        // End sub node
        
        XCTAssert(root["listTest (long)"] is ListTag)
        var listNode = root["listTest (long)"] as! ListTag
        XCTAssertEqual("listTest (long)", listNode.name)
        XCTAssertEqual(5, listNode.count)
        
        // The values should be: 11, 12, 13, 14, 15
        for i in 0..<listNode.count {
            XCTAssert(listNode[i] is LongTag)
            XCTAssertEqual(nil, listNode[i].name)
            XCTAssertEqual(Int64(i + 11), (listNode[i] as! LongTag).value)
        }
        
        XCTAssert(root["listTest (compound)"] is ListTag)
        listNode = root["listTest (compound)"] as! ListTag
        XCTAssertEqual("listTest (compound)", listNode.name)
        XCTAssertEqual(2, listNode.count)
        
        // First Sub Node
        XCTAssert(listNode[0] is CompoundTag)
        subNode = listNode[0] as! CompoundTag
        
        // First node in sub node
        XCTAssert(subNode["name"] is StringTag)
        XCTAssertEqual("name", subNode["name"]!.name)
        XCTAssertEqual("Compound tag #0", (subNode["name"] as! StringTag).value)
        
        // Second node in sub node
        XCTAssert(subNode["created-on"] is LongTag)
        XCTAssertEqual("created-on", subNode["created-on"]!.name)
        XCTAssertEqual(1264099775885, (subNode["created-on"] as! LongTag).value)
        
        // Second Sub Node
        XCTAssert(listNode[1] is CompoundTag)
        subNode = listNode[1] as! CompoundTag
        
        // First node in sub node
        XCTAssert(subNode["name"] is StringTag)
        XCTAssertEqual("name", subNode["name"]!.name)
        XCTAssertEqual("Compound tag #1", (subNode["name"] as! StringTag).value)
        
        // Second node in sub node
        XCTAssert(subNode["created-on"] is LongTag)
        XCTAssertEqual("created-on", subNode["created-on"]!.name)
        XCTAssertEqual(1264099775885, (subNode["created-on"] as! LongTag).value)
        
        XCTAssert(root["byteTest"] is ByteTag)
        node = root["byteTest"]!
        XCTAssertEqual("byteTest", node.name)
        XCTAssertEqual(UInt8(127), (node as! ByteTag).value)
        
        let byteArrayName = "byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"
        XCTAssert(root[byteArrayName] is ByteArrayTag)
        node = root[byteArrayName]!
        XCTAssertEqual(byteArrayName, node.name)
        XCTAssertEqual(1000, (node as! ByteArrayTag).value.count)
        // Values are: the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...)
        for n in 0..<1000 {
            XCTAssertEqual(UInt8((n*n*255 + n*7)%100), (node as! ByteArrayTag)[n])
        }
        
        XCTAssert(root["doubleTest"] is DoubleTag)
        node = root["doubleTest"]!
        XCTAssertEqual("doubleTest", node.name)
        XCTAssertEqual(0.493128713218231, (node as! DoubleTag).value)
        
        XCTAssert(root["intArrayTest"] is IntArrayTag)
        let intArrayTag = root.get("intArrayTest") as! IntArrayTag
        XCTAssertNotNil(intArrayTag)
        let intArrayValues: [Int32] = [2058486330, 689588807, 591140869, 1039519385, 1050801872, 1120424277, 436948408, 1022844073, 1164321124, 1667817685]
        XCTAssertEqual(intArrayTag.value.count, intArrayValues.count)
        for i in 0..<intArrayValues.count {
            XCTAssertEqual(intArrayValues[i], intArrayTag.value[i])
        }
        
        XCTAssert(root["longArrayTest"] is LongArrayTag)
        let longArrayTag = root.get("longArrayTest") as! LongArrayTag
        XCTAssertNotNil(longArrayTag)
        let longArrayValues: [Int64] = [-6866598452151144177, -1461874943718568068, 5217825863610607223, 1860859988227119473, -5776759366968858117, -7740952930289281811, -6188853534200571741, 4318246429499846831, -47296042280759594, -3674987599896452234, -7226131946019043057, -4289962655585463703, -995980216626770396, -3604406255970428456, 5689530171199932158, 2743453607135376494, 9105486958483704041, -8207372937485762308, 5515722376825306945, -1410484250696471474]
        XCTAssertEqual(longArrayTag.value.count, longArrayValues.count)
        for i in 0..<longArrayValues.count {
            XCTAssertEqual(longArrayValues[i], longArrayTag.value[i])
        }
    }
    
    static func makeTestList() throws -> CompoundTag {
        return try CompoundTag(name: "Root", [
            ListTag(name: "ByteList", [
                ByteTag(100),
                ByteTag(20),
                ByteTag(3)
            ]),
            ListTag(name: "DoubleList", [
                DoubleTag(1),
                DoubleTag(2000),
                DoubleTag(-3000000)
            ]),
            ListTag(name: "FloatList", [
                FloatTag(1),
                FloatTag(2000),
                FloatTag(-3000000)
            ]),
            ListTag(name: "IntList", [
                IntTag(1),
                IntTag(2000),
                IntTag(-3000000)
            ]),
            ListTag(name: "LongList", [
                LongTag(1),
                LongTag(2000),
                LongTag(-3000000)
            ]),
            ListTag(name: "ShortList", [
                ShortTag(1),
                ShortTag(200),
                ShortTag(-30000)
            ]),
            ListTag(name: "StringList", [
                StringTag("one"),
                StringTag("two thousand"),
                StringTag("negative three million")
            ]),
            ListTag(name: "CompoundList", [
                CompoundTag(),
                CompoundTag(),
                CompoundTag()
            ]),
            ListTag(name: "ListList", [
                ListTag(listType: .list),
                ListTag(listType: .list),
                ListTag(listType: .list)
            ]),
            ListTag(name: "ByteArrayList", [
                ByteArrayTag([1, 2, 3]),
                ByteArrayTag([11, 12, 13]),
                ByteArrayTag([21, 22, 23])
            ]),
            ListTag(name: "IntArrayList", [
                IntArrayTag([1, -2, 3]),
                IntArrayTag([1000, -2000, 3000]),
                IntArrayTag([1000000, -2000000, 3000000])
            ]),
            ListTag(name: "LongArrayList", [
                LongArrayTag([1, -2, 3]),
                LongArrayTag([1000, -2000, 3000]),
                LongArrayTag([1000000, -2000000, 3000000])
            ])
        ])
    }
    
    static func makeReaderTest() throws -> CBBuffer {
        let file = try NBTFile(rootTag: CompoundTag(name: "root", [
            IntTag(name: "first"),
            IntTag(name: "second"),
            CompoundTag(name: "third-comp", [
                IntTag(name: "inComp1"),
                IntTag(name: "inComp2"),
                IntTag(name: "inComp3")
            ]),
            ListTag(name: "fourth-list", [
                ListTag([
                    CompoundTag([
                        CompoundTag(name: "inList1")
                    ])
                ]),
                ListTag([
                    CompoundTag([
                        CompoundTag(name: "inList2")
                    ])
                ]),
                ListTag([
                    CompoundTag([
                        CompoundTag(name: "inList3")
                    ])
                ])
            ]),
            IntTag(name: "fifth"),
            ByteArrayTag(name: "hugeArray", [UInt8](repeating: 0, count: 1024*1024))
        ]))
        var buffer = Data()
        _ = try file.save(to: &buffer, compression: .none)
        return CBBuffer(buffer)
    }
    
    static func makeValueTest() throws -> CompoundTag {
        return try CompoundTag(name: "root", [
            ByteTag(name: "byte", 1),
            ShortTag(name: "short", 2),
            IntTag(name: "int", 3),
            LongTag(name: "long", 4),
            FloatTag(name: "float", 5),
            DoubleTag(name: "double", 6),
            ByteArrayTag(name: "byteArray", [10, 11, 12]),
            IntArrayTag(name: "intArray", [20, 21, 22]),
            LongArrayTag(name: "longArray", [30, 31, 32]),
            StringTag(name: "string", "123")
        ])
    }
    
    static func assertValueTest(_ file: NBTFile) throws {
        let root = file.rootTag
        XCTAssertEqual("root", root.name)
        XCTAssertEqual(10, root.count)
        
        XCTAssert(root["byte"] is ByteTag)
        var node = root["byte"]!
        XCTAssertEqual("byte", node.name)
        XCTAssertEqual(1, (node as! ByteTag).value)
        
        XCTAssert(root["short"] is ShortTag)
        node = root["short"]!
        XCTAssertEqual("short", node.name)
        XCTAssertEqual(2, (node as! ShortTag).value)
        
        XCTAssert(root["int"] is IntTag)
        node = root["int"]!
        XCTAssertEqual("int", node.name)
        XCTAssertEqual(3, (node as! IntTag).value)
        
        XCTAssert(root["long"] is LongTag)
        node = root["long"]!
        XCTAssertEqual("long", node.name)
        XCTAssertEqual(4, (node as! LongTag).value)
        
        XCTAssert(root["float"] is FloatTag)
        node = root["float"]!
        XCTAssertEqual("float", node.name)
        XCTAssertEqual(5, (node as! FloatTag).value)
        
        XCTAssert(root["double"] is DoubleTag)
        node = root["double"]!
        XCTAssertEqual("double", node.name)
        XCTAssertEqual(6, (node as! DoubleTag).value)
        
        XCTAssert(root["byteArray"] is ByteArrayTag)
        node = root["byteArray"]!
        XCTAssertEqual("byteArray", node.name)
        XCTAssertEqual([UInt8]([10, 11, 12]), (node as! ByteArrayTag).value)
        
        XCTAssert(root["intArray"] is IntArrayTag)
        node = root["intArray"]!
        XCTAssertEqual("intArray", node.name)
        XCTAssertEqual([Int32]([20, 21, 22]), (node as! IntArrayTag).value)
        
        XCTAssert(root["longArray"] is LongArrayTag)
        node = root["longArray"]!
        XCTAssertEqual("longArray", node.name)
        XCTAssertEqual([Int64]([30, 31, 32]), (node as! LongArrayTag).value)
        
        XCTAssert(root["string"] is StringTag)
        node = root["string"]!
        XCTAssertEqual("string", node.name)
        XCTAssertEqual("123", (node as! StringTag).value)
    }
    
    static func getFileName(file: TestFile, compression: CBCompression) -> String {
        var fileName = ""
        
        switch file {
        case .small:
            fileName.append("test")
        case .big:
            fileName.append("bigtest")
        case .nonUTF8(let index):
            fileName.append("actorprefix\(index)")
        }
        
        switch compression {
        case .none:
            fileName.append(".nbt")
        case .gZip:
            fileName.append(".nbt.gz")
        case .zLib:
            fileName.append(".nbt.z")
        default:
            fileName.append(".nbt")
        }
        
        return fileName
    }
    
    static func getFileUrl(file: TestFile, compression: CBCompression) throws -> URL {
        let fileName = getFileName(file: file, compression: compression)
        let url = Bundle.module.url(forResource: fileName, withExtension: nil)
        precondition(url != nil, "Can't find file.")
        return url!
    }
    
    static func getFileData(file: TestFile, compression: CBCompression) throws -> Data {
        let url = try getFileUrl(file: file, compression: compression)
        let data = try Data(contentsOf: url)
        return data
    }
    
    /// Gets the size of the uncompressed file in bytes.
    static func getFileSize(file: TestFile) -> Int {
        switch file{
        case .small:
            return 34
        case .big:
            return 1783
        case .nonUTF8:
            return 767
        }
    }
}

