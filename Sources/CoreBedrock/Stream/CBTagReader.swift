//
// Created by yechentide on 2025/04/20
//

import Foundation

public struct CBTagReader: CustomDebugStringConvertible {
    private var reader: CBBinaryReader

    public init(data: Data, littleEndian: Bool = true) {
        self.reader = CBBinaryReader(data: data, littleEndian: littleEndian)
    }

    public var remainingByteCount: Int {
        reader.remainingByteCount
    }

    public var debugDescription: String {
        "CBTagReaderV2(remainingByteCount: \(reader.remainingByteCount))"
    }

    public func readAll() throws -> [NBT] {
        var tags: [NBT] = []
        while let tag = try readNext() {
            tags.append(tag)
        }
        return tags
    }

    public func readNext() throws -> NBT? {
        if reader.remainingByteCount <= 0 {
            return nil
        }

        let tagType = try reader.readTagType()
        if tagType == .end {
            return nil
        }

        let name = try reader.readNBTString()
        return try parseTag(type: tagType, name: name)
    }

    private func parseTag(type: TagType, name: String?) throws -> NBT {
        switch type {
            case .byte:       return ByteTag(name: name, try reader.readUInt8())
            case .short:      return ShortTag(name: name, try reader.readInt16())
            case .int:        return IntTag(name: name, try reader.readInt32())
            case .long:       return LongTag(name: name, try reader.readInt64())
            case .float:      return FloatTag(name: name, try reader.readFloat())
            case .double:     return DoubleTag(name: name, try reader.readDouble())
            case .string:     return StringTag(name: name, try reader.readNBTString())
            case .byteArray:
                let length = try reader.readInt32()
                let data = try reader.readBytes(Int(length))
                return ByteArrayTag(name: name, data)
            case .intArray:
                let length = try reader.readInt32()
                let array = try (0..<length).map { _ in try reader.readInt32() }
                return IntArrayTag(name: name, array)
            case .longArray:
                let length = try reader.readInt32()
                let array = try (0..<length).map { _ in try reader.readInt64() }
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
}
