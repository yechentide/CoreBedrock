import Foundation

extension FileManager {
    public func dirExists(at url: URL) -> Bool {
        var isDir: ObjCBool = false
        let fileExists: Bool
        if #available(iOS 16.0, macOS 13.0, *) {
            fileExists = FileManager.default.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir)
        } else {
            fileExists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        }
        return fileExists && isDir.boolValue
    }
}
