import XCTest
@testable import CoreBedrock

class NBTFileTests: XCTestCase {
    let testDirName = "NBTFileTests"
    var testDir: URL?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NBTFile.littleEndianByDefault = false
        
        let bundle = Bundle(for: Self.self)
        testDir = bundle.resourceURL!.appendingPathComponent(testDirName, isDirectory: true)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: testDir!.path){
            try fileManager.createDirectory(at: testDir!, withIntermediateDirectories: true, attributes: nil)
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        if testDir != nil {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: testDir!.path) {
                try fileManager.removeItem(at: testDir!)
            }
        }
    }
    
    func testLoadingSmallFileUncompressed() throws {
        let url = try TestData.getFileUrl(file: .small, compression: .none)
        let file = try NBTFile(contentsOf: url)
        XCTAssertNotNil(file.fileName)
        XCTAssertEqual(url.path, file.fileName!)
        XCTAssertEqual(CBCompressionType.none, file.fileCompression)
        try TestData.assertNbtSmallFile(file)
    }

    func testLoadingSmallFileGZip() throws {
        let url = try TestData.getFileUrl(file: .small, compression: .gZip)
        let file = try NBTFile(contentsOf: url)
        XCTAssertNotNil(file.fileName)
        XCTAssertEqual(url.path, file.fileName!)
        XCTAssertEqual(CBCompressionType.gZip, file.fileCompression)
        try TestData.assertNbtSmallFile(file)
    }
    
    func testLoadingSmallFileZLib() throws {
        let url = try TestData.getFileUrl(file: .small, compression: .zLib)
        let file = try NBTFile(contentsOf: url)
        XCTAssertNotNil(file.fileName)
        XCTAssertEqual(url.path, file.fileName!)
        XCTAssertEqual(CBCompressionType.zLib, file.fileCompression)
        try TestData.assertNbtSmallFile(file)
    }
    
    func testLoadingBigFileUncompressed() throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .none), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        XCTAssertEqual(length, 1783)
    }

    func testLoadingBigFileGZip() throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .gZip), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        XCTAssertEqual(length, 1783)
    }
    
    func testLoadingBigFileZLib() throws {
        let file = NBTFile(useLittleEndian: false)
        let length = try file.load(contentsOf: TestData.getFileUrl(file: .big, compression: .zLib), compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        XCTAssertEqual(length, 1783)
    }
    
    func testLoadingBigFileBuffer() throws {
        let file = NBTFile(useLittleEndian: false)
        let url = try TestData.getFileUrl(file: .big, compression: .none)
        let data = try Data(contentsOf: url)
        let length = try file.load(contentsOf: data, compression: .autoDetect)
        try TestData.assertNbtBigFile(file)
        XCTAssertEqual(length, 1783)
    }

    func testSavingNbtSmallFileUncompressed() throws {
        let file = try TestData.makeSmallFile()
        let fileUrl = testDir!.appendingPathComponent("test.nbt")
        let length = try file.save(to: fileUrl, compression: .none)
        let attr = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
        let fileSize = attr[FileAttributeKey.size] as! Int
        
        XCTAssertEqual(length, fileSize)
    }

    func testReloadFile() throws {
        try reloadFileInteral(.big, .none, .none, false)
        try reloadFileInteral(.big, .gZip, .none, false)
        try reloadFileInteral(.big, .zLib, .none, false)
        try reloadFileInteral(.big, .none, .none, false)
        try reloadFileInteral(.big, .gZip, .none, false)
        try reloadFileInteral(.big, .zLib, .none, false)
    }
    
    func reloadFileInteral(_ file: TestFile, _ loadCompression: CBCompressionType, _ saveCompression: CBCompressionType, _ useLittleEndian: Bool) throws {
        NBTFile.littleEndianByDefault = useLittleEndian
        let loadedFile = try NBTFile(contentsOf: TestData.getFileUrl(file: file, compression: loadCompression))
        let fileName = TestData.getFileName(file: file, compression: saveCompression)
        let bytesWritten = try loadedFile.save(to: testDir!.appendingPathComponent(fileName), compression: saveCompression)
        let bytesRead = try loadedFile.load(contentsOf: testDir!.appendingPathComponent(fileName), compression: .autoDetect)
        
        XCTAssertEqual(bytesWritten, bytesRead)
        try TestData.assertNbtBigFile(loadedFile)
    }
    
    func testSaveToBuffer() throws {
        var file = try TestData.makeBigFile()
        var buffer = Data()
        var length = try file.save(to: &buffer, compression: .none)
        XCTAssertEqual(length, TestData.getFileSize(file: .big))
        
        file = try TestData.makeSmallFile()
        length = try file.save(to: &buffer, compression: .none)
        XCTAssertEqual(length, TestData.getFileSize(file: .small))
    }
    
    func testToString() throws {
        let file = try NBTFile(contentsOf: TestData.getFileUrl(file: .big, compression: .none))
        XCTAssertEqual(file.rootTag.description, file.description)
        XCTAssertEqual(file.rootTag.toString(indentString: "   "), file.toString(indentString: "   "))
    }
    
    func testHugeNbt() throws {
        let val = [UInt8](repeating: 0, count: 5 * 1024 * 1024)
        let root = try CompoundTag(name: "root", [
            ByteArrayTag(name: "payload1", val)
        ])
        let file = try NBTFile(rootTag: root)
        var buffer = Data()
        _ = try file.save(to: &buffer, compression: .none)
    }
    
    func testRootTag() throws {
        let oldRoot = CompoundTag(name: "defaultRoot")
        let newFile = try NBTFile(rootTag: oldRoot)
        XCTAssertThrowsError(try newFile.setRootTag(CompoundTag())) { error in
            XCTAssertEqual(error as! CBStreamError, CBStreamError.argumentError("Root tag must be named."))
        }
        
        // Ensure that the root has not changed
        XCTAssert(oldRoot === newFile.rootTag)
        
        // Invalid the root tag, and ensure that expected exception is thrown
        oldRoot.name = nil
        var buffer = Data()
        XCTAssertThrowsError(try newFile.save(to: &buffer, compression: .none)) { error in
            XCTAssertEqual(error as? CBStreamError, CBStreamError.invalidFormat("Cannot save NBTFile: root tag is not named. Its name may be an empty string, but not nil."))
        }
    }
}
