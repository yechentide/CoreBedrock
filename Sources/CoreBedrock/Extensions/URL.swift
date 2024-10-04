//
// Created by yechentide on 2024/06/02
//

import Foundation

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
