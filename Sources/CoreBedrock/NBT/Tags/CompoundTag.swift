//
// Created by yechentide on 2024/06/02
//

import Foundation

// swiftlint:disable line_length force_cast

/// Represents a collection of named `NBT` objects.
public final class CompoundTag: NBT {
    // We want CompoundTag to emulate an Ordered Dictionary
    // so keys and values are stored in separate collections.

    // Use a dictionary for the keys to track the indexes in the _tags array
    private var _keys: [String: Int] = [:]
    // The backing store for the collection of tags
    private var _tags: [NBT] = []

    /// Creates an empty, unnamed `CompoundTag` tag.
    override public init() {
        super.init()
    }

    /// Creates  an empty `CompoundTag` tag with the given name.
    /// - Parameter name: Name to assign to this tag. May be `nil`.
    public init(name: String?) {
        super.init()
        self.name = name
    }

    /// Creates an unnamed `CompoundTag` tag, containing the specified tags.
    /// - Parameter tags: Collection of tags to include.
    /// - Throws: An `CBError.argumentError` if some of the tags were not named or
    /// two tags with teh same name were given.
    public convenience init(_ tags: [NBT]) throws {
        try self.init(name: nil, tags)
    }

    /// Creates a named `CompoundTag` tag, containing the specified tags.
    /// - Parameters:
    ///   - name: Name to assign to this tag. May be `nil`.
    ///   - tags: Collection of tags to include.
    /// - Throws: An `CBError.argumentError` if some of the tags were not named or
    ///  two tags with teh same name were given.
    public init(name: String?, _ tags: [NBT]) throws {
        super.init()
        self.name = name
        for tag in tags {
            try self.append(tag)
        }
    }

    /// Creates a deep copy of given `CompoundTag`.
    /// - Parameter other: An existing CompoundTag to copy.
    /// - Throws: An `CBError.argumentError` if some of the tags were not named or
    /// two tags with teh same name were given.
    public init(from other: CompoundTag) throws {
        super.init()
        _name = other.name
        // Copy tags
        for tag in other._tags {
            try self.append(tag.clone())
        }
    }

    // Override to return the .compound type
    override public var tagType: TagType {
        .compound
    }

    /// Gets a collection containing all tag names in this `CompoundTag`.
    public var names: [String] {
        Array(self._keys.keys)
    }

    /// Gets or sets a collection containing all tags in this `CompoundTag`.
    public var tags: [NBT] {
        get {
            self._tags
        }
        set {
            self._tags = newValue
        }
    }

    /// Gets the number of tags contained in the `CompoundTag`.
    public var count: Int {
        self._tags.count
    }

    /// Gets or sets the tag with the specified name. May return `nil`.
    override public subscript(_ tagName: String) -> NBT? {
        get {
            guard let index = _keys[tagName] else { return nil }

            return self._tags[index]
        }
        set {
            if newValue == nil {
                _ = self.remove(forKey: tagName)
                return
            }
            precondition(newValue!.name == tagName, "Given tag name must match the tag's actual name.")
            precondition(newValue!.parent == nil, "A tag may only be added to one compound/list at a time.")
            precondition(newValue !== self || newValue !== parent!, "A compound tag may not be added to itself or to its child tag.")

            // This subscript CAN be used to "append" to the collection.
            if let index = _keys[tagName] {
                // Replace (and orphan) the existing tag
                let oldTag = self._tags[index]
                oldTag.parent = nil
                self._tags[index] = newValue!
                newValue!.parent = self
                // Update _keys
                self._keys.removeValue(forKey: oldTag.name!)
                self._keys[newValue!.name!] = index
            } else {
                // Append to collection
                self._tags.append(newValue!)
                self._keys[tagName] = self._tags.endIndex - 1
            }
        }
    }

    /// Inserts an item to this `CompoundTag` at the specified index.
    /// - Parameters:
    ///   - newTag: The tag to insert into this `Compound`.
    ///   - index: The zero-based index at which newTag should be inserted.
    /// - Throws: An `CBError.argumentError` if `newTag` already has a parent tag, is the same as this tag or has a name used in this Compound tag; an `CBError.argumentOutOfRange` error if the given `index` is not a valid index in this `CompoundTag`.
    public func insert(_ newTag: NBT, at index: Int) throws {
        if newTag as? Self === self {
            throw CBStreamError.argumentError("Cannot add tag to itself")
        }
        if newTag.parent != nil {
            throw CBStreamError.argumentError("A tag may only be added to one compound/list at a time.")
        }
        if newTag.name == nil {
            throw CBStreamError.argumentError("Only named tags are allowed in Compound tags.")
        }
        if self.contains(newTag.name!) {
            throw CBStreamError.argumentError("A tag with the same name has already been added.")
        }
        if index < 0 || index > self._tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the Compound tag.")
        }

        self._tags.insert(newTag, at: index)
        newTag.parent = self
        self._keys.removeAll()
        for (index, tag) in self._tags.enumerated() {
            self._keys[tag.name!] = index
        }
    }

    /// Adds a tag to the end of this `CompoundTag`.
    /// - Parameter newTag: The object to add to this CompoundTag.
    /// - Throws: An `CBError.argumentError`  if the given tag is unnamed or
    /// if a tag with the given name already exists in this `CompoundTag`.
    public func append(_ newTag: NBT) throws {
        if newTag as? Self === self {
            throw CBStreamError.argumentError("Cannot add tag to itself")
        }
        if newTag.parent != nil {
            throw CBStreamError.argumentError("A tag may only be added to one compound/list at a time.")
        }
        if newTag.name == nil {
            throw CBStreamError.argumentError("Only named tags are allowed in Compound tags.")
        }
        if self.contains(newTag.name!) {
            throw CBStreamError.argumentError("A tag with the same name has already been added.")
        }

        self._tags.append(newTag)
        newTag.parent = self

        let index = self._tags.endIndex - 1
        self._keys[newTag.name!] = index
    }

    /// Adds all tags from the specified collection to this `CompoundTag`.
    /// - Parameter newTags: The collection whose elements should be added to this `CompoundTag`.
    /// - Throws: An `CBError.argumentError`  if the given tag is unnamed or
    /// if a tag with the given name already exists in this `CompoundTag`.
    public func append(contentsOf newTags: [NBT]) throws {
        for tag in newTags {
            try self.append(tag)
        }
    }

    /// Determines whether this `CompoundTag` contains a specific `NBT`.
    /// Looks for exact object matches, not name matches.
    /// - Parameter tag: The object to locate in this `CompoundTag`.
    /// - Returns: `true` if tag is found; otherwise, `false`.
    /// - Throws: An `CBError.argumentError` if the given tag is unnamed.
    public func contains(_ tag: NBT) throws -> Bool {
        if tag.name == nil {
            throw CBStreamError.argumentError("Only named tags are allowed in Compound tags.")
        }
        if let index = _keys[tag.name!] {
            return tag === self._tags[index]
        }
        return false
    }

    /// Determines whether this `CompoundTag` contains a tag with a specific name.
    /// - Parameter tagName: Tag name to search for.
    /// - Returns: `true` if a tag with given name was found; otherwise, `false`.
    public func contains(_ tagName: String) -> Bool {
        self._keys.keys.contains(tagName)
    }

    /// Gets the tag with the given name. May return `nil`.
    /// - Parameter tagName: The name of the tag to get.
    /// - Returns: The tag with the specified key. `nil` if no tag with the given name was not found.
    public func get(_ tagName: String) -> NBT? {
        guard let index = _keys[tagName] else { return nil }

        return self._tags[index]
    }

    /// Gets the tag with the given name cast to the specified type.
    /// - Parameters:
    ///   - tagName: The name of the tag to get.
    ///   - result: When this method returns, contains the tag associated with the specified name
    ///   if the tag is found AND matches the specified type; otherwise, `nil`.
    /// - Returns: `true` if a tag with the specified name was found, regardless of type; otherwise, `false`.
    public func get<T>(_ tagName: String, result: inout T?) -> Bool where T: NBT {
        guard let index = _keys[tagName] else {
            result = nil
            return false
        }

        let tag = self._tags[index]
        if tag is T {
            result = (tag as! T)
        } else {
            // Force nil if the type doesn't match
            result = nil
        }
        return true // because *A* tag was found
    }

    /// Removes the first occurrence of a specific `NBT` from the CompoundTag.
    /// Looks for exact object matches, not name matches.
    /// - Parameter tag: The tag to remove from the CompoundTag.
    /// - Returns: `true` if tag was successfully removed from the CompoundTag;
    /// otherwise, `false`. This method also returns `false` if tag is not found.
    public func remove(_ tag: NBT) throws -> Bool {
        // Validate
        guard tag.name != nil else { throw CBStreamError.argumentError("Trying to remove an unnamed tag.") }

        // Look for name in _keys
        guard let index = _keys[tag.name!] else { return false }

        // Compare instances
        guard self._tags[index] === tag else { return false }

        self._tags.remove(at: index)
        tag.parent = nil

        self._keys.removeAll()
        for (index, tag) in self._tags.enumerated() {
            self._keys[tag.name!] = index
        }

        return true
    }

    /// Removes the tag with the specified name from this CompoundTag.
    /// - Parameter tagName: The name of the tag to remove.
    /// - Returns: `true` if the tag is successfully found and removed; otherwise, `false`.
    /// This method returns `false` if name is not found in the `CompoundTag`.
    public func remove(forKey tagName: String) -> Bool {
        guard let index = _keys[tagName] else { return false }

        let tag = self._tags.remove(at: index)
        tag.parent = nil

        self._keys.removeAll()
        for (index, tag) in self._tags.enumerated() {
            self._keys[tag.name!] = index
        }

        return true
    }

    /// Removes all tags from this CompoundTag
    public func removeAll() {
        for tag in self._tags {
            tag.parent = nil
        }
        self._tags.removeAll()
        self._keys.removeAll()
    }

    func renameTag(oldName: String, newName: String) throws {
        guard oldName != newName else { return }
        guard !self._keys.keys.contains(newName) else { throw CBStreamError.argumentError("Cannot rename: a tag with the same name already exists in this compound.") }
        guard let index = _keys[oldName] else { throw CBStreamError.argumentError("Cannot rename: no tag found to rename.") }

        let tag = self._tags[index]
        // Rename tag
        tag._name = newName
        // Update _keys
        self._keys.removeValue(forKey: oldName)
        self._keys[newName] = index
    }

    override public func clone() throws -> NBT {
        try CompoundTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Compound")
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

extension CompoundTag: Sequence {
    public func makeIterator() -> Array<NBT>.Iterator {
        self._tags.makeIterator()
    }
}

extension CompoundTag: Collection {
    // Implement the startIndex and just pass straight to
    // the startIndex of the _tags array.
    public var startIndex: Int {
        self._tags.startIndex
    }

    // Implement the endIndex and just pass straight to
    // the endIndex of the _tags array.
    public var endIndex: Int {
        self._tags.endIndex
    }

    // Advances to the next index in the collection
    public func index(after i: Int) -> Int {
        self._tags.index(after: i)
    }
}

// swiftlint:enable line_length force_cast
