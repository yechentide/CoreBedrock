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
        var (hasDBDir, hasLevelDat) = (false, false)
        let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
        let contents = try FileManager.default.contentsOfDirectory(
            at: dirURL,
            includingPropertiesForKeys: keys
        )

        for fileURL in contents {
            let attributes = try fileURL.resourceValues(forKeys: Set(keys))
            if attributes.name == "db" && attributes.isDirectory == true {
                hasDBDir = true
            } else if attributes.name == "level.dat" && attributes.isDirectory! == false {
                hasLevelDat = true
            }
        }

        if hasDBDir && hasLevelDat { return true }
        return false
    }
}
