//
// Created by yechentide on 2024/06/02
//

import Foundation

public extension FixedWidthInteger {
    var data: Data {
        withUnsafeBytes(of: self) { Data($0) }
    }

    var binaryString: String {
        var result: [String] = []
        for byteIndex in 0..<(Self.bitWidth / 8) {
            let byte = UInt8(truncatingIfNeeded: self >> (byteIndex * 8))
            let byteString = String(byte, radix: 2)
            let padding = String(repeating: "0", count: 8 - byteString.count)
            result.append(padding + byteString)
        }
        return result.joined(separator: "_")
    }

    mutating func bitOn(offset: UInt8) {
        guard offset >= 0, offset < Self.bitWidth else { return }

        let newValue = (self >> offset | 0x1) << offset | self
        self = newValue
    }

    mutating func bitOff(offset: UInt8) {
        guard offset >= 0, offset < Self.bitWidth else { return }

        var mask = Self(0)
        mask.bitOn(offset: offset)
        mask = ~mask
        self &= mask
    }

    func isBitOn(offset: UInt8) -> Bool {
        (self >> offset) & 0x1 == 1
    }

    var bitArray: [UInt8] {
        // 0b0010 ---> [0b0, 0b1, 0b0, 0b0]
        var array = [UInt8]()
        for offset in 0..<self.bitWidth {
            let flag = (self >> offset) & 0x1 == 1
            array.append(flag ? 1 : 0)
        }
        return array
    }
}
