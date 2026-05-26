//
// Created by yechentide on 2025/08/22
//

import Foundation

enum NetEaseKeyDerivation {
    private enum KeyFileError: LocalizedError {
        case invalidHexString(String)
        case keyFileNotFound(String)
    }

    static func deriveKey(dbDirPath: String, currentFileData: Data) throws -> Data {
        let currentBody = currentFileData.dropFirst(NetEaseConstants.headerSize)
        guard currentBody.count >= NetEaseConstants.expectedKeyLength else {
            throw NetEaseError.invalidCurrentFileData
        }

        let manifestName = try NetEaseFileProcessor.findManifestFile(in: dbDirPath)
        var manifestBytes = manifestName
        if manifestBytes.count < NetEaseConstants.expectedManifestLength {
            manifestBytes.append(
                Data(
                    repeating: 0x0A,
                    count: NetEaseConstants.expectedManifestLength - manifestBytes.count
                )
            )
        }
        manifestBytes = manifestBytes.prefix(NetEaseConstants.expectedManifestLength)

        var keyRaw = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            keyRaw[index] = currentBody[currentBody.startIndex + index] ^ manifestBytes[index]
        }

        let first8 = keyRaw.prefix(8)
        let last8 = keyRaw.suffix(8)

        guard first8 == last8 else {
            throw NetEaseError.keyVerificationFailed
        }

        return first8
    }

    static func loadKeyFile(at keyFilePath: String) throws -> Data {
        guard FileManager.default.fileExists(atPath: keyFilePath) else {
            throw KeyFileError.keyFileNotFound(keyFilePath)
        }

        let trimmedKeyHex = try String(contentsOfFile: keyFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedKeyHex.count.isMultiple(of: 2) else {
            throw KeyFileError.invalidHexString(trimmedKeyHex)
        }

        var key = Data(capacity: trimmedKeyHex.count / 2)
        var index = trimmedKeyHex.startIndex
        while index < trimmedKeyHex.endIndex {
            let nextIndex = trimmedKeyHex.index(index, offsetBy: 2)
            let byteString = String(trimmedKeyHex[index..<nextIndex])
            guard let byte = UInt8(byteString, radix: 16) else {
                throw KeyFileError.invalidHexString(trimmedKeyHex)
            }

            key.append(byte)
            index = nextIndex
        }

        guard key.count == 8 else {
            throw NetEaseError.invalidKeyLength(key.count)
        }

        return key
    }

    static func saveKeyFile(in worldDirPath: String, key: Data) throws {
        let keyFilePath = (worldDirPath as NSString).appendingPathComponent(NetEaseConstants.keyFileName)
        let keyHex = key.map { String(format: "%02x", $0) }.joined()
        let keyData = Data((keyHex + "\n").utf8)

        try keyData.write(to: URL(fileURLWithPath: keyFilePath), options: .atomic)
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o600],
            ofItemAtPath: keyFilePath
        )
    }

    static func findKeyFile(forWorldAt worldDirPath: String) -> String? {
        let worldKeyPath = (worldDirPath as NSString).appendingPathComponent(NetEaseConstants.keyFileName)
        let parentKeyPath = ((worldDirPath as NSString).deletingLastPathComponent as NSString)
            .appendingPathComponent(NetEaseConstants.keyFileName)

        for keyFilePath in [worldKeyPath, parentKeyPath] {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: keyFilePath, isDirectory: &isDirectory),
               !isDirectory.boolValue {
                return keyFilePath
            }
        }

        return nil
    }

    static func loadKeyFileForWorld(at worldDirPath: String) throws -> Data? {
        guard let keyFilePath = findKeyFile(forWorldAt: worldDirPath) else {
            return nil
        }

        return try self.loadKeyFile(at: keyFilePath)
    }
}
