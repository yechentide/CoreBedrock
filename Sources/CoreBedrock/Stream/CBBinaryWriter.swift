//
// Created by yechentide on 2025/04/20
//

import Foundation

public final class CBBinaryWriter: CustomDebugStringConvertible {
    // MARK: - Properties

    private let buffer: CBBuffer
    private let swapNeeded: Bool
    private var bytesWritten: Int = 0

    // MARK: - Initializers

    public init(littleEndian: Bool = true) {
        self.buffer = CBBuffer()
        let isLittleEndian = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        self.swapNeeded = isLittleEndian != littleEndian
    }

    public init(buffer: CBBuffer, littleEndian: Bool = true) {
        self.buffer = buffer
        let isLittleEndian = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        self.swapNeeded = isLittleEndian != littleEndian
    }

    public convenience init(capacity: Int = 64, littleEndian: Bool = true) {
        self.init(buffer: CBBuffer(capacity: capacity), littleEndian: littleEndian)
    }

    // MARK: - Computed Properties

    public var currentPosition: Int {
        return buffer.currentPosition
    }

    public var data: Data {
        return Data(buffer.toArray())
    }

    public var count: Int {
        return buffer.count
    }

    public var debugDescription: String {
        "CBBinaryWriterV2(bufferCount: \(buffer.count), bytesWritten: \(bytesWritten))"
    }

    // MARK: - Primitive Writers

    public func write(_ value: UInt8) throws {
        try buffer.write([value])
        bytesWritten += 1
    }

    public func write(_ bytes: [UInt8]) throws {
        try buffer.write(bytes)
        bytesWritten += bytes.count
    }

    public func write<T: FixedWidthInteger>(_ value: T) throws {
        var val = swapNeeded ? value.byteSwapped : value
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try buffer.write([UInt8](data))
        bytesWritten += MemoryLayout<T>.size
    }

    public func write(_ value: Float) throws {
        var val = swapNeeded ? value.bitPattern.byteSwapped : value.bitPattern
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try buffer.write([UInt8](data))
        bytesWritten += MemoryLayout<Float>.size
    }

    public func write(_ value: Double) throws {
        var val = swapNeeded ? value.bitPattern.byteSwapped : value.bitPattern
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try buffer.write([UInt8](data))
        bytesWritten += MemoryLayout<Double>.size
    }

    // MARK: - String Writer

    /// Writes a UTF-8 string with a 2-byte length prefix (NBT-style)
    public func writeNBTString(_ value: String) throws {
        let utf8Bytes = [UInt8](value.utf8)
        guard utf8Bytes.count <= UInt16.max else {
            throw CBStreamError.argumentOutOfRange("value", "String too long")
        }
        try write(UInt16(utf8Bytes.count))
        try write(utf8Bytes)
    }

    // MARK: - Utility

    public func asOutputStream() -> OutputStream {
        return buffer.asOutputStream()
    }

    public func toByteArray() -> [UInt8] {
        return buffer.toArray()
    }
}
