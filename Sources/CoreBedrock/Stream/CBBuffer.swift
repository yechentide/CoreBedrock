//
// Created by yechentide on 2025/04/20
//

import Foundation

public final class CBBuffer: CustomStringConvertible {
    // MARK: - Types

    public enum SeekOrigin {
        case begin, current, end
    }

    // MARK: - Properties

    private var buffer: Data
    private(set) var currentPosition = 0

    // MARK: - Initializers

    public init(capacity: Int = 0) {
        self.buffer = Data(count: capacity)
    }

    public init(data: Data) {
        self.buffer = data
    }

    public init(bytes: [UInt8]) {
        self.buffer = Data(bytes)
    }

    // MARK: - Computed Properties

    public var isEmpty: Bool {
        self.buffer.isEmpty
    }

    public var count: Int {
        self.buffer.count
    }

    public var description: String {
        "CBBufferV2(position: \(self.currentPosition), count: \(self.count), buffer: \(self.buffer.hexString))"
    }

    public func seek(to offset: Int, from origin: SeekOrigin) throws {
        let newPos: Int = switch origin {
        case .begin:
            offset
        case .current:
            self.currentPosition + offset
        case .end:
            self.buffer.count + offset
        }

        guard (0...self.buffer.count).contains(newPos) else {
            throw CBStreamError.outOfBounds
        }

        self.currentPosition = newPos
    }

    public func toArray() -> [UInt8] {
        [UInt8](self.buffer)
    }

    public func resize(to newSize: Int) {
        if newSize < self.buffer.count {
            self.buffer = self.buffer.prefix(newSize)
        } else if newSize > self.buffer.count {
            self.buffer.append(Data(count: newSize - self.buffer.count))
        }
        if self.currentPosition > newSize {
            self.currentPosition = newSize
        }
    }

    public func read(into output: inout [UInt8], count: Int) throws -> Int {
        let available = self.buffer.count - self.currentPosition
        guard available > 0 else { return 0 }

        let bytesToRead = min(count, available)
        if output.count < bytesToRead {
            output.append(contentsOf: repeatElement(0, count: bytesToRead - output.count))
        } else if output.count > bytesToRead {
            output.removeLast(output.count - bytesToRead)
        }
        output.withUnsafeMutableBytes { dstPtr in
            self.buffer.copyBytes(
                to: dstPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                from: self.currentPosition..<(self.currentPosition + bytesToRead)
            )
        }
        self.currentPosition += bytesToRead
        return bytesToRead
    }

    public func write(_ input: [UInt8]) throws {
        if self.currentPosition == self.buffer.count {
            self.buffer.append(contentsOf: input)
        } else {
            if self.currentPosition + input.count > self.buffer.count {
                self.buffer.append(Data(count: self.currentPosition + input.count - self.buffer.count))
            }
            self.buffer.replaceSubrange(self.currentPosition..<(self.currentPosition + input.count), with: input)
        }
        self.currentPosition += input.count
    }
}

public extension CBBuffer {
    func readInteger<T: FixedWidthInteger>() -> T? {
        let size = MemoryLayout<T>.size
        guard self.currentPosition + size <= self.buffer.count else { return nil }

        return self.buffer.withUnsafeBytes { rawBuffer in
            guard let baseAddress = rawBuffer.baseAddress?.advanced(by: currentPosition) else { return nil }

            self.currentPosition += size
            if Int(bitPattern: baseAddress) % MemoryLayout<T>.alignment == 0 {
                // aligned: safe to load directly
                let value = baseAddress.load(as: T.self)
                return T(littleEndian: value)
            } else {
                // unaligned: copy to stack
                var tmp: T = 0
                memcpy(&tmp, baseAddress, size)
                return T(littleEndian: tmp)
            }
        }
    }

    func writeInteger(_ value: some FixedWidthInteger) throws {
        var val = value.littleEndian
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try self.write([UInt8](data))
    }

    func asInputStream() -> InputStream {
        InputStream(data: self.buffer)
    }

    func asOutputStream() -> OutputStream {
        let stream = OutputStream.toMemory()
        stream.open()
        _ = self.buffer.withUnsafeBytes {
            stream.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: self.buffer.count)
        }
        return stream
    }
}
