//
// Created by yechentide on 2024/10/05
//

public class MCBlock {
    public let type: MCBlockType
    public let states: CompoundTag
    public let version: Int32

    public init(type: MCBlockType, states: CompoundTag, version: Int32) {
        self.type = type
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
        let type = MCBlockType(rawValue: nameTag.value) ?? .unknown
        return MCBlock(
            type: type, states: statesTag, version: versionTag.value
        )
    }

    public func encode() -> CompoundTag {
        let rootTag = CompoundTag()
        let nameTag = StringTag(name: "name", type.rawValue)
        let versionTag = IntTag(name: "version", version)
        try! rootTag.append(nameTag)
        try! rootTag.append(states)
        try! rootTag.append(versionTag)
        return rootTag
    }
}
