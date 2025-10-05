//
// Created by yechentide on 2024/06/02
//

import Foundation

extension String {
    /// Convert hex string to binary data with little-endian
    public var hexData: Data? {
        var str = self.lowercased()
        if str.hasPrefix("0x") {
            let i = str.index(str.startIndex, offsetBy: 2)
            str = String(str[i...])
        }
        if str.contains("_") {
            str = str.filter { $0 != "_" }
        }
        guard str.count % 2 == 0 else { return nil }

        var byteArray = [UInt8]()
        var start = str.startIndex
        while start < str.endIndex {
            let end = str.index(start, offsetBy: 1)
            let byteStr = str[start...end]
            guard let byte = UInt8(byteStr, radix: 16) else { return nil }
            byteArray.append(byte)
            start = str.index(start, offsetBy: 2)
        }
        return Data(byteArray)
    }

    public func removeMinecraftColorCodes() -> String {
        let pattern = "§[0-9a-gk-or]"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: self.utf16.count)
            let modifiedString = regex.stringByReplacingMatches(
                in: self,
                options: [],
                range: range,
                withTemplate: ""
            )
            return modifiedString
        } catch {
            return self
        }
    }

    func toRGBA() -> RGBA? {
        var hexString = self
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let length = hexString.count
        guard length == 6 || length == 8 else {
            return nil
        }

        guard let value = UInt32(hexString, radix: 16) else {
            return nil
        }

        if hexString.count == 6 {
            return (
                red:   UInt8((value >> 16) & 0xFF),
                green: UInt8((value >> 8) & 0xFF),
                blue:  UInt8(value & 0xFF),
                alpha: 255
            )
        } else {
            return (
                red:   UInt8((value >> 24) & 0xFF),
                green: UInt8((value >> 16) & 0xFF),
                blue:  UInt8((value >> 8) & 0xFF),
                alpha: UInt8(value & 0xFF)
            )
        }
    }
}
