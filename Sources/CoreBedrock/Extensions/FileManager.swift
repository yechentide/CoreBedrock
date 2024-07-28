//
// Created by yechentide on 2024/07/21
//

import Foundation

extension FileManager {
    public func createDirectoryIfMissing(at url: URL) throws {
        guard !fileExists(atPath: url.absoluteString) else {
            return
        }
        try createDirectory(at: url, withIntermediateDirectories: true)
    }

    public func deleteFileIfExists(at url: URL) throws {
        guard fileExists(atPath: url.absoluteString) else {
            return
        }
        try removeItem(at: url)
    }

    public func dirExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        let path = if #available(iOS 16.0, macOS 13.0, *) {
            url.path(percentEncoded: false)
        } else {
            url.path
        }
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
