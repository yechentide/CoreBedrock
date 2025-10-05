//
// Created by yechentide on 2024/06/02
//

import Foundation

// swiftlint:disable line_length

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
    public convenience init(_ tags: [NBT]) throws {
        try self.init(name: nil, tags, listType: .unknown)
    }

    /// Creates an unnamed `ListTag` with empty contents and an explicitly specified list type.
    /// - Parameter listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    public convenience init(listType: TagType) throws {
        try self.init(name: nil, listType: listType)
    }

    /// Creates an `ListTag` with the given name and contents, and an inferred list type.
    /// - Parameters:
    ///   - tagNanameme: The name to assign to this tag. May be `nil`.
    ///   - tags: Collection of tags to insert into the list. All tags are expected to be of the same type.
    public convenience init(name: String?, _ tags: [NBT]) throws {
        try self.init(name: name, tags, listType: .unknown)
    }

    /// Creates an unnamed `ListTag` with the given contents, and an explicitly specified list type.
    /// - Parameters:
    ///   - tags: Collection of tags to insert into the list. All tags are expected to be of the same type (matching `listType`).
    ///   - listType: The `TagType` to assign to this list. May be `.unknown` (to infer type from the first element of tags).
    public convenience init(_ tags: [NBT], listType: TagType) throws {
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
            try self.append(tag)
        }
    }

    /// Creates a deep copy of the given `ListTag`.
    /// - Parameter other: The existing `ListTag` to copy.
    public init(_ other: ListTag) throws {
        super.init()
        self._name = other._name
        self._listType = other._listType
        for tag in other._tags {
            try self.append(tag.clone())
        }
    }

    // Override to return the .list type
    override public var tagType: TagType {
        .list
    }

    private var _listType: TagType = .unknown
    /// Gets or sets the tag type of this list. All tags in this NBT must be of the same type.
    public var listType: TagType { self._listType }

    // Use a function instead of a setter until Swift allows throwing in properties
    public func setListType(_ newType: TagType) throws {
        if newType == .end {
            // Empty lists may have type "End"
            if !self._tags.isEmpty {
                throw CBStreamError.argumentError("Only empty list tags may have TagType of End.")
            }
        } else if newType < TagType.byte || (newType > TagType.longArray && newType != TagType.unknown) {
            throw CBStreamError.argumentOutOfRange("newType", "value is out of the range of acceptable tag types.")
        }

        if !self._tags.isEmpty {
            let actualType = self._tags[0].tagType
            // We can safely assume that ALL tags have the same TagType as the first tag.
            if actualType != newType {
                throw CBStreamError.argumentError("Given TagType (\(newType)) does not match actual element type (\(actualType)).")
            }
        }
        self._listType = newType
    }

    /// Gets the number of tags contained in the `ListTag`.
    public var count: Int {
        self._tags.count
    }

    /// Gets or sets a collection containing all tags in this `ListTag`.
    public var tags: [NBT] {
        get {
            self._tags
        }
        set {
            self._tags = newValue
        }
    }

    /// Gets or sets the tag at the specified index..
    override public subscript(_ index: Int) -> NBT {
        get { self._tags[index] }
        set {
            precondition(newValue.parent == nil, "A tag may only be added to one compound/list at a time.")
            precondition(newValue !== self || newValue !== parent!, "A list tag may not be added to itself or to its child tag.")
            precondition(newValue.name == nil, "Named tag given. A list only can contain unnamed tags.")
            precondition(newValue.tagType == self._listType || self._listType == .unknown, "Items must be of type \(self._listType)")

            self._tags[index] = newValue
            newValue.parent = self
        }
    }

    /// Adds a tag to the end of this `ListTag`.
    /// - Parameter newTag: The tag to be added to this list.
    /// - Throws: An `CBError.argumentError` if `newTag` is already in another list, is the same as this tag or does not match the tag type of this list.
    public func append(_ newTag: NBT) throws {
        try self.insert(newTag, at: self._tags.endIndex)
    }

    /// Adds all tags from the specified collection to the end of this `ListTag`.
    /// - Parameter newTags: The collection whose elements should be added to this `ListTag`.
    public func append(contentsOf newTags: [NBT]) throws {
        for tag in newTags {
            try self.append(tag)
        }
    }

    /// Determines whether this `ListTag` contains the specified tag.
    /// - Parameter tag: The tag to locate in the list.
    /// - Returns: `true` if the given tag is found in the list; otherwise `false`.
    public func contains(_ tag: NBT) -> Bool {
        self._tags.contains { $0 === tag }
    }

    /// Gets the tag at the given index.
    /// - Parameter index: The zero-based index of the tag to get.
    /// - Throws: An `CBError.argumentOutOfRange` error if `index` is not a valid index in this list.
    /// - Returns: The tag at the given index.
    public func get(at index: Int) throws -> NBT {
        if index < 0 || index >= self._tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        return self._tags[index]
    }

    /// Returns the first index where the specified value appears in the collection.
    /// - Parameter tag: An `NBT` to search for in the collection.
    /// - Returns: The first index where `tag` is found. If `tag` is not
    ///   found in the collection, returns `nil`.
    public func firstIndex(of tag: NBT) -> Int? {
        self._tags.firstIndex(of: tag)
    }

    /// Returns the last index where the specified value appears in the
    /// collection.
    /// - Parameter tag: An `NBT` to search for in the collection.
    /// - Returns: The last index where `tag` is found. If `tag` is not
    ///   found in the collection, returns `nil`.
    public func lastIndex(of tag: NBT) -> Int? {
        self._tags.lastIndex(of: tag)
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
        if self.listType != .unknown && newTag.tagType != self.listType {
            throw CBStreamError.argumentError("Items in this list must be of type \(self.listType). Given type: \(newTag.tagType).", "newTag")
        }
        if index < 0 || index > self._tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        self._tags.insert(newTag, at: index)
        if self.listType == .unknown {
            self._listType = newTag.tagType
        }
        newTag.parent = self
    }

    /// Removes the first occurrence of a specific `NBT` from the `ListTag`.
    /// - Parameter tag: The tag to remove from this `ListTag`.
    /// - Returns: `true` if tag was successfully removed from this `ListTag`; otherwise, `false`.
    public func remove(_ tag: NBT) -> Bool {
        let index = self._tags.firstIndex(of: tag)
        if index != nil {
            self._tags.remove(at: index!)
            tag.parent = nil
            return true
        }
        return false
    }

    /// Removes a tag at the specified index from this `ListTag`.
    /// - Parameter index: The zero-based index of the item to remove.
    /// - Throws: An `CBError.argumentOutOfRange` error if `index` is not a valid index in the `ListTag`.
    public func remove(at index: Int) throws -> NBT {
        if index < 0 || index >= self._tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the list.")
        }
        let tag = self._tags.remove(at: index)
        tag.parent = nil
        return tag
    }

    /// Removes all the tags from this `ListTag`.
    public func removeAll() {
        for tag in self._tags {
            tag.parent = nil
        }
        self._tags.removeAll()
    }

    override public func clone() throws -> NBT {
        try ListTag(self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_List")
        if name != nil, !name!.isEmpty {
            formattedStr.append("(\"\(name!)\")")
        }
        formattedStr.append(": \(self._tags.count) entries {")

        if !self._tags.isEmpty {
            formattedStr.append("\n")
            for tag in self._tags {
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
        self._tags.makeIterator()
    }
}

extension ListTag: Collection {
    public var startIndex: Int {
        self._tags.startIndex
    }

    public var endIndex: Int {
        self._tags.endIndex
    }

    public func index(after i: Int) -> Int {
        self._tags.index(after: i)
    }
}

// swiftlint:enable line_length
