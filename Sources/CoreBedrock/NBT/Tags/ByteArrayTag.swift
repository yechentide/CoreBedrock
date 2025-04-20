//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing an array of bytes.
public final class ByteArrayTag: NBT {
    // Override to return the .byteArray type
    override public var tagType: TagType {
        return .byteArray
    }

    /// Gets or sets the value/payload of this tag (an array of bytes).
    public var value: [UInt8]

    /// Creates an unnamed `ByteArrayTag` tag, containing an empty array of bytes.
    override public init() {
        value = []
        super.init()
    }

    /// Creates an unnamed `ByteArrayTag` tag, containing the given array of bytes.
    /// - Parameter value: The byte array to assign to this tag's `value`.
    convenience public init(_ value: [UInt8]) {
        self.init(name: nil, value)
    }

    /// Creates an `ByteArrayTag` tag with the given name, containing an empty array of bytes.
    /// - Parameter name: The name to assign to this tag.
    convenience public init(name: String?) {
        self.init(name: name, [])
    }

    /// Creates an `ByteArrayTag` tag with the given name, containing the given array of bytes.
    /// - Parameters:
    ///   - name: The name to assign to this tag.
    ///   - value: The byte array to assign to this tag's `value`.
    public init(name: String?, _ value: [UInt8]) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a deep copy of the given `ByteArrayTag`.
    /// - Parameter other: The tag to copy.
    public init(from other: ByteArrayTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    /// Gets or sets a byte at the given index.
    public subscript(_ index: Int) -> UInt8 {
        get { return value[index] }
        set { value[index] = newValue }
    }

    override public func clone() -> NBT {
        return ByteArrayTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Byte_Array")
        if name != nil && name!.count > 0 {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": [\(value.count) bytes]")

        return formattedStr
    }
}
