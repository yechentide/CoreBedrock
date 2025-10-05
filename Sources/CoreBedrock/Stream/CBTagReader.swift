//
// Created by yechentide on 2025/04/20
//

import Foundation

public struct CBTagReader: CustomDebugStringConvertible {
    private var reader: CBBinaryReader

    public init(reader: CBBinaryReader) {
        self.reader = reader
    }

    public init(data: Data, littleEndian: Bool = true) {
        self.reader = CBBinaryReader(data: data, littleEndian: littleEndian)
    }

    public init(data: Data, offset: Int = 0, littleEndian: Bool = true) throws {
        self.reader = CBBinaryReader(data: data, littleEndian: littleEndian)
        try self.reader.skip(offset)
    }

    public var remainingByteCount: Int {
        self.reader.remainingByteCount
    }

    public var debugDescription: String {
        "CBTagReaderV2(remainingByteCount: \(self.reader.remainingByteCount))"
    }

    public func readAll() throws -> [NBT] {
        var tags: [NBT] = []
        while let tag = try readNext() {
            tags.append(tag)
        }
        return tags
    }

    public func readNext() throws -> NBT? {
        if self.reader.remainingByteCount <= 0 {
            return nil
        }

        let tagType = try reader.readTagType()
        if tagType == .end {
            return nil
        }

        let name = try reader.readNBTString()
        return try self.parseTag(type: tagType, name: name)
    }

    // swiftlint:disable cyclomatic_complexity

    private func parseTag(type: TagType, name: String?) throws -> NBT {
        switch type {
        case .byte: return try ByteTag(name: name, self.reader.readUInt8())
        case .short: return try ShortTag(name: name, self.reader.readInt16())
        case .int: return try IntTag(name: name, self.reader.readInt32())
        case .long: return try LongTag(name: name, self.reader.readInt64())
        case .float: return try FloatTag(name: name, self.reader.readFloat())
        case .double: return try DoubleTag(name: name, self.reader.readDouble())
        case .string: return try StringTag(name: name, self.reader.readNBTString())
        case .byteArray:
            let length = try reader.readInt32()
            let data = try reader.readBytes(Int(length))
            return ByteArrayTag(name: name, data)
        case .intArray:
            let length = try reader.readInt32()
            let array = try (0..<length).map { _ in try self.reader.readInt32() }
            return IntArrayTag(name: name, array)
        case .longArray:
            let length = try reader.readInt32()
            let array = try (0..<length).map { _ in try self.reader.readInt64() }
            return LongArrayTag(name: name, array)
        case .list:
            let listType = try reader.readTagType()
            let length = try reader.readInt32()
            var listItems: [NBT] = []
            for _ in 0..<length {
                let item = try parseTag(type: listType, name: nil)
                listItems.append(item)
            }
            return try ListTag(name: name, listItems, listType: listType)
        case .compound:
            let compound = CompoundTag(name: name)
            while true {
                let childType = try reader.readTagType()
                if childType == .end { break }
                let childName = try reader.readNBTString()
                let child = try parseTag(type: childType, name: childName)
                try compound.append(child)
            }
            return compound
        default:
            throw CBStreamError.invalidFormat("Unknown or unsupported tag type: \(type)")
        }
    }

    // swiftlint:enable cyclomatic_complexity
}
