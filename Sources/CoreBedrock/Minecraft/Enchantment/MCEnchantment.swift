public struct MCEnchantment {
    public let type: MCEnchantmentType
    public let level: UInt8

    public init?(type: MCEnchantmentType, level: UInt8) {
        guard level > 0, level <= type.maxLevel else { return nil }
        self.type = type
        self.level = level
    }
}
