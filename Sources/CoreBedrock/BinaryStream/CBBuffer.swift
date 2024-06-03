//
// Created by yechentide on 2024/06/02
//

import Foundation

// This class is a partial port of the .NET MemoryStream class.
// It borrows heavily in design and functionality to create a
// stream-like object that uses a backing buffer while maintaining
// a reference type.

/// Specifies the position in a buffer to use for seeking.
public enum SeekOrigin {
    /// Specifies the beginning of a buffer.
    case begin

    /// Specifies the current position within a buffer.
    case current

    /// Specifies the end of a buffer.
    case end
}

/// Creates a buffer whose backing store is a byte array in memory.
public class CBBuffer {
    private var _buffer: [UInt8]            // Either allocated internally or externally
    private var _length: Int = 0            // Number of bytes within the buffer
    private var _capacity: Int = 0          // length of usable portion of buffer
    private var _origin: Int = 0            // For user-provided arrays, start at this origin

    private var _expandable: Bool = false   // User-provided buffers aren't expandable
    private var _position: Int = 0          // read/write head
    // Note that _capacity == _buffer.count for non-user-provided [UInt8]'s

    // Constants
    private let maxBufferLength: Int = Int(Int32.max)
    private let maxByteArrayLength: Int = 0x7FFFFFC7

    /// Initializes a new instance of the `CBBuffer` class with an expandable capacity initialized as specified.
    /// - Parameter capacity: The initial size of the internal array in bytes.
    /// - Throws: an `argumentOutOfRange` error if `capacity` is negative.
    public init(_ capacity: Int) throws {
        guard capacity >= 0 else { throw CBStreamError.argumentOutOfRange("capacity", "Non-negative number required.") }

        if capacity == 0 {
            _buffer = []
        } else {
            _buffer = [UInt8](repeating: 0, count: capacity)
        }
        _capacity = capacity
        _expandable = true
    }

    /// Initializes a new non-resizable instance of the `CBBuffer` class based on
    /// the specified byte array with the `canWrite` property set as specified.
    /// - Parameter buffer: The array of unsigned bytes from which to create the current `CBBuffer`.
    public init(_ buffer: [UInt8]) {
        _buffer = buffer
        _length = buffer.count
        _capacity = buffer.count
    }

    /// Initializes a new instance of the `CBBuffer` class based on the specified region of
    /// a byte array.
    /// - Parameters:
    ///   - buffer: The array of unsigned bytes from which to create the current `CBBuffer`.
    ///   - index: The index into `buffer` at which the `CBBuffer` begins.
    ///   - count: The length of the `CBBuffer` in bytes.
    /// - Throws: An `argumentOutOfRange` error if index or count is less than zero;
    /// or a `formatError` if the buffer length minus the `index` is less than `count`.
    public init(_ buffer: [UInt8], _ index: Int, _ count: Int) throws {
        guard index >= 0 else { throw CBStreamError.argumentOutOfRange("index", "Non-negative number required.") }
        guard count >= 0 else { throw CBStreamError.argumentOutOfRange("count", "Non-negative number required.") }
        guard index + count <= buffer.count else {
            throw CBStreamError.argumentError("Offset and length were out of bounds for the array or count is greater than the number of elements from index to the end of the source collection.")
        }

        _buffer = buffer
        _origin = index
        _position = index
        _length = index + count
        _capacity = index + count
    }

    /// Initializes a new instance of the `CBBuffer` class with an expandable capacity initialized to zero.
    public convenience init() {
        try! self.init(0)
    }

    /// Initializes a new instance of the `CBBuffer` class based on the specified region of
    /// a `Data` buffer, with the `canWrite` property set as specified, and the ability to call
    /// `getBuffer` set as specified.
    /// - Parameter buffer: The `Data` buffer from which to create the current `CBBuffer`.
    public convenience init(_ buffer: Data) {
        self.init([UInt8](buffer))
    }

    /// Initializes a new instance of the `CBBuffer` class based on the specified region of a `Data` buffer.
    /// - Parameters:
    ///   - buffer: The `Data` buffer from which to create the current `CBBuffer`.
    ///   - index: The index into `buffer` at which the `CBBuffer` begins.
    ///   - count: The length of the `CBBuffer` in bytes.
    /// - Throws: An `argumentOutOfRange` error if index or count is less than zero;
    /// or a `formatError` if the buffer length minus the `index` is less than `count`.
    public convenience init(_ buffer: Data, _ index: Int, _ count: Int) throws {
        try self.init([UInt8](buffer), index, count)
    }

    /// Gets the number of bytes allocated for this `CBBuffer`.
    public var capacity: Int {
        get {
            // As of Swift 5.3, throwing errors is not allowed in properties
            // try ensureNotClosed()
            return _capacity - _origin
        }
    }

    /// Gets the length of the `CBBuffer` in bytes.
    public var length: Int {
        get {
            // As of Swift 5.3, throwing errors is not allowed in properties
            // try ensureNotClosed()
            return _length - _origin
        }
    }

    /// Gets  the current position within the `CBBuffer`.
    public var position: Int {
        get {
            // As of Swift 5.3, throwing errors is not allowed in properties
            // try ensureNotClosed()
            return _position - _origin
        }
    }

    // Use a method to set capacity until Swift allows throwing in properties
    /// Sets the number of bytes allocated for this `CBBuffer`.
    public func setCapacity(upto value: Int) throws {
        // Only update the capacity if the CBBuffer is expandable and
        // the value is different than the current capacity. Special
        // behavior if the buffer isn't expandable: we don't throw if
        // value is the same as the current capacity
        guard value >= length else { throw CBStreamError.argumentOutOfRange("capacity", "Capacity cannot be less than the current size.") }
        guard _expandable || value == capacity else { throw CBStreamError.bufferNotExpandable }

        // CBBuffer has this invariant: _origin > 0 => !expandable (see init)
        guard _expandable && value != _capacity else { return }
        guard value > 0 else {
            _buffer = []
            _capacity = 0
            return
        }

        var newBuffer: [UInt8] = [UInt8](repeating: 0, count: value)
        if _length > 0 {
            // Copy the contents of the current _buffer to the new one
            for i in 0..<_length {
                newBuffer[i] = _buffer[i]
            }
        }
        _buffer = newBuffer
        _capacity = value
    }

    // Returns a bool saying whether a new array was allocated
    private func ensureCapacity(_ value: Int) throws -> Bool {
        // Check for overflow
        guard value >= 0 else { throw CBStreamError.argumentOutOfRange("value", "Non-negative number required.") }
        guard value > _capacity else { return false }

        var newCapacity = max(value, 256)

        // Overflow is okay here since the next statement will deal
        // with the cases where _capacity * 2 overflows.
        if newCapacity < _capacity * 2 {
            newCapacity = _capacity * 2
        }

        // Expand the array only up to maxByteArrayLength
        // but also give the user the value they asked for
        if UInt(_capacity * 2) > maxByteArrayLength {
            newCapacity = max(value, maxByteArrayLength)
        }

        try setCapacity(upto: newCapacity)
        return true
    }

    // Use a method to set length until Swift allows throwing in properties
    /// Sets the length of the `CBBuffer` in bytes.
    public func setLength(_ value: Int) throws {
        // Sets the length of the CBBuffer to a given value.  The new
        // value must be nonnegative and less than the space remaining in
        // the array, int.MaxValue - origin
        // Origin is 0 in all cases other than a CBBuffer created on
        // top of an existing array and a specific starting offset was passed
        // into the CBBuffer constructor.  The upper bounds prevents any
        // situations where a buffer may be created on top of an array then
        // the buffer is made longer than the maximum possible length of the
        // array (int.MaxValue).
        guard 0 <= value && value <= Int.max else { throw CBStreamError.argumentOutOfRange("length", "Stream length must be non-negative and less than 2^31 - 1 - origin.") }
        // Origin wasn't publicly exposed above
        guard value <= Int.max - _origin else {
            throw CBStreamError.argumentOutOfRange("length", "Stream length must be non-negative and less than 2^31 - 1 - origin.")
        }

        let newLength = _origin + value
        let allocatedNewArray = try ensureCapacity(newLength)
        if !allocatedNewArray && newLength > _length {
            // "Clear" the elements starting at _length
            for i in _length..<(newLength - _length) {
                _buffer[i] = 0
            }
        }
        _length = newLength
        if _position > newLength {
            _position = newLength
        }
    }

    // Use a method to set length until Swift allows throwing in properties
    /// Sets  the current position within the `CBBuffer`.
    public func setPosition(_ value: Int) throws {
        guard 0 <= value else { throw CBStreamError.argumentOutOfRange("position", "Non-negative number required.") }
        guard value <= maxBufferLength else { throw CBStreamError.argumentOutOfRange("position", "Value must be less than 2^31 - 1 - origin.") }

        _position = _origin + value
    }

    private func validateBufferArguments(_ buffer: [UInt8], _ offset: Int, _ count: Int) throws {
        guard offset >= 0 else { throw CBStreamError.argumentOutOfRange("offset", "Non-negative number required.") }
        guard count >= 0 else { throw CBStreamError.argumentOutOfRange("count", "Non-negative number required.") }
        guard count <= buffer.count - offset else { throw CBStreamError.argumentOutOfRange("count", "Offset and length were out of bounds for the array or count is greater than the number of elements from index to the end of the source collection.") }
    }

    /// Returns the array of unsigned bytes from which this `CBBuffer` was created.
    /// - Returns: The byte array from which this `CBBuffer` was created, or the underlying array if
    /// a byte array was not provided to the `CBBuffer` constructor during construction of
    /// the current instance.
    public func getBuffer() -> [UInt8] {
        return _buffer
    }

    /// Reads a block of bytes from the current `CBBuffer` and writes the data to a buffer.
    /// - Parameters:
    ///   - buffer: When this method returns, contains the specified byte array with the values
    ///   between `offset` and (`offset` + `count` - 1) replaced by the bytes read from
    ///   the current `CBBuffer`.
    ///   - offset: The zero-based byte offset in `buffer` at which to begin storing data from
    ///   the current `CBBuffer`.
    ///   - count: The maximum number of bytes to read.
    /// - Throws: An `argumentOutOfRange` error if `offset` or `count` is negative or if
    /// `offset` subtracted from the buffer length is less than `count`.
    /// - Returns: The total number of bytes written into the buffer. This can be less than the
    /// number of bytes requested if that number of bytes are not currently available,
    /// or zero if the end of the `CBBuffer` is reached before any bytes are read.
    public func read(_ buffer: inout [UInt8], _ offset: Int, _ count: Int) throws -> Int {
        try validateBufferArguments(buffer, offset, count)

        let bytes = (_length - _position > count) ? count : _length - _position
        guard bytes > 0 else { return 0 }

        var tmpPos = 0
        _buffer[_position..<(_position + bytes)].forEach { byte in
            buffer[offset + tmpPos] = byte
            tmpPos += 1
        }

        _position += bytes
        return bytes
    }

    /// Reads a byte from the current `CBBuffer`.
    /// - Returns: The byte cast to `Int`, or -1 if the end of the `CBBuffer` has been reached.
    public func readByte() -> Int {
        guard _position < _length else { return -1 }

        let byte = _buffer[_position]
        _position += 1

        return Int(byte)
    }

    /// Sets the position within the current `CBBuffer` to the specified value.
    /// - Parameters:
    ///   - offset: The new position within the `CBBuffer`. This is relative to the `loc`
    ///   parameter, and can be positive or negative.
    ///   - loc: A value of type `SeekOrigin`, which acts as the seek reference point.
    /// - Throws: An `argumentOutOfRange` error if `offset` is greater than `Int32.max`;
    /// a `seekBeforeBegin` error if seeking is attempted before the beginning of the `CBBuffer`.
    /// - Returns: The new position within the `CBBuffer`, calculated by combining
    /// the initial reference point and the offset.
    public func seek(to offset: Int, from loc: SeekOrigin) throws -> Int {
        guard offset <= maxBufferLength else { throw CBStreamError.argumentOutOfRange("offset", "Value must be less than 2^31 - 1 - origin.") }

        let tempPosition: Int

        switch loc {
            case .begin:
                tempPosition = _origin + offset
                break
            case .current:
                tempPosition = _position + offset
                break
            case .end:
                tempPosition = _length + offset
                break
        }

        if tempPosition < _origin || _origin > tempPosition {
            throw CBStreamError.seekBeforeBegin
        }
        _position = tempPosition

        return _position
    }

    /// Writes the `CBBuffer` contents to a byte array, regardless of the `position` property.
    /// - Returns: A new byte array.
    public func toArray() -> [UInt8] {
        let count = _length - _origin
        guard count > 0 else { return [UInt8]() }

        var copy = [UInt8](repeating: 0, count: count)
        // Copy bytes over
        var tmpPos = 0
        _buffer[_origin..<_length].forEach { byte in
            copy[tmpPos] = byte
            tmpPos += 1
        }

        return copy
    }

    /// Writes a block of bytes to the current `CBBuffer` using data read from a buffer.
    /// - Parameters:
    ///   - buffer: The buffer to write data from.
    ///   - offset: The zero-based byte offset in `buffer` at which to begin copying bytes to the current `CBBuffer`.
    ///   - count: The maximum number of bytes to write.
    /// - Throws: A `writeNotSupported` error if the `CBBuffer` does not support writing or
    /// if the current position is closer than `count` bytes to the end of the `CBBuffer` and
    /// the capacity cannot be modified; an argumentOutOfRange if `offset` or `count` are negative.
    public func write(_ buffer: [UInt8], _ offset: Int, _ count: Int) throws {
        try validateBufferArguments(buffer, offset, count)

        let dstPos = _position + count
        // Check for overflow
        guard dstPos >= 0 else { throw CBStreamError.invalidOperation("Stream too long.") }

        if dstPos > _length {
            var mustZero = _position > _length
            if dstPos > _capacity {
                let allocatedNewArray = try ensureCapacity(dstPos)
                if allocatedNewArray {
                    mustZero = false
                }
            }
            if mustZero {
                for j in _length..<dstPos {
                    _buffer[j] = 0
                }
            }
            _length = dstPos
        }
        // Technically buffer will never == _buffer because [UInt8]
        // is not a reference type, but keep the check to maintain
        // parity with .NET
        if count <= 8 && buffer != _buffer {
            var byteCount = count - 1
            while byteCount >= 0 {
                _buffer[_position + byteCount] = buffer[offset + byteCount]
                byteCount -= 1
            }
        } else {
            // Copy bytes to _buffer
            let tmpArray = Array(buffer[offset..<(offset + count)])
            var tmpPos = 0
            for i in _position..<(_position + count) {
                _buffer[i] = tmpArray[tmpPos]
                tmpPos += 1
            }
        }
        _position = dstPos
    }

    /// Writes a byte to the current `CBBuffer` at the current position.
    /// - Parameter value: The byte to write.
    /// - Throws: A `writeNotSupported` error if the `CBBuffer` does not support writing or
    /// the current position is at the end of the `CBBuffer`, and the capacity cannot be modified.
    public func writeByte(_ value: UInt8) throws {
        if _position >= _length {
            let newLength = _position + 1
            var mustZero = _position > _length
            if newLength > _capacity {
                let allocatedNewArray = try ensureCapacity(newLength)
                if allocatedNewArray {
                    mustZero = false
                }
            }
            if mustZero {
                for i in _length..<_position {
                    _buffer[i] = 0
                }
            }
            _length = newLength
        }

        _buffer[_position] = value
        _position += 1
    }
}
