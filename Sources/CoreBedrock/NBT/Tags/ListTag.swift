//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a collection of unnamed `NBT` objects, all of the same type.
public final class ListTag: NBT {
    // The backing store for the collection of tags
    private var _tags: [NBT] = []

    /// Creates an unnamed `ListTag` with empty contents and undefined list type.
    override public init() {
        super.init()
    }

    /// Creates an `ListTag` with given name, empty contents, and undefined list type.
    /// - Parameter name: The name to assign to this tag. May be `nil`.
    public init(name: String?) {
        super.init()
        self.name = name
    }

    /// Creates an unnamed `ListTag` with the given contents, and inferred list type.
    /// - Parameter tags: Collection of tags to insert into the list. All tags are expected to be of the same type.
    convenience public init(_ tags: [NBT]) throws {
        try self.init(name: nil, tags, listType: .unknown)
    }

    /// Creates an unnamed `ListTag` with empty contents and an explicitly specified list type.
    /// - Parameter listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    convenience public init(listType: TagType) throws {
        try self.init(name: nil, listType: listType)
    }

    /// Creates an `ListTag` with the given name and contents, and an inferred list type.
    /// - Parameters:
    ///   - tagNanameme: The name to assign to this tag. May be `nil`.
    ///   - tags: Collection of tags to insert into the list. All tags are expected to be of the same type.
    convenience public init(name: String?, _ tags: [NBT]) throws {
        try self.init(name: name, tags, listType: .unknown)
    }

    /// Creates an unnamed `ListTag` with the given contents, and an explicitly specified list type.
    /// - Parameters:
    ///   - tags: Collection of tags to insert into the list. All tags are expected to be of the same type (matching `listType`).
    ///   - listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    convenience public init(_ tags: [NBT], listType: TagType) throws {
        try self.init(name: nil, tags, listType: listType)
    }

    /// Creates an `ListTag` with the given name, empty contents, and an explicitly specified list type.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    public init(name: String?, listType: TagType) throws {
        super.init()
        self.name = name
        try self.setListType(listType)
    }

    /// Creates an `ListTag` with the given name and contents, and an explicitly specified list type.
    /// - Parameters:
    ///   - name: The name to assign to this tag. May be `nil`.
    ///   - tags: Collection of tags to insert into the list. All tags are expected to be of the same type (matching `listType`).
    ///   - listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    public init(name: String?, _ tags: [NBT], listType: TagType) throws {
        super.init()
        self.name = name
        try self.setListType(listType)

        for tag in tags {
            try append(tag)
        }
    }

    /// Creates a deep copy of the given `ListTag`.
    /// - Parameter other: The existing `ListTag` to copy.
    public init(_ other: ListTag) throws {
        super.init()
        self._name = other._name
        self._listType = other._listType
        for tag in _tags {
            try _tags.append(tag.clone())
        }
    }

    // Override to return the .list type
    override public var tagType: TagType {
        return .list
    }

    private var _listType: TagType = .unknown
    /// Gets or sets the tag type of this list. All tags in this NBT must be of the same type.
    public var listType: TagType {
        get { return _listType }
    }
    // Use a function instead of a setter until Swift allows throwing in properties
    public func setListType(_ newType: TagType) throws {
        if newType == .end {
            // Empty lists may have type "End"
            if _tags.count > 0 {
                throw CBStreamError.argumentError("Only empty list tags may have TagType of End.")
            }
        } else if newType < TagType.byte || (newType > TagType.longArray && newType != TagType.unknown) {
            throw CBStreamError.argumentOutOfRange("newType", "value is out of the range of acceptable tag types.")
        }

        if _tags.count > 0 {
            let actualType = _tags[0].tagType
            // We can safely assume that ALL tags have the same TagType as the first tag.
            if actualType != newType {
                throw CBStreamError.argumentError("Given TagType (\(newType)) does not match actual element type (\(actualType)).")
            }
        }
        _listType = newType
    }

    /// Gets the number of tags contained in the `ListTag`.
    public var count: Int {
        return _tags.count
    }

    /// Gets or sets a collection containing all tags in this `ListTag`.
    public var tags: [NBT] {
        get {
            return _tags
        }
        set {
            _tags = newValue
        }
    }

    /// Gets or sets the tag at the specified index..
    public override subscript(_ index: Int) -> NBT {
        get { return _tags[index] }
        set {
            precondition(newValue.parent == nil, "A tag may only be added to one compound/list at a time.")
            precondition(newValue !== self || newValue !== parent!, "A list tag may not be added to itself or to its child tag.")
            precondition(newValue.name == nil, "Named tag given. A list only can contain unnamed tags.")
            precondition(newValue.tagType == _listType || _listType == .unknown, "Items must be of type \(_listType)")

            _tags[index] = newValue
            newValue.parent = self
        }
    }

    /// Adds a tag to the end of this `ListTag`.
    /// - Parameter newTag: The tag to be added to this list.
    /// - Throws: An `CBError.argumentError` if `newTag` is already in another list, is the same as this tag or does not match the tag type of this list.
    public func append(_ newTag: NBT) throws {
        try insert(newTag, at: _tags.endIndex)
    }

    /// Adds all tags from the specified collection to the end of this `ListTag`.
    /// - Parameter newTags: The collection whose elements should be added to this `ListTag`.
    public func append(contentsOf newTags: [NBT]) throws {
        for tag in newTags {
            try append(tag)
        }
    }

    /// Determines whether this `ListTag` contains the specified tag.
    /// - Parameter tag: The tag to locate in the list.
    /// - Returns: `true` if the given tag is found in the list; otherwise `false`.
    public func contains(_ tag: NBT) -> Bool {
        return _tags.contains { $0 === tag }
    }

    /// Gets the tag at the given index.
    /// - Parameter index: The zero-based index of the tag to get.
    /// - Throws: An `CBError.argumentOutOfRange` error if `index` is not a valid index in this list.
    /// - Returns: The tag at the given index.
    public func get(at index: Int) throws -> NBT {
        if index < 0 || index >= _tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        return _tags[index]
    }

    /// Returns the first index where the specified value appears in the collection.
    /// - Parameter tag: An `NBT` to search for in the collection.
    /// - Returns: The first index where `tag` is found. If `tag` is not
    ///   found in the collection, returns `nil`.
    public func firstIndex(of tag: NBT) -> Int? {
        return _tags.firstIndex(of: tag)
    }

    /// Returns the last index where the specified value appears in the
    /// collection.
    /// - Parameter tag: An `NBT` to search for in the collection.
    /// - Returns: The last index where `tag` is found. If `tag` is not
    ///   found in the collection, returns `nil`.
    public func lastIndex(of tag: NBT) -> Int? {
        return _tags.lastIndex(of: tag)
    }

    /// Inserts an item to this `ListTag` at the specified index.
    /// - Parameters:
    ///   - newTag: The tag to insert into this `ListTag`.
    ///   - index: The zero-based index at which newTag should be inserted.
    /// - Throws: An `CBError.argumentError` if `newTag` is already in another list, is the same as this tag or does not match the tag type of this list; an `CBError.argumentOutOfRange` error if the given `index` is not a valid index in this `ListTag`.
    public func insert(_ newTag: NBT, at index: Int) throws {
        if newTag.parent != nil {
            throw CBStreamError.argumentError("A tag may only be added to one compound/list at a time.")
        }
        if newTag === self || newTag === self.parent {
            throw CBStreamError.argumentError("A list may not be added to itself or to its child tag.")
        }
        if newTag.name != nil {
            throw CBStreamError.argumentError("Named tag given. A list may only contain unnamed tags.")
        }
        if listType != .unknown && newTag.tagType != listType {
            throw CBStreamError.argumentError("Items in this list must be of type \(listType). Given type: \(newTag.tagType).", "newTag")
        }
        if index < 0 || index > _tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        _tags.insert(newTag, at: index)
        if listType == .unknown {
            _listType = newTag.tagType
        }
        newTag.parent = self
    }

    /// Removes the first occurrence of a specific `NBT` from the `ListTag`.
    /// - Parameter tag: The tag to remove from this `ListTag`.
    /// - Returns: `true` if tag was successfully removed from this `ListTag`; otherwise, `false`.
    public func remove(_ tag: NBT) -> Bool {
        let index = _tags.firstIndex(of: tag)
        if index != nil {
            _tags.remove(at: index!)
            tag.parent = nil
            return true
        }
        return false
    }

    /// Removes a tag at the specified index from this `ListTag`.
    /// - Parameter index: The zero-based index of the item to remove.
    /// - Throws: An `CBError.argumentOutOfRange` error if `index` is not a valid index in the `ListTag`.
    public func remove(at index: Int) throws -> NBT {
        if index < 0 || index >= _tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        let tag = _tags.remove(at: index)
        tag.parent = nil
        return tag
    }

    /// Removes all the tags from this `ListTag`.
    public func removeAll() {
        for tag in _tags {
            tag.parent = nil
        }
        _tags.removeAll()
    }

    override func readTag(_ readStream: CBBinaryReader, _ skip: (NBT) -> Bool) throws -> Bool {
        // Check if the tag needs to be skipped
        if skip(self) {
            try skipTag(readStream)
            return false
        }

        try setListType(readStream.readTagType())

        let length = try readStream.readInt32()
        guard length >= 0 else { throw CBStreamError.invalidFormat("Negative list size given.") }

        for _ in 0..<length {
            var newTag: NBT
            switch listType {
                case .byte:
                    newTag = ByteTag()
                    break
                case .short:
                    newTag = ShortTag()
                    break
                case .int:
                    newTag = IntTag()
                    break
                case .long:
                    newTag = LongTag()
                    break
                case .float:
                    newTag = FloatTag()
                    break
                case .double:
                    newTag = DoubleTag()
                    break
                case .byteArray:
                    newTag = ByteArrayTag()
                    break
                case .string:
                    newTag = StringTag()
                    break
                case .list:
                    newTag = ListTag()
                    break
                case .compound:
                    newTag = CompoundTag()
                    break
                case .intArray:
                    newTag = IntArrayTag()
                    break
                case .longArray:
                    newTag = LongArrayTag()
                    break
                default:
                    // Should never happen since ListType is checked beforehand
                    throw CBStreamError.invalidFormat("Unsupported tag type found in NBT_List: \(listType)")
            }
            newTag.parent = self
            if try newTag.readTag(readStream, skip) {
                _tags.append(newTag)
            }
        }
        return true
    }

    override func skipTag(_ readStream: CBBinaryReader) throws {
        // Read list type to make sure it's defined
        try setListType(readStream.readTagType())

        let length = Int(try readStream.readInt32())
        if length < 0 {
            throw CBStreamError.invalidFormat("Negative list size given.")
        }

        switch listType {
            case .byte:
                try readStream.skip(length)
                break
            case .short:
                try readStream.skip(length * MemoryLayout<Int16>.size)
                break
            case .int:
                try readStream.skip(length * MemoryLayout<Int32>.size)
                break
            case .long:
                try readStream.skip(length * MemoryLayout<Int64>.size)
                break
            case .float:
                try readStream.skip(length * MemoryLayout<Float>.size)
                break
            case .double:
                try readStream.skip(length * MemoryLayout<Double>.size)
                break
            default:
                for _ in 0..<length {
                    switch listType {
                        case .byteArray:
                            try ByteArrayTag().skipTag(readStream)
                            break
                        case .string:
                            try readStream.skipString()
                            break
                        case .list:
                            try ListTag().skipTag(readStream)
                            break
                        case .compound:
                            try CompoundTag().skipTag(readStream)
                            break
                        case .intArray:
                            try IntArrayTag().skipTag(readStream)
                            break
                        case .longArray:
                            try LongArrayTag().skipTag(readStream)
                            break
                        default:
                            break
                    }
                }
                break
        }
    }

    override func writeTag(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(TagType.list)
        guard let name = name else { throw CBStreamError.invalidFormat("Name is nil") }
        try writeStream.write(name)
        try writeData(writeStream)
    }

    override func writeData(_ writeStream: CBBinaryWriter) throws {
        guard listType != .unknown else { throw CBStreamError.invalidFormat("ListTag had no elements and an Unknown ListType.") }
        try writeStream.write(listType)
        // write as Int32
        try writeStream.write(Int32(_tags.count))
        for tag in _tags {
            try tag.writeData(writeStream)
        }
    }

    override public func clone() throws -> NBT {
        return try ListTag(self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_List")
        if name != nil && name!.count > 0 {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": \(_tags.count) entries {")

        if _tags.count > 0 {
            formattedStr.append("\n")
            for tag in _tags {
                formattedStr.append(tag.toString(indentString: indentString, indentLevel: indentLevel + 1))
                formattedStr.append("\n")
            }
            for _ in 0..<indentLevel {
                formattedStr.append(indentString)
            }
        }
        formattedStr.append("}")

        return formattedStr
    }
}

extension ListTag: Sequence {
    public func makeIterator() -> Array<NBT>.Iterator {
        return _tags.makeIterator()
    }
}

extension ListTag: Collection {
    public var startIndex: Int {
        return _tags.startIndex
    }

    public var endIndex: Int {
        return _tags.endIndex
    }

    public func index(after i: Int) -> Int {
        return _tags.index(after: i)
    }
}

