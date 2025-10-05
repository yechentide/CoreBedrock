//
// Created by yechentide on 2025/08/23
//

import Foundation
import Testing

extension Trait where Self == TemporaryDatabaseTrait {
    static var withTemporaryDatabase: Self {
        Self()
    }
}

struct TemporaryDatabaseTrait: TestTrait, TestScoping {
    enum Context {
        @TaskLocal static var dbPath = ""
    }

    func provideScope(
        for _: Test,
        testCase _: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        print()
        let dbPath = self.createTemporaryDatabase()
        defer {
            deleteTemporaryDatabase(dbPath)
        }

        do {
            try await Context.$dbPath.withValue(dbPath) {
                try await function()
            }
        } catch {
            throw error
        }
    }

    private func createTemporaryDatabase() -> String {
        let testDataPath = Bundle.module.path(forResource: "TestData/db", ofType: nil)!
        let tempDBDirName = "db_\(UUID().uuidString)"
        let sourceDBURL: URL
        let temporaryDBURL: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            sourceDBURL = URL(filePath: testDataPath, directoryHint: .isDirectory)
            temporaryDBURL = FileManager.default.temporaryDirectory
                .appending(component: tempDBDirName, directoryHint: .isDirectory)
        } else {
            sourceDBURL = URL(fileURLWithPath: testDataPath, isDirectory: true)
            temporaryDBURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(tempDBDirName, isDirectory: true)
        }

        do {
            try? FileManager.default.removeItem(at: temporaryDBURL)
            try FileManager.default.copyItem(at: sourceDBURL, to: temporaryDBURL)
            print("Created test db at \(temporaryDBURL.path())")
        } catch {
            Issue.record("Failed to copy the database from bundle.")
        }

        if #available(iOS 16.0, macOS 13.0, *) {
            return temporaryDBURL.path()
        } else {
            return temporaryDBURL.path
        }
    }

    private func deleteTemporaryDatabase(_ dbPath: String) {
        do {
            try FileManager.default.removeItem(atPath: dbPath)
            print("Deleted test db at \(dbPath)\n")
        } catch {
            Issue.record("Failed to remove the temporary database.\n")
        }
    }
}
