import Foundation

// https://stackoverflow.com/questions/32814535/how-to-get-directory-size-with-swift-on-os-x
extension URL {
    private static let byteCountFormatter = ByteCountFormatter()

    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }

    func directorySize() throws -> UInt? {
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

    func formattedDirectorySize() throws -> String? {
        guard let rawSize = try self.directorySize() else {
            return nil
        }
        URL.byteCountFormatter.countStyle = .file
        guard let size = URL.byteCountFormatter.string(for: rawSize) else {
            return nil
        }
        return size
    }
}
