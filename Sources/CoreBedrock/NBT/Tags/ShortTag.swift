//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a signed 16-bit integer.
public final class ShortTag: NBT {
    // Override to return the .short type
    override public var tagType: TagType {
        return .short
    }

    /// Gets or sets the value/payload of this tag (a signed 16-bit integer).
    public var value: Int16

    /// Creates an unnamed `ShortTag` tag with the default of value of 0.
    override public init() {
        value = 0
        super.init()
    }

    /// Creates an unnamed `ShortTag` tag with the given value.
    /// - Parameter value: The value to assign to this tag.
    convenience public init(_ value: Int16) {
        self.init(name: nil, value)
    }

    /// Creates an `ShortTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    convenience public init(name: String?) {
        self.init(name: name, 0)
    }

    /// Creates an `ShortTag` tag with the given name and value.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - value: The value to assign to this tag.
    public init(name: String?, _ value: Int16) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a copy of the given `CBDouble` tag.
    /// - Parameter other: The tag to copy.
    public init(from other: ShortTag) {
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
        value = try readStream.readInt16()
        return true
    }

    override func skipTag(_ readStream: CBBinaryReader) throws {
        try readStream.skip(MemoryLayout<Int16>.size)
    }

    override func writeTag(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(TagType.short)
        guard let name = name else { throw CBStreamError.invalidFormat("Name is null") }
        try writeStream.write(name)
        try writeData(writeStream)
    }

    override func writeData(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(value)
    }

    override public func clone() -> NBT {
        return ShortTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Short")
        if name != nil && name!.count > 0 {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(value))

        return formattedStr
    }

}
