//
// Created by yechentide on 2024/06/02
//

public enum TagType: UInt8, CaseIterable, Sendable {
    /// Placeholder TagType used to indicate unknown/undefined tag type in ListTag.
    case unknown = 0xFF

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
    case compound = 0x0A

    /// TAG_Int_Array: A length-prefixed array of signed 32-bit integers.
    case intArray = 0x0B

    /// TAG_Long_Array: A length-prefixed array of signed 32-bit integers.
    case longArray = 0x0C
}

extension TagType: Comparable {
    public static func < (lhs: TagType, rhs: TagType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: TagType, rhs: TagType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

public extension TagType {
    var hasValue: Bool {
        switch self {
        case .compound, .end, .list, .unknown: false
        default: true
        }
    }

    var hasLength: Bool {
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
            "TAG_Byte"
        case .byteArray:
            "TAG_Byte_Array"
        case .compound:
            "TAG_Compound"
        case .double:
            "TAG_Double"
        case .end:
            "TAG_End"
        case .float:
            "TAG_Float"
        case .int:
            "TAG_Int"
        case .intArray:
            "TAG_Int_Array"
        case .list:
            "TAG_List"
        case .long:
            "TAG_Long"
        case .longArray:
            "TAG_Long_Array"
        case .short:
            "TAG_Short"
        case .string:
            "TAG_String"
        default:
            "UNKNOWN"
        }
    }
}
