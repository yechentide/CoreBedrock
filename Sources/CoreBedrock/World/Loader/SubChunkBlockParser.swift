//
// Created by yechentide on 2025/05/10
//

import Foundation

//enum PaletteMetaType: UInt8 {
//    case persistence = 0
//    case runtime = 1
//}

/*
Decode sub chunk data

ref.
- [Block Protocol in Beta 1.2.13](https://gist.github.com/Tomcc/a96af509e275b1af483b25c543cfbf37)
- [Bedrock Edition level format](https://minecraft.fandom.com/wiki/Bedrock_Edition_level_format/History#LevelDB_based_format)
*/
internal struct SubChunkBlockParser {
    private let binaryReader: CBBinaryReader
    private let chunkY: Int8

    public init(data: Data, chunkY: Int8) {
        self.binaryReader = CBBinaryReader(data: data)
        self.chunkY = chunkY
    }

    public func parse() throws -> MCSubChunk? {
        let storageVersion = try binaryReader.readUInt8()
        return switch storageVersion {
            case 9: try parseVersion9()
            case 8: try parseVersion8()
            default: nil
        }
    }

    private func parseVersion9() throws -> MCSubChunk? {
        let layerCount = try binaryReader.readUInt8()
        let chunkY = try binaryReader.readInt8()
        guard chunkY == self.chunkY, layerCount > 0 else {
            return nil
        }

        let (blockIndicesData, blockBitsPerBlock, blockBlocksPerWord, _) = try binaryReader.readIndicesData()
        let blockPalette = try binaryReader.readBlockPalette()
        guard !blockPalette.isEmpty, !blockIndicesData.isEmpty else {
            return nil
        }

        var waterBitsPerBlock: Int = 1
        var waterBlocksPerWord: Int = CBBinaryReader.wordBitSize
        var waterPalette: [MCBlock] = []
        var waterIndicesData: [UInt8] = []
        if layerCount > 1 {
            (waterIndicesData, waterBitsPerBlock, waterBlocksPerWord, _) = try binaryReader.readIndicesData()
            waterPalette = try binaryReader.readBlockPalette()
            guard !waterPalette.isEmpty, !waterIndicesData.isEmpty else {
                return nil
            }
        }

        return MCSubChunk(
            chunkY: self.chunkY, chunkVersion: 9,
            blockBitsPerBlock: blockBitsPerBlock, blockBlocksPerWord: blockBlocksPerWord,
            blockPalette: blockPalette, blockIndicesData: blockIndicesData,
            waterBitsPerBlock: waterBitsPerBlock, waterBlocksPerWord: waterBlocksPerWord,
            waterPalette: waterPalette, waterIndicesData: waterIndicesData
        )
    }

    private func parseVersion8() throws -> MCSubChunk? {
        let layerCount = try binaryReader.readUInt8()
        guard layerCount > 0 else {
            return nil
        }

        let (blockIndicesData, blockBitsPerBlock, blockBlocksPerWord, _) = try binaryReader.readIndicesData()
        let blockPalette = try binaryReader.readBlockPalette()
        guard !blockPalette.isEmpty, !blockIndicesData.isEmpty else {
            return nil
        }

        var waterBitsPerBlock: Int = 1
        var waterBlocksPerWord: Int = CBBinaryReader.wordBitSize
        var waterPalette: [MCBlock] = []
        var waterIndicesData: [UInt8] = []
        if layerCount > 1 {
            (waterIndicesData, waterBitsPerBlock, waterBlocksPerWord, _) = try binaryReader.readIndicesData()
            waterPalette = try binaryReader.readBlockPalette()
            guard !waterPalette.isEmpty, !waterIndicesData.isEmpty else {
                return nil
            }
        }

        return MCSubChunk(
            chunkY: self.chunkY, chunkVersion: 9,
            blockBitsPerBlock: blockBitsPerBlock, blockBlocksPerWord: blockBlocksPerWord,
            blockPalette: blockPalette, blockIndicesData: blockIndicesData,
            waterBitsPerBlock: waterBitsPerBlock, waterBlocksPerWord: waterBlocksPerWord,
            waterPalette: waterPalette, waterIndicesData: waterIndicesData
        )
    }

    // TODO: create MCBlock from block ID and block data
    private func parseClassic() throws -> MCSubChunk? {
        var blockIDList = [UInt8]()
        var blockDataList = [UInt8]()
        // 4096 bytes for block ids
        for _ in 0..<MCSubChunk.totalBlockCount {
            let id = try binaryReader.readUInt8()
            blockIDList.append(id)
        }
        // Each byte contains 2 blocks: 4 bits per block
        for _ in 0..<(MCSubChunk.totalBlockCount/2) {
            let twoBlockData = try binaryReader.readUInt8()
            let firstBlockData = twoBlockData & 0x0F
            let secondBlockData = (twoBlockData >> 4) & 0x0F
            blockDataList.append(firstBlockData)
            blockDataList.append(secondBlockData)
        }

        var blockPalette = [MCBlock]()
        var blockIndicesData = [UInt8]()
        for i in 0..<MCSubChunk.totalBlockCount {
            // TODO: create MCBlock from block ID and block data
            // let blockID = blockIDList[i]
            // let blockData = blockDataList[i]
            let block = MCBlock(type: .unknown, states: CompoundTag(), version: 0)
            blockPalette.append(block)

            let word = UInt32(truncatingIfNeeded: i)
            let bytes: [UInt8] = withUnsafeBytes(of: word) { Array($0) }
            blockIndicesData.append(contentsOf: bytes)
        }

        return MCSubChunk(
            chunkY: self.chunkY, chunkVersion: 9,
            blockBitsPerBlock: CBBinaryReader.wordBitSize, blockBlocksPerWord: 1,
            blockPalette: blockPalette, blockIndicesData: blockIndicesData,
            waterBitsPerBlock: 1, waterBlocksPerWord: CBBinaryReader.wordBitSize,
            waterPalette: [], waterIndicesData: []
        )
    }

    // MARK: - Skip indices parsing for better performance
//    private func parseBlockIndicesUnsafe(from rawData: [UInt8], bitsPerBlock: Int, blocksPerWord: Int) throws -> [UInt16]? {
//        var result = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
//        let mask: UInt32 = (1 << bitsPerBlock) - 1
//        rawData.withUnsafeBytes { (rawBuffer: UnsafeRawBufferPointer) in
//            let wordPointer = rawBuffer.bindMemory(to: UInt32.self)
//            let wordCount = wordPointer.count
//            result.withUnsafeMutableBufferPointer { resultBuffer in
//                var outputPtr = resultBuffer.baseAddress!
//                var remaining = MCSubChunk.totalBlockCount
//                for w in 0..<wordCount {
//                    let word = UInt32(littleEndian: wordPointer[w])
//                    for i in 0..<blocksPerWord {
//                        guard remaining > 0 else { break }
//                        let shift = i * bitsPerBlock
//                        let value = (word >> shift) & mask
//                        outputPtr.pointee = UInt16(truncatingIfNeeded: value)
//                        outputPtr += 1
//                        remaining -= 1
//                    }
//                }
//            }
//        }
//        return result
//    }
//
//    @available(*, deprecated, renamed: "parseBlockIndicesUnsafe", message: "")
//    private func readBlockIndices(bitsPerBlock: Int) throws -> [UInt16]? {
//        let blocksPerWord = Self.wordBitSize / bitsPerBlock
//        let totalWords = Int(ceil(   Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)   ))
//        let totalBytes = totalWords * 4
//        guard binaryReader.remainingByteCount >= totalBytes else {
//            return nil
//        }
//
//        let mask: UInt32 = ~(UInt32(0xFFFF) << bitsPerBlock)
//        var elements = [UInt16]()
//
//        for _ in 0 ..< totalWords {
//            let word = try binaryReader.readUInt32()
//            for i in 0 ..< blocksPerWord {
//                guard elements.count < MCSubChunk.totalBlockCount else { break }
//                let element: UInt32 = mask & (word >> (i * bitsPerBlock))
//                elements.append(UInt16(truncatingIfNeeded: element))
//            }
//        }
//
//        return elements.count == MCSubChunk.totalBlockCount ? elements : nil
//    }
}
