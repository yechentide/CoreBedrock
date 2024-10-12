//
// Created by yechentide on 2024/07/14
//

import Foundation
import CoreGraphics

public struct MCDir {
    public let dirURL: URL

    public var dirSize: String? = nil
    public var lastOpenedDate: Date? = nil
    public var worldImage: CGImage? = nil

    public var worldName: String? = nil
    public var gameMode: MCGameMode? = nil
    public var difficulty: MCGameDifficulty? = nil
    public var lastPlayedDate: String? = nil

    public init(dirURL: URL, dirSize: String? = nil, lastOpened: Date? = nil, worldImage: CGImage? = nil,
                worldName: String? = nil, gameMode: MCGameMode? = nil, difficulty: MCGameDifficulty? = nil,
                lastPlayedDate: String? = nil
    ) {
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

        let imageURL = dirURL.appendingPathComponent("world_icon.jpeg", isDirectory: false)
        if let jpgImage = CGImage.loadJPG(url: imageURL) {
            self.worldImage = jpgImage
        }

        let levelDatURL = dirURL.appendingPathComponent("level.dat", isDirectory: false)
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
        return date.format("yyyy-MM-dd")
    }
}
