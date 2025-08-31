//
// Created by yechentide on 2024/07/14
//

import Foundation
import CoreGraphics

public struct MCDir: Sendable {
    public enum MCFileType: String {
        case db         = "db"
        case levelDat   = "level.dat"
        case worldName  = "levelname.txt"
        case worldImage = "world_icon.jpeg"

        public var isDirectory: Bool {
            switch self {
                case .db: return true
                default: return false
            }
        }
    }

    public static func generateURL(for type: MCFileType, in worldDirectory: URL) -> URL {
        return worldDirectory.appendingSafePath(type.rawValue, isDirectory: type.isDirectory)
    }

    public static func generatePath(for type: MCFileType, in worldDirectory: URL) -> String {
        return generateURL(for: type, in: worldDirectory).safePath(percentEncoded: false)
    }

    public let dirURL: URL

    public var dirSize: String? = nil
    public var lastOpenedDate: Date? = nil
    public var worldImage: CGImage? = nil

    public var worldName: String? = nil
    public var gameMode: MCGameMode? = nil
    public var difficulty: MCGameDifficulty? = nil
    public var lastPlayedDate: String? = nil

    public var isNetEaseWorld = false

    public init(dirURL: URL, dirSize: String? = nil, lastOpened: Date? = nil, worldImage: CGImage? = nil,
                worldName: String? = nil, gameMode: MCGameMode? = nil, difficulty: MCGameDifficulty? = nil,
                lastPlayedDate: String? = nil, isNetEaseWorld: Bool = false
    ) {
        self.dirURL = dirURL
        self.dirSize = dirSize
        self.lastOpenedDate = lastOpened
        self.worldImage = worldImage
        self.worldName = worldName
        self.gameMode = gameMode
        self.difficulty = difficulty
        self.lastPlayedDate = lastPlayedDate
        self.isNetEaseWorld = isNetEaseWorld
    }

    public init(dirURL: URL, detectWorldType: Bool = false) throws {
        let isMCDir = try FileManager.default.isMCWorldDir(at: dirURL)
        if !isMCDir {
            throw CBError.invalidWorldDirectory(dirURL)
        }

        self.dirURL = dirURL
        self.dirSize = try dirURL.formattedDirectorySize()
        self.lastOpenedDate = try dirURL.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate

        let imageURL = Self.generateURL(for: .worldImage, in: dirURL)
        if let jpgImage = CGImage.loadJPG(url: imageURL) {
            self.worldImage = jpgImage
        }

        let levelDatURL = Self.generateURL(for: .levelDat, in: dirURL)
        let worldMeta = try MCWorldMeta(from: levelDatURL)
        self.worldName = worldMeta.worldName
        self.gameMode = worldMeta.gameMode
        self.difficulty = worldMeta.difficulty
        self.lastPlayedDate = worldMeta.lastPlayedDate

        if detectWorldType {
            let dirPath = dirURL.safePath(percentEncoded: false)
            if let isNetEaseWorld = try? NetEaseWorldTransform.isNetEaseWorld(at: dirPath) {
                self.isNetEaseWorld = isNetEaseWorld
            }
        }
    }

    public var lastOpenedLocalDate: String {
        guard let date = self.lastOpenedDate else {
            return "???"
        }
        return date.dateString
    }

    public mutating func changeWorldName(to newName: String) throws {
        let levelDatURL = Self.generateURL(for: .levelDat, in: dirURL)
        var worldMeta = try MCWorldMeta(from: levelDatURL)
        worldMeta.worldName = newName
        try worldMeta.updateFiles(dirURL: dirURL)
        worldName = newName
    }

    public func parse() throws -> MCWorld {
        return try MCWorld(from: dirURL)
    }
}
