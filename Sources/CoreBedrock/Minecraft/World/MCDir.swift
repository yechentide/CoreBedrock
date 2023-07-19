import Foundation
import CoreGraphics

public struct MCDir {
    public let dirURL: URL

    public let worldMeta: MCWorldMeta
    public var worldImage: CGImage? = nil
    public var dirSize: String? = nil
    public var lastOpened: Date? = nil

    public var worldName: String {
        worldMeta.worldName ?? "???"
    }

    public static func isMCWorldDir(dirURL: URL) throws -> Bool {
        guard FileManager.default.dirExists(at: dirURL) else { return false }

        var (hasDB, hasLevelDat, hasLevelName) = (false, false, false)
        let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
        let contents = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: keys)

        for fileURL in contents {
            let attributes = try fileURL.resourceValues(forKeys: Set(keys))
            if attributes.name == "db" && attributes.isDirectory! == true {
                hasDB = true
            } else if attributes.name == "level.dat" && attributes.isDirectory! == false {
                hasLevelDat = true
            } else if attributes.name == "levelname.txt" && attributes.isDirectory! == false {
                hasLevelName = true
            }
        }

        if hasDB && hasLevelDat && hasLevelName { return true }
        return false
    }

    public init(dirURL: URL, worldMeta: MCWorldMeta, worldImage: CGImage?, dirSize: String?, lastOpened: Date?) {
        self.dirURL = dirURL
        self.worldMeta = worldMeta
        self.worldImage = worldImage
        self.dirSize = dirSize
        self.lastOpened = lastOpened
    }

    public init(dirURL: URL) throws {
        let isMCDir = try Self.isMCWorldDir(dirURL: dirURL)
        if !isMCDir {
            throw CBLvDBError.invalidWorldDirectory(dirURL)
        }

        self.dirURL = dirURL
        self.dirSize = try dirURL.formattedDirectorySize()
        self.lastOpened = try dirURL.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate

        let levelDatURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
        self.worldMeta = try MCWorldMeta(from: levelDatURL)

        let imageURL = dirURL.appendingPathComponent("world_icon.jpeg", isDirectory: false)
        if let jpgImage = CGImage.loadJPG(url: imageURL) {
            self.worldImage = jpgImage
        }
    }

    public var lastOpenedLocalDate: String {
        guard let date = self.lastOpened else {
            return "???"
        }
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = .medium
        localDateFormatter.timeStyle = .medium
        localDateFormatter.dateFormat = "yyyy/MM/dd"
        return localDateFormatter.string(from: date)
    }

    public func move(to dstDir: URL) throws -> MCDir {
        let dstURL = dstDir.appendingPathComponent(self.dirURL.lastPathComponent, isDirectory: true)
        try FileManager.default.moveItem(at: self.dirURL, to: dstURL)
        return MCDir(dirURL: dstURL, worldMeta: worldMeta, worldImage: worldImage, dirSize: dirSize, lastOpened: lastOpened)
    }

    public func copy(to dstDir: URL, newDirName: String? = nil) throws -> MCDir {
        let oldName = dirURL.lastPathComponent
        let dstURL = dstDir.appendingPathComponent(newDirName ?? oldName, isDirectory: true)
        try FileManager.default.copyItem(at: dirURL, to: dstURL)
        return MCDir(dirURL: dstURL, worldMeta: worldMeta, worldImage: worldImage, dirSize: dirSize, lastOpened: lastOpened)
    }

    public func delete() throws {
        try FileManager.default.removeItem(at: dirURL)
    }

    public func parse() throws -> MCWorld {
        return try MCWorld(from: dirURL, meta: worldMeta)
    }
}
