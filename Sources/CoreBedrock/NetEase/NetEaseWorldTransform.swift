//
// Created by yechentide on 2025/08/22
//

public import Foundation

public enum NetEaseWorldTransform {
    private static func readCurrentFileData(in worldDirPath: String) throws -> Data {
        let worldDirURL = URL(fileURLWithPath: worldDirPath)
        let dbDirURL = worldDirURL.appendingCompatiblePath("db", isDirectory: true)
        let currentFileURL = dbDirURL.appendingCompatiblePath("CURRENT", isDirectory: false)
        guard let currentFileData = try? Data(contentsOf: currentFileURL) else {
            throw NetEaseError.currentFileNotFound
        }

        return currentFileData
    }

    public static func isNetEaseWorld(at worldDirPath: String) throws -> Bool {
        guard let currentFileData = try? readCurrentFileData(in: worldDirPath) else {
            return false
        }

        let type = NetEaseHeader.identifyHeader(in: currentFileData, isCurrentFile: true)
        return type == .neteaseEncrypted
    }

    public static func decryptWorld(at worldDirPath: String) throws {
        try autoreleasepool {
            let currentFileData = try readCurrentFileData(in: worldDirPath)
            try NetEaseHeader.validate(currentFileData: currentFileData, shouldHasHeader: .neteaseEncrypted)

            let dbDirPath = (worldDirPath as NSString).appendingPathComponent("db")
            let customKey = try NetEaseKeyDerivation.deriveKey(dbDirPath: dbDirPath, currentFileData: currentFileData)
            try NetEaseKeyDerivation.saveKeyFile(in: worldDirPath, key: customKey)

            try Task.checkCancellation()
            try NetEaseFileProcessor.processFiles(
                in: dbDirPath,
                shouldProcess: { fileName, headerType in
                    headerType == .neteaseEncrypted && NetEaseFileProcessor.shouldProcessNetEaseFile(fileName)
                },
                transform: { fileData in
                    try NetEaseCrypto.decryptFile(data: fileData, key: customKey)
                }
            )
        }
    }

    public static func encryptWorld(at worldDirPath: String) throws {
        let customKey = try NetEaseKeyDerivation.loadKeyFileForWorld(at: worldDirPath)
            ?? NetEaseConstants.defaultKey
        try self.encryptWorld(at: worldDirPath, with: customKey)
    }

    public static func encryptWorld(at worldDirPath: String, with customKey: Data) throws {
        try autoreleasepool {
            let currentFileData = try readCurrentFileData(in: worldDirPath)
            try NetEaseHeader.validate(currentFileData: currentFileData, shouldHasHeader: .bedrockCurrentFile)

            guard customKey.count == 8 else {
                throw NetEaseError.invalidKeyLength(customKey.count)
            }

            let dbDirPath = (worldDirPath as NSString).appendingPathComponent("db")
            try Task.checkCancellation()
            try NetEaseFileProcessor.processFiles(
                in: dbDirPath,
                shouldProcess: { fileName, headerType in
                    headerType != .neteaseEncrypted && NetEaseFileProcessor.shouldProcessNetEaseFile(fileName)
                },
                transform: { fileData in
                    try NetEaseCrypto.encryptFile(data: fileData, key: customKey)
                }
            )
        }
    }

    public static func decryptPlayerData(at worldDirPath: String) throws {
        try NetEasePlayerDataProcessor.processPlayerData(
            worldDir: worldDirPath,
            transform: NetEaseNBTTransform.patchDecodedPlayerData
        )
    }

    public static func encryptPlayerData(at worldDirPath: String) throws {
        try NetEasePlayerDataProcessor.processPlayerData(
            worldDir: worldDirPath,
            transform: NetEaseNBTTransform.patchEncodedPlayerData
        )
    }
}
