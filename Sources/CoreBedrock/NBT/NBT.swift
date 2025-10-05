//
// Created by yechentide on 2024/06/02
//

import Foundation

// swiftlint:disable line_length force_cast unused_setter_value

/// An  base class for the different kinds of named binary tags. This class is not meant to be instantiated but Swift currently does not allow for abstract classes and protocols are too limited for the behavior desired here.
public class NBT {
    /// String to use for indentation when getting the `description` of this `NBT`.
    public static let defaultIndentString = "  "

    /// Parent compound tag, either ListTag or CompoundTag, if any. May be `nil` for detached tags.
    public internal(set) weak var parent: NBT?

    /// The type of this tag.
    public var tagType: TagType {
        .unknown
    }

    /// Gets whether this tag has a value attached. All tags except Compound, List, and End have values.
    public var hasValue: Bool {
        self.tagType.hasValue
    }

    var _name: String?
    /// Gets the name of this tag.
    public var name: String? {
        get { self._name }
        set {
            guard self._name != newValue else { return }

            if let parentAsCompound = parent as? CompoundTag {
                guard let newName = newValue else { preconditionFailure("Tags inside an CompoundTag must have a name.") }

                do {
                    try parentAsCompound.renameTag(oldName: name!, newName: newName)
                } catch {
                    fatalError("Cannot rename tag")
                }
            }
            self._name = newValue
        }
    }

    /// Gets the full name of this tag, including all parent tag names, separated by periods. Unnamed tags show up as empty strings.
    public var path: String {
        guard let parent else { return self.name ?? "" }

        if let parentAsList = parent as? ListTag {
            return "\(parentAsList.path)[\(String(parentAsList.firstIndex(of: self)!))]"
        } else {
            return "\(parent.path).\(self.name ?? "")"
        }
    }

    /// Creates a deep copy of this tag.
    public func clone() throws -> NBT {
        fatalError("Cannot call this function from NBT; subclasses need to override and add functionality.")
    }

    func toString(indentString: String) -> String {
        self.toString(indentString: indentString, indentLevel: 0)
    }

    func toString(indentString _: String, indentLevel _: Int) -> String {
        fatalError("Cannot call this function from NBT; subclasses need to override and add functionality.")
    }

    // SHORTCUTS - These are included for developer convenience to avoid extra type casts.

    /// Gets or sets the tag with the specified name. May return `nil`.
    /// - Remark: This subscript is only applicable to `CompoundTag` tags. Using this subscript from
    /// any other tag type will result in a `fataError`.
    public subscript(_: String) -> NBT? {
        get { fatalError("String indexers only work on CompoundTag tags.") }
        set { fatalError("String indexers only work on CompoundTag tags.") }
    }

    /// Gets or sets the tag at the specified index.
    /// - Remark: This subscript is only applicable to `ListTag` tags. Using this subscript from
    /// any other tag type will result in a `fataError`.
    public subscript(_: Int) -> NBT {
        get { fatalError("Integer indexers only work on ListTag tags.") }
        set { fatalError("Integer indexers only work on ListTag tags.") }
    }

    /// Returns the value of this tag cast as a byte (unsigned 8-bit integer).
    /// - Remark: Only supported by `ByteTag` tags.
    public var byteValue: UInt8 {
        precondition(self.tagType == .byte, "Cannot get byteValue from \(Self.getCanonicalTagName(self.tagType))")
        return (self as! ByteTag).value
    }

    /// Returns the value of this tag cast as a short (signed 16-bit integer).
    /// - Remark: Only supported by `ByteTag` and `ShortTag` tags.
    public var shortValue: Int16 {
        switch self.tagType {
        case .byte:
            Int16((self as! ByteTag).value)
        case .short:
            (self as! ShortTag).value
        default:
            preconditionFailure("Cannot get shortValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    /// Returns the value of this tag cast as an int (signed 32-bit integer).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, and `IntTag` tags.
    public var intValue: Int32 {
        switch self.tagType {
        case .byte:
            Int32((self as! ByteTag).value)
        case .short:
            Int32((self as! ShortTag).value)
        case .int:
            (self as! IntTag).value
        default:
            preconditionFailure("Cannot get intValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    /// Returns the value of this tag cast as a long (signed 64-bit integer).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, and `LongTag` tags.
    public var longValue: Int64 {
        switch self.tagType {
        case .byte:
            Int64((self as! ByteTag).value)
        case .short:
            Int64((self as! ShortTag).value)
        case .int:
            Int64((self as! IntTag).value)
        case .long:
            (self as! LongTag).value
        default:
            preconditionFailure("Cannot get longValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    /// Returns the value of this tag cast as a float (single-precision floating point number).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, `LongTag`,
    /// and `FloatTag` tags.
    public var floatValue: Float {
        switch self.tagType {
        case .byte:
            Float((self as! ByteTag).value)
        case .short:
            Float((self as! ShortTag).value)
        case .int:
            Float((self as! IntTag).value)
        case .long:
            Float((self as! LongTag).value)
        case .float:
            (self as! FloatTag).value
        case .double:
            Float((self as! DoubleTag).value)
        default:
            preconditionFailure("Cannot get floatValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    /// Returns the value of this tag cast as a byte (double-precision floating point number).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, `LongTag`,
    /// `FloatTag`, and `DoubleTag` tags.
    public var doubleValue: Double {
        switch self.tagType {
        case .byte:
            Double((self as! ByteTag).value)
        case .short:
            Double((self as! ShortTag).value)
        case .int:
            Double((self as! IntTag).value)
        case .long:
            Double((self as! LongTag).value)
        case .float:
            Double(String((self as! FloatTag).value))!
        case .double:
            (self as! DoubleTag).value
        default:
            preconditionFailure("Cannot get doubleValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    /// Returns the value of this tag cast as a byte array (`[UInt8]`).
    /// - Remark: Only supported by `ByteArrayTag` tags.
    public var byteArrayValue: [UInt8] {
        precondition(self.tagType == .byteArray, "Cannot get byteArrayValue from \(Self.getCanonicalTagName(self.tagType))")
        return (self as! ByteArrayTag).value
    }

    /// Returns the value of this tag cast as a byte array (`[Int32]`).
    /// - Remark: Only supported by `IntArrayTag` tags.
    public var intArrayValue: [Int32] {
        precondition(self.tagType == .intArray, "Cannot get intArrayValue from \(Self.getCanonicalTagName(self.tagType))")
        return (self as! IntArrayTag).value
    }

    /// Returns the value of this tag cast as a byte array (`[Int64]`).
    /// - Remark: Only supported by `LongArrayTag` tags.
    public var longArrayValue: [Int64] {
        precondition(self.tagType == .longArray, "Cannot get longArrayValue from \(Self.getCanonicalTagName(self.tagType))")
        return (self as! LongArrayTag).value
    }

    /// Returns the value of this tag cast as a `String`. For number values, returns the stringified version.
    /// - Remark: Not supported by `CompoundTag`, `ListTag`, `ByteArrayTag`,
    /// `IntArrayTag`, or `LongArrayTag` tags.
    public var stringValue: String {
        switch self.tagType {
        case .string:
            (self as! StringTag).value
        case .byte:
            String((self as! ByteTag).value)
        case .short:
            String((self as! ShortTag).value)
        case .int:
            String((self as! IntTag).value)
        case .long:
            String((self as! LongTag).value)
        case .float:
            String((self as! FloatTag).value)
        case .double:
            String((self as! DoubleTag).value)
        default:
            preconditionFailure("Cannot get stringValue from \(Self.getCanonicalTagName(self.tagType))")
        }
    }

    public static func getCanonicalTagName(_ type: TagType) -> String {
        type.description
    }
}

extension NBT: CustomStringConvertible {
    /// Gets the contents of this tag and any child tags as a string. Indents the string using
    /// multiples of `defaultIndentString`.
    public var description: String {
        self.toString(indentString: NBT.defaultIndentString)
    }
}

extension NBT: Equatable {
    public static func == (lhs: NBT, rhs: NBT) -> Bool {
        lhs === rhs
    }
}

public extension NBT {
    func toData() throws -> Data {
        let writer = CBTagWriter()
        try writer.write(tag: self)
        return writer.toData()
    }
}

// swiftlint:enable line_length force_cast unused_setter_value
