//
// Created by yechentide on 2024/06/02
//

import Foundation

public final class IntArrayTag: NBT {
    // Override to return the .intArray type
    override public var tagType: TagType {
        .intArray
    }

    /// Gets or sets the value/payload of this tag (an array of signed 32-bit integers).
    public var value: [Int32]

    /// Creates an unnamed `ByteTag` tag, containing an empty array of bytes.
    override public init() {
        self.value = []
        super.init()
    }

    /// Creates an unnamed `IntArrayTag` tag, containing the given array.
    /// - Parameter value: The array to assign to this tag's `value`.
    public convenience init(_ value: [Int32]) {
        self.init(name: nil, value)
    }

    /// Creates an `IntArrayTag` tag with the given name, containing an empty array.
    /// - Parameter name: The name to assign to this tag.
    public convenience init(name: String?) {
        self.init(name: name, [])
    }

    /// Creates an `IntArrayTag` tag with the given name, containing the given array.
    /// - Parameters:
    ///   - name: The name to assign to this tag.
    ///   - value: The array to assign to this tag's `value`.
    public init(name: String?, _ value: [Int32]) {
        self.value = value
        super.init()
        self.name = name
    }

    /// Creates a deep copy of the given `IntArrayTag`.
    /// - Parameter other: The tag to copy.
    public init(from other: IntArrayTag) {
        self.value = other.value
        super.init()
        self.name = other.name
    }

    /// Gets or sets a byte at the given index.
    public subscript(_ index: Int) -> Int32 {
        get { self.value[index] }
        set { self.value[index] = newValue }
    }

    override public func clone() -> NBT {
        IntArrayTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Int_Array")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": [\(self.value.count) ints]")

        return formattedStr
    }
}
