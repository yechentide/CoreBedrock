//
// Created by yechentide on 2025/08/22
//

import Foundation

internal enum NetEaseKey {
    static func findManifestFile(dbDir: String) throws -> Data {
        guard let entries = try? FileManager.default.contentsOfDirectory(atPath: dbDir) else {
            throw NetEaseError.manifestNotFound
        }

        for entry in entries {
            if entry.hasPrefix("MANIFEST-") {
                return Data(entry.utf8)
            }
        }

        throw NetEaseError.manifestNotFound
    }

    static func deriveKey(dbDir: String) throws -> Data {
        let currentPath = URL(fileURLWithPath: dbDir).appendingPathComponent("CURRENT")
        guard let currentData = try? Data(contentsOf: currentPath) else {
            throw NetEaseError.readCurrentFailed
        }
        try NetEaseHeader.validateDecryptableFile(data: currentData)
        let currentBody = currentData.dropFirst(4)
        guard currentBody.count >= 16 else {
            throw NetEaseError.invalidCurrentLength(currentBody.count)
        }

        // Add newline to manifestName
        let manifestName = try findManifestFile(dbDir: dbDir)
        var manifestWithNewline = manifestName
        manifestWithNewline.append(0x0A) // '\n'
        guard manifestWithNewline.count == 16 else {
            throw NetEaseError.invalidManifestLength(manifestWithNewline.count)
        }

        var keyRaw = Data(count: 16)
        for i in 0..<16 {
            keyRaw[i] = currentBody[currentBody.startIndex + i] ^ manifestWithNewline[i]
        }

        let first8 = keyRaw.prefix(8)
        let last8 = keyRaw.suffix(8)

        guard first8 == last8 else {
            throw NetEaseError.keyVerificationFailed
        }
        return first8
    }
}
