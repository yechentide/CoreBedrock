//
// Created by yechentide on 2024/07/14
//

import Foundation

public enum MCDirManager {
    public static func isMCWorldDir(at dirURL: URL) throws -> Bool {
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

    public static func moveDir(from srcDir: URL, to dstDir: URL, newDirName: String? = nil) throws -> URL {
        let newName = newDirName ?? srcDir.lastPathComponent
        let dstURL = dstDir.appendingPathComponent(newName, isDirectory: true)
        try FileManager.default.moveItem(at: srcDir, to: dstURL)
        return dstURL
    }

    public static func copyDir(from srcDir: URL, to dstDir: URL, newDirName: String? = nil) throws -> URL {
        let newName = newDirName ?? srcDir.lastPathComponent
        let dstURL = dstDir.appendingPathComponent(newName, isDirectory: true)
        try FileManager.default.copyItem(at: srcDir, to: dstURL)
        return dstURL
    }

    public static func deleteDir(at dirURL: URL) throws {
        try FileManager.default.removeItem(at: dirURL)
    }

//    public func parse() throws -> MCWorld {
//        return try MCWorld(from: dirURL, meta: worldMeta)
//    }
}
