//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
import CoreBedrock

enum TestFile {
    case small
    case big
    case nonUTF8(Int)
}

class TestData {
    static func makeSmallFile() throws -> NBTFile {
        let compoundTag = try CompoundTag(name: "hello world",
                                          [StringTag(name: "name", "Bananarama")])
        return try NBTFile(rootTag: compoundTag, useLittleEndian: false)
    }

    static func assertNbtSmallFile(_ file: NBTFile) throws {
        let root = file.rootTag
        #expect(root.name == "hello world")
        #expect(root.count == 1)

        #expect(root["name"] is StringTag)

        let node = root["name"] as! StringTag
        #expect(node.name == "name")
        #expect(node.value == "Bananarama")
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
            ]),
            useLittleEndian: false
        )
    }

    static func assertNbtBigFile(_ file: NBTFile)  throws {
        let root = file.rootTag
        #expect(root.name == "Level")
        #expect(root.count == 13)

        #expect(root["longTest"] is LongTag)
        var node = root["longTest"]!
        #expect(node.name == "longTest")
        #expect((node as! LongTag).value == Int64(9223372036854775807))

        #expect(root["shortTest"] is ShortTag)
        node = root["shortTest"]!
        #expect(node.name == "shortTest")
        #expect((node as! ShortTag).value == Int16(32767))

        #expect(root["stringTest"] is StringTag)
        node = root["stringTest"]!
        #expect(node.name == "stringTest")
        #expect((node as! StringTag).value == "HELLO WORLD THIS IS A TEST STRING ÅÄÖ!")

        #expect(root["floatTest"] is FloatTag)
        node = root["floatTest"]!
        #expect(node.name == "floatTest")
        #expect((node as! FloatTag).value == Float(0.4982315))

        #expect(root["intTest"] is IntTag)
        node = root["intTest"]!
        #expect(node.name == "intTest")
        #expect((node as! IntTag).value == Int32(2147483647))

        #expect(root["nested compound test"] is CompoundTag)
        let compoundNode = root["nested compound test"] as! CompoundTag
        #expect(compoundNode.name == "nested compound test")
        #expect(compoundNode.count == 2)

        // First nested test
        #expect(compoundNode["ham"] is CompoundTag)
        var subNode = compoundNode["ham"] as! CompoundTag
        #expect(subNode.name == "ham")
        #expect(subNode.count == 2)

        // Checking sub node values
        #expect(subNode["name"] is StringTag)
        #expect(subNode["name"]!.name == "name")
        #expect((subNode["name"] as! StringTag).value == "Hampus")

        #expect(subNode["value"] is FloatTag)
        #expect(subNode["value"]!.name == "value")
        #expect((subNode["value"] as! FloatTag).value == Float(0.75))
        // End sub node

        // Second nested test
        #expect(compoundNode["egg"] is CompoundTag)
        subNode = compoundNode["egg"] as! CompoundTag
        #expect(subNode.name == "egg")
        #expect(subNode.count == 2)

        // Checking sub node values
        #expect(subNode["name"] is StringTag)
        #expect(subNode["name"]!.name == "name")
        #expect((subNode["name"] as! StringTag).value == "Eggbert")

        #expect(subNode["value"] is FloatTag)
        #expect(subNode["value"]!.name == "value")
        #expect((subNode["value"] as! FloatTag).value == Float(0.5))
        // End sub node

        #expect(root["listTest (long)"] is ListTag)
        var listNode = root["listTest (long)"] as! ListTag
        #expect(listNode.name == "listTest (long)")
        #expect(listNode.count == 5)

        // The values should be: 11, 12, 13, 14, 15
        for i in 0..<listNode.count {
            #expect(listNode[i] is LongTag)
            #expect(listNode[i].name == nil)
            #expect((listNode[i] as! LongTag).value == Int64(i + 11))
        }

        #expect(root["listTest (compound)"] is ListTag)
        listNode = root["listTest (compound)"] as! ListTag
        #expect(listNode.name == "listTest (compound)")
        #expect(listNode.count == 2)

        // First Sub Node
        #expect(listNode[0] is CompoundTag)
        subNode = listNode[0] as! CompoundTag

        // First node in sub node
        #expect(subNode["name"] is StringTag)
        #expect(subNode["name"]!.name == "name")
        #expect((subNode["name"] as! StringTag).value == "Compound tag #0")

        // Second node in sub node
        #expect(subNode["created-on"] is LongTag)
        #expect(subNode["created-on"]!.name == "created-on")
        #expect((subNode["created-on"] as! LongTag).value == 1264099775885)

        // Second Sub Node
        #expect(listNode[1] is CompoundTag)
        subNode = listNode[1] as! CompoundTag

        // First node in sub node
        #expect(subNode["name"] is StringTag)
        #expect(subNode["name"]!.name == "name")
        #expect((subNode["name"] as! StringTag).value == "Compound tag #1")

        // Second node in sub node
        #expect(subNode["created-on"] is LongTag)
        #expect(subNode["created-on"]!.name == "created-on")
        #expect((subNode["created-on"] as! LongTag).value == 1264099775885)

        #expect(root["byteTest"] is ByteTag)
        node = root["byteTest"]!
        #expect(node.name == "byteTest")
        #expect((node as! ByteTag).value == UInt8(127))

        let byteArrayName = "byteArrayTest (the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...))"
        #expect(root[byteArrayName] is ByteArrayTag)
        node = root[byteArrayName]!
        #expect(node.name == byteArrayName)
        #expect((node as! ByteArrayTag).value.count == 1000)
        // Values are: the first 1000 values of (n*n*255+n*7)%100, starting with n=0 (0, 62, 34, 16, 8, ...)
        for n in 0..<1000 {
            #expect((node as! ByteArrayTag)[n] == UInt8((n*n*255 + n*7)%100))
        }

        #expect(root["doubleTest"] is DoubleTag)
        node = root["doubleTest"]!
        #expect(node.name == "doubleTest")
        #expect((node as! DoubleTag).value == 0.493128713218231)

        #expect(root["intArrayTest"] is IntArrayTag)
        let intArrayTag = root.get("intArrayTest") as! IntArrayTag
        #expect(intArrayTag != nil)
        let intArrayValues: [Int32] = [2058486330, 689588807, 591140869, 1039519385, 1050801872, 1120424277, 436948408, 1022844073, 1164321124, 1667817685]
        #expect(intArrayValues.count == intArrayTag.value.count)
        for i in 0..<intArrayValues.count {
            #expect(intArrayTag.value[i] == intArrayValues[i])
        }

        #expect(root["longArrayTest"] is LongArrayTag)
        let longArrayTag = root.get("longArrayTest") as! LongArrayTag
        #expect(longArrayTag != nil)
        let longArrayValues: [Int64] = [-6866598452151144177, -1461874943718568068, 5217825863610607223, 1860859988227119473, -5776759366968858117, -7740952930289281811, -6188853534200571741, 4318246429499846831, -47296042280759594, -3674987599896452234, -7226131946019043057, -4289962655585463703, -995980216626770396, -3604406255970428456, 5689530171199932158, 2743453607135376494, 9105486958483704041, -8207372937485762308, 5515722376825306945, -1410484250696471474]
        #expect(longArrayValues.count == longArrayTag.value.count)
        for i in 0..<longArrayValues.count {
            #expect(longArrayTag.value[i] == longArrayValues[i])
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
        ]), useLittleEndian: false)
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
        #expect(root.name == "root")
        #expect(root.count == 10)

        #expect(root["byte"] is ByteTag)
        var node = root["byte"]!
        #expect(node.name == "byte")
        #expect((node as! ByteTag).value == 1)

        #expect(root["short"] is ShortTag)
        node = root["short"]!
        #expect(node.name == "short")
        #expect((node as! ShortTag).value == 2)

        #expect(root["int"] is IntTag)
        node = root["int"]!
        #expect(node.name == "int")
        #expect((node as! IntTag).value == 3)

        #expect(root["long"] is LongTag)
        node = root["long"]!
        #expect(node.name == "long")
        #expect((node as! LongTag).value == 4)

        #expect(root["float"] is FloatTag)
        node = root["float"]!
        #expect(node.name == "float")
        #expect((node as! FloatTag).value == 5)

        #expect(root["double"] is DoubleTag)
        node = root["double"]!
        #expect(node.name == "double")
        #expect((node as! DoubleTag).value == 6)

        #expect(root["byteArray"] is ByteArrayTag)
        node = root["byteArray"]!
        #expect(node.name == "byteArray")
        #expect((node as! ByteArrayTag).value == [UInt8]([10, 11, 12]))

        #expect(root["intArray"] is IntArrayTag)
        node = root["intArray"]!
        #expect(node.name == "intArray")
        #expect((node as! IntArrayTag).value == [Int32]([20, 21, 22]))

        #expect(root["longArray"] is LongArrayTag)
        node = root["longArray"]!
        #expect(node.name == "longArray")
        #expect((node as! LongArrayTag).value == [Int64]([30, 31, 32]))

        #expect(root["string"] is StringTag)
        node = root["string"]!
        #expect(node.name == "string")
        #expect((node as! StringTag).value == "123")
    }

    static func getFileName(file: TestFile, compression: CBCompressionType) -> String {
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

    static func getFileUrl(file: TestFile, compression: CBCompressionType) throws -> URL {
        let fileName = getFileName(file: file, compression: compression)
        let url = Bundle.module.url(forResource: fileName, withExtension: nil)
        precondition(url != nil, "Can't find file.")
        return url!
    }

    static func getFileData(file: TestFile, compression: CBCompressionType) throws -> Data {
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
