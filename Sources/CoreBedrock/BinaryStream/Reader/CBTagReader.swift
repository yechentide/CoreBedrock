//
// Created by yechentide on 2024/06/02
//

import Foundation

extension CBTagReader: CustomStringConvertible {
    public var description: String {
        return toString(includeValue: false, indentString: NBT.defaultIndentString)
    }
}

/// Represents a reader that provides fast, non-cached, forward-only access to NBT data.
public class CBTagReader {
    private var _state: CBParseState = .atStreamBeginning
    private var _reader: CBBinaryReader
    private var _nodes: [CBTagReaderNode]
    private var _streamStartOffset: Int = 0
    private var _atValue: Bool = false
    private var _valueCache: Any!
    private var _cacheTagValues: Bool

    private let noValueToReadError = "Value already read, or no value to read."
    private let nonValueTagError = "Trying to read value of a non-value tag."
    private let invalidParentTagError = "Parent tag is neither a Compound nor a List."
    private let erroneousStateError = "CBTagReader is in an erroneous state!"

    /// Initializes a new instance of the `CBTagReader` class based on the specified stream.
    /// - Parameters:
    ///   - stream: The stream to read from.
    ///   - useLittleEndian: `True` if the NBT data is Little-Endian encoded; otherwise `false`.
    public init(stream: CBBuffer, useLittleEndian: Bool) {
        skipEndTags = true
        _cacheTagValues = false
        _nodes = []
        parentTagType = .unknown
        tagType = .unknown
        _streamStartOffset = stream.position

        _reader = CBBinaryReader(stream, useLittleEndian)
    }

    /// Initializes a new instance of the `CBTagReader` class based on the specified stream.
    /// - Parameter stream: The stream to read from.
    public convenience init(_ stream: CBBuffer) {
        self.init(stream: stream, useLittleEndian: true)
    }

    /// Gets the stream from which the data is being read.
    public var baseStream: CBBuffer { return _reader.baseStream }

    /// Gets or sets whether the `CBTagReader` should save a copy of the most recently read tag's value. Unless
    /// `cacheTagValues` is set to `true`, tag values can only be read once. The default is `false`.
    public var cacheTagValues: Bool {
        get { return _cacheTagValues }
        set {
            _cacheTagValues = newValue
            if !newValue {
                _valueCache = nil
            }
        }
    }

    /// Gets whether this `CBTagReader` instance is in a state of error.
    /// No further reading can be done from this instance if a parse error occurred.
    public var isInErrorState: Bool { return _state == .error }

    /// Parsing option: Whether CBTagReader should skip End tags in ReadToFollowing() automatically while parsing.
    /// Default is `true`.
    public var skipEndTags: Bool

    // These properties have internal "get" access for unit testing purposes
    private(set) var rootName: String?
    private(set) var parentName: String?
    private(set) var tagName: String?
    private(set) var parentTagType: TagType
    private(set) var tagType: TagType
    var isListElement: Bool { return parentTagType == .list }
    var hasValue: Bool {
        switch tagType {
            case .compound,
                    .end,
                    .list,
                    .unknown:
                return false
            default:
                return true
        }
    }
    var hasName: Bool { return tagName != nil }
    var isAtStreamEnd: Bool { return _state == .atStreamEnd }
    var isCompound: Bool { return tagType == .compound }
    var isList: Bool { return tagType == .list }
    var hasLength: Bool {
        // Technically Compound tags also have a length, but
        // it is not known until all child tags are read.
        switch tagType {
            case .list,
                    .byteArray,
                    .intArray,
                    .longArray:
                return true
            default:
                return false
        }
    }
    private(set) var tagStartOffset: Int = 0
    private(set) var tagsRead: Int = 0
    private(set) var depth: Int = 0
    private(set) var listType: TagType = .unknown
    private(set) var tagLength: Int = 0
    private(set) var parentTagLength: Int = 0
    private(set) var listIndex: Int = 0

    /// Reads the next tag from the stream.
    /// - Returns: `true` if the tag was read successfully; false if there are no more tags to read.
    /// - Throws: An `invalidFormat` error if an error occurred while parsing data; an `invalidReaderState` error if the reader cannot recover from a previous parsing error.
    public func readToFollowing() throws -> Bool {
    readLoop: while true {
        switch _state {
            case .atStreamBeginning:
                // Set the state to error in case reader.ReadTagType throws
                _state = .error
                // Read the first tag, make sure it's a compound
                if try _reader.readTagType() != .compound {
                    _state = .error
                    throw CBStreamError.invalidFormat("Given NBT stream does not start with TAG_Compound.")
                }
                depth = 1
                tagType = .compound
                // Read the root name. Advance to the first inside tag.
                try readTagHeader(true)
                rootName = tagName
                return true

            case .atCompoundBeginning:
                goDown()
                _state = .inCompound
                continue readLoop

            case .inCompound:
                if _atValue {
                    try skipValue()
                }
                // Read next tag, check if we've hit the end
                tagStartOffset = _reader.baseStream.position - _streamStartOffset

                let oldState = _state
                // Set state to error in case reader.ReadTagType throws
                _state = .error
                tagType = try _reader.readTagType()
                _state = oldState

                if tagType == .end {
                    tagName = nil
                    tagsRead += 1
                    _state = .atCompoundEnd
                    if skipEndTags {
                        tagsRead -= 1
                        continue readLoop
                    } else {
                        return true
                    }
                } else {
                    try readTagHeader(true)
                    return true
                }

            case .atListBeginning:
                goDown()
                listIndex -= 1
                tagType = listType
                _state = .inList
                continue readLoop

            case .inList:
                if _atValue {
                    try skipValue()
                }
                listIndex += 1
                if listIndex >= parentTagLength {
                    goUp()
                    if parentTagType == .list {
                        _state = .inList
                        tagType = .list
                        continue readLoop
                    } else if parentTagType == .compound {
                        _state = .inCompound
                        continue readLoop
                    } else {
                        // This should not happen unless CBTagReader is bugged
                        _state = .error
                        throw CBStreamError.invalidFormat(invalidParentTagError)
                    }
                } else {
                    tagStartOffset = _reader.baseStream.position - _streamStartOffset
                    try readTagHeader(false)
                }
                return true

            case .atCompoundEnd:
                goUp()
                if parentTagType == .list {
                    _state = .inList
                    tagType = .compound
                    continue readLoop
                } else if parentTagType == .compound {
                    _state = .inCompound
                    continue readLoop
                } else if parentTagType == .unknown {
                    _state = .atStreamEnd
                    return false
                } else {
                    // This should not happen unless CBTagReader is bugged
                    _state = .error
                    throw CBStreamError.invalidFormat(invalidParentTagError)
                }

            case .atStreamEnd:
                // Nothing left to read!
                return false

            default:
                // Parsing error, or unexpected state
                throw CBStreamError.invalidReaderState(erroneousStateError)
        }
    }
    }

    /// Reads until a tag with the specified name is found. Returns false if are no more tags to read (end of stream is reached).
    /// - Parameter tagName: Name of the tag. May be null (to look for next unnamed tag).
    /// - Throws: A `formatException` error if an error occurred while parsing data in NBT format; an `invalidOperation` error if the `CBTagReader` cannot recover from a previous parsing error.
    /// - Returns: `true` if a matching tag is found; otherwise `false`.
    public func readToFollowing(_ tagName: String) throws -> Bool {
        while try readToFollowing() {
            if self.tagName == tagName {
                return true
            }
        }
        return false
    }

    /// Advances the CBTagReader to the next descendant tag with the specified name. If a matching child tag is not found, the CBTagReader is positioned on the end tag.
    /// - Parameter tagName: Name of the tag you wish to move to. May be null (to look for next unnamed tag).
    /// - Throws: A `formatException` error if an error occurred while parsing data in NBT format; an `invalidOperation` error if the `CBTagReader` cannot recover from a previous parsing error.
    /// - Returns: `true` if a matching descendant tag is found; otherwise `false`.
    public func readToDescendant(_ tagName: String) throws -> Bool {
        if _state == .error {
            throw CBStreamError.invalidReaderState(erroneousStateError)
        } else if _state == .atStreamEnd {
            return false
        }
        let currentDepth = depth
        while try readToFollowing() {
            if depth <= currentDepth {
                return false
            } else if self.tagName == tagName {
                return true
            }
        }
        return false
    }

    /// Advances the CBTagReader to the next sibling tag, skipping any child tags. If there are no more siblings, CBTagReader is positioned on the tag following the last of this tag's descendants.
    /// - Throws: A `formatException` error if an error occurred while parsing data in NBT format; an `invalidOperation` error if the `CBTagReader` cannot recover from a previous parsing error.
    /// - Returns: `true` if a sibling element is found; otherwise `false`.
    public func readToNextSibling() throws -> Bool {
        if _state == .error {
            throw CBStreamError.invalidReaderState(erroneousStateError)
        } else if _state == .atStreamEnd {
            return false
        }
        let currentDepth = depth
        while try readToFollowing() {
            if depth == currentDepth {
                return true
            } else if depth < currentDepth {
                return false
            }
        }
        return false
    }

    /// Advances the CBTagReader to the next sibling tag with the specified name.
    /// If a matching sibling tag is not found, CBTagReader is positioned on the tag following the last siblings.
    /// - Parameter tagName: The name of the sibling tag you wish to move to.
    /// - Throws: A `formatException` error if an error occurred while parsing data in NBT format; an `invalidOperation` error if the `CBTagReader` cannot recover from a previous parsing error.
    /// - Returns: `true` if a sibling element is found; otherwise `false`.
    public func readToNextSibling(_ tagName: String) throws -> Bool {
        while try readToNextSibling() {
            if self.tagName == tagName {
                return true
            }
        }
        return false
    }

    /// Skips current tag, its value/descendants, and any following siblings. In other words: reads until parent tag's sibling.
    /// - Throws: A `formatException` error if an error occurred while parsing data in NBT format; an `invalidOperation` error if the `CBTagReader` cannot recover from a previous parsing error.
    /// - Returns: Total number of tags that were skipped. Returns 0 if end of the stream is reached.
    public func skip() throws -> Int {
        if _state == .error {
            throw CBStreamError.invalidReaderState(erroneousStateError)
        } else if _state == .atStreamEnd {
            return 0
        }
        let startDepth = depth
        var skipped = 0
        while try readToFollowing() && depth >= startDepth {
            skipped += 1
        }
        return skipped
    }

    /// Reset the state to read contiguous tags
    public func resetState() {
        _state = .atStreamBeginning
    }

    /// Use this property to avoid weak `parent` references becoming nil due to instance being released
    var parentMap: [String:NBT] = [:]

    /// Reads the entirety of the current tag, including any descendants,
    /// and constructs an NbtTag object of the appropriate type.
    /// - Throws: An `CBStreamError.invalidFormat` error if an error occurred while parsing data in NBT format;
    /// an `CBStreamError.invalidReaderState` error if the CBTagReader cannot recover from a previous parsing error;
    /// an `CBStreamError.endOfStream` error if the end of the stream has been reached; an `CBStreamError.invalidOperation`
    /// error if the tag value has already been read and `cacheTagValues` is false.
    /// - Returns: Constructed NbtTag object
    public func readAsTag() throws -> NBT {
        if _state == .error {
            throw CBStreamError.invalidReaderState(erroneousStateError)
        }
        else if _state == .atStreamEnd {
            throw CBStreamError.endOfStream
        }
        else if _state == .atStreamBeginning || _state == .atCompoundEnd {
            _ = try readToFollowing()
        }

        // Get this tag
        var parent: NBT
        if tagType == .compound {
            parent = CompoundTag(name: tagName)
        }
        else if tagType == .list {
            parent = try ListTag(name: tagName, listType: listType)
        }
        else if _atValue {
            let result = try readValueAsTag()
            _ = try readToFollowing()
            // If we're at a value tag, there are no child tags to read
            return result
        }
        else {
            // End tags cannot be read as tags (there is no corresponding NbtTag object)
            throw CBStreamError.invalidOperation(noValueToReadError)
        }

        let startingDepth = depth
        var parentDepth = depth
        repeat {
            _ = try readToFollowing()
            // Going up the file tree, or end of document: wrap up
            while depth <= parentDepth && parent.parent != nil {
                parent = parent.parent!
                parentDepth -= 1
            }
            if depth <= startingDepth {
                break
            }

            var thisTag: NBT
            if tagType == .compound {
                thisTag = CompoundTag(name: tagName)
                try addToParent(child: thisTag, parent: parent)
                parentMap[parent.path] = parent
                parent = thisTag
                parentDepth = depth
            }
            else if tagType == .list {
                thisTag = try ListTag(name: tagName, listType: listType)
                try addToParent(child: thisTag, parent: parent)
                parentMap[parent.path] = parent
                parent = thisTag
                parentDepth = depth
            }
            else if tagType != .end {
                thisTag = try readValueAsTag()
                try addToParent(child: thisTag, parent: parent)
            }
        } while true

        return parent
    }

    /// Reads the value as an object of the correct type, boxed.
    /// Cannot be called for tags that do not have a single-object
    /// value (compound, list, and end tags).
    /// - Throws: An `CBStreamError.endOfStream` error if the end of the stream was reached;
    /// an `CBStreamError.invalidFormat` error if an error occurred while parsing data in NBT format;
    /// an `CBStreamError.invalidOperation` error if the value has already been read or there is no
    /// value to read; an `CBStreamError.invalidReaderState` error if the `CBTagReader` cannot
    /// recover from a previous parsing error.
    /// - Returns: The value boxed in the correct type.
    public func readValue() throws -> Any? {
        if _state == .atStreamEnd {
            throw CBStreamError.endOfStream
        }
        if !_atValue {
            if cacheTagValues {
                if _valueCache == nil {
                    throw CBStreamError.invalidOperation("No value to read.")
                } else {
                    return _valueCache
                }
            } else {
                throw CBStreamError.invalidOperation(noValueToReadError)
            }
        }

        _valueCache = nil
        _atValue = false
        var value: Any?
        switch tagType {
            case .byte:
                value = try _reader.readByte()
                break
            case .short:
                value = try _reader.readInt16()
                break
            case .int:
                value = try _reader.readInt32()
                break
            case .long:
                value = try _reader.readInt64()
                break
            case .float:
                value = try _reader.readFloat()
                break
            case .double:
                value = try _reader.readDouble()
                break
            case .byteArray:
                let byteArr = try _reader.readBytes(tagLength)
                if byteArr.count < tagLength {
                    throw CBStreamError.endOfStream
                }
                value = byteArr
                break
            case .intArray:
                var intArr: [Int32] = []
                for _ in 0..<tagLength {
                    try intArr.append(_reader.readInt32())
                }
                value = intArr
                break
            case .longArray:
                var longArr: [Int64] = []
                for _ in 0..<tagLength {
                    try longArr.append(_reader.readInt64())
                }
                value = longArr
                break
            case .string:
                value = try _reader.readString()
                break
            default:
                throw CBStreamError.invalidOperation(nonValueTagError)
        }

        _valueCache = cacheTagValues ? value : nil
        return value
    }

    /// If the current tag is a List, reads all elements of this list as an array.
    /// If any tags/values have already been read from this list, only reads
    /// the remaining unread tags/values. ListType must be a value type
    /// (byte, short, int, long, float, double, or string). Stops reading after
    /// the last list element.
    /// - Throws: An `CBStreamError.endOfStream` error if the end of the stream was reached;
    /// an `CBStreamError.invalidOperation` error if the current tag is not of type List; an
    /// `CBStreamError.invalidReaderState` error if `CBTagReader` cannot recover from
    /// a previous parsing error; an `CBStreamError.invalidFormat` error if an error occurred while
    /// parsing data in NBT foramt.
    /// - Returns: List contents converted to an array of the requested type.
    public func readListAsArray<T>() throws -> [T] {
        switch _state {
            case .atStreamEnd:
                throw CBStreamError.endOfStream
            case .error:
                throw CBStreamError.invalidReaderState(erroneousStateError)
            case .atListBeginning:
                goDown()
                listIndex = 0
                tagType = listType
                _state = .inList
                break
            case .inList:
                break
            default:
                throw CBStreamError.invalidOperation("ReadListAsArray may only be used on List tags.")
        }

        let elementsToRead = parentTagLength - listIndex

        // Special handling for reading byte arrays (as byte arrays)
        if listType == .byte && T.Type.self == UInt8.Type.self {
            tagsRead += elementsToRead
            listIndex = parentTagLength - 1
            let val = try _reader.readBytes(elementsToRead) as! [T]
            if val.count < elementsToRead {
                throw CBStreamError.endOfStream
            }
            return val
        }

        // For everything else, gotta read elements one-by-one
        var result: [T] = []
        switch listType {
            case .byte:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readByte()))
                }
                break
            case .short:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readInt16()))
                }
                break
            case .int:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readInt32()))
                }
                break
            case .long:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readInt64()))
                }
                break
            case .float:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readFloat()))
                }
                break
            case .double:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readDouble()))
                }
                break
            case .string:
                for _ in 0..<elementsToRead {
                    try result.append(convertValue(_reader.readString()))
                }
                break
            default:
                throw CBStreamError.invalidOperation("ReadListAsArray may only be used on lists of value types.")
        }

        tagsRead += elementsToRead
        listIndex = parentTagLength - 1
        return result
    }

    /// Returns a String that represents the current CBTagReader object.
    /// Prints current tag's depth, ordinal number, type, name, size
    /// (for arrays and lists), and optionally value.
    /// - Parameters:
    ///   - includeValue: If set to `nil`, also reads and prints the current tag's value.
    ///   - indentString: String to be used for indentation. May be empty string, but may not be `nil`.
    /// - Returns: <#description#>
    public func toString(includeValue: Bool, indentString: String) -> String {
        var string = ""
        for _ in 0..<depth {
            string.append(indentString)
        }
        string.append("#\(tagsRead). \(tagType)")
        if isList {
            string.append("<\(listType)>")
        }
        if hasLength {
            string.append("[\(tagLength)]")
        }
        string.append(" \(tagName ?? "")")
        if includeValue && (_atValue || hasValue && cacheTagValues) &&
            tagType != .intArray && tagType != .byteArray && tagType != .longArray {
            string.append(" = ")
            do {
                let val = try readValue()
                string.append(val != nil ? String(describing: val!) : "")
            } catch {

            }
        }
        return string
    }

    private func addToParent(child: NBT, parent: NBT) throws {
        if let parentAsList = parent as? ListTag {
            try parentAsList.append(child)
        }
        else if let parentAsCompound = parent as? CompoundTag {
            try parentAsCompound.append(child)
        }
        else {
            // Cannot happen unless NbtRead is bugged
            throw CBStreamError.invalidFormat(invalidParentTagError)
        }
    }

    // Swift doesn't have an easy way to convert values to another type.
    // Since we only care about the value types defined for NBT we can
    // safely assume checking only those types will suffice.
    private func convertValue<T>(_ value: Any) throws -> T {
        if T.Type.self == UInt8.Type.self {
            if value is UInt8 { return UInt8(value as! UInt8) as! T}
            else if value is Int16 { return UInt8(value as! Int16) as! T }
            else if value is Int32 { return UInt8(value as! Int32) as! T }
            else if value is Int64 { return UInt8(value as! Int64) as! T }
            else if value is Float { return UInt8(value as! Float) as! T }
            else if value is Double { return UInt8(value as! Double) as! T }
            else if value is String { return UInt8(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == Int16.Type.self {
            if value is UInt8 { return Int16(value as! UInt8) as! T}
            else if value is Int16 { return Int16(value as! Int16) as! T }
            else if value is Int32 { return Int16(value as! Int32) as! T }
            else if value is Int64 { return Int16(value as! Int64) as! T }
            else if value is Float { return Int16(value as! Float) as! T }
            else if value is Double { return Int16(value as! Double) as! T }
            else if value is String { return Int16(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == Int32.Type.self {
            if value is UInt8 { return Int32(value as! UInt8) as! T}
            else if value is Int16 { return Int32(value as! Int16) as! T }
            else if value is Int32 { return Int32(value as! Int32) as! T }
            else if value is Int64 { return Int32(value as! Int64) as! T }
            else if value is Float { return Int32(value as! Float) as! T }
            else if value is Double { return Int32(value as! Double) as! T }
            else if value is String { return Int32(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == Int64.Type.self {
            if value is UInt8 { return Int64(value as! UInt8) as! T}
            else if value is Int16 { return Int64(value as! Int16) as! T }
            else if value is Int32 { return Int64(value as! Int32) as! T }
            else if value is Int64 { return Int64(value as! Int64) as! T }
            else if value is Float { return Int64(value as! Float) as! T }
            else if value is Double { return Int64(value as! Double) as! T }
            else if value is String { return Int64(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == Float.Type.self {
            if value is UInt8 { return Float(value as! UInt8) as! T}
            else if value is Int16 { return Float(value as! Int16) as! T }
            else if value is Int32 { return Float(value as! Int32) as! T }
            else if value is Int64 { return Float(value as! Int64) as! T }
            else if value is Float { return Float(value as! Float) as! T }
            else if value is Double { return Float(value as! Double) as! T }
            else if value is String { return Float(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == Double.Type.self {
            if value is UInt8 { return Double(value as! UInt8) as! T}
            else if value is Int16 { return Double(value as! Int16) as! T }
            else if value is Int32 { return Double(value as! Int32) as! T }
            else if value is Int64 { return Double(value as! Int64) as! T }
            else if value is Float { return Double(value as! Float) as! T }
            else if value is Double { return Double(value as! Double) as! T }
            else if value is String { return Double(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else if T.Type.self == String.Type.self {
            if value is UInt8 { return String(value as! UInt8) as! T}
            else if value is Int16 { return String(value as! Int16) as! T }
            else if value is Int32 { return String(value as! Int32) as! T }
            else if value is Int64 { return String(value as! Int64) as! T }
            else if value is Float { return String(value as! Float) as! T }
            else if value is Double { return String(value as! Double) as! T }
            else if value is String { return String(value as! String) as! T }
            else {
                throw CBStreamError.invalidFormat("Cannot convert from type: \(type(of: value))")
            }
        }
        else {
            throw CBStreamError.invalidFormat("Cannot convert to type: \(type(of: value))")
        }
    }

    /// Goes one step down the NBT file's hierarchy, preserving the current state
    private func goDown() {
        let newNode = CBTagReaderNode(
            parentName: parentName,
            parentTagType: parentTagType,
            parentTagLength: parentTagLength,
            listType: listType,
            listIndex: listIndex
        )
        _nodes.append(newNode)

        parentName = tagName
        parentTagType = tagType
        parentTagLength = tagLength
        listIndex = 0
        tagLength = 0

        depth += 1
    }

    /// Goes one step up the NBT file's hierarchy, restoring the previous state
    private func goUp() {
        let oldNode = _nodes.popLast()!

        parentName = oldNode.parentName
        parentTagType = oldNode.parentTagType
        parentTagLength = oldNode.parentTagLength
        listIndex = oldNode.listIndex
        listType = oldNode.listType
        tagLength = 0

        depth -= 1
    }

    private func readValueAsTag() throws -> NBT {
        if !_atValue {
            // Should never happen
            throw CBStreamError.invalidOperation(noValueToReadError)
        }

        _atValue = false
        switch tagType {
            case .byte:
                return try ByteTag(name: tagName, _reader.readByte())
            case .short:
                return try ShortTag(name: tagName, _reader.readInt16())
            case .int:
                return try IntTag(name: tagName, _reader.readInt32())
            case .long:
                return try LongTag(name: tagName, _reader.readInt64())
            case .float:
                return try FloatTag(name: tagName, _reader.readFloat())
            case .double:
                return try DoubleTag(name: tagName, _reader.readDouble())
            case .string:
                return try StringTag(name: tagName, _reader.readString())
            case .byteArray:
                let bytes = try _reader.readBytes(tagLength)
                if bytes.count < tagLength {
                    throw CBStreamError.endOfStream
                }
                return ByteArrayTag(name: tagName, bytes)
            case .intArray:
                var ints: [Int32] = []
                for _ in 0..<tagLength {
                    try ints.append(_reader.readInt32())
                }
                return IntArrayTag(name: tagName, ints)
            case .longArray:
                var longs: [Int64] = []
                for _ in 0..<tagLength {
                    try longs.append(_reader.readInt64())
                }
                return LongArrayTag(name: tagName, longs)
            default:
                throw CBStreamError.invalidOperation(nonValueTagError)
        }
    }

    private func readTagHeader(_ readName: Bool) throws {
        tagsRead += 1
        tagName = readName ? try _reader.readString() : nil
        tagLength = 0
        listType = .unknown

        switch tagType {
            case .byte,
                    .short,
                    .int,
                    .long,
                    .float,
                    .double,
                    .string:
                _atValue = true
                break
            case .intArray,
                    .byteArray,
                    .longArray:
                tagLength = Int(try _reader.readInt32())
                _atValue = true
                break
            case .list:
                // Setting state to error in case reader throws
                _state = .error
                listType = try _reader.readTagType()
                tagLength = Int(try _reader.readInt32())
                if tagLength < 0 {
                    throw CBStreamError.invalidFormat("Negative tag length given: \(tagLength)")
                }
                _state = .atListBeginning
                break
            case .compound:
                _state = .atCompoundBeginning
                break
            default:
                _state = .error
                throw CBStreamError.invalidFormat("Trying to read tag of unknown type.")
        }
    }

    private func skipValue() throws {
        // Make sure to check for "atValue" before calling this method
        switch tagType {
            case .byte:
                try _reader.skip(MemoryLayout<UInt8>.size)
                break
            case .short:
                try _reader.skip(MemoryLayout<Int16>.size)
                break
            case .float,
                    .int:
                try _reader.skip(MemoryLayout<Int32>.size)
                break
            case .double,
                    .long:
                try _reader.skip(MemoryLayout<Int64>.size)
                break
            case .byteArray:
                try _reader.skip(tagLength)
                break
            case .intArray:
                try _reader.skip(MemoryLayout<Int32>.size * tagLength)
                break
            case .longArray:
                try _reader.skip(MemoryLayout<Int64>.size * tagLength)
                break
            case .string:
                try _reader.skipString()
                break
            default:
                throw CBStreamError.invalidOperation(nonValueTagError)
        }

        _atValue = false
        _valueCache = nil
    }
}

extension CBTagReader {
    static let wordBitSize = 32

    var unreadCount: Int {
        return _reader.unreadCount
    }

    func readUInt8() throws -> UInt8 {
        return try _reader.readByte()
    }

    func readUInt32() throws -> UInt32 {
        return try _reader.readUInt32()
    }

//    func readWords(bitsPerBlock: Int) throws -> [UInt16]? {
//        let blocksPerWord = Self.wordBitSize / bitsPerBlock
//        let totalWords = Int(ceil(   Double(MCSubChunk.totalBlockCount) / Double(blocksPerWord)   ))
//        let totalBytes = totalWords * 4
//        guard _reader.unreadCount >= totalBytes else {
//            return nil
//        }
//
//        let mask: UInt32 = ~(UInt32(0xFFFF) << bitsPerBlock)
//        var elements = [UInt16]()
//
//        for _ in 0 ..< totalWords {
//            let word = try _reader.readUInt32()
//            for i in 0 ..< blocksPerWord {
//                guard elements.count < MCSubChunk.totalBlockCount else { break }
//                let element: UInt32 = mask & (word >> (i * bitsPerBlock))
//                elements.append(UInt16(truncatingIfNeeded: element))
//            }
//        }
//
//        return elements.count == MCSubChunk.totalBlockCount ? elements : nil
//    }
}
