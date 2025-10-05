//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a single byte.
public final class ByteTag: NBT {
    // Override to return the .byte type
    override public var tagType: TagType {
        .byte
    }

    /// Gets or sets the value/payload of this tag (a single byte).
    public var value: UInt8

    /// Creates an `ByteTag` tag with the given name and value.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - value: The byte value to assign to this tag.
    public init(name: String?, _ value: UInt8) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates an unnamed `ByteTag` tag with the default of value of 0.
    override public init() {
        self.value = 0
        super.init()
    }

    /// Creates an unnamed `ByteTag` tag with the given value.
    /// - Parameter value: The byte value to assign to this tag.
    public convenience init(_ value: UInt8) {
        self.init(name: nil, value)
    }

    /// Creates an `ByteTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    public convenience init(name: String?) {
        self.init(name: name, 0)
    }

    /// Creates a copy of the given `ByteTag` tag.
    /// - Parameter other: The tag to copy.
    public init(from other: ByteTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    override public func clone() -> NBT {
        ByteTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Byte")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(self.value))

        return formattedStr
    }
}
