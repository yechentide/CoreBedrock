//
// Created by yechentide on 2024/07/14
//

import Foundation

public struct MCWorldMeta {
    public static let levelDatFile = "level.dat"
    public static let worldNameFile = "levelname.txt"

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

        let reader = CBTagReader(CBBuffer(rawData[8...]))
        guard let tag = try reader.readAsTag() as? CompoundTag else {
            throw CBError.failedParseLevelData(levelDatURL)
        }
        self.tag = tag
    }

    public func toData() throws -> Data {
        let buffer = CBBuffer()
        let writter = try CBTagWriter(stream: buffer, rootTagName: "", useLittleEndian: true)
        for childTag in tag {
            try writter.writeTag(tag: childTag)
        }
        try writter.endCompound()
        try writter.finish()
        return Data(buffer.toArray())
    }

    public func updateFiles(dirURL: URL) throws {
        let levelDatURL = dirURL.appendingPathComponent(Self.levelDatFile, isDirectory: false)

        let tagData = try toData()
        let metaRawData = version.data + Int32(tagData.count).data + tagData
        try metaRawData.write(to: levelDatURL)

        let nameFileURL = dirURL.appendingPathComponent(Self.worldNameFile, isDirectory: false)
        let nameFilePath = if #available(iOS 16.0, macOS 13.0, *) {
            nameFileURL.path()
        } else {
            nameFileURL.path
        }
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
            if let newName = newValue {
                let nameTag = StringTag(name: "LevelName", newName)
                tag["LevelName"] = nameTag
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
