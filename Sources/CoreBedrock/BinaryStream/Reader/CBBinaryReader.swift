//
// Created by yechentide on 2024/06/02
//

import Foundation

/// A binary reader class that takes care of reading primitives from an NBT stream
/// while taking care of endianness, string encoding, and skipping.
final class CBBinaryReader {
    private var _buffer: CBBuffer
    private var _swapNeeded: Bool
    private var _seekBuffer: [UInt8]!
    private let _seekBufferSize = 1024 * 8

    /// Initializes a new instance of the `CBBinaryReader` class based on the specified stream and using UTF-8 encoding.
    /// - Parameters:
    ///   - input: The input stream.
    ///   - useLittleEndian: `true` to read values as little endian; otherwise `false`.
    init(_ input: CBBuffer, _ useLittleEndian: Bool = true) {
        _buffer = input

        let isLittleEndian = CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        _swapNeeded = isLittleEndian != useLittleEndian
    }

    /// Exposes access to the underlying stream of the `CBBinaryReader`.
    var baseStream: CBBuffer { return _buffer }

    var unreadCount: Int {
        return _buffer.length - _buffer.position
    }

    /// Converts a byte array ([UInt8]) to its number equivalent. This is intended
    /// to be used with FixedWidthIntegers, Floats, and Doubles.
    /// - Parameters:
    ///   - value: An array of bytes.
    ///   - type: The type to convert to
    /// - Returns: An object of the specified type
    func fromByteArray<T>(_ value: [UInt8], _ type: T.Type) -> T {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }

    /// Skips the specified number of bytes in the current stream by advancing the current position of the stream.
    /// - Parameter bytesToSkip: The number of bytes to skip. This value must be 0 or non-negative.
    /// - Throws: An `argumentOutOfRange` error if `bytesToSkip` is negative; a `endOfStream` error if the end of the stream is reached.
    func skip(_ bytesToSkip: Int) throws {
        guard bytesToSkip >= 0 else { throw CBStreamError.argumentOutOfRange("bytesToSkip", "Non-negative number required.") }
        guard bytesToSkip > 0 else { return }

        if _seekBuffer == nil {
            _seekBuffer = [UInt8](repeating: 0, count: _seekBufferSize)
        }
        var bytesSkipped = 0
        while bytesSkipped < bytesToSkip {
            let bytesToRead = min(_seekBufferSize, bytesToSkip - bytesSkipped)
            let bytesRead = try _buffer.read(&_seekBuffer, 0, bytesToRead)
            if bytesRead == 0 {
                throw CBStreamError.endOfStream
            }
            bytesSkipped += bytesRead
        }
    }

    /// Skips a string in the current stream by determining the length of the string and advancing the current position that many number of bytes.
    /// - Throws: An `invalidFormat` error if the length of the string could not be determined.
    func skipString() throws {
        let length = try readInt16()
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative string length given!") }
        try skip(Int(length))
    }
}

extension CBBinaryReader {
    /// Reads a byte from the current stream and converts it to an `TagType` value.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `formatError` if the byte read is not valid as an `TagType`.
    /// - Returns: An `TagType` value.
    func readTagType() throws -> TagType {
        let type = _buffer.readByte()
        guard type >= 0 else { throw CBStreamError.endOfStream }
        guard type <= Int(TagType.longArray.rawValue) else { throw CBStreamError.invalidFormat("NBT tag type out of range: \(type)") }
        return TagType(rawValue: UInt8(type))!
    }

    /// Returns a byte from the current stream.
    /// - Throws: An `endOfStream` error if the end of the stream is reached.
    /// - Returns: A byte from the current stream.
    func readByte() throws -> UInt8 {
        let byte = _buffer.readByte()
        guard byte >= 0 else { throw CBStreamError.endOfStream }
        return UInt8(byte)
    }

    /// Reads the specified number of bytes from the current stream into a byte array and advances the current position by that number of bytes.
    /// - Parameter count: The number of bytes to read. This value must be 0 or a non-negative number or an exception will occur.
    /// - Throws: An `argumentOutOfRange` error if `count` is negative; a `streamIsClosed` error if the stream is closed.
    /// - Returns: A byte array containing data read from the underlying stream. This might be less than the number of bytes requested if the end of the stream is reached.
    func readBytes(_ count: Int) throws -> [UInt8] {
        var count = count
        guard count >= 0 else { throw CBStreamError.argumentOutOfRange("count", "Non-negative number required.") }
        guard count > 0 else { return [] }

        var result = [UInt8](repeating: 0, count: count)
        var numRead = 0
        repeat {
            let n = try _buffer.read(&result, numRead, count)
            if n == 0 { break }
            numRead += n
            count -= n
        } while count > 0

        if numRead != result.count {
            // Trim array. This should happen on EOF & possibly net streams.
            var copy = [UInt8](repeating: 0, count: numRead)
            // Copy bytes
            for i in 0..<numRead {
                copy[i] = result[i]
            }
            result = copy
        }

        return result
    }

    /// Reads a 2-byte signed integer from the current stream and advances the current position of the stream by two bytes.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: A 2-byte signed integer read from the current stream.
    func readInt16() throws -> Int16 {
        var bytes = try readBytes(2)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, Int16.self)
    }

    func readUInt16() throws -> UInt16 {
        var bytes = try readBytes(2)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, UInt16.self)
    }

    /// Reads a 4-byte signed integer from the current stream and advances the current position of the stream by four bytes.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: A 4-byte signed integer read from the current stream.
    func readInt32() throws -> Int32 {
        var bytes = try readBytes(4)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, Int32.self)
    }

    func readUInt32() throws -> UInt32 {
        var bytes = try readBytes(4)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, UInt32.self)
    }

    /// Reads an 8-byte signed integer from the current stream and advances the current position of the stream by eight bytes.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: An 8-byte signed integer read from the current stream.
    func readInt64() throws -> Int64 {
        var bytes = try readBytes(8)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, Int64.self)
    }

    /// Reads a 4-byte floating point value from the current stream and advances the current position of the stream by four bytes.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: A 4-byte floating point value read from the current stream.
    func readFloat() throws -> Float {
        var bytes = try readBytes(4)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, Float.self)
    }

    /// Reads an 8-byte floating point value from the current stream and advances the current position of the stream by eight bytes.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: An 8-byte floating point value read from the current stream.
    func readDouble() throws -> Double {
        var bytes = try readBytes(8)
        if _swapNeeded {
            bytes.reverse()
        }
        return fromByteArray(bytes, Double.self)
    }

    /// Reads a string from the current stream. The string is prefixed with the length, encoded as an integer seven bits at a time.
    /// - Throws: An `endOfStream` error if the end of the stream is reached; a `streamIsClosed` error if the stream is closed.
    /// - Returns: The string being read.
    func readString() throws -> String {
        let length = try readInt16()
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative string length given!") }

        var utf8 = UTF8()
        var string = ""
        let bytes = try readBytes(Int(length))
        var generator = bytes.makeIterator()

        while true {
            switch utf8.decode(&generator) {
                case .scalarValue(let unicodeScalar):
                    string.append(String(unicodeScalar))
                case .emptyInput:
                    return string
                case .error:
                    if let nonUTF8Str = String(data: Data(bytes), encoding: .isoLatin1) {
                        return nonUTF8Str
                    } else {
                        throw CBStreamError.stringConversionError
                    }
            }
        }
    }
}
