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

        guard newPos >= 0 && newPos <= buffer.count else {
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
        let bytesToRead = min(count, available)
        guard bytesToRead > 0 else { return 0 }

        let range = currentPosition..<(currentPosition + bytesToRead)
        buffer.copyBytes(to: &output, from: range)
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
        let value = buffer[currentPosition..<currentPosition+size].withUnsafeBytes { $0.load(as: T.self) }
        currentPosition += size
        return value
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
