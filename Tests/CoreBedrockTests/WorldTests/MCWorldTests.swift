//
// Created by yechentide on 2024/11/04
//

import Testing
import Foundation
import CoreBedrock

struct MCWorldTests {
    private let testDataPath = Bundle.module.path(forResource: "TestData/world", ofType: nil)!

    private func prepareTemporaryWorld(using newName: String) -> URL {
        let originalURL: URL
        let worldDirURL: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            originalURL = URL(filePath: testDataPath, directoryHint: .isDirectory)
            worldDirURL = FileManager.default.temporaryDirectory.appending(component: newName, directoryHint: .isDirectory)
        } else {
            originalURL = URL(fileURLWithPath: testDataPath, isDirectory: true)
            worldDirURL = FileManager.default.temporaryDirectory.appendingPathComponent(newName, isDirectory: true)
        }

        do {
            try? FileManager.default.removeItem(at: worldDirURL)
            try FileManager.default.copyItem(at: originalURL, to: worldDirURL)
            print("Created test world at \(worldDirURL.path()).")
        } catch {
            Issue.record("Failed to copy the world from bundle.")
        }
        return worldDirURL
    }

    private func removeTemporaryWorld(_ dirURL: URL) {
        print()
        do {
            try FileManager.default.removeItem(at: dirURL)
            print("Removed test world at \(dirURL.description).\n")
        } catch {
            Issue.record("Failed to remove the temporary world.\n")
        }
    }

    @Test
    func openWorld() throws {
        let worldDirURL = prepareTemporaryWorld(using: "world")
        do {
            let world = try MCWorld(from: worldDirURL)
            #expect(world.worldName == "FlatTest")
            world.db.close()
        } catch {
            Issue.record("Failed to open the world.\n")
        }
        removeTemporaryWorld(worldDirURL)
    }

    @Test
    func openWorldThatPathContainsSpace() throws {
        let worldDirURL = prepareTemporaryWorld(using: "world space")
        do {
            let world = try MCWorld(from: worldDirURL)
            #expect(world.worldName == "FlatTest")
            world.db.close()
        } catch {
            print(error)
            Issue.record("Failed to open the world.\n")
        }
        removeTemporaryWorld(worldDirURL)
    }

    @Test
    func openWorldThatPathContainsFullWidthCharacters() throws {
        let worldDirURL = prepareTemporaryWorld(using: "世界あ")
        do {
            let world = try MCWorld(from: worldDirURL)
            #expect(world.worldName == "FlatTest")
            world.db.close()
        } catch {
            print(error)
            Issue.record("Failed to open the world.\n")
        }
        removeTemporaryWorld(worldDirURL)
    }
}
