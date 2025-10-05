//
// Created by yechentide on 2025/09/04
//

import Foundation
import Testing

extension Trait where Self == TemporaryNetEaseWorldTrait {
    static var withTemporaryNetEaseWorld: Self {
        Self()
    }
}

struct TemporaryNetEaseWorldTrait: TestTrait, TestScoping {
    enum Context {
        @TaskLocal static var worldDirPath = ""
    }

    func provideScope(
        for _: Test,
        testCase _: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        print()
        let worldDirPath = self.createTemporaryWorld()
        defer {
            deleteTemporaryWorld(worldDirPath)
        }

        do {
            try await Context.$worldDirPath.withValue(worldDirPath) {
                try await function()
            }
        } catch {
            throw error
        }
    }

    private func createTemporaryWorld() -> String {
        let testWorldPath = Bundle.module.path(forResource: "TestData/netease-world", ofType: nil)!
        let tempWorldDirName = "netease-world_\(UUID().uuidString)"
        let sourceDirURL: URL
        let temporaryDirURL: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            sourceDirURL = URL(filePath: testWorldPath, directoryHint: .isDirectory)
            temporaryDirURL = FileManager.default.temporaryDirectory.appending(
                component: tempWorldDirName, directoryHint: .isDirectory
            )
        } else {
            sourceDirURL = URL(fileURLWithPath: testWorldPath, isDirectory: true)
            temporaryDirURL = FileManager.default.temporaryDirectory.appendingPathComponent(
                tempWorldDirName, isDirectory: true
            )
        }

        do {
            try? FileManager.default.removeItem(at: temporaryDirURL)
            try FileManager.default.copyItem(at: sourceDirURL, to: temporaryDirURL)
            print("Created test world at \(temporaryDirURL.path())")
        } catch {
            Issue.record("Failed to copy the world from bundle.")
        }

        if #available(iOS 16.0, macOS 13.0, *) {
            return temporaryDirURL.path()
        } else {
            return temporaryDirURL.path
        }
    }

    private func deleteTemporaryWorld(_ worldDirPath: String) {
        do {
            try FileManager.default.removeItem(atPath: worldDirPath)
            print("Deleted test world at \(worldDirPath)\n")
        } catch {
            Issue.record("Failed to remove the temporary world.\n")
        }
    }
}
