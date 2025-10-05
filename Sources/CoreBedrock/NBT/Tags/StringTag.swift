//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a UTF-8-encoded string.
public final class StringTag: NBT {
    // Override to return the .string type
    override public var tagType: TagType {
        .string
    }

    /// The value/payload of this tag (a single string). May not be null.
    public var value: String

    /// Creates an unnamed `StringTag` tag with the default value (empty string).
    override public init() {
        self.value = ""
        super.init()
    }

    /// Creates an unnamed `StringTag` tag with the given value.
    /// - Parameter value: The `String` value to assign to this tag.
    public convenience init(_ value: String) {
        self.init(name: nil, value)
    }

    /// Creates an `StringTag` tag with the given name and value.
    /// - Parameters:
    ///   - name: The name to assign to this tag.
    ///   - value: The `String` value to assign to this tag.
    public init(name: String?, _ value: String) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a copy of given `StringTag` tag.
    /// - Parameter other: The tag to copy.
    public init(from other: StringTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    override public func clone() -> NBT {
        StringTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_String")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": \"")
        formattedStr.append(self.value)
        formattedStr.append("\"")

        return formattedStr
    }
}
