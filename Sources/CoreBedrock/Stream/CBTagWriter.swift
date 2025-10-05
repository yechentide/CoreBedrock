//
// Created by yechentide on 2025/04/20
//

import Foundation

public struct CBTagWriter: CustomDebugStringConvertible {
    private let writer: CBBinaryWriter

    public init(littleEndian: Bool = true) {
        self.writer = CBBinaryWriter(littleEndian: littleEndian)
    }

    public init(buffer: CBBuffer, littleEndian: Bool = true) {
        self.writer = CBBinaryWriter(buffer: buffer, littleEndian: littleEndian)
    }

    public init(capacity: Int = 64, littleEndian: Bool = true) {
        self.writer = CBBinaryWriter(capacity: capacity, littleEndian: littleEndian)
    }

    public var count: Int { self.writer.count }

    public var debugDescription: String {
        "CBTagWriterV2(bufferCount: \(self.writer.count))"
    }

    public func toData() -> Data {
        self.writer.data
    }

    public func write(tag: NBT) throws {
        try self.writeTag(tag)
    }

    public func write(tags: [NBT]) throws {
        for tag in tags {
            try self.writeTag(tag)
        }
    }

    private func writeTag(_ tag: NBT) throws {
        try self.writer.write(tag.tagType.rawValue)
        try self.writer.writeNBTString(tag.name ?? "")
        try self.writeTagPayload(tag)
    }

    // swiftlint:disable cyclomatic_complexity

    private func writeTagPayload(_ tag: NBT) throws {
        switch tag {
        case let tag as ByteTag:
            try self.writer.write(tag.byteValue)
        case let tag as ShortTag:
            try self.writer.write(tag.shortValue)
        case let tag as IntTag:
            try self.writer.write(tag.intValue)
        case let tag as LongTag:
            try self.writer.write(tag.longValue)
        case let tag as FloatTag:
            try self.writer.write(tag.floatValue)
        case let tag as DoubleTag:
            try self.writer.write(tag.doubleValue)
        case let tag as StringTag:
            try self.writer.writeNBTString(tag.stringValue)
        case let tag as ByteArrayTag:
            try self.writer.write(Int32(tag.byteArrayValue.count))
            try self.writer.write(tag.byteArrayValue)
        case let tag as IntArrayTag:
            try self.writer.write(Int32(tag.intArrayValue.count))
            for value in tag.intArrayValue {
                try self.writer.write(value)
            }
        case let tag as LongArrayTag:
            try self.writer.write(Int32(tag.longArrayValue.count))
            for value in tag.longArrayValue {
                try self.writer.write(value)
            }
        case let tag as ListTag:
            try self.writeListTag(tag)
        case let tag as CompoundTag:
            try self.writeCompoundTag(tag)
        default:
            throw CBStreamError.invalidFormat("Unsupported tag type for writing: \(tag.tagType)")
        }
    }

    // swiftlint:enable cyclomatic_complexity

    private func writeListTag(_ tag: ListTag) throws {
        try self.writer.write(tag.listType.rawValue)
        try self.writer.write(Int32(tag.tags.count))
        for item in tag.tags {
            try self.writeTagPayload(item)
        }
    }

    private func writeCompoundTag(_ tag: CompoundTag) throws {
        for child in tag.tags {
            try self.writeTag(child)
        }
        try self.writer.write(TagType.end.rawValue)
    }
}
