public class MCBlock {
    public let name: String
    public let states: CompoundTag
    public let version: Int32

    public init(name: String, states: CompoundTag, version: Int32) {
        self.name = name
        self.states = states
        self.version = version
    }

    public static func decode(_ tag: CompoundTag) -> MCBlock? {
        let nameTag = tag["name"] as? StringTag
        let statesTag = tag["states"] as? CompoundTag
        let versionTag = tag["version"] as? IntTag
        guard let name = nameTag, let states = statesTag, let version = versionTag else {
            return nil
        }
        return MCBlock(name: name.value, states: states, version: version.value)
    }

    public func encode() -> CompoundTag {
        let rootTag = CompoundTag()
        let nameTag = StringTag(name: "name", name)
        let versionTag = IntTag(name: "version", version)
        try! rootTag.append(nameTag)
        try! rootTag.append(states)
        try! rootTag.append(versionTag)
        return rootTag
    }
}
