public class MCBlock {
    public let type: MCBlockType
    public let nameTag: StringTag
    public let states: CompoundTag
    public let version: Int32

    public init(type: MCBlockType, nameTag: StringTag, states: CompoundTag, version: Int32) {
        self.type = type
        self.nameTag = nameTag
        self.states = states
        self.version = version
    }

    public static func decode(_ tag: CompoundTag) -> MCBlock? {
        guard let nameTag = tag["name"] as? StringTag,
              let statesTag = tag["states"] as? CompoundTag,
              let versionTag = tag["version"] as? IntTag
        else {
            return nil
        }
        let blockType = MCBlockType.parse(name: nameTag.value, stateTag: tag)
        return MCBlock(type: blockType, nameTag: nameTag, states: statesTag, version: versionTag.value)
    }

    public func encode() -> CompoundTag {
        let rootTag = CompoundTag()
        let versionTag = IntTag(name: "version", version)
        try! rootTag.append(nameTag)
        try! rootTag.append(states)
        try! rootTag.append(versionTag)
        return rootTag
    }

    public var name: String {
        nameTag.value
    }

    public var argbHex: UInt32? {
        type.argb
    }
}
