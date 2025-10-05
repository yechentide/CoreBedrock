//
// Created by yechentide on 2024/06/02
//

import Foundation

public extension Data {
    var hexString: String {
        var result: [String] = []
        for byte in self {
            let hexString = String(format: "%02X", byte)
            result.append(hexString)
        }
        return result.joined(separator: "_")
    }

    var uint8: UInt8 {
        UInt8(littleEndian: self[self.startIndex...self.startIndex].withUnsafeBytes {
            $0.load(as: UInt8.self)
        })
    }

    var int8: Int8 {
        Int8(littleEndian: self[self.startIndex...self.startIndex].withUnsafeBytes {
            $0.load(as: Int8.self)
        })
    }

    var uint16: UInt16 {
        UInt16(littleEndian: self[self.startIndex + 0...self.startIndex + 1].withUnsafeBytes {
            $0.load(as: UInt16.self)
        })
    }

    var int16: Int16 {
        Int16(littleEndian: self[self.startIndex + 0...self.startIndex + 1].withUnsafeBytes {
            $0.load(as: Int16.self)
        })
    }

    var uint32: UInt32? {
        guard self.count >= 4 else { return nil }

        return UInt32(littleEndian: self[self.startIndex + 0..<self.startIndex + 4].withUnsafeBytes {
            $0.load(as: UInt32.self)
        })
    }

    var int32: Int32? {
        guard self.count >= 4 else { return nil }

        return Int32(littleEndian: self[self.startIndex + 0..<self.startIndex + 4].withUnsafeBytes {
            $0.load(as: Int32.self)
        })
    }
}
