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
