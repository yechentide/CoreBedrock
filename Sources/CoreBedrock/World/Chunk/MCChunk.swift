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

    private func getSubChunk(fromBlockY blockY: Int) -> MCSubChunk? {
        let chunkY = convertPos(from: blockY, .blockToChunk)
        let index = chunkY - Int(minChunkY)
        guard 0..<subChunks.count ~= index else { return nil }
        return subChunks[index]
    }

    public func block(x blockX: Int, y blockY: Int, z blockZ: Int) -> MCBlock? {
        let chunkX = convertPos(from: blockX, .blockToChunk)
        let chunkZ = convertPos(from: blockZ, .blockToChunk)
        guard chunkX == self.chunkX,
              chunkZ == self.chunkZ,
              let subChunk = getSubChunk(fromBlockY: blockY)
        else {
            return nil
        }
        let localX = blockX - chunkX * MCSubChunk.sideLength
        let localZ = blockZ - chunkZ * MCSubChunk.sideLength
        let localY = blockY - convertPos(from: blockY, .blockToChunk) * MCSubChunk.sideLength
        return subChunk.block(atLocalX: localX, localY: localY, localZ: localZ)
    }

    public func block(pos: Pos3Di32) -> MCBlock? {
        return block(x: Int(pos.x), y: Int(pos.y), z: Int(pos.z))
    }

    public func biome(x blockX: Int, y blockY: Int, z blockZ: Int) -> MCBiomeType? {
        guard !self.biomes.sections.isEmpty else {
            return nil
        }
        let chunkX = convertPos(from: blockX, .blockToChunk)
        let chunkZ = convertPos(from: blockZ, .blockToChunk)
        guard chunkX == self.chunkX, chunkZ == self.chunkZ else {
            return nil
        }
        let localX = blockX - chunkX * MCSubChunk.sideLength
        let localZ = blockZ - chunkZ * MCSubChunk.sideLength
        return self.biomes.biome(atLocalX: localX, blockY: blockY, localZ: localZ)
    }

    public func blockEntity(x blockX: Int, y blockY: Int, z blockZ: Int) -> CompoundTag? {
        let key = Pos3Di32(
            x: Int32(truncatingIfNeeded: blockX),
            y: Int32(truncatingIfNeeded: blockY),
            z: Int32(truncatingIfNeeded: blockZ)
        )
        return self.blockEntities[key]
    }

    public func blockEntity(pos: Pos3Di32) -> CompoundTag? {
        return self.blockEntities[pos]
    }
}
