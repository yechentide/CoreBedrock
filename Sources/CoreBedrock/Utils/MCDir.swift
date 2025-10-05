//
// Created by yechentide on 2024/07/14
//

import CoreGraphics
import Foundation

public struct MCDir: Sendable {
    public enum MCFileType: String {
        case db
        case levelDat = "level.dat"
        case worldName = "levelname.txt"
        case worldImage = "world_icon.jpeg"

        public var isDirectory: Bool {
            switch self {
            case .db: true
            default: false
            }
        }
    }

    public static func generateURL(for type: MCFileType, in worldDirectory: URL) -> URL {
        worldDirectory.appendingCompatiblePath(type.rawValue, isDirectory: type.isDirectory)
    }

    public static func generatePath(for type: MCFileType, in worldDirectory: URL) -> String {
        self.generateURL(for: type, in: worldDirectory).compatiblePath(percentEncoded: false)
    }

    public let dirURL: URL

    public var dirSize: String?
    public var lastOpenedDate: Date?
    public var worldImage: CGImage?

    public var worldName: String?
    public var gameMode: MCGameMode?
    public var difficulty: MCGameDifficulty?
    public var lastPlayedDate: String?

    public init(dirURL: URL, dirSize: String? = nil, lastOpened: Date? = nil, worldImage: CGImage? = nil,
                worldName: String? = nil, gameMode: MCGameMode? = nil, difficulty: MCGameDifficulty? = nil,
                lastPlayedDate: String? = nil) {
        self.dirURL = dirURL
        self.dirSize = dirSize
        self.lastOpenedDate = lastOpened
        self.worldImage = worldImage
        self.worldName = worldName
        self.gameMode = gameMode
        self.difficulty = difficulty
        self.lastPlayedDate = lastPlayedDate
    }

    public init(dirURL: URL) throws {
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
    }

    public var lastOpenedLocalDate: String {
        guard let date = self.lastOpenedDate else {
            return "???"
        }

        return date.dateString
    }

    public mutating func changeWorldName(to newName: String) throws {
        let levelDatURL = Self.generateURL(for: .levelDat, in: self.dirURL)
        var worldMeta = try MCWorldMeta(from: levelDatURL)
        worldMeta.worldName = newName
        try worldMeta.updateFiles(dirURL: self.dirURL)
        self.worldName = newName
    }

    public func parse() throws -> MCWorld {
        try MCWorld(from: self.dirURL)
    }
}
