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

    public init(
        loadOption: MCChunkReadOptions, chunkX: Int32, chunkZ: Int32, minChunkY: Int32,
        version: UInt8, currentTikc: Int32, subChunks: [MCSubChunk],
        blockEntities: [Pos3Di32 : CompoundTag], entities: [CompoundTag],
        pendingTicks: [MCPendingTick], biomes: MCBiomeColumn
    ) {
        self.loadOption = loadOption
        self.chunkX = chunkX
        self.chunkZ = chunkZ
        self.minChunkY = minChunkY
        self.version = version
        self.currentTikc = currentTikc
        self.subChunks = subChunks.sorted { $0.chunkY < $1.chunkY }
        self.blockEntities = blockEntities
        self.entities = entities
        self.pendingTicks = pendingTicks
        self.biomes = biomes
    }

    public var minBlockX: Int {
        Int(chunkX) * MCSubChunk.sideLength
    }
    public var maxBlockX: Int {
        Int(chunkX) *  MCSubChunk.sideLength +  MCSubChunk.sideLength - 1
    }
    public var minBlockZ: Int {
        Int(chunkZ) *  MCSubChunk.sideLength
    }
    public var maxBlockZ: Int {
        Int(chunkZ) *  MCSubChunk.sideLength +  MCSubChunk.sideLength - 1
    }
    public var minBlockY: Int {
        guard !subChunks.isEmpty else {
            return Int(minChunkY) *  MCSubChunk.sideLength
        }
        return Int(subChunks.first!.chunkY) * MCSubChunk.sideLength
    }
    public var maxBlockY: Int {
        guard !subChunks.isEmpty else {
            return minChunkY < 0 ? 319 : 255
        }
        return Int(subChunks.last!.chunkY + 1) *  MCSubChunk.sideLength - 1
    }

    private func getSubChunk(fromBlockY blockY: Int) -> MCSubChunk? {
        let chunkY = convertPos(from: blockY, .blockToChunk)
        return subChunks.first(where: { $0.chunkY == chunkY })
    }

    public func block(x blockX: Int, y blockY: Int, z blockZ: Int) -> MCBlock? {
        guard let subChunk = getSubChunk(fromBlockY: blockY) else {
            return nil
        }
        let localX = blockX - Int(self.chunkX) * MCSubChunk.sideLength
        let localZ = blockZ - Int(self.chunkZ) * MCSubChunk.sideLength
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
