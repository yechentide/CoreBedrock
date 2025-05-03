//
// Created by yechentide on 2024/06/02
//

import Foundation

/// An  base class for the different kinds of named binary tags. This class is not meant to be instantiated but Swift currently does not allow for abstract classes and protocols are too limited for the behavior desired here.
public class NBT {
    /// String to use for indentation when getting the `description` of this `NBT`.
    public static let defaultIndentString: String = "  "

    /// Parent compound tag, either ListTag or CompoundTag, if any. May be `nil` for detached tags.
    public internal(set) weak var parent: NBT?

    /// The type of this tag.
    public var tagType: TagType {
        return .unknown
    }

    /// Gets whether this tag has a value attached. All tags except Compound, List, and End have values.
    public var hasValue: Bool {
        tagType.hasValue
    }

    var _name: String?
    /// Gets the name of this tag.
    public var name: String? {
        get { return _name }
        set {
            guard _name != newValue else { return }

            if let parentAsCompound = parent as? CompoundTag {
                guard let newName = newValue else { preconditionFailure("Tags inside an CompoundTag must have a name.") }

                do {
                    try parentAsCompound.renameTag(oldName: name!, newName: newName)
                } catch {
                    fatalError("Cannot rename tag")
                }
            }
            _name = newValue
        }
    }

    /// Gets the full name of this tag, including all parent tag names, separated by periods. Unnamed tags show up as empty strings.
    public var path: String {
        guard let parent = parent else { return name ?? "" }

        if let parentAsList = parent as? ListTag {
            return "\(parentAsList.path)[\(String(parentAsList.firstIndex(of: self)!))]"
        } else {
            return "\(parent.path).\(name ?? "")"
        }
    }

    /// Creates a deep copy of this tag.
    public func clone() throws -> NBT {
        fatalError("Cannot call this function from NBT; subclasses need to override and add functionality.")
    }

    func toString(indentString: String) -> String {
        toString(indentString: indentString, indentLevel: 0)
    }

    func toString(indentString: String, indentLevel: Int) -> String {
        fatalError("Cannot call this function from NBT; subclasses need to override and add functionality.")
    }

    // SHORTCUTS - These are included for developer convenience to avoid extra type casts.

    /// Gets or sets the tag with the specified name. May return `nil`.
    /// - Remark: This subscript is only applicable to `CompoundTag` tags. Using this subscript from
    /// any other tag type will result in a `fataError`.
    public subscript(_ tagName: String) -> NBT? {
        get { fatalError("String indexers only work on CompoundTag tags.") }
        set { fatalError("String indexers only work on CompoundTag tags.") }
    }

    /// Gets or sets the tag at the specified index.
    /// - Remark: This subscript is only applicable to `ListTag` tags. Using this subscript from
    /// any other tag type will result in a `fataError`.
    public subscript(_ index: Int) -> NBT {
        get { fatalError("Integer indexers only work on ListTag tags.") }
        set { fatalError("Integer indexers only work on ListTag tags.") }
    }

    /// Returns the value of this tag cast as a byte (unsigned 8-bit integer).
    /// - Remark: Only supported by `ByteTag` tags.
    public var byteValue: UInt8 {
        precondition(tagType == .byte, "Cannot get byteValue from \(NBT.getCanonicalTagName(tagType))")
        return (self as! ByteTag).value
    }

    /// Returns the value of this tag cast as a short (signed 16-bit integer).
    /// - Remark: Only supported by `ByteTag` and `ShortTag` tags.
    public var shortValue: Int16 {
        switch tagType {
            case .byte:
                return Int16((self as! ByteTag).value)
            case .short:
                return (self as! ShortTag).value
            default:
                preconditionFailure("Cannot get shortValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    /// Returns the value of this tag cast as an int (signed 32-bit integer).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, and `IntTag` tags.
    public var intValue: Int32 {
        switch tagType {
            case .byte:
                return Int32((self as! ByteTag).value)
            case .short:
                return Int32((self as! ShortTag).value)
            case .int:
                return (self as! IntTag).value
            default:
                preconditionFailure("Cannot get intValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    /// Returns the value of this tag cast as a long (signed 64-bit integer).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, and `LongTag` tags.
    public var longValue: Int64 {
        switch tagType {
            case .byte:
                return Int64((self as! ByteTag).value)
            case .short:
                return Int64((self as! ShortTag).value)
            case .int:
                return Int64((self as! IntTag).value)
            case .long:
                return (self as! LongTag).value
            default:
                preconditionFailure("Cannot get longValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    /// Returns the value of this tag cast as a float (single-precision floating point number).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, `LongTag`,
    /// and `FloatTag` tags.
    public var floatValue: Float {
        switch tagType {
            case .byte:
                return Float((self as! ByteTag).value)
            case .short:
                return Float((self as! ShortTag).value)
            case .int:
                return Float((self as! IntTag).value)
            case .long:
                return Float((self as! LongTag).value)
            case .float:
                return (self as! FloatTag).value
            case .double:
                return Float((self as! DoubleTag).value)
            default:
                preconditionFailure("Cannot get floatValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    /// Returns the value of this tag cast as a byte (double-precision floating point number).
    /// - Remark: Only supported by `ByteTag`, `ShortTag`, `IntTag`, `LongTag`,
    /// `FloatTag`, and `DoubleTag` tags.
    public var doubleValue: Double {
        switch tagType {
            case .byte:
                return Double((self as! ByteTag).value)
            case .short:
                return Double((self as! ShortTag).value)
            case .int:
                return Double((self as! IntTag).value)
            case .long:
                return Double((self as! LongTag).value)
            case .float:
                return Double(String((self as! FloatTag).value))!
            case .double:
                return (self as! DoubleTag).value
            default:
                preconditionFailure("Cannot get doubleValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    /// Returns the value of this tag cast as a byte array (`[UInt8]`).
    /// - Remark: Only supported by `ByteArrayTag` tags.
    public var byteArrayValue: [UInt8] {
        precondition(tagType == .byteArray, "Cannot get byteArrayValue from \(NBT.getCanonicalTagName(tagType))")
        return (self as! ByteArrayTag).value
    }

    /// Returns the value of this tag cast as a byte array (`[Int32]`).
    /// - Remark: Only supported by `IntArrayTag` tags.
    public var intArrayValue: [Int32] {
        precondition(tagType == .intArray, "Cannot get intArrayValue from \(NBT.getCanonicalTagName(tagType))")
        return (self as! IntArrayTag).value
    }

    /// Returns the value of this tag cast as a byte array (`[Int64]`).
    /// - Remark: Only supported by `LongArrayTag` tags.
    public var longArrayValue: [Int64] {
        precondition(tagType == .longArray, "Cannot get longArrayValue from \(NBT.getCanonicalTagName(tagType))")
        return (self as! LongArrayTag).value
    }

    /// Returns the value of this tag cast as a `String`. For number values, returns the stringified version.
    /// - Remark: Not supported by `CompoundTag`, `ListTag`, `ByteArrayTag`,
    /// `IntArrayTag`, or `LongArrayTag` tags.
    public var stringValue: String {
        switch tagType {
            case .string:
                return (self as! StringTag).value
            case .byte:
                return String((self as! ByteTag).value)
            case .short:
                return String((self as! ShortTag).value)
            case .int:
                return String((self as! IntTag).value)
            case .long:
                return String((self as! LongTag).value)
            case .float:
                return String((self as! FloatTag).value)
            case .double:
                return String((self as! DoubleTag).value)
            default:
                preconditionFailure("Cannot get stringValue from \(NBT.getCanonicalTagName(tagType))")
        }
    }

    public static func getCanonicalTagName(_ type: TagType) -> String {
        return type.description
    }
}

extension NBT: CustomStringConvertible {
    /// Gets the contents of this tag and any child tags as a string. Indents the string using
    /// multiples of `defaultIndentString`.
    public var description: String {
        return toString(indentString: NBT.defaultIndentString)
    }
}

extension NBT: Equatable {
    public static func == (lhs: NBT, rhs: NBT) -> Bool {
        return lhs === rhs
    }
}

extension NBT {
    public func toData() throws -> Data {
        let writer = CBTagWriter()
        try writer.write(tag: self)
        return writer.toData()
    }
}
