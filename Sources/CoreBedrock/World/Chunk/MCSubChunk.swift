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

        let wordIndex = Int(floor(Double(index) / Double(blockBlocksPerWord)))
        let wordBytesCount = CBBinaryReader.wordBitSize / 8
        guard (wordIndex+1) * wordBytesCount <= blockIndicesData.count else {
            return nil
        }

        let wordBytes = blockIndicesData[wordIndex*wordBytesCount..<(wordIndex+1)*wordBytesCount]
        guard let word = Data(wordBytes).uint32 else {
            return nil
        }
        let mask: UInt32 = ~(UInt32.max << self.blockBitsPerBlock)
        let indexInWord = index % blockBlocksPerWord
        let paletteIndex: UInt32 = mask & (word >> (indexInWord * blockBitsPerBlock))

        guard paletteIndex < blockPalette.count else {
            return nil
        }
        return blockPalette[Int(paletteIndex)]
    }
}
