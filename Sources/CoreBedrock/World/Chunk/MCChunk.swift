//
// Created by yechentide on 2024/10/05
//

import CoreGraphics
import LvDBWrapper

public struct MCChunk {
    public static var viewSize: Int { MCSubChunk.sideLength * MCSubChunk.sideLength }
    public static func calcRange(chunkIndex: Int32) -> ClosedRange<Int> {
        return Int(chunkIndex)*MCSubChunk.sideLength ... Int(chunkIndex+1)*MCSubChunk.sideLength-1
    }

    public let loadOption: MCChunkReadOptions

    public let chunkX: Int32
    public let chunkZ: Int32
    public private(set) var minChunkY: Int32

    public let version: UInt8
    public private(set) var currentTikc: Int32 = 0

    public private(set) var subChunks: [MCSubChunk]
    public private(set) var blockEntities: [Pos3Di32: CompoundTag]
    public private(set) var entities: [CompoundTag]
    public private(set) var pendingTicks: [MCPendingTick]
    public private(set) var biomes: MCBiomeColumn

    public var minBlockX: Int {
        Int(chunkX) * 16
    }
    public var maxBlockX: Int {
        Int(chunkX) * 16 + 15
    }
    public var minBlockZ: Int {
        Int(chunkZ) * 16
    }
    public var maxBlockZ: Int {
        Int(chunkZ) * 16 + 15
    }
    public var minBlockY: Int {
        Int(minChunkY) * 16
    }
    public var maxBlockY: Int {
        minChunkY < 0 ? 319 : 255
    }
}
