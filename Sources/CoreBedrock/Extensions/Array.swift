//
// Created by yechentide on 2025/09/20
//

extension Array where Element == UInt8 {
    func loadUInt32(at offset: Int) -> UInt32? {
        guard offset + 4 <= count else { return nil }
        return withUnsafeBytes {
            $0.load(fromByteOffset: offset, as: UInt32.self)
        }
    }
}
