//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
@testable import CoreBedrock

struct URLTests {
    let testURL = URL(fileURLWithPath: "/path/to/test")
    let testDirectory = URL(fileURLWithPath: "/path/to/directory")

    @Test
    func testSafePath() throws {
        let path = testURL.safePath(percentEncoded: false)
        #expect(path == "/path/to/test")

        let encodedPath = testURL.safePath(percentEncoded: true)
        #expect(encodedPath == "/path/to/test")
    }

    @Test
    func testAppendingSafePath() throws {
        let fileURL = testURL.appendingSafePath("file.txt", isDirectory: false)
        #expect(fileURL.lastPathComponent == "file.txt")
        #expect(fileURL.hasDirectoryPath == false)

        let dirURL = testURL.appendingSafePath("folder", isDirectory: true)
        #expect(dirURL.lastPathComponent == "folder")
        #expect(dirURL.hasDirectoryPath == true)
    }

    @Test
    func testDirectoryOperations() throws {
        // Since this test depends on the actual file system,
        // it's recommended to use mocks or test directories
        let tempDir = FileManager.default.temporaryDirectory
            .appendingSafePath("test_directory", isDirectory: true)

        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        // Check if directory exists and is reachable
        #expect(try tempDir.isDirectoryAndReachable())

        // Create a test file and check directory size
        let testFile = tempDir.appendingSafePath("test.txt", isDirectory: false)
        let testData = "test content".data(using: .utf8)!
        try testData.write(to: testFile)

        let size = try tempDir.directorySize()
        #expect(size != nil)
        #expect(size == UInt(testData.count))

        let formattedSize = try tempDir.formattedDirectorySize()
        #expect(formattedSize != nil)
    }
}
