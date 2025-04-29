//
// Created by yechentide on 2025/04/19
//

public struct MCPendingTick {
    public let x: Int32
    public let y: Int32
    public let z: Int32
    public let time: Int64
    public let block: MCBlock

    public static func parse(rootTag: CompoundTag) -> MCPendingTick? {
        guard let blockStateTag = rootTag["blockState"] as? CompoundTag,
              let block = MCBlock.decode(blockStateTag),
              let timeTag = rootTag["time"] as? LongTag,
              let xTag = rootTag["x"] as? IntTag,
              let yTag = rootTag["y"] as? IntTag,
              let zTag = rootTag["z"] as? IntTag
        else {
            return nil
        }
        return MCPendingTick(
            x: xTag.value,
            y: yTag.value,
            z: zTag.value,
            time: timeTag.value,
            block: block
        )
    }
}
