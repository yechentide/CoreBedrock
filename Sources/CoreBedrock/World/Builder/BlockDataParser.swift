//
// Created by yechentide on 2024/10/05
//

import Foundation

//enum PaletteMetaType: UInt8 {
//    case persistence = 0
//    case runtime = 1
//}

/**
Decode sub chunk data

ref.
- [Block Protocol in Beta 1.2.13](https://gist.github.com/Tomcc/a96af509e275b1af483b25c543cfbf37)
- [Bedrock Edition level format](https://minecraft.fandom.com/wiki/Bedrock_Edition_level_format/History#LevelDB_based_format)
*/
public struct BlockDataParser {
    private static let wordBitSize = 32

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
        let subChunk = MCSubChunk(chunkY: self.chunkY, chunkVersion: 9)

        let layerCount = try binaryReader.readUInt8()
        let chunkY = try binaryReader.readInt8()
        guard chunkY == self.chunkY,
              layerCount > 0,
              let blockLayer = try readBlockLayer()
        else {
            return nil
        }
        subChunk.setBlockLayer(palette: blockLayer.palette, indices: blockLayer.indices)

        if layerCount > 1 {
            if let waterLayer = try readBlockLayer() {
                subChunk.setWaterLayer(palette: waterLayer.palette, indices: waterLayer.indices)
            } else {
                return nil
            }
        }
        return subChunk
    }

    private func parseVersion8() throws -> MCSubChunk? {
        let subChunk = MCSubChunk(chunkY: self.chunkY, chunkVersion: 8)

        let layerCount = try binaryReader.readUInt8()
        guard layerCount > 0,
              let blockLayer = try readBlockLayer(),
              !blockLayer.palette.isEmpty,
              blockLayer.indices.count == MCSubChunk.totalBlockCount
        else {
            return nil
        }
        subChunk.setBlockLayer(palette: blockLayer.palette, indices: blockLayer.indices)

        if layerCount > 1 {
            if let waterLayer = try readBlockLayer() {
                subChunk.setWaterLayer(palette: waterLayer.palette, indices: waterLayer.indices)
            } else {
                return nil
            }
        }
        return subChunk
    }

    private func decodeClassic() throws -> MCSubChunk? {
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

        // key = specified block (id + state data)
        // value = index of the blockPalette
        var paletteIndexMap = [String: UInt16]()
        var blockPalette = [MCBlock]()
        var blockIndices = [UInt16]()

        for i in 0..<MCSubChunk.totalBlockCount {
            let blockID = blockIDList[i]
            let blockData = blockDataList[i]
            let key = "\(blockID),\(blockData)"
            if let index = paletteIndexMap[key] {
                blockIndices.append(index)
                continue
            }
            let index = UInt16(exactly: blockPalette.count) ?? 0
            // TODO: create MCBlock from block ID and block data
            let block = MCBlock(type: .unknown, states: CompoundTag(), version: 0)
            paletteIndexMap[key] = index
            blockPalette.append(block)
            blockIndices.append(index)
        }

        let subChunk = MCSubChunk(chunkY: self.chunkY, chunkVersion: 0)
        subChunk.setBlockLayer(palette: blockPalette, indices: blockIndices)
        return subChunk
    }

    private func readBlockLayer() throws -> (palette: [MCBlock], indices: [UInt16])? {
        let type = try binaryReader.readUInt8()
        guard type > 0 else {
            return nil
        }

        // let serializedType = type & 0x01
        let bitsPerBlock = Int(type >> 1)
        if bitsPerBlock == 0 {
            return ([], [])
        }

        guard 1...Self.wordBitSize ~= bitsPerBlock,
              let indices = try readBlockIndicesUnsafe(bitsPerBlock: bitsPerBlock)
        else {
            return nil
        }

        let paletteCount = try binaryReader.readUInt32()
        guard let maxIndex = indices.max(),
              maxIndex < paletteCount,
              paletteCount <= MCSubChunk.totalBlockCount,
              let palette = try readBlockPalette(count: paletteCount)
        else {
            return nil
        }

        return (palette, indices)
    }

    private func readBlockPalette(count: UInt32) throws -> [MCBlock]? {
        var palette = [MCBlock]()
        let tagReader = CBTagReader(reader: binaryReader)
        for _ in 0..<count {
            guard let paletteTag = try? tagReader.readNext() as? CompoundTag,
                  let block = MCBlock.decode(paletteTag)
            else {
                return nil
            }
            palette.append(block)
        }
        return palette
    }

    private func readBlockIndicesUnsafe(bitsPerBlock: Int) throws -> [UInt16]? {
        let blocksPerWord = Self.wordBitSize / bitsPerBlock
        let totalWords = Int(ceil(Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)))
        let totalBytes = totalWords * 4
        guard binaryReader.remainingByteCount >= totalBytes else {
            return nil
        }

        let rawData = try binaryReader.readBytes(totalBytes)
        var result = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
        let mask: UInt32 = (1 << bitsPerBlock) - 1

        rawData.withUnsafeBytes { (rawBuffer: UnsafeRawBufferPointer) in
            let wordPointer = rawBuffer.bindMemory(to: UInt32.self)
            let wordCount = wordPointer.count

            result.withUnsafeMutableBufferPointer { resultBuffer in
                var outputPtr = resultBuffer.baseAddress!
                var remaining = MCSubChunk.totalBlockCount

                for w in 0..<wordCount {
                    let word = UInt32(littleEndian: wordPointer[w])
                    for i in 0..<blocksPerWord {
                        guard remaining > 0 else { break }
                        let shift = i * bitsPerBlock
                        let value = (word >> shift) & mask
                        outputPtr.pointee = UInt16(truncatingIfNeeded: value)
                        outputPtr += 1
                        remaining -= 1
                    }
                }
            }
        }

        return result
    }

    @available(*, deprecated, message: "Legacy scalar implementation. Use readBlockIndicesUnsafe version for better performance.")
    private func readBlockIndices(bitsPerBlock: Int) throws -> [UInt16]? {
        let blocksPerWord = Self.wordBitSize / bitsPerBlock
        let totalWords = Int(ceil(   Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)   ))
        let totalBytes = totalWords * 4
        guard binaryReader.remainingByteCount >= totalBytes else {
            return nil
        }

        let mask: UInt32 = ~(UInt32(0xFFFF) << bitsPerBlock)
        var elements = [UInt16]()

        for _ in 0 ..< totalWords {
            let word = try binaryReader.readUInt32()
            for i in 0 ..< blocksPerWord {
                guard elements.count < MCSubChunk.totalBlockCount else { break }
                let element: UInt32 = mask & (word >> (i * bitsPerBlock))
                elements.append(UInt16(truncatingIfNeeded: element))
            }
        }

        return elements.count == MCSubChunk.totalBlockCount ? elements : nil
    }
}
