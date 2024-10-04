//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a signed 32-bit integer.
public final class IntTag: NBT {
    // Override to return the .int type
    override public var tagType: TagType {
        return .int
    }

    /// Gets or sets the value/payload of this tag (a signed 32-bit integer).
    public var value: Int32

    /// Creates an unnamed `IntTag` tag with the default of value of 0.
    override public init() {
        value = 0
        super.init()
    }

    /// Creates an unnamed `IntTag` tag with the given value.
    /// - Parameter value: The value to assign to this tag.
    convenience public init(_ value: Int32) {
        self.init(name: nil, value)
    }

    /// Creates an `IntTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    convenience public init(name: String?) {
        self.init(name: name, 0)
    }

    /// Creates an `IntTag` tag with the given name and value.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - value: The value to assign to this tag.
    public init(name: String?, _ value: Int32) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a copy of the given `IntTag` tag.
    /// - Parameter other: The tag to copy.
    public init(from other: IntTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    override func readTag(_ readStream: CBBinaryReader, _ skip: (NBT) -> Bool) throws -> Bool {
        // Check if the tag needs to be skipped
        if skip(self) {
            try skipTag(readStream)
            return false
        }
        value = try readStream.readInt32()
        return true
    }

    override func skipTag(_ readStream: CBBinaryReader) throws {
        try readStream.skip(MemoryLayout<Int32>.size)
    }

    override func writeTag(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(TagType.int)
        guard let name = name else { throw CBStreamError.invalidFormat("Name is null") }
        try writeStream.write(name)
        try writeData(writeStream)
    }

    override func writeData(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(value)
    }

    override public func clone() -> NBT {
        return IntTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Int")
        if name != nil && name!.count > 0 {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(value))

        return formattedStr
    }
}

