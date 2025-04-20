//
// Created by yechentide on 2024/07/14
//

import Foundation

public struct MCWorldMeta {
    public let version: Int32
    public var tag: CompoundTag

    public init(version: Int32, tag: CompoundTag) {
        self.version = version
        self.tag = tag
    }

    public init(from levelDatURL: URL) throws {
        let rawData = try Data(contentsOf: levelDatURL)
        try self.init(rawData: rawData, levelDatURL: levelDatURL)
    }

    public init(rawData: Data, levelDatURL: URL? = nil) throws {
        guard rawData.count >= 8 else {
            throw CBError.failedParseLevelData(levelDatURL)
        }

        self.version = rawData[0..<4].int32!

        let reader = CBTagReader(data: rawData[8...])
        guard let tag = try reader.readNext() as? CompoundTag else {
            throw CBError.failedParseLevelData(levelDatURL)
        }
        self.tag = tag
    }

    public func toData() throws -> Data {
        let buffer = CBBuffer()
        let writter = CBTagWriter(buffer: buffer)
        try writter.write(tag: tag)
        return writter.toData()
    }

    public func updateFiles(dirURL: URL) throws {
        let levelDatURL = MCDir.generateURL(for: .levelDat, in: dirURL)

        let tagData = try toData()
        let metaRawData = version.data + Int32(tagData.count).data + tagData
        try metaRawData.write(to: levelDatURL)

        let nameFileURL = MCDir.generateURL(for: .worldName, in: dirURL)
        let nameFilePath = MCDir.generatePath(for: .worldName, in: dirURL)
        if FileManager.default.fileExists(atPath: nameFilePath) {
            if let worldName = worldName {
                try worldName.write(to: nameFileURL, atomically: true, encoding: .utf8)
            }
        }
    }

    // MARK: - getter / setter
    public var worldName: String? {
        get {
            if let name = tag["LevelName"]?.stringValue {
                return name
            } else {
                return nil
            }
        }
        set {
            if let newName = newValue, let nameTag = tag["LevelName"] as? StringTag {
                nameTag.value = newName
            }
        }
    }

    // MARK: - getters
    public var gameMode: MCGameMode {
        guard let modeRawValue = tag["GameType"]?.intValue,
              let mode = MCGameMode(rawValue: modeRawValue)
        else {
            return MCGameMode.unknown
        }
        return mode
    }

    public var difficulty: MCGameDifficulty {
        guard let difficultyRawValue = tag["Difficulty"]?.intValue,
              let difficulty = MCGameDifficulty(rawValue: difficultyRawValue)
        else {
            return MCGameDifficulty.unknown
        }
        return difficulty
    }

    public var inventoryVersion: String? {
        guard let inventoryVersion = tag["InventoryVersion"]?.stringValue
        else {
            return nil
        }
        return inventoryVersion
    }

    public var lastPlayedDate: String? {
        guard let lastPlayed = tag["LastPlayed"]?.longValue
        else {
            return nil
        }
        let lastPlayedDate = Date(timeIntervalSince1970: TimeInterval(lastPlayed))
        return lastPlayedDate.format("yyyy-MM-dd")
    }

    public var lastOpenedVersion: String? {
        guard let lastOpenedWithVertion = tag["lastOpenedWithVersion"] as? ListTag,
              lastOpenedWithVertion.listType == .int
        else {
            return nil
        }
        return lastOpenedWithVertion.tags
            .map {"\($0.intValue)"}
            .joined(separator: ".")
    }

    public var seed: String? {
        guard let seed = tag["RandomSeed"]?.stringValue
        else {
            return nil
        }
        return seed
    }
}
