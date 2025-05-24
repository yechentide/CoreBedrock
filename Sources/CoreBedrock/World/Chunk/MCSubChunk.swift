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

    private let blockBitsPerBlock: Int
    private let blockBlocksPerWord: Int
    private let blockMask: UInt32
    private let blockPalette: [MCBlock]
    private let blockIndicesData: [UInt8]

    private let waterBitsPerBlock: Int
    private let waterBlocksPerWord: Int
    private let waterPalette: [MCBlock]
    private let waterIndicesData: [UInt8]

    public init(
        chunkY: Int8, chunkVersion: UInt8,
        blockBitsPerBlock: Int, blockBlocksPerWord: Int,
        blockPalette: [MCBlock], blockIndicesData: [UInt8],
        waterBitsPerBlock: Int, waterBlocksPerWord: Int,
        waterPalette: [MCBlock], waterIndicesData: [UInt8]
    ) {
        self.chunkY = chunkY
        self.chunkVersion = chunkVersion

        self.blockBitsPerBlock = blockBitsPerBlock
        self.blockBlocksPerWord = blockBlocksPerWord
        self.blockMask = ~(UInt32.max << self.blockBitsPerBlock)
        self.blockPalette = blockPalette
        self.blockIndicesData = blockIndicesData

        self.waterBitsPerBlock = waterBitsPerBlock
        self.waterBlocksPerWord = waterBlocksPerWord
        self.waterPalette = waterPalette
        self.waterIndicesData = waterIndicesData
    }

    public func block(atLocalX localX: Int, localY: Int, localZ: Int) -> MCBlock? {
        guard let index = Self.linearIndex(localX, localY, localZ) else {
            return nil
        }

        let wordIndex: Int = index / blockBlocksPerWord
        let offset = wordIndex * 4
        guard offset + 4 <= blockIndicesData.count else { return nil }

        let word = UInt32(blockIndicesData[offset])
            | (UInt32(blockIndicesData[offset + 1]) << 8)
            | (UInt32(blockIndicesData[offset + 2]) << 16)
            | (UInt32(blockIndicesData[offset + 3]) << 24)
        let indexInWord = index % blockBlocksPerWord
        let paletteIndex: UInt32 = self.blockMask & (word >> (indexInWord * blockBitsPerBlock))

        guard paletteIndex < blockPalette.count else {
            return nil
        }
        return blockPalette[Int(paletteIndex)]
    }

    public func blocksInYColumn(atLocalX localX: Int, localZ: Int) -> [MCBlock]? {
        guard let baseIndex = Self.linearIndex(localX, 0, localZ) else {
            return nil
        }

        var blocks: [MCBlock] = []
        var currentWordIndex = baseIndex / blockBlocksPerWord
        var currentWord: UInt32?

        for y in 0..<Self.sideLength {
            let index = baseIndex + y
            let wordIndex: Int = index / blockBlocksPerWord

            if currentWord == nil || wordIndex != currentWordIndex {
                let offset = wordIndex * 4
                guard offset + 4 <= blockIndicesData.count else { return nil }

                currentWord = UInt32(blockIndicesData[offset])
                | (UInt32(blockIndicesData[offset + 1]) << 8)
                | (UInt32(blockIndicesData[offset + 2]) << 16)
                | (UInt32(blockIndicesData[offset + 3]) << 24)
                currentWordIndex = wordIndex
            }

            guard let word = currentWord else { return nil }
            let indexInWord = index % blockBlocksPerWord
            let paletteIndex = Int(self.blockMask & (word >> (indexInWord * blockBitsPerBlock)))

            guard paletteIndex < blockPalette.count else { return nil }
            blocks.append(blockPalette[paletteIndex])
        }

        return blocks
    }
}
