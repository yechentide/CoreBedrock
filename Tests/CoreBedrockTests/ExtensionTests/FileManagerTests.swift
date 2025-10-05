//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import Testing

struct FileManagerTests {
    @Test
    func testCreateDirectoryIfMissing() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(UUID().uuidString)

        try FileManager.default.createDirectoryIfMissing(at: testDir)
        #expect(FileManager.default.dirExists(at: testDir))

        // Test with existing directory
        try FileManager.default.createDirectoryIfMissing(at: testDir)
        #expect(FileManager.default.dirExists(at: testDir))

        try FileManager.default.removeItem(at: testDir)
    }

    @Test
    func testDeleteFileIfExists() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent(UUID().uuidString)

        try "test".write(to: testFile, atomically: true, encoding: .utf8)

        try FileManager.default.deleteFileIfExists(at: testFile)
        #expect(!FileManager.default.fileExists(atPath: testFile.path))

        // Test with non-existent file
        try FileManager.default.deleteFileIfExists(at: testFile)
        #expect(!FileManager.default.fileExists(atPath: testFile.path))
    }

    @Test
    func testDirExists() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let testDir = tempDir.appendingPathComponent(UUID().uuidString)
        let testFile = tempDir.appendingPathComponent(UUID().uuidString)

        try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        #expect(FileManager.default.dirExists(at: testDir))

        try "test".write(to: testFile, atomically: true, encoding: .utf8)
        #expect(!FileManager.default.dirExists(at: testFile))

        let nonExistentPath = tempDir.appendingPathComponent(UUID().uuidString)
        #expect(!FileManager.default.dirExists(at: nonExistentPath))

        try FileManager.default.removeItem(at: testDir)
        try FileManager.default.removeItem(at: testFile)
    }

    @Test
    func testIsMCWorldDir() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let worldDir = tempDir.appendingPathComponent(UUID().uuidString)
        let dbDir = worldDir.appendingPathComponent("db")
        let levelDat = worldDir.appendingPathComponent("level.dat")

        // Create MC world directory structure
        try FileManager.default.createDirectory(at: worldDir, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: dbDir, withIntermediateDirectories: true)
        try "test".write(to: levelDat, atomically: true, encoding: .utf8)

        #expect(throws: Never.self) {
            let result = try FileManager.default.isMCWorldDir(at: worldDir)
            #expect(result == true)
        }

        // Test without db directory
        try FileManager.default.removeItem(at: dbDir)
        #expect(throws: Never.self) {
            let result = try FileManager.default.isMCWorldDir(at: worldDir)
            #expect(result == false)
        }

        // Test without level.dat
        try FileManager.default.createDirectory(at: dbDir, withIntermediateDirectories: true)
        try FileManager.default.removeItem(at: levelDat)
        #expect(throws: Never.self) {
            let result = try FileManager.default.isMCWorldDir(at: worldDir)
            #expect(result == false)
        }

        try FileManager.default.removeItem(at: worldDir)
    }
}
