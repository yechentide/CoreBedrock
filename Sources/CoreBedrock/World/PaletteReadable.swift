//
// Created by yechentide on 2025/09/20
//

internal protocol PaletteReadable {
    associatedtype PaletteValue

    var bitWidth: Int { get }
    var palette: [PaletteValue] { get }
    var indicesBytes: [UInt8] { get }
}

extension PaletteReadable {
    internal var indexBitMask: UInt32 {
        ~(UInt32.max << bitWidth)
    }

    internal var valuesPerWord: Int {
        CBBinaryReader.wordBitSize / bitWidth
    }

    internal func paletteValue(localX: Int, localY: Int, localZ: Int) -> PaletteValue? {
        guard let index = MCSubChunk.linearIndex(localX, localY, localZ) else {
            return nil
        }

        let wordIndex: Int = index / valuesPerWord
        let offset = wordIndex * 4
        guard offset + 4 <= indicesBytes.count else { return nil }

        let word = indicesBytes.withUnsafeBytes {
            $0.load(fromByteOffset: offset, as: UInt32.self)
        }
        let indexInWord = index % valuesPerWord
        let paletteIndex: UInt32 = indexBitMask & (word >> (indexInWord * bitWidth))

        guard paletteIndex < palette.count else {
            return nil
        }
        return palette[Int(paletteIndex)]
    }

    internal func paletteValue(in word: UInt32, atIndex indexInWord: Int) -> PaletteValue? {
        let paletteIndex = Int(self.indexBitMask & (word >> (indexInWord * self.bitWidth)))
        guard paletteIndex < self.palette.count else { return nil }
        return self.palette[paletteIndex]
    }
}
