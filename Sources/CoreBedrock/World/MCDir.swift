//
// Created by yechentide on 2024/07/14
//

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

    public init(dirURL: URL, worldMeta: MCWorldMeta, worldImage: CGImage?, dirSize: String?, lastOpened: Date?) {
        self.dirURL = dirURL
        self.worldMeta = worldMeta
        self.worldImage = worldImage
        self.dirSize = dirSize
        self.lastOpened = lastOpened
    }

    public init(dirURL: URL) throws {
        let isMCDir = try MCDirManager.isMCWorldDir(at: dirURL)
        if !isMCDir {
            throw CBError.invalidWorldDirectory(dirURL)
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
        return Date.formatDate(date)
    }
}

