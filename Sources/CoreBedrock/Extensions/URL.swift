//
// Created by yechentide on 2024/06/02
//

import Foundation

extension URL {
    public static func from(filePath: String) -> URL {
        return if #available(iOS 16.0, macOS 13.0, *) {
            .init(filePath: filePath)
        } else {
            .init(fileURLWithPath: filePath)
        }
    }

    public func compatiblePath(percentEncoded: Bool) -> String {
        return if #available(iOS 16.0, macOS 13.0, *) {
            self.path(percentEncoded: percentEncoded)
        } else {
            self.path
        }
    }

    public func appendingCompatiblePath(_ path: String, isDirectory: Bool) -> URL {
        return if #available(iOS 16.0, macOS 13.0, *) {
            self.appending(path: path, directoryHint: isDirectory ? .isDirectory : .notDirectory)
        } else {
            self.appendingPathComponent(path, isDirectory: isDirectory)
        }
    }
}

// https://stackoverflow.com/questions/32814535/how-to-get-directory-size-with-swift-on-os-x
extension URL {
    public func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }

    public func directorySize() throws -> UInt? {
        guard try isDirectoryAndReachable(),
              let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL]
        else {
            return nil
        }
        let rawSize = try urls.lazy.reduce(0) { size, url in
            (try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0) + size
        }
        return UInt(rawSize)
    }

    public func formattedDirectorySize() throws -> String? {
        let byteCountFormatter = ByteCountFormatter()
        guard let rawSize = try self.directorySize() else {
            return nil
        }
        byteCountFormatter.countStyle = .file
        guard let size = byteCountFormatter.string(for: rawSize) else {
            return nil
        }
        return size
    }
}
