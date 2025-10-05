@testable import CoreBedrock
import Foundation
import Testing

struct NetEaseFileProcessorTests {
    @Test(.withTemporaryNetEaseWorld)
    func findManifestFileSuccess() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let manifestData = try NetEaseFileProcessor.findManifestFile(in: dbDirPath)
        let manifestString = String(data: manifestData, encoding: .utf8)!

        #expect(manifestString.hasPrefix(NetEaseConstants.manifestPrefix))
        #expect(manifestString == "MANIFEST-000048")
    }

    @Test(.withEmptyDirectory)
    func findManifestFileNotFoundError() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        #expect(throws: NetEaseError.manifestFileNotFound) {
            try NetEaseFileProcessor.findManifestFile(in: directoryPath)
        }
    }

    @Test(.withEmptyDirectory)
    func findManifestFileDbNotFoundError() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let nonExistentPath = "\(directoryPath)/does-not-exist"
        #expect(throws: NetEaseError.dbNotFound(nonExistentPath)) {
            try NetEaseFileProcessor.findManifestFile(in: nonExistentPath)
        }
    }

    @Test
    func shouldProcessNetEaseFileWithCurrentFile() {
        #expect(NetEaseFileProcessor.shouldProcessNetEaseFile("CURRENT"))
    }

    @Test
    func shouldProcessNetEaseFileWithManifestFile() {
        #expect(NetEaseFileProcessor.shouldProcessNetEaseFile("MANIFEST-000048"))
        #expect(NetEaseFileProcessor.shouldProcessNetEaseFile("MANIFEST-123456"))
    }

    @Test
    func shouldProcessNetEaseFileWithLdbFile() {
        #expect(NetEaseFileProcessor.shouldProcessNetEaseFile("000052.ldb"))
        #expect(NetEaseFileProcessor.shouldProcessNetEaseFile("test.ldb"))
    }

    @Test
    func shouldProcessNetEaseFileWithOtherFiles() {
        #expect(!NetEaseFileProcessor.shouldProcessNetEaseFile("000050.log"))
        #expect(!NetEaseFileProcessor.shouldProcessNetEaseFile("random.txt"))
        #expect(!NetEaseFileProcessor.shouldProcessNetEaseFile("data.db"))
        #expect(!NetEaseFileProcessor.shouldProcessNetEaseFile(""))
    }

    @Test(.withTemporaryNetEaseWorld)
    func processFilesSuccess() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        var processedFiles: [String] = []
        var processedHeaders: [NetEaseHeader] = []

        try NetEaseFileProcessor.processFiles(
            in: dbDirPath,
            shouldProcess: { fileName, headerType in
                processedFiles.append(fileName)
                processedHeaders.append(headerType)
                return false // Don't actually transform files in this test
            },
            transform: { data in
                data // Identity transform
            }
        )

        #expect(!processedFiles.isEmpty)
        #expect(processedFiles.contains("CURRENT"))
        #expect(processedFiles.contains("MANIFEST-000048"))
        #expect(processedFiles.contains("000052.ldb"))
        #expect(processedFiles.contains("000050.log"))

        #expect(processedHeaders.count == processedFiles.count)
    }

    @Test(.withTemporaryNetEaseWorld)
    func processFilesWithTransformation() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        let testFilePath = "\(dbDirPath)/test_file.ldb"
        let originalData = Data([0x01, 0x02, 0x03, 0x04])
        try originalData.write(to: URL(fileURLWithPath: testFilePath))

        defer {
            try? FileManager.default.removeItem(atPath: testFilePath)
        }

        var transformCallCount = 0

        try NetEaseFileProcessor.processFiles(
            in: dbDirPath,
            shouldProcess: { fileName, _ in
                fileName == "test_file.ldb"
            },
            transform: { _ in
                transformCallCount += 1
                return Data([0xFF, 0xFE, 0xFD, 0xFC])
            }
        )

        #expect(transformCallCount == 1)

        let modifiedData = try Data(contentsOf: URL(fileURLWithPath: testFilePath))
        #expect(modifiedData == Data([0xFF, 0xFE, 0xFD, 0xFC]))
    }

    @Test(.withEmptyDirectory)
    func processFilesDbNotFoundError() throws {
        let directoryPath = EmptyDirectoryTrait.Context.directoryPath
        let nonExistentPath = "\(directoryPath)/does-not-exist"

        #expect(throws: NetEaseError.dbNotFound(nonExistentPath)) {
            try NetEaseFileProcessor.processFiles(
                in: nonExistentPath,
                shouldProcess: { _, _ in true },
                transform: { $0 }
            )
        }
    }

    @Test(.withTemporaryNetEaseWorld)
    func processFilesWithSelectiveProcessing() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        var processedFileNames: [String] = []

        try NetEaseFileProcessor.processFiles(
            in: dbDirPath,
            shouldProcess: { fileName, _ in
                let shouldProcess = fileName == "CURRENT" || fileName.hasPrefix("MANIFEST")
                if shouldProcess {
                    processedFileNames.append(fileName)
                }
                return false // Don't actually transform
            },
            transform: { data in
                data
            }
        )

        #expect(processedFileNames.contains("CURRENT"))
        #expect(processedFileNames.contains("MANIFEST-000048"))
        #expect(!processedFileNames.contains("000052.ldb"))
    }

    @Test(.withTemporaryNetEaseWorld)
    func processFilesHeaderIdentification() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        var headerResults: [(String, NetEaseHeader)] = []

        try NetEaseFileProcessor.processFiles(
            in: dbDirPath,
            shouldProcess: { fileName, headerType in
                headerResults.append((fileName, headerType))
                return false // Don't transform
            },
            transform: { $0 }
        )

        let currentFileHeader = headerResults.first { $0.0 == "CURRENT" }?.1
        #expect(currentFileHeader == .neteaseEncrypted)

        let manifestHeaders = headerResults.filter { $0.0.hasPrefix("MANIFEST") }
        #expect(manifestHeaders.count == 1)
        #expect(manifestHeaders[0].1 == .neteaseEncrypted)

        let ldbFileHeaders = headerResults.filter { $0.0.hasSuffix(".ldb") }
        #expect(ldbFileHeaders.count == 1)
        for item in ldbFileHeaders {
            #expect(item.1 == .neteaseEncrypted)
        }

        let logFileHeaders = headerResults.filter { $0.0.hasSuffix(".log") }
        #expect(logFileHeaders.count == 1)
        for item in logFileHeaders {
            #expect(item.1 == .unknown)
        }
    }

    @Test(.withTemporaryNetEaseWorld)
    func processFilesTransformError() throws {
        let worldDirPath = TemporaryNetEaseWorldTrait.Context.worldDirPath
        let dbDirPath = "\(worldDirPath)/db"

        enum TestError: Error {
            case transformFailed
        }

        #expect(throws: TestError.transformFailed) {
            try NetEaseFileProcessor.processFiles(
                in: dbDirPath,
                shouldProcess: { fileName, _ in
                    fileName == "CURRENT"
                },
                transform: { _ in
                    throw TestError.transformFailed
                }
            )
        }
    }
}
