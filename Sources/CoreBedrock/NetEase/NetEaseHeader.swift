//
// Created by yechentide on 2025/08/22
//

import Foundation

enum NetEaseHeader {
    case neteaseEncrypted
    case bedrockCurrentFile
    case unknown

    var data: Data {
        switch self {
        case .neteaseEncrypted:
            Data([0x80, 0x1D, 0x30, 0x01])
        case .bedrockCurrentFile:
            Data([0x4D, 0x41, 0x4E, 0x49]) // "MANI"
        case .unknown:
            Data()
        }
    }

    static func identifyHeader(in data: Data, isCurrentFile: Bool) -> Self {
        guard data.count >= 4 else {
            return .unknown
        }

        let headerBytes = data[0..<4]
        if headerBytes == Self.neteaseEncrypted.data {
            return .neteaseEncrypted
        }
        if isCurrentFile, headerBytes == Self.bedrockCurrentFile.data {
            return .bedrockCurrentFile
        }
        return .unknown
    }

    static func validate(currentFileData: Data, shouldHasHeader expectHeader: Self) throws {
        guard expectHeader != .unknown else {
            return
        }

        let actualHeader = Self.identifyHeader(in: currentFileData, isCurrentFile: true)
        guard actualHeader != .unknown else {
            throw NetEaseError.invalidHeader
        }

        if expectHeader == .bedrockCurrentFile {
            // Expecting Bedrock CURRENT file for encryption operation
            if actualHeader == .bedrockCurrentFile {
                return // File is Bedrock format, can proceed with encryption
            } else {
                throw NetEaseError.alreadyEncrypted
            }
        } else {
            // Expecting NetEase encrypted file for decryption operation
            if actualHeader == .bedrockCurrentFile {
                throw NetEaseError.alreadyDecrypted
            } else {
                return // File is NetEase encrypted, can proceed with decryption
            }
        }
    }
}
