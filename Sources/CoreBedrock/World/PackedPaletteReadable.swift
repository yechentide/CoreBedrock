//
// Created by yechentide on 2025/09/20
//

public protocol PackedPaletteReadable {
    associatedtype PaletteValue

    var bitWidth: Int { get }
    var palette: [PaletteValue] { get }
    var indicesBytes: [UInt8] { get }
}

public extension PackedPaletteReadable {
    var indexBitMask: UInt32 {
        ~(UInt32.max << bitWidth)
    }

    var valuesPerWord: Int {
        CBBinaryReader.wordBitSize / bitWidth
    }

    func paletteIndex(localX: Int, localY: Int, localZ: Int) -> Int? {
        guard let linearIndex = MCSubChunk.linearIndex(localX, localY, localZ) else {
            return nil
        }

        return self.paletteIndex(at: linearIndex)
    }

    func paletteIndex(at linearIndex: Int) -> Int? {
        guard 0..<MCSubChunk.totalBlockCount ~= linearIndex else {
            return nil
        }

        let wordIndex = linearIndex / self.valuesPerWord
        let byteOffset = wordIndex * 4
        guard byteOffset + 4 <= self.indicesBytes.count else { return nil }

        let word = self.indicesBytes.withUnsafeBytes {
            $0.load(fromByteOffset: byteOffset, as: UInt32.self)
        }
        let indexInWord = linearIndex % self.valuesPerWord
        return self.paletteIndex(in: word, atIndex: indexInWord)
    }

    func paletteIndex(in word: UInt32, atIndex indexInWord: Int) -> Int? {
        let paletteIndex = Int(self.indexBitMask & (word >> (indexInWord * self.bitWidth)))
        guard paletteIndex < self.palette.count else { return nil }

        return paletteIndex
    }

    func paletteValue(localX: Int, localY: Int, localZ: Int) -> PaletteValue? {
        guard let paletteIndex = self.paletteIndex(localX: localX, localY: localY, localZ: localZ) else { return nil }
        return self.palette[paletteIndex]
    }

    func paletteValue(in word: UInt32, atIndex indexInWord: Int) -> PaletteValue? {
        guard let paletteIndex = self.paletteIndex(in: word, atIndex: indexInWord) else { return nil }
        return self.palette[paletteIndex]
    }

    func unpackPaletteIndices() -> [UInt16]? {
        var result = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)

        for linear in 0..<MCSubChunk.totalBlockCount {
            let wordIndex = linear / self.valuesPerWord
            let byteOffset = wordIndex * 4

            guard byteOffset + 4 <= self.indicesBytes.count else { return nil }

            let word = self.indicesBytes.withUnsafeBytes {
                $0.load(fromByteOffset: byteOffset, as: UInt32.self)
            }
            let indexInWord = linear % self.valuesPerWord
            guard let paletteIndex = self.paletteIndex(in: word, atIndex: indexInWord) else { return nil }
            result[linear] = UInt16(paletteIndex)
        }

        return result
    }
}
