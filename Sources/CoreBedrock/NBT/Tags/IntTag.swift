//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a signed 32-bit integer.
public final class IntTag: NBT {
    // Override to return the .int type
    override public var tagType: TagType {
        .int
    }

    /// Gets or sets the value/payload of this tag (a signed 32-bit integer).
    public var value: Int32

    /// Creates an unnamed `IntTag` tag with the default of value of 0.
    override public init() {
        self.value = 0
        super.init()
    }

    /// Creates an unnamed `IntTag` tag with the given value.
    /// - Parameter value: The value to assign to this tag.
    public convenience init(_ value: Int32) {
        self.init(name: nil, value)
    }

    /// Creates an `IntTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    public convenience init(name: String?) {
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

    override public func clone() -> NBT {
        IntTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Int")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(self.value))

        return formattedStr
    }
}
