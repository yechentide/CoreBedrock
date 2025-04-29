//
// Created by yechentide on 2024/10/05
//

import Foundation

public class MCSubChunk {
    public static let sideLength = 16
    public static let totalBlockCount = 4096 // 16 * 16 * 16
    public static let localPosRange = 0 ..< MCSubChunk.sideLength
    public static func linearIndex(_ localX: Int, _ localY: Int, _ localZ: Int) -> Int? {
        guard localPosRange ~= localX, localPosRange ~= localY, localPosRange ~= localZ else {
            return nil
        }
        return (localX * MCSubChunk.sideLength + localZ) * MCSubChunk.sideLength + localY
    }

    public let chunkY: Int8
    public let chunkVersion: UInt8
    public private(set) var blockPalette: [MCBlock] = []
    public private(set) var blockIndices: [UInt16] = []
    public private(set) var waterPalette: [MCBlock] = []
    public private(set) var waterIndices: [UInt16] = []

    public init(chunkY: Int8, chunkVersion: UInt8) {
        self.chunkY = chunkY
        self.chunkVersion = chunkVersion
    }

    public init(chunkY: Int8, chunkVersion: UInt8, blockPalette: [MCBlock], blockIndices: [UInt16], waterPalette: [MCBlock], waterIndices: [UInt16]) {
        self.chunkY = chunkY
        self.chunkVersion = chunkVersion
        self.blockPalette = blockPalette
        self.blockIndices = blockIndices
        self.waterPalette = waterPalette
        self.waterIndices = waterIndices
    }

    public func setBlockLayer(palette: [MCBlock], indices: [UInt16]) {
        self.blockPalette = palette
        self.blockIndices = indices
    }

    public func setWaterLayer(palette: [MCBlock], indices: [UInt16]) {
        self.waterPalette = palette
        self.waterIndices = indices
    }

    public func block(atLocalX localX: Int, localY: Int, localZ: Int) -> MCBlock? {
        guard let index = Self.linearIndex(localX, localY, localZ),
              0..<blockIndices.count ~= index
        else {
            return nil
        }
        let paletteIndex = Int(blockIndices[index])
        guard paletteIndex < blockPalette.count
        else {
            return nil
        }
        return blockPalette[paletteIndex]
    }
}
