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
    private(set) var currentPosition: Int = 0

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

    public var count: Int {
        return buffer.count
    }

    public var description: String {
        "CBBufferV2(position: \(currentPosition), count: \(count), buffer: \(buffer.hexString))"
    }

    public func seek(to offset: Int, from origin: SeekOrigin) throws {
        let newPos: Int
        switch origin {
            case .begin:
                newPos = offset
            case .current:
                newPos = currentPosition + offset
            case .end:
                newPos = buffer.count + offset
        }

        guard (0...buffer.count).contains(newPos) else {
            throw CBStreamError.outOfBounds
        }
        currentPosition = newPos
    }

    public func toArray() -> [UInt8] {
        return [UInt8](buffer)
    }

    public func resize(to newSize: Int) {
        if newSize < buffer.count {
            buffer = buffer.prefix(newSize)
        } else if newSize > buffer.count {
            buffer.append(Data(count: newSize - buffer.count))
        }
        if currentPosition > newSize {
            currentPosition = newSize
        }
    }

    public func read(into output: inout [UInt8], count: Int) throws -> Int {
        let available = buffer.count - currentPosition
        guard available > 0 else { return 0 }

        let bytesToRead = min(count, available)
        if output.count < bytesToRead {
            output.append(contentsOf: repeatElement(0, count: bytesToRead - output.count))
        } else if output.count > bytesToRead {
            output.removeLast(output.count - bytesToRead)
        }
        output.withUnsafeMutableBytes { dstPtr in
            buffer.copyBytes(
                to: dstPtr.baseAddress!.assumingMemoryBound(to: UInt8.self),
                from: currentPosition..<(currentPosition + bytesToRead)
            )
        }
        currentPosition += bytesToRead
        return bytesToRead
    }

    public func write(_ input: [UInt8]) throws {
        if currentPosition == buffer.count {
            buffer.append(contentsOf: input)
        } else {
            if currentPosition + input.count > buffer.count {
                buffer.append(Data(count: currentPosition + input.count - buffer.count))
            }
            buffer.replaceSubrange(currentPosition..<(currentPosition + input.count), with: input)
        }
        currentPosition += input.count
    }
}

extension CBBuffer {
    public func readInteger<T: FixedWidthInteger>() -> T? {
        let size = MemoryLayout<T>.size
        guard currentPosition + size <= buffer.count else { return nil }
        return buffer.withUnsafeBytes { rawBuffer in
            guard let baseAddress = rawBuffer.baseAddress?.advanced(by: currentPosition) else { return nil }

            currentPosition += size
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

    public func writeInteger<T: FixedWidthInteger>(_ value: T) throws {
        var val = value.littleEndian
        let data = withUnsafeBytes(of: &val) { Data($0) }
        try write([UInt8](data))
    }

    public func asInputStream() -> InputStream {
        return InputStream(data: buffer)
    }

    public func asOutputStream() -> OutputStream {
        let stream = OutputStream.toMemory()
        stream.open()
        _ = buffer.withUnsafeBytes {
            stream.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: buffer.count)
        }
        return stream
    }
}
