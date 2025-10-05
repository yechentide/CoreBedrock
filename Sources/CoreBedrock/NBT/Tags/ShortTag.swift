//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a signed 16-bit integer.
public final class ShortTag: NBT {
    // Override to return the .short type
    override public var tagType: TagType {
        .short
    }

    /// Gets or sets the value/payload of this tag (a signed 16-bit integer).
    public var value: Int16

    /// Creates an unnamed `ShortTag` tag with the default of value of 0.
    override public init() {
        self.value = 0
        super.init()
    }

    /// Creates an unnamed `ShortTag` tag with the given value.
    /// - Parameter value: The value to assign to this tag.
    public convenience init(_ value: Int16) {
        self.init(name: nil, value)
    }

    /// Creates an `ShortTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    public convenience init(name: String?) {
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

    override public func clone() -> NBT {
        ShortTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Short")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(self.value))

        return formattedStr
    }
}
