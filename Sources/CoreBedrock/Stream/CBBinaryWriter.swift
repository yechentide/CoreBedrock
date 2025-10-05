//
// Created by yechentide on 2025/04/20
//

import Foundation

public final class CBBinaryWriter: CustomDebugStringConvertible {
    // MARK: - Properties

    private let buffer: CBBuffer
    private let swapNeeded: Bool
    private var bytesWritten = 0

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
        self.buffer.currentPosition
    }

    public var data: Data {
        Data(self.buffer.toArray())
    }

    public var isEmpty: Bool {
        self.buffer.isEmpty
    }

    public var count: Int {
        self.buffer.count
    }

    public var debugDescription: String {
        "CBBinaryWriterV2(bufferCount: \(self.buffer.count), bytesWritten: \(self.bytesWritten))"
    }

    // MARK: - Primitive Writers

    public func write(_ value: UInt8) throws {
        try self.buffer.write([value])
        self.bytesWritten += 1
    }

    public func write(_ bytes: [UInt8]) throws {
        try self.buffer.write(bytes)
        self.bytesWritten += bytes.count
    }

    public func write<T: FixedWidthInteger>(_ value: T) throws {
        var val = self.swapNeeded ? value.byteSwapped : value
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try self.buffer.write([UInt8](data))
        self.bytesWritten += MemoryLayout<T>.size
    }

    public func write(_ value: Float) throws {
        var val = self.swapNeeded ? value.bitPattern.byteSwapped : value.bitPattern
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try self.buffer.write([UInt8](data))
        self.bytesWritten += MemoryLayout<Float>.size
    }

    public func write(_ value: Double) throws {
        var val = self.swapNeeded ? value.bitPattern.byteSwapped : value.bitPattern
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try self.buffer.write([UInt8](data))
        self.bytesWritten += MemoryLayout<Double>.size
    }

    // MARK: - String Writer

    /// Writes a UTF-8 string with a 2-byte length prefix (NBT-style)
    public func writeNBTString(_ value: String) throws {
        let utf8Bytes = [UInt8](value.utf8)
        guard utf8Bytes.count <= UInt16.max else {
            throw CBStreamError.argumentOutOfRange("value", "String too long")
        }

        try self.write(UInt16(utf8Bytes.count))
        try self.write(utf8Bytes)
    }

    // MARK: - Utility

    public func asOutputStream() -> OutputStream {
        self.buffer.asOutputStream()
    }

    public func toByteArray() -> [UInt8] {
        self.buffer.toArray()
    }
}
