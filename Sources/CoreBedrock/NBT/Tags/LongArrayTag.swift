//
// Created by yechentide on 2024/06/02
//

import Foundation

public final class LongArrayTag: NBT {
    // Override to return the .intArray type
    override public var tagType: TagType {
        return .longArray
    }

    /// Gets or sets the value/payload of this tag (an array of signed 64-bit integers).
    public var value: [Int64]

    /// Creates an unnamed `LongArrayTag` tag, containing an empty array of bytes.
    override public init() {
        value = []
        super.init()
    }

    /// Creates an unnamed `LongArrayTag` tag, containing the given array.
    /// - Parameter value: The array to assign to this tag's `value`.
    convenience public init(_ value: [Int64]) {
        self.init(name: nil, value)
    }

    /// Creates an `LongArrayTag` tag with the given name, containing an empty array.
    /// - Parameter name: The name to assign to this tag.
    convenience public init(name: String?) {
        self.init(name: name, [])
    }

    /// Creates an `LongArrayTag` tag with the given name, containing the given array.
    /// - Parameters:
    ///   - name: The name to assign to this tag.
    ///   - value: The array to assign to this tag's `value`.
    public init(name: String?, _ value: [Int64]) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a deep copy of the given `LongArrayTag`.
    /// - Parameter other: The tag to copy.
    public init(from other: LongArrayTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    /// Gets or sets a byte at the given index.
    public subscript(_ index: Int) -> Int64 {
        get { return value[index] }
        set { value[index] = newValue }
    }

    override func readTag(_ readStream: CBBinaryReader, _ skip: (NBT) -> Bool) throws -> Bool {
        let length = Int(try readStream.readInt32())
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative length given in TAG_Long_Array") }

        // Check if the tag needs to be skipped
        if skip(self) {
            try readStream.skip(length * MemoryLayout<Int64>.size)
            return false
        }

        value = [Int64](repeating: 0, count: length)
        for i in 0..<length {
            value[i] = try readStream.readInt64()
        }
        return true
    }

    override func skipTag(_ readStream: CBBinaryReader) throws {
        let length = Int(try readStream.readInt32())
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative length given in TAG_Long_Array") }
        try readStream.skip(length * MemoryLayout<Int64>.size)
    }

    override func writeTag(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(TagType.longArray)
        guard let name = name else { throw CBStreamError.invalidFormat("Name is null") }
        try writeStream.write(name)
        try writeData(writeStream)
    }

    override func writeData(_ writeStream: CBBinaryWriter) throws {
        // Need to write the length as Int32
        try writeStream.write(Int32(value.count))
        for i in 0..<value.count {
            try writeStream.write(value[i])
        }
    }

    override public func clone() -> NBT {
        return LongArrayTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Long_Array")
        if name != nil && name!.count > 0 {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": [\(value.count) longs]")

        return formattedStr
    }
}
