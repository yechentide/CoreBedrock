//
// Created by yechentide on 2024/06/02
//

public enum TagType: UInt8, CaseIterable, Sendable {
    /// Placeholder TagType used to indicate unknown/undefined tag type in ListTag.
    case unknown = 0xff

    /// TAG_End: Signifies the end of a Compound tag or List tag.
    case end = 0x00

    /// TAG_Byte: A signed 8-bit integer. Sometimes used for booleans.
    case byte = 0x01

    /// TAG_Short: A signed 16-bit integer.
    case short = 0x02

    /// TAG_Int: A signed 32-bit integer.
    case int = 0x03

    /// TAG_Long: A signed 64-bit integer.
    case long = 0x04

    /// TAG_Float: A signed IEEE-754 single-precision floating point number.
    case float = 0x05

    /// TAG_Double: A signed IEEE-754 double-precision floating point number.
    case double = 0x06

    /// TAG_Byte_Array: A length-prefixed array of signed 8-bit integers.
    case byteArray = 0x07

    /// TAG_String: A length-prefixed UTF-8 string. It has a size, rather than being null terminated.
    case string = 0x08

    /// TAG_List: A list of nameless tags, all of the same type.
    case list = 0x09

    /// TAG_Compound: A set of uniquely named tags.
    case compound = 0x0a

    /// TAG_Int_Array: A length-prefixed array of signed 32-bit integers.
    case intArray = 0x0b

    /// TAG_Long_Array: A length-prefixed array of signed 32-bit integers.
    case longArray = 0x0c
}

extension TagType: Comparable {
    public static func < (lhs: TagType, rhs: TagType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func ==(lhs: TagType, rhs: TagType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension TagType {
    public var hasValue: Bool {
        switch self {
            case .compound, .end, .list, .unknown: false
            default: true
        }
    }

    public var hasLength: Bool {
        switch self {
            case .list, .byteArray, .intArray, .longArray: true
            default: false
        }
    }
}

extension TagType: CustomStringConvertible {
    public var description: String {
        switch self {
            case .byte:
                return "TAG_Byte"
            case .byteArray:
                return "TAG_Byte_Array"
            case .compound:
                return "TAG_Compound"
            case .double:
                return "TAG_Double"
            case .end:
                return "TAG_End"
            case .float:
                return "TAG_Float"
            case .int:
                return "TAG_Int"
            case .intArray:
                return "TAG_Int_Array"
            case .list:
                return "TAG_List"
            case .long:
                return "TAG_Long"
            case .longArray:
                return "TAG_Long_Array"
            case .short:
                return "TAG_Short"
            case .string:
                return "TAG_String"
            default:
                return "UNKNOWN";
        }
    }
}
