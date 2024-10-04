//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct NBTFileTests {
    private func setup() throws -> URL {
        let testDirName = "NBTFileTests_\(UUID().uuidString)"

        let testDir: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            testDir = FileManager.default.temporaryDirectory.appending(component: testDirName, directoryHint: .isDirectory)
        } else {
            testDir = FileManager.default.temporaryDirectory.appendingPathComponent(testDirName, isDirectory: true)
        }

        if FileManager.default.fileExists(atPath: testDir.path) {
            try FileManager.default.removeItem(at: testDir)
        }
        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true, attributes: nil)
        print("Created test dir at \(testDir.path()).")
        return testDir
    }

    private func cleanup(testDir: URL) throws {
        if FileManager.default.fileExists(atPath: testDir.path) {
            try FileManager.default.removeItem(at: testDir)
            print("Removed test dir at \(testDir.path()).")
        }
    }

    @Test
    func testLoadingSmallFileUncompressed() async throws {
        let url = try TestData.getFileUrl(file: .small, compression: .none)
        let file = try NBTFile(contentsOf: url, useLittleEndian: false)
        #expect(file.fileName != nil)
        #expect(file.fileName! == url.path)
        #expect(file.fileCompression == CBCompressionType.none)
        try TestData.assertNbtSmallFile(file)
    }

    @Test
    func testLoadingSmallFileGZip() async throws {
        let url = try TestData.getFileUrl(file: .small, compression: .gZip)
        let file = try NBTFile(contentsOf: url, useLittleEndian: false)
        #expect(file.fileName != nil)
        #expect(file.fileName! == url.path)
        #expect(file.fileCompression == CBCompressionType.gZip)
        try TestData.assertNbtSmallFile(file)
    }

    @Test
    func testLoadingSmallFileZLib() async throws {
        let url = try TestData.getFileUrl(file: .small, compression: .zLib)
        let file = try NBTFile(contentsOf: url, useLittleEndian: false)
        #expect(file.fileName != nil)
        #expect(file.fileName! == url.path)
        #expect(file.fileCompression == CBCompressionType.zLib)
        try TestData.assertNbtSmallFile(file)
    }

    @Test
    func testLoadingBigFileUncompressed() async throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        #expect(length == 1783)
    }

    @Test
    func testLoadingBigFileGZip() async throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .gZip), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        #expect(length == 1783)
    }

    @Test
    func testLoadingBigFileZLib() async throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .zLib), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        #expect(length == 1783)
    }

    @Test
    func testLoadingBigFileBuffer() async throws {
        let file = NBTFile(useLittleEndian: false)
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let length = try file.load(contentsOf: data, compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        #expect(length == 1783)
    }

    @Test
    func testSavingNbtSmallFileUncompressed() async throws {
        let testDir = try setup()
        let file = try TestData.makeSmallFile()
        let fileUrl = testDir.appendingPathComponent("test.nbt")
        let length = try file.save(to: fileUrl, compression: .none)
        let attr = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
        let fileSize = attr[FileAttributeKey.size] as! Int

        #expect(length == fileSize)
        try cleanup(testDir: testDir)
    }

    @Test
    func testReloadFile() async throws {
        let testDir = try setup()
        try reloadFileInteral(testDir, .big, .none, .none, false)
        try reloadFileInteral(testDir, .big, .gZip, .none, false)
        try reloadFileInteral(testDir, .big, .zLib, .none, false)
        try reloadFileInteral(testDir, .big, .none, .none, false)
        try reloadFileInteral(testDir, .big, .gZip, .none, false)
        try reloadFileInteral(testDir, .big, .zLib, .none, false)
        try cleanup(testDir: testDir)
    }

    private func reloadFileInteral(_ testDir: URL, _ file: TestFile, _ loadCompression: CBCompressionType, _ saveCompression: CBCompressionType, _ useLittleEndian: Bool) throws {
        let loadedFile = try NBTFile(contentsOf: TestData.getFileUrl(file: file, compression: loadCompression), useLittleEndian: useLittleEndian)
        let fileName = TestData.getFileName(file: file, compression: saveCompression)
        let bytesWritten = try loadedFile.save(to: testDir.appendingPathComponent(fileName), compression: saveCompression)
        let bytesRead = try loadedFile.load(contentsOf: testDir.appendingPathComponent(fileName), compression: .autoDetect)

        #expect(bytesWritten == bytesRead)
        try TestData.assertNbtBigFile(loadedFile)
    }

    @Test
    func testSaveToBuffer() async throws {
        var file = try TestData.makeBigFile()
        var buffer = Data()
        var length = try file.save(to: &buffer, compression: .none)
        #expect(TestData.getFileSize(file: .big) == length)

        file = try TestData.makeSmallFile()
        length = try file.save(to: &buffer, compression: .none)
        #expect(TestData.getFileSize(file: .small) == length)
    }

    @Test
    func testToString() async throws {
        let file = try NBTFile(contentsOf: TestData.getFileUrl(file: .big, compression: .none), useLittleEndian: false)
        #expect(file.rootTag.description == file.description)
        #expect(file.rootTag.toString(indentString: "   ") == file.toString(indentString: "   "))
    }

    @Test
    func testHugeNbt() async throws {
        let val = [UInt8](repeating: 0, count: 5 * 1024 * 1024)
        let root = try CompoundTag(name: "root", [
            ByteArrayTag(name: "payload1", val)
        ])
        let file = try NBTFile(rootTag: root, useLittleEndian: false)
        var buffer = Data()
        _ = try file.save(to: &buffer, compression: .none)
    }

    @Test
    func testRootTag() async throws {
        let oldRoot = CompoundTag(name: "defaultRoot")
        let newFile = try NBTFile(rootTag: oldRoot, useLittleEndian: false)
        #expect(throws: CBStreamError.argumentError("Root tag must be named.")) {
            try newFile.setRootTag(CompoundTag())
        }

        // Ensure that the root has not changed
        #expect(newFile.rootTag === oldRoot)

        // Invalid the root tag, and ensure that expected exception is thrown
        oldRoot.name = nil
        var buffer = Data()
        #expect(throws: CBStreamError.invalidFormat("Cannot save NBTFile: root tag is not named. Its name may be an empty string, but not nil.")) {
            try newFile.save(to: &buffer, compression: .none)
        }
    }
}
