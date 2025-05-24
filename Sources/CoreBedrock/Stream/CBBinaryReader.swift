//
// Created by yechentide on 2025/04/20
//

import Foundation

public struct CBBinaryReader: CustomDebugStringConvertible {
    // MARK: - Properties

    public static let wordBitSize = 32

    private let buffer: CBBuffer
    private let swapNeeded: Bool

    // MARK: - Initializers

    public init(data: Data, littleEndian: Bool = true) {
        self.init(buffer: CBBuffer(data: data), littleEndian: littleEndian)
    }

    public init(buffer: CBBuffer, littleEndian: Bool = true) {
        self.buffer = buffer
        let isLittleEndian = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        self.swapNeeded = isLittleEndian != littleEndian
    }

    // MARK: - Computed Properties

    public var remainingByteCount: Int {
        return buffer.count - buffer.currentPosition
    }

    public var debugDescription: String {
        "CBBinaryReaderV2(position: \(buffer.currentPosition), remainingByteCount: \(remainingByteCount))"
    }

    public func skip(_ count: Int) throws {
        guard count >= 0 else {
            throw CBStreamError.argumentOutOfRange("count", "Non-negative number required.")
        }
        if count == 0 { return }

        // advance the position using seek instead of allocating temporary buffer
        try buffer.seek(to: count, from: .current)
    }

    public func readBytes(_ count: Int) throws -> [UInt8] {
        guard count >= 0 else {
            throw CBStreamError.argumentOutOfRange("count", "Non-negative number required.")
        }
        var output = [UInt8](repeating: 0, count: count)
        let readCount = try buffer.read(into: &output, count: count)
        guard readCount == count else {
            throw CBStreamError.endOfStream
        }
        return output
    }

    public func readAllBytes() throws -> [UInt8] {
        return try readBytes(remainingByteCount)
    }

    private func convert<T>(_ bytes: [UInt8]) -> T {
        let data = swapNeeded ? Data(bytes.reversed()) : Data(bytes)
        return data.withUnsafeBytes { $0.load(as: T.self) }
    }
}

extension CBBinaryReader {
    // MARK: - Integer Reads

    public func readUInt8() throws -> UInt8 {
        let bytes = try readBytes(1)
        return convert(bytes)
    }

    public func readInt8() throws -> Int8 {
        let bytes = try readBytes(1)
        return convert(bytes)
    }

    public func readUInt16() throws -> UInt16 {
        let bytes = try readBytes(2)
        return convert(bytes)
    }

    public func readInt16() throws -> Int16 {
        let bytes = try readBytes(2)
        return convert(bytes)
    }

    public func readUInt32() throws -> UInt32 {
        let bytes = try readBytes(4)
        return convert(bytes)
    }

    public func readInt32() throws -> Int32 {
        let bytes = try readBytes(4)
        return convert(bytes)
    }

    public func readUInt64() throws -> UInt64 {
        let bytes = try readBytes(8)
        return convert(bytes)
    }

    public func readInt64() throws -> Int64 {
        let bytes = try readBytes(8)
        return convert(bytes)
    }

    // MARK: - Floating Point Reads

    public func readFloat() throws -> Float {
        let bytes = try readBytes(4)
        return convert(bytes)
    }

    public func readDouble() throws -> Double {
        let bytes = try readBytes(8)
        return convert(bytes)
    }
}

extension CBBinaryReader {
    // MARK: - NBT Reads

    public func readTagType() throws -> TagType {
        let raw = try readUInt8()
        guard let type = TagType(rawValue: raw), raw <= TagType.longArray.rawValue else {
            throw CBStreamError.invalidFormat("NBT tag type out of range: \(raw)")
        }
        return type
    }

    public func readNBTString() throws -> String {
        let length = try readUInt16()
        guard length > 0 else {
            return ""
        }

        let bytes = try readBytes(Int(length))
        if let string = String(bytes: bytes, encoding: .utf8) {
            return string
        }
        if let latin1 = String(data: Data(bytes), encoding: .isoLatin1) {
            return latin1
        }
        throw CBStreamError.stringConversionError
    }

    public func skipNBTString() throws {
        let length = try readInt16()
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative string length given!") }
        try skip(Int(length))
    }
}

extension CBBinaryReader {
    // Mark: - SubChunk Reads

    public func readIndicesData() throws -> (rawData: [UInt8], bitsPerBlock: Int, blocksPerWord: Int, totalWords: Int) {
        let type = try readUInt8()
        guard type > 0 else {
            throw CBStreamError.invalidFormat("Invalid block indices data type: \(type)")
        }
        // let serializedType = type & 0x01
        let bitsPerBlock = Int(type >> 1)
        guard 1...Self.wordBitSize ~= bitsPerBlock else {
            throw CBStreamError.invalidFormat("Invalid block bit size: \(bitsPerBlock)")
        }

        let blocksPerWord = Self.wordBitSize / bitsPerBlock
        let totalWords = Int(ceil(Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)))
        let totalBytes = totalWords * 4
        guard remainingByteCount >= totalBytes else {
            throw CBStreamError.endOfStream
        }
        let rawData = try readBytes(totalBytes)
        return (rawData, bitsPerBlock, blocksPerWord, totalWords)
    }

    public func readBlockPalette() throws -> [MCBlock] {
        let paletteCount = try readUInt32()
        guard paletteCount <= MCSubChunk.totalBlockCount else {
            throw CBStreamError.argumentOutOfRange("paletteCount", "Palette count out of range: \(paletteCount)")
        }
        var palette = [MCBlock]()
        let tagReader = CBTagReader(reader: self)
        for _ in 0..<paletteCount {
            guard let paletteTag = try? tagReader.readNext() as? CompoundTag,
                  let block = MCBlock.decode(paletteTag)
            else {
                throw CBStreamError.invalidFormat("Invalid block tag found in palette")
            }
            palette.append(block)
        }
        return palette
    }
}
