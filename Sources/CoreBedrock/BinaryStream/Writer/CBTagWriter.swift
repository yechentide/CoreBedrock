//
// Created by yechentide on 2024/06/02
//

import Foundation

public final class CBTagWriter {
    private let maxStreamCopyBufferSize = 1024 * 8

    private var _writer: CBBinaryWriter
    private var _listType: TagType
    private var _parentType: TagType
    private var _listIndex: Int
    private var _listSize: Int
    private var _nodes: [CBTagWriterNode]

    /// Initializes a new instance of the `CBTagWriter` class.
    /// - Parameters:
    ///   - stream: The stream to write to.
    ///   - rootTagName: The name to give to the root tag (written immediately).
    ///   - useLittleEndian: `true` if the data in the stream should be Little-Endian encoded; otherwise `false`.
    /// - Throws: An `IOError.writeNotSupported` error if the stream is not writeable.
    public init(stream: CBBuffer, rootTagName: String, useLittleEndian: Bool) throws {
        _writer = CBBinaryWriter(stream, useLittleEndian)
        _listType = .unknown
        _listIndex = 0
        _listSize = 0
        _nodes = []

        // The root must always start with a Compound tag
        try _writer.write(TagType.compound)
        try _writer.write(rootTagName)
        _parentType = .compound
    }

    /// Initializes a new instance of the `CBTagWriter` class.
    /// - Parameters:
    ///   - stream: The stream to write to.
    ///   - rootTagName: The name to give to the root tag (written immediately).
    /// - Throws: An `IOError.writeNotSupported` error if the stream is not writeable.
    convenience public init(stream: CBBuffer, rootTagName: String) throws {
        try self.init(stream: stream, rootTagName: rootTagName, useLittleEndian: true)
    }

    public private(set) var isDone: Bool = false

    public var baseStream: CBBuffer { return _writer.baseStream }

    /// Begins an unnamed compound tag.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can be
    /// written, a named compound tag was expected, a tag of a different type was
    /// expected, or the size of a parent list has been exceeded.
    public func beginCompound() throws {
        try enforceConstraints(name: nil, desiredType: .compound)
        goDown(thisType: .compound)
    }

    /// Begins a named compound tag.
    /// - Parameter tagName: The name to give to this compound tag.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can be
    /// written, an unnamed compound tag was expected, a tag of a different type was
    /// expected.
    public func beginCompound(_ tagName: String) throws {
        try enforceConstraints(name: tagName, desiredType: .compound)
        goDown(thisType: .compound)

        try _writer.write(TagType.compound)
        try _writer.write(tagName)
    }

    /// Ends a compound tag.
    /// - Throws: An `CBStreamError.invalidFormat` error if not currently in a compound.
    public func endCompound() throws {
        if isDone || _parentType != .compound {
            throw CBStreamError.invalidFormat("Not currently in a compound.")
        }
        goUp()
        try _writer.write(TagType.end)
    }

    /// Begins an unnamed list tag.
    /// - Parameters:
    ///   - elementType: The type of elements in the list.
    ///   - size: The number of elements in the list. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can be
    /// written, a named list tag was expected, a tag of a different type was expected,
    /// or the size of a parent list has been exceeded; an `CBStreamError.argumentOutOfRange`
    /// error if `size` is negative or `elementType` is not a valid type.
    public func beginList(elementType: TagType, size: Int) throws {
        if size < 0 {
            throw CBStreamError.argumentOutOfRange("size", "List size may not be negative.")
        }
        if elementType.rawValue < TagType.byte.rawValue ||
            elementType.rawValue > TagType.longArray.rawValue {
            throw CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type.")
        }
        try enforceConstraints(name: nil, desiredType: .list)
        goDown(thisType: .list)
        _listType = elementType
        _listSize = size

        try _writer.write(elementType)
        try _writer.write(Int32(size))
    }

    /// Begins a named list tag.
    /// - Parameters:
    ///   - tagName: The name given to this list tag.
    ///   - elementType: The type of elements in the list.
    ///   - size: The number of elements in the list. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can be
    /// written, a unnamed list tag was expected, or a tag of a different type was expected;
    /// an `CBStreamError.argumentOutOfRange` error if `size` is negative or
    /// `elementType` is not a valid type.
    public func beginList(tagName: String, elementType: TagType, size: Int) throws {
        if size < 0 {
            throw CBStreamError.argumentOutOfRange("size", "List size may not be negative.")
        }
        if elementType.rawValue < TagType.byte.rawValue ||
            elementType.rawValue > TagType.longArray.rawValue {
            throw CBStreamError.argumentOutOfRange("elementType", "Unrecognized tag type.")
        }
        try enforceConstraints(name: tagName, desiredType: .list)
        goDown(thisType: .list)
        _listType = elementType
        _listSize = size

        try _writer.write(TagType.list)
        try _writer.write(tagName)
        try _writer.write(elementType)
        try _writer.write(Int32(size))
    }

    /// Ends a list tag.
    /// - Throws: An `CBStreamError.invalidFormat` error if not currently in a list or
    /// not all list elements have been written yet.
    public func endList() throws {
        if _parentType != .list || isDone {
            throw CBStreamError.invalidFormat("Not currently in a list.")
        }
        else if _listIndex < _listSize {
            throw CBStreamError.invalidFormat("Cannot end list: not all elements have been written yet. Expected: \(_listSize), written: \(_listIndex)")
        }
        goUp()
    }

    /// Writes an unnamed byte tag.
    /// - Parameter value: The unsigned byte to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named byte tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeByte(value: UInt8) throws {
        try enforceConstraints(name: nil, desiredType: .byte)
        try _writer.write(value)
    }

    /// Writes a named byte tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The unsigned byte to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed byte tag was expcted, or a tag of a different type was exptected.
    public func writeByte(tagName: String, value: UInt8) throws {
        try enforceConstraints(name: tagName, desiredType: .byte)
        try _writer.write(TagType.byte)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed double tag.
    /// - Parameter value: The double-precision, floating-point value to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named double tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeDouble(value: Double) throws {
        try enforceConstraints(name: nil, desiredType: .double)
        try _writer.write(value)
    }

    /// Writes a named double tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The double-precision, floating-point value to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed double tag was expcted, or a tag of a different type was exptected.
    public func writeDouble(tagName: String, value: Double) throws {
        try enforceConstraints(name: tagName, desiredType: .double)
        try _writer.write(TagType.double)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed float tag.
    /// - Parameter value: The single-precision, floating-point value to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named float tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeFloat(value: Float) throws {
        try enforceConstraints(name: nil, desiredType: .float)
        try _writer.write(value)
    }

    /// Writes a named float tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The single-precision, floating-point value to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed float tag was expcted, or a tag of a different type was exptected.
    public func writeFloat(tagName: String, value: Float) throws {
        try enforceConstraints(name: tagName, desiredType: .float)
        try _writer.write(TagType.float)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed int tag.
    /// - Parameter value: The 32-bit, signed integer to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named int tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeInt(value: Int32) throws {
        try enforceConstraints(name: nil, desiredType: .int)
        try _writer.write(value)
    }

    /// Writes a named int tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The 32-bit, signed integer to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed int tag was expcted, or a tag of a different type was exptected.
    public func writeInt(tagName: String, value: Int32) throws {
        try enforceConstraints(name: tagName, desiredType: .int)
        try _writer.write(TagType.int)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed long tag.
    /// - Parameter value: The 64-bit, signed integer to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named long tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeLong(value: Int64) throws {
        try enforceConstraints(name: nil, desiredType: .long)
        try _writer.write(value)
    }

    /// Writes a named long tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The 64-bit, signed integer to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed long tag was expcted, or a tag of a different type was exptected.
    public func writeLong(tagName: String, value: Int64) throws {
        try enforceConstraints(name: tagName, desiredType: .long)
        try _writer.write(TagType.long)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed short tag.
    /// - Parameter value: The 16-bit, signed integer to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named short tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeShort(value: Int16) throws {
        try enforceConstraints(name: nil, desiredType: .short)
        try _writer.write(value)
    }

    /// Writes a named short tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The 16-bit, signed integer towrite.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed short tag was expcted, or a tag of a different type was exptected.
    public func writeShort(tagName: String, value: Int16) throws {
        try enforceConstraints(name: tagName, desiredType: .short)
        try _writer.write(TagType.short)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed string tag.
    /// - Parameter value: The string to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, a named string tag was expcted, a tag of a different type was exptected,
    /// or the size of a parent list has been exceeded.
    public func writeString(value: String) throws {
        try enforceConstraints(name: nil, desiredType: .string)
        try _writer.write(value)
    }

    /// Writes a named string tag.
    /// - Parameters:
    ///   - tagName: The name to be given to this tag.
    ///   - value: The string to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can
    /// be written, an unnamed string tag was expcted, or a tag of a different type was exptected.
    public func writeString(tagName: String, value: String) throws {
        try enforceConstraints(name: tagName, desiredType: .string)
        try _writer.write(TagType.string)
        try _writer.write(tagName)
        try _writer.write(value)
    }

    /// Writes an unnamed byte array tag, copying data from an array.
    /// - Parameters:
    ///   - data: A byte array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named byte array tag was expected, or a tag of a
    /// different type was expected.
    public func writeByteArray(data: [UInt8]) throws {
        try writeByteArray(data: data, offset: 0, count: data.count)
    }

    /// Writes an unnamed byte array tag, copying data from an array.
    /// - Parameters:
    ///   - data: A byte array containing the data to write.
    ///   - offset: The starting point in <paramref name="data"/> at which to begin writing. Must not be negative.
    ///   - count: The number of bytes to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from the array length.
    public func writeByteArray(data: [UInt8], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: nil, desiredType: .byteArray)
        try _writer.write(Int32(count))
        try _writer.write(data, offset, count)
    }

    /// Writes a named byte array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this byte array tag.
    ///   - data: A byte array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed byte array tag was expected, or a tag of a
    /// different type was expected.
    public func writeByteArray(tagName: String, data: [UInt8]) throws {
        try writeByteArray(tagName: tagName, data: data, offset: 0, count: data.count)
    }

    /// Writes a named byte array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this byte array tag.
    ///   - data: A byte array containing the data to write.
    ///   - offset: The starting point in <paramref name="data"/> at which to begin writing. Must not be negative.
    ///   - count: The number of bytes to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from the array length.
    public func writeByteArray(tagName: String, data: [UInt8], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: tagName, desiredType: .byteArray)
        try _writer.write(TagType.byteArray)
        try _writer.write(tagName)
        try _writer.write(Int32(count))
        try _writer.write(data, offset, count)
    }

    /// Writes an unnamed byte array tag, copying data from a stream.
    /// - Parameters:
    ///   - dataSource: A Stream from which data will be copied.
    ///   - count: The number of bytes to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if the
    /// given stream does not support reading.
    public func writeByteArray(dataSource: CBBuffer, count: Int) throws {
        if count < 0 {
            throw CBStreamError.argumentOutOfRange("count", "Value may not be negative.")
        }
        let bufferSize = min(count, maxStreamCopyBufferSize)
        var streamCopyBuffer = [UInt8](repeating: 0, count: bufferSize)
        try writeByteArray(dataSource: dataSource, count: count, buffer: &streamCopyBuffer)
    }

    /// Writes an unnamed byte array tag, copying data from a stream.
    /// - Parameters:
    ///   - dataSource: A Stream from which data will be copied.
    ///   - count: The number of bytes to write. Must not be negative.
    ///   - buffer: Buffer to use for copying. Size must be greater than 0.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if the
    /// given stream does not support reading or `buffer` size is 0.
    public func writeByteArray(dataSource: CBBuffer, count: Int, buffer: inout [UInt8]) throws {
        if count < 0 {
            throw CBStreamError.argumentOutOfRange("count", "Value may not be negative.")
        }
        else if buffer.count == 0 && count > 0 {
            throw CBStreamError.argumentError("Buffer size must be greater than 0 when count is greater than 0.", "buffer")
        }

        try enforceConstraints(name: nil, desiredType: .byteArray)
        try writeByteArrayFromStreamImpl(dataSource: dataSource, count: count, buffer: &buffer)
    }

    /// Writes a named byte array tag, copying data from a stream.
    /// - Parameters:
    ///   - tagName: Name to give to this byte array tag.
    ///   - dataSource: A Stream from which data will be copied.
    ///   - count: The number of bytes to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if the
    /// given stream does not support reading.
    public func writeByteArray(tagName: String, dataSource: CBBuffer, count: Int) throws {
        if count < 0 {
            throw CBStreamError.argumentOutOfRange("count", "Value may not be negative.")
        }
        let bufferSize = min(count, maxStreamCopyBufferSize)
        var streamCopyBuffer = [UInt8](repeating: 0, count: bufferSize)
        try writeByteArray(tagName: tagName, dataSource: dataSource, count: count, buffer: &streamCopyBuffer)
    }

    /// Writes an unnamed byte array tag, copying data from another stream.
    /// - Parameters:
    ///   - tagName: Name to give to this byte array tag.
    ///   - dataSource: A Stream from which data will be copied.
    ///   - count: The number of bytes to write. Must not be negative.
    ///   - buffer: Buffer to use for copying. Size must be greater than 0.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed byte array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if the
    /// given stream does not support reading or `buffer` size is 0.
    public func writeByteArray(tagName: String, dataSource: CBBuffer,
                               count: Int, buffer: inout [UInt8]) throws {
        if count < 0 {
            throw CBStreamError.argumentOutOfRange("count", "Value may not be negative.")
        }
        else if buffer.count == 0 && count > 0 {
            throw CBStreamError.argumentError("Buffer size must be greater than 0 when count is greater than 0.", "buffer")
        }

        try enforceConstraints(name: tagName, desiredType: .byteArray)
        try _writer.write(TagType.byteArray)
        try _writer.write(tagName)
        try writeByteArrayFromStreamImpl(dataSource: dataSource, count: count, buffer: &buffer)
    }

    /// Writes an unnamed int array tag, copying data from an array.
    /// - Parameters:
    ///   - data: An int array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed int array tag was expected, or a tag of a
    /// different type was expected.
    public func writeIntArray(data: [Int32]) throws {
        try writeIntArray(data: data, offset: 0, count: data.count)
    }

    /// Writes an unnamed int array tag, copying data from an array.
    /// - Parameters:
    ///   - data: An int array containing the data to write.
    ///   - offset: The starting point in `data` at which to begin writing. Must not be negative.
    ///   - count: The number of elements to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named int array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from array length.
    public func writeIntArray(data: [Int32], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: nil, desiredType: .intArray)
        try _writer.write(Int32(count))
        for i in offset..<count {
            try _writer.write(data[i])
        }
    }

    /// Writes a named int array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this int array tag.
    ///   - data: An int array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed int array tag was expected, or a tag of a
    /// different type was expected.
    public func writeIntArray(tagName: String, data: [Int32]) throws {
        try writeIntArray(tagName: tagName, data: data, offset: 0, count: data.count)
    }

    /// Writes a named int array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this int array tag.
    ///   - data: An int array containing the data to write.
    ///   - offset: The starting point in `data` at which to begin writing. Must not be negative.
    ///   - count: The number of elements to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed int array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from array length.
    public func writeIntArray(tagName: String, data: [Int32], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: tagName, desiredType: .intArray)
        try _writer.write(TagType.intArray)
        try _writer.write(tagName)
        try _writer.write(Int32(count))
        for i in offset..<count {
            try _writer.write(data[i])
        }
    }

    /// Writes an unnamed long array tag, copying data from an array.
    /// - Parameters:
    ///   - data: A long array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed long array tag was expected, or a tag of a
    /// different type was expected.
    public func writeLongArray(data: [Int64]) throws {
        try writeLongArray(data: data, offset: 0, count: data.count)
    }

    /// Writes an unnamed long array tag, copying data from an array.
    /// - Parameters:
    ///   - data: A long array containing the data to write.
    ///   - offset: The starting point in `data` at which to begin writing. Must not be negative.
    ///   - count: The number of elements to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, a named long array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from array length.
    public func writeLongArray(data: [Int64], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: nil, desiredType: .longArray)
        try _writer.write(Int32(count))
        for i in offset..<count {
            try _writer.write(data[i])
        }
    }

    /// Writes a named long array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this int array tag.
    ///   - data: A  long array containing the data to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed long array tag was expected, or a tag of a
    /// different type was expected.
    public func writeLongArray(tagName: String, data: [Int64]) throws {
        try writeLongArray(tagName: tagName, data: data, offset: 0, count: data.count)
    }

    /// Writes a named long array tag, copying data from an array.
    /// - Parameters:
    ///   - tagName: Name to give to this int array tag.
    ///   - data: A long array containing the data to write.
    ///   - offset: The starting point in `data` at which to begin writing. Must not be negative.
    ///   - count: The number of elements to write. Must not be negative.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags
    /// can be wrtten, an unnamed long array tag was expected, or a tag of a
    /// different type was expected; an `CBStreamError.argumentOutOfRange`
    /// error if `count` is negative; an `CBStreamError.argumentError` if
    /// `count` is greater than `offset` subtracted from array length.
    public func writeLongArray(tagName: String, data: [Int64], offset: Int, count: Int) throws {
        try CBTagWriter.checkArray(data: data, offset: offset, count: count)
        try enforceConstraints(name: tagName, desiredType: .longArray)
        try _writer.write(TagType.longArray)
        try _writer.write(tagName)
        try _writer.write(Int32(count))
        for i in offset..<count {
            try _writer.write(data[i])
        }
    }

    /// Write an `NbtTag` object and all of its child tags to the stream. Use this method sparingly
    /// with `CBTagWriter`, constructing `NbtTag` objects defeats the purpose of this class. If you
    /// already have lots of `NbtTag` objects, you might as well use `NbtFile` to write them all
    /// at once.
    /// - Parameter tag: The tag to write.
    /// - Throws: An `CBStreamError.invalidFormat` error if no more tags can be written or the given
    /// tag is unacceptable at this time.
    public func writeTag(tag: NBT) throws {
        try enforceConstraints(name: tag.name, desiredType: tag.tagType)
        if tag.name != nil {
            try tag.writeTag(_writer)
        } else {
            try tag.writeData(_writer)
        }
    }

    /// Ensures that file has been written in its entirety, with no tags left open.
    /// This method is for verification only, and does not actually write any data.
    /// Calling this method is optional (but probably a good idea, to catch any usage errors).
    /// - Throws: An `CBStreamError.invalidFormat` error if not all tags have been closed yet.
    public func finish() throws {
        if !isDone {
            throw CBStreamError.invalidFormat("Cannot finish: not all tags have been closed yet.")
        }
    }

    private func goDown(thisType: TagType) {
        let newNode = CBTagWriterNode(
            parentType: _parentType,
            listType: _listType,
            listSize: _listSize,
            listIndex: _listIndex
        )
        _nodes.append(newNode)

        _parentType = thisType
        _listType = .unknown
        _listSize = 0
        _listIndex = 0
    }

    private func goUp() {
        if _nodes.count == 0 {
            isDone = true
        } else {
            let oldNode = _nodes.popLast()!
            _parentType = oldNode.parentType
            _listType = oldNode.listType
            _listSize = oldNode.listSize
            _listIndex = oldNode.listIndex
        }
    }

    private func enforceConstraints(name: String?, desiredType: TagType) throws {
        if isDone {
            throw CBStreamError.invalidFormat("Cannot write any more tags: root tag has been closed.")
        }
        if _parentType == .list {
            if name != nil {
                throw CBStreamError.invalidFormat("Expecting an unnamed tag.")
            }
            else if _listType != desiredType {
                throw CBStreamError.invalidFormat("Unexpected tag type (expected: \(_listType), given: \(desiredType))")
            }
            else if _listIndex >= _listSize {
                throw CBStreamError.invalidFormat("Given list size exceeded.")
            }
            _listIndex += 1
        }
        else if name == nil {
            throw CBStreamError.invalidFormat("Expecting a named tag.")
        }
    }

    private static func checkArray(data: Array<Any>, offset: Int, count: Int) throws {
        if offset < 0 {
            throw CBStreamError.argumentOutOfRange("offset", "Offset may not be negative.")
        }
        else if count < 0 {
            throw CBStreamError.argumentOutOfRange("count", "Count may not be negative.")
        }
        else if data.count - offset < count {
            throw CBStreamError.argumentError("Count may not be greater than offset subtracted from the array length.")
        }
    }

    private func writeByteArrayFromStreamImpl(dataSource: CBBuffer, count: Int, buffer: inout [UInt8]) throws {
        try _writer.write(Int32(count))
        let maxBytesToWrite = min(buffer.count, CBBinaryWriter.maxWriteChunk)
        var bytesWritten = 0
        while bytesWritten < count {
            let bytesToRead = min(count - bytesWritten, maxBytesToWrite)
            let bytesRead = try dataSource.read(&buffer, 0, bytesToRead)
            try _writer.write(buffer, 0, bytesRead)
            bytesWritten += bytesRead
        }
    }
}
