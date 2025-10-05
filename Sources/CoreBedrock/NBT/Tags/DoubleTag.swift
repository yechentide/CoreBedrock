//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a tag containing a double-precision floating point number.
public final class DoubleTag: NBT {
    // Override to return the .double type
    override public var tagType: TagType {
        .double
    }

    /// Gets or sets the value/payload of this tag (a double-precision floating point number).
    public var value: Double

    /// Creates an unnamed `DoubleTag` tag with the default of value of 0.
    override public init() {
        self.value = 0
        super.init()
    }

    /// Creates an unnamed `DoubleTag` tag with the given value.
    /// - Parameter value: The value to assign to this tag.
    public convenience init(_ value: Double) {
        self.init(name: nil, value)
    }

    /// Creates an `DoubleTag` tag with the given name and the default value of 0.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    public convenience init(name: String?) {
        self.init(name: name, 0)
    }

    /// Creates an `DoubleTag` tag with the given name and value.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - value: The value to assign to this tag.
    public init(name: String?, _ value: Double) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a copy of the given `DoubleTag` tag.
    /// - Parameter other: The tag to copy.
    public init(from other: DoubleTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    override public func clone() -> NBT {
        DoubleTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Double")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": ")
        formattedStr.append(String(self.value))

        return formattedStr
    }
}
