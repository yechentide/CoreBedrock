//
// Created by yechentide on 2024/10/04
//

import Foundation

extension Data {
    public var hexString: String {
        var result: [String] = []
        for byte in self {
            let hexString = String(format: "%02X", byte)
            result.append(hexString)
        }
        return result.joined(separator: "_")
    }

    public var uint8: UInt8 {
        UInt8(littleEndian: self[ self.startIndex...self.startIndex ].withUnsafeBytes{
            $0.load(as: UInt8.self)
        })
    }

    public var int8: Int8 {
        Int8(littleEndian: self[ self.startIndex...self.startIndex ].withUnsafeBytes{
            $0.load(as: Int8.self)
        })
    }

    public var uint32: UInt32? {
        guard self.count >= 4 else { return nil }

        return UInt32(littleEndian: self[ self.startIndex+0..<self.startIndex+4 ].withUnsafeBytes{
            $0.load(as: UInt32.self)
        })
    }

    public var int32: Int32? {
        guard self.count >= 4 else { return nil }

        return Int32(littleEndian: self[ self.startIndex+0..<self.startIndex+4 ].withUnsafeBytes{
            $0.load(as: Int32.self)
        })
    }
}
