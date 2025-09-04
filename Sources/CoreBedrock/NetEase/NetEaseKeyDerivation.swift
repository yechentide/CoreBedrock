//
// Created by yechentide on 2025/08/22
//

import Foundation

internal enum NetEaseKeyDerivation {
    static func deriveKey(dbDirPath: String, currentFileData: Data) throws -> Data {
        let currentBody = currentFileData.dropFirst(NetEaseConstants.headerSize)
        guard currentBody.count >= NetEaseConstants.expectedKeyLength else {
            throw NetEaseError.invalidCurrentFileData
        }

        // Add newline to manifestName
        let manifestName = try NetEaseFileProcessor.findManifestFile(in: dbDirPath)
        var manifestWithNewline = manifestName
        manifestWithNewline.append(0x0A) // '\n'
        guard manifestWithNewline.count == NetEaseConstants.expectedManifestLength else {
            throw NetEaseError.invalidManifestFileData
        }

        var keyRaw = Data(count: NetEaseConstants.expectedKeyLength)
        for index in 0..<NetEaseConstants.expectedKeyLength {
            keyRaw[index] = currentBody[currentBody.startIndex + index] ^ manifestWithNewline[index]
        }

        let first8 = keyRaw.prefix(8)
        let last8 = keyRaw.suffix(8)

        guard first8 == last8 else {
            throw NetEaseError.keyVerificationFailed
        }
        return first8
    }
}
