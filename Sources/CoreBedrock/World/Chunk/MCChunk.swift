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

    let loadOption: MCChunkReadOptions

    let chunkX: Int32
    let chunkZ: Int32
    var minChunkY: Int32

    let version: UInt8
    var currentTikc: Int32 = 0

    var subChunks: [MCSubChunk]
    var blockEntities: [Pos3Di32: CompoundTag]
    var entities: [CompoundTag]
    var pendingTicks: [MCPendingTick]
    var biomes: MCBiomeColumn

    var minBlockX: Int {
        Int(chunkX) * 16
    }
    var maxBlockX: Int {
        Int(chunkX) * 16 + 15
    }
    var minBlockZ: Int {
        Int(chunkZ) * 16
    }
    var maxBlockZ: Int {
        Int(chunkZ) * 16 + 15
    }
    var minBlockY: Int {
        Int(minChunkY) * 16
    }
    var maxBlockY: Int {
        minChunkY < 0 ? 319 : 255
    }
}
