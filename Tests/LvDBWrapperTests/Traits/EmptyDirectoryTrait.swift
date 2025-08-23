//
// Created by yechentide on 2025/08/23
//

import Testing
import Foundation

extension Trait where Self == EmptyDirectoryTrait {
    static var withEmptyDirectory: Self {
        Self()
    }
}

struct EmptyDirectoryTrait: TestTrait, TestScoping {
    enum Context {
        @TaskLocal static var directoryPath: String = ""
    }

    func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        print()
        let directoryURL = try createTemporaryDirectory()
        defer {
            deleteTemporaryDirectory(directoryURL)
        }
        let directoryPath = if #available(iOS 16.0, macOS 13.0, *) {
            directoryURL.path()
        } else {
            directoryURL.path
        }
        print("Created test directory at \(directoryPath)")

        do {
            try await Context.$directoryPath.withValue(directoryPath) {
                try await function()
            }
        } catch {
            throw error
        }
    }

    private func createTemporaryDirectory() throws -> URL {
        let directoryURL = URL.temporaryDirectory.appending(path: "db_\(UUID().uuidString)")
        try? FileManager.default.removeItem(at: directoryURL)
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        return directoryURL
    }

    private func deleteTemporaryDirectory(_ directoryURL: URL) {
        do {
            try FileManager.default.removeItem(at: directoryURL)
            print("Deleted test directory at \(directoryURL)\n")
        } catch {
            Issue.record("Failed to remove the temporary directory.\n")
        }
    }
}
