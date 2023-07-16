import Foundation

public struct MCWorldMeta {
    public let version: Int32
    public let tag: CompoundTag

    public init(version: Int32, tag: CompoundTag) {
        self.version = version
        self.tag = tag
    }

    public init(from levelDatURL: URL) throws {
        let rawMetaData = try Data(contentsOf: levelDatURL)
        guard rawMetaData.count >= 8 else {
            throw CBLvDBError.failedParseLevelData(levelDatURL)
        }

        self.version = rawMetaData[0..<4].int32!

        let reader = CBReader(CBBuffer(rawMetaData[8...]))
        guard let tag = try reader.readAsTag() as? CompoundTag else {
            throw CBLvDBError.failedParseLevelData(levelDatURL)
        }
        self.tag = tag
    }

    public func toData() throws -> Data {
        let buffer = CBBuffer()
        let writter = try CBWriter(stream: buffer, rootTagName: "", useLittleEndian: true)
        for childTag in tag {
            try writter.writeTag(tag: childTag)
        }
        try writter.endCompound()
        try writter.finish()
        return Data(buffer.toArray())
    }

    public var worldName: String? {
        get {
            if let name = tag["LevelName"]?.stringValue {
                return name
            } else {
                return nil
            }
        }
    }

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
        return Date.formatDate(lastPlayedDate)
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
