//
// Created by yechentide on 2025/04/19
//

public struct MCChunkReadOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let block         = MCChunkReadOptions(rawValue: 1 << 0)
    public static let biome         = MCChunkReadOptions(rawValue: 1 << 1)
    public static let pendingTicks  = MCChunkReadOptions(rawValue: 1 << 2)
    public static let blockEntities = MCChunkReadOptions(rawValue: 1 << 3)
    public static let entities      = MCChunkReadOptions(rawValue: 1 << 4)

    public static let all: MCChunkReadOptions = [
        .block,
        .biome,
        .pendingTicks,
        .blockEntities,
        .entities
    ]

    public static let blockAndBiome: MCChunkReadOptions = [
        .block,
        .biome
    ]
}
