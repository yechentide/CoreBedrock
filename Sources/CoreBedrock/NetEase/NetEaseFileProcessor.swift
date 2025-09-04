//
// Created by yechentide on 2025/09/04
//

import Foundation

internal enum NetEaseFileProcessor {
    static func findManifestFile(in dbDirPath: String) throws -> Data {
        guard FileManager.default.fileExists(atPath: dbDirPath) else {
            throw NetEaseError.dbNotFound(dbDirPath)
        }

        let propertyKeys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
        guard let enumerator = FileManager.default.enumerator(
            at: URL(fileURLWithPath: dbDirPath),
            includingPropertiesForKeys: propertyKeys,
            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
        ) else {
            throw NetEaseError.fileEnumerationFailed(dbDirPath)
        }

        for case let fileURL as URL in enumerator {
            let attributes = try fileURL.resourceValues(forKeys: Set(propertyKeys))
            guard attributes.isDirectory == false,
                    let fileName = attributes.name,
                  fileName.hasPrefix(NetEaseConstants.manifestPrefix) else {
                continue
            }
            return Data(fileName.utf8)
        }

        throw NetEaseError.manifestFileNotFound
    }

    static func shouldProcessNetEaseFile(_ fileName: String) -> Bool {
        return fileName == "CURRENT"
            || fileName.hasPrefix(NetEaseConstants.manifestPrefix)
            || fileName.hasSuffix(".ldb")
    }

    static func processFiles(
        in dbDirPath: String,
        shouldProcess: (String, NetEaseHeader) -> Bool,
        transform: (Data) throws -> Data
    ) throws {
        guard FileManager.default.fileExists(atPath: dbDirPath) else {
            throw NetEaseError.dbNotFound(dbDirPath)
        }

        let propertyKeys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
        let enumerator = FileManager.default.enumerator(
            at: URL(fileURLWithPath: dbDirPath),
            includingPropertiesForKeys: propertyKeys,
            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
        )
        guard let enumerator else {
            throw NetEaseError.fileEnumerationFailed(dbDirPath)
        }

        for case let fileURL as URL in enumerator {
            let attributes = try fileURL.resourceValues(forKeys: Set(propertyKeys))
            guard attributes.isDirectory == false, let fileName = attributes.name else {
                continue
            }
            let fileData = try Data(contentsOf: fileURL)
            let isCurrentFile = fileName == "CURRENT"
            let headerType = NetEaseHeader.identifyHeader(in: fileData, isCurrentFile: isCurrentFile)

            if shouldProcess(fileName, headerType) {
                let processed = try transform(fileData)
                try processed.write(to: fileURL)
            }
        }
    }
}
