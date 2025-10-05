//
// Created by yechentide on 2025/09/20
//

protocol PaletteReadable {
    associatedtype PaletteValue

    var bitWidth: Int { get }
    var palette: [PaletteValue] { get }
    var indicesBytes: [UInt8] { get }
}

extension PaletteReadable {
    var indexBitMask: UInt32 {
        ~(UInt32.max << bitWidth)
    }

    var valuesPerWord: Int {
        CBBinaryReader.wordBitSize / bitWidth
    }

    func paletteValue(localX: Int, localY: Int, localZ: Int) -> PaletteValue? {
        guard let index = MCSubChunk.linearIndex(localX, localY, localZ) else {
            return nil
        }

        let wordIndex: Int = index / self.valuesPerWord
        let offset = wordIndex * 4
        guard offset + 4 <= indicesBytes.count else { return nil }

        let word = indicesBytes.withUnsafeBytes {
            $0.load(fromByteOffset: offset, as: UInt32.self)
        }
        let indexInWord = index % self.valuesPerWord
        let paletteIndex: UInt32 = self.indexBitMask & (word >> (indexInWord * bitWidth))

        guard paletteIndex < palette.count else {
            return nil
        }

        return palette[Int(paletteIndex)]
    }

    func paletteValue(in word: UInt32, atIndex indexInWord: Int) -> PaletteValue? {
        let paletteIndex = Int(self.indexBitMask & (word >> (indexInWord * self.bitWidth)))
        guard paletteIndex < self.palette.count else { return nil }

        return self.palette[paletteIndex]
    }
}
