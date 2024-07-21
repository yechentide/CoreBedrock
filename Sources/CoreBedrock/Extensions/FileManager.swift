//
// Created by yechentide on 2024/07/21
//

import Foundation

extension FileManager {
    func createDirectoryIfMissing(url: URL) throws {
        guard !fileExists(atPath: url.absoluteString) else {
            return
        }
        try createDirectory(at: url, withIntermediateDirectories: true)
    }

    func dirExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        var path = if #available(iOS 16.0, macOS 13.0, *) {
            url.path(percentEncoded: false)
        } else {
            url.path
        }
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return fileExists && isDir.boolValue
    }
}
