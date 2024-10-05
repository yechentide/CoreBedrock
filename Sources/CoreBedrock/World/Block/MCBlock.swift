//
// Created by yechentide on 2024/10/05
//

public class MCBlock {
    public let type: String
    public let nameTag: StringTag
    public let states: CompoundTag
    public let version: Int32

    public init(type: String, nameTag: StringTag, states: CompoundTag, version: Int32) {
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
        return MCBlock(
            type: nameTag.value, nameTag: nameTag, states: statesTag, version: versionTag.value
        )
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
}
