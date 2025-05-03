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

    public var count: Int { return writer.count }

    public var debugDescription: String {
        "CBTagWriterV2(bufferCount: \(writer.count))"
    }

    public func toData() -> Data {
        return writer.data
    }

    public func write(tag: NBT) throws {
        try writeTag(tag)
    }

    public func write(tags: [NBT]) throws {
        for tag in tags {
            try writeTag(tag)
        }
    }

    private func writeTag(_ tag: NBT) throws {
        try writer.write(tag.tagType.rawValue)
        try writer.writeNBTString(tag.name ?? "")
        try writeTagPayload(tag)
    }

    private func writeTagPayload(_ tag: NBT) throws {
        switch tag {
            case let t as ByteTag:
                try writer.write(t.byteValue)
            case let t as ShortTag:
                try writer.write(t.shortValue)
            case let t as IntTag:
                try writer.write(t.intValue)
            case let t as LongTag:
                try writer.write(t.longValue)
            case let t as FloatTag:
                try writer.write(t.floatValue)
            case let t as DoubleTag:
                try writer.write(t.doubleValue)
            case let t as StringTag:
                try writer.writeNBTString(t.stringValue)
            case let t as ByteArrayTag:
                try writer.write(Int32(t.byteArrayValue.count))
                try writer.write(t.byteArrayValue)
            case let t as IntArrayTag:
                try writer.write(Int32(t.intArrayValue.count))
                for v in t.intArrayValue { try writer.write(v) }
            case let t as LongArrayTag:
                try writer.write(Int32(t.longArrayValue.count))
                for v in t.longArrayValue { try writer.write(v) }
            case let t as ListTag:
                try writeListTag(t)
            case let t as CompoundTag:
                try writeCompoundTag(t)
            default:
                throw CBStreamError.invalidFormat("Unsupported tag type for writing: \(tag.tagType)")
        }
    }

    private func writeListTag(_ tag: ListTag) throws {
        try writer.write(tag.listType.rawValue)
        try writer.write(Int32(tag.tags.count))
        for item in tag.tags {
            try writeTagPayload(item)
        }
    }

    private func writeCompoundTag(_ tag: CompoundTag) throws {
        for child in tag.tags {
            try writeTag(child)
        }
        try writer.write(TagType.end.rawValue)
    }
}
