//
// Created by yechentide on 2025/04/20
//

import Foundation

public enum BlockPaletteReader {
    static let wordBitSize = 32

    static func readWords(from data: Data, bitsPerBlock: Int) throws -> [UInt16]? {
        let blocksPerWord = Self.wordBitSize / bitsPerBlock
        let totalWords = Int(ceil(   Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)   ))
        let totalBytes = totalWords * 4
        guard data.count >= totalBytes else {
            return nil
        }

        let reader = CBBinaryReader(data: data)
        let mask: UInt32 = ~(UInt32(0xFFFF) << bitsPerBlock)
        var elements = [UInt16]()

        for _ in 0 ..< totalWords {
            let word = try reader.readUInt32()
            for i in 0 ..< blocksPerWord {
                guard elements.count < MCSubChunk.totalBlockCount else { break }
                let element: UInt32 = mask & (word >> (i * bitsPerBlock))
                elements.append(UInt16(truncatingIfNeeded: element))
            }
        }

        return elements.count == MCSubChunk.totalBlockCount ? elements : nil
    }
}
