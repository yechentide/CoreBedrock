//
// Created by yechentide on 2025/08/22
//

import Foundation
import LvDBWrapper

public enum NetEaseWorldTransform {
    public static func isNetEaseWorld(at worldDir: String) throws -> Bool{
        let fileManager = FileManager.default
        let dbDirPath = (worldDir as NSString).appendingPathComponent("db")
        guard fileManager.fileExists(atPath: dbDirPath) else {
            throw NetEaseError.dbNotFound(dbDirPath)
        }
        let currentPath = URL(fileURLWithPath: dbDirPath).appendingPathComponent("CURRENT")
        guard let currentData = try? Data(contentsOf: currentPath) else {
            return false
        }
        try NetEaseHeader.validateDecryptableFile(data: currentData)
        return true
    }

    private static func applyXOR(to data: Data, with key: Data) -> Data {
        guard !key.isEmpty else { return data }
        var result = Data(capacity: data.count)
        for (i, byte) in data.enumerated() {
            result.append(byte ^ key[i % key.count])
        }
        return result
    }

    private static func decryptFile(data: Data, key: Data) throws -> Data {
        try NetEaseHeader.validateDecryptableFile(data: data)
        let body = data.dropFirst(4)
        return applyXOR(to: body, with: key)
    }

    private static func encryptFile(data: Data, key: Data) throws -> Data {
        let encryptedBody = applyXOR(to: data, with: key)
        return NetEaseHeader.current.data + encryptedBody
    }

    private static func processFiles(
        in worldDir: String,
        shouldProcess: (NetEaseHeader) -> Bool,
        transform: (Data, Data) throws -> Data
    ) throws {
        let fileManager = FileManager.default
        let dbDirPath = (worldDir as NSString).appendingPathComponent("db")
        guard fileManager.fileExists(atPath: dbDirPath) else {
            throw NetEaseError.dbNotFound(dbDirPath)
        }

        let key = try NetEaseKey.deriveKey(dbDir: dbDirPath)
        let enumerator = fileManager.enumerator(atPath: dbDirPath)

        while let relativePath = enumerator?.nextObject() as? String {
            let filePath = (dbDirPath as NSString).appendingPathComponent(relativePath)
            var isDir: ObjCBool = false
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir), !isDir.boolValue {
                let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let headerType = NetEaseHeader.identifyHeader(in: fileData)

                if shouldProcess(headerType) {
                    let processed = try transform(fileData, key)
                    try processed.write(to: URL(fileURLWithPath: filePath))
                }
            }
        }
    }

    public static func decryptWorld(at worldDir: String) throws {
        try processFiles(
            in: worldDir,
            shouldProcess: { $0 == .current },
            transform: { fileData, key in
                try decryptFile(data: fileData, key: key)
            }
        )
    }

    public static func encryptWorld(at worldDir: String) throws {
        try processFiles(
            in: worldDir,
            shouldProcess: { $0 == .vanilla },
            transform: { fileData, key in
                try encryptFile(data: fileData, key: key)
            }
        )
    }

    private static func processPlayerData(
        worldDir: String,
        transform: (Data) throws -> Data?,
    ) throws {
        let dbDirPath = (worldDir as NSString).appendingPathComponent("db")
        let db = try LvDB(dbPath: dbDirPath)
        defer { db.close() }

        let localPlayerKey = LvDBStringKeyType.localPlayer.rawValue.data(using: .utf8)!
        let localPlayerData = try db.get(localPlayerKey)
        if let fixedData = try transform(localPlayerData) {
            try db.put(localPlayerKey, fixedData)
        }

        let iter = try db.makeIterator()
        iter.seek("player_".data(using: .utf8)!)
        while iter.valid() {
            defer { iter.next() }
            // player_server_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            guard
                let key = iter.key(),
                key.count == 50,
                let prefix = String(data: key[0...3], encoding: .utf8),
                prefix == "play",
                let serverPlayerData = iter.value()
            else {
                break
            }

            if let fixedData = try transform(serverPlayerData) {
                try db.put(key, fixedData)
            }
        }
    }

    public static func decryptPlayerData(at worldDir: String) throws {
        try processPlayerData(worldDir: worldDir, transform: NetEaseNBTTransform.patchDecodedPlayerData)
    }

    public static func encryptPlayerData(at worldDir: String) throws {
        try processPlayerData(worldDir: worldDir, transform: NetEaseNBTTransform.patchEncodedPlayerData)
    }
}
