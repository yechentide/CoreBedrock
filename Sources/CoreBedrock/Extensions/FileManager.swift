//
// Created by yechentide on 2024/07/21
//

import Foundation

extension FileManager {
    public func createDirectoryIfMissing(at url: URL) throws {
        guard !fileExists(atPath: url.path) else {
            return
        }
        try createDirectory(at: url, withIntermediateDirectories: true)
    }

    public func deleteFileIfExists(at url: URL) throws {
        guard fileExists(atPath: url.path) else {
            return
        }
        try removeItem(at: url)
    }

    public func dirExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        let path = url.safePath(percentEncoded: false)
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return fileExists && isDir.boolValue
    }

    public func isMCWorldDir(at dirURL: URL) throws -> Bool {
        var isDirForDB: ObjCBool = false
        let dbDirPath = dirURL.appendingSafePath("db", isDirectory: true).safePath(percentEncoded: false)
        let hasDBDir = FileManager.default.fileExists(
            atPath: dbDirPath, isDirectory: &isDirForDB
        ) && isDirForDB.boolValue

        var isDirForLevelDat: ObjCBool = false
        let levelDatPath = dirURL.appendingSafePath("level.dat", isDirectory: false).safePath(percentEncoded: false)
        let hasLevelDat = FileManager.default.fileExists(
            atPath: levelDatPath, isDirectory: &isDirForLevelDat
        ) && !isDirForLevelDat.boolValue

        return hasDBDir && hasLevelDat
    }
}
