import Foundation

public struct MCLevelData: CustomStringConvertible {
    private var version: Int32
    public var rootTag: CompoundTag

    public init(srcURL: URL) throws {
        guard let nbtData = try? Data(contentsOf: srcURL), nbtData.count > 8 else {
            throw CBLvDBError.failedParseLevelData(srcURL)
        }

        version = nbtData[0...3].int32!
        // data length: nbtData[4...7].int32

        let stream = CBBuffer(nbtData[8...])
        let reader = CBReader(stream)
        rootTag = try reader.readAsTag() as! CompoundTag
        if rootTag.tagType != .compound {
            throw CBLvDBError.failedParseLevelData(srcURL)
        }
    }

    public var description: String {
        return "Version: \(version)\nContent:\n\(rootTag.description)"
    }

    public func save(to dstURL: URL) {
        do {
            let ms = CBBuffer()
            let writer = try CBWriter(stream: ms, rootTagName: "")

            for tag in rootTag {
                try writer.writeTag(tag: tag)
            }

            try writer.endCompound()
            try writer.finish()

            let contentData = Data(ms.toArray())
            let data = version.data + Int32(contentData.count).data + contentData
            try data.write(to: dstURL)
        } catch {
            fatalError("Error: faild save")
        }
    }

    public var worldName: String {
        get {
            return rootTag["LevelName"]?.stringValue ?? ""
        }
        set {
            (rootTag["LevelName"] as? StringTag)?.value = newValue
        }
    }

    public var difficulty: Int32 {
        get {
            return rootTag["Difficulty"]?.intValue ?? 0
        }
        set {
            (rootTag["Difficulty"] as? IntTag)?.value = newValue
        }
    }
}
