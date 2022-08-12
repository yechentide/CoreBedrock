import Foundation

extension String {
    /// Convert little-endian display string to data
    public var hexData: Data? {
        var str = self
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
}
