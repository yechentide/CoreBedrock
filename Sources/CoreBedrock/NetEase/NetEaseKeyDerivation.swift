//
// Created by yechentide on 2025/08/22
//

import Foundation

enum NetEaseKeyDerivation {
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
}
