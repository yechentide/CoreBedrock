//
// Created by yechentide on 2024/07/21
//

public import Foundation

public extension FileManager {
    func createDirectoryIfMissing(at url: URL) throws {
        guard !fileExists(atPath: url.path) else {
            return
        }

        try createDirectory(at: url, withIntermediateDirectories: true)
    }

    func deleteFileIfExists(at url: URL) throws {
        guard fileExists(atPath: url.path) else {
            return
        }

        try removeItem(at: url)
    }

    func dirExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        let path = url.compatiblePath(percentEncoded: false)
        let fileExists = self.fileExists(atPath: path, isDirectory: &isDir)
        return fileExists && isDir.boolValue
    }

    func isMCWorldDir(at dirURL: URL) throws -> Bool {
        var isDirForDB: ObjCBool = false
        let dbDirPath = dirURL.appendingCompatiblePath("db", isDirectory: true).compatiblePath(percentEncoded: false)
        let hasDBDir = self.fileExists(
            atPath: dbDirPath, isDirectory: &isDirForDB
        ) && isDirForDB.boolValue

        var isDirForLevelDat: ObjCBool = false
        let levelDatPath = dirURL
            .appendingCompatiblePath("level.dat", isDirectory: false)
            .compatiblePath(percentEncoded: false)
        let hasLevelDat = self.fileExists(
            atPath: levelDatPath, isDirectory: &isDirForLevelDat
        ) && !isDirForLevelDat.boolValue

        return hasDBDir && hasLevelDat
    }
}
