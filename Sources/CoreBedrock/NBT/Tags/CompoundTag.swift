//
// Created by yechentide on 2024/06/02
//

import Foundation

/// Represents a collection of named `NBT` objects.
public final class CompoundTag: NBT {
    // We want CompoundTag to emulate an Ordered Dictionary
    // so keys and values are stored in separate collections.

    // Use a dictionary for the keys to track the indexes in the _tags array
    private var _keys: [String:Int] = [:]
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
    convenience public init(_ tags: [NBT]) throws {
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
            try append(tag)
        }
    }

    /// Creates a deep copy of given `CompoundTag`.
    /// - Parameter other: An existing CompoundTag to copy.
    /// - Throws: An `CBError.argumentError` if some of the tags were not named or
    /// two tags with teh same name were given.
    public init(from other: CompoundTag) throws {
        super.init()
        _name = other.name
        // Copy keys
        _keys = other._keys
        // Copy tags
        for tag in other._tags {
            try append(tag.clone())
        }
    }

    // Override to return the .compound type
    override public var tagType: TagType {
        return .compound
    }

    /// Gets a collection containing all tag names in this `CompoundTag`.
    public var names: [String] {
        return Array(_keys.keys)
    }

    /// Gets or sets a collection containing all tags in this `CompoundTag`.
    public var tags: [NBT] {
        get {
            return _tags
        }
        set {
            _tags = newValue
        }
    }

    /// Gets the number of tags contained in the `CompoundTag`.
    public var count: Int {
        return _tags.count
    }

    /// Gets or sets the tag with the specified name. May return `nil`.
    public override subscript(_ tagName: String) -> NBT? {
        get {
            guard let index = _keys[tagName] else { return nil }
            return _tags[index]
        }
        set {
            if newValue == nil {
                _ = remove(forKey: tagName)
                return
            }
            precondition(newValue!.name == tagName, "Given tag name must match the tag's actual name.")
            precondition(newValue!.parent == nil, "A tag may only be added to one compound/list at a time.")
            precondition(newValue !== self || newValue !== parent!, "A compound tag may not be added to itself or to its child tag.")

            // This subscript CAN be used to "append" to the collection.
            if let index = _keys[tagName] {
                // Replace (and orphan) the existing tag
                let oldTag = _tags[index]
                oldTag.parent = nil
                _tags[index] = newValue!
                newValue!.parent = self
                // Update _keys
                _keys.removeValue(forKey: oldTag.name!)
                _keys[newValue!.name!] = index
            } else {
                // Append to collection
                _tags.append(newValue!)
                _keys[tagName] = _tags.endIndex - 1
            }
        }
    }

    /// Inserts an item to this `CompoundTag` at the specified index.
    /// - Parameters:
    ///   - newTag: The tag to insert into this `Compound`.
    ///   - index: The zero-based index at which newTag should be inserted.
    /// - Throws: An `CBError.argumentError` if `newTag` already has a parent tag, is the same as this tag or has a name used in this Compound tag; an `CBError.argumentOutOfRange` error if the given `index` is not a valid index in this `CompoundTag`.
    public func insert(_ newTag: NBT, at index: Int) throws {
        if newTag as? CompoundTag === self {
            throw CBStreamError.argumentError("Cannot add tag to itself")
        }
        if newTag.parent != nil {
            throw CBStreamError.argumentError("A tag may only be added to one compound/list at a time.")
        }
        if newTag.name == nil {
            throw CBStreamError.argumentError("Only named tags are allowed in Compound tags.")
        }
        if contains(newTag.name!) {
            throw CBStreamError.argumentError("A tag with the same name has already been added.")
        }
        if index < 0 || index > _tags.count {
            throw CBStreamError.argumentOutOfRange("index", "The given value is not a valid index in the Compound tag.")
        }

        _tags.insert(newTag, at: index)
        newTag.parent = self
        _keys.removeAll()
        for (index, tag) in _tags.enumerated() {
            _keys[tag.name!] = index
        }
    }

    /// Adds a tag to the end of this `CompoundTag`.
    /// - Parameter newTag: The object to add to this CompoundTag.
    /// - Throws: An `CBError.argumentError`  if the given tag is unnamed or
    /// if a tag with the given name already exists in this `CompoundTag`.
    public func append(_ newTag: NBT) throws {
        if newTag as? CompoundTag === self {
            throw CBStreamError.argumentError("Cannot add tag to itself")
        }
        if newTag.parent != nil {
            throw CBStreamError.argumentError("A tag may only be added to one compound/list at a time.")
        }
        if newTag.name == nil {
            throw CBStreamError.argumentError("Only named tags are allowed in Compound tags.")
        }
        if contains(newTag.name!) {
            throw CBStreamError.argumentError("A tag with the same name has already been added.")
        }

        _tags.append(newTag)
        newTag.parent = self

        let index = _tags.endIndex - 1
        _keys[newTag.name!] = index
    }

    /// Adds all tags from the specified collection to this `CompoundTag`.
    /// - Parameter newTags: The collection whose elements should be added to this `CompoundTag`.
    /// - Throws: An `CBError.argumentError`  if the given tag is unnamed or
    /// if a tag with the given name already exists in this `CompoundTag`.
    public func append(contentsOf newTags: [NBT]) throws {
        for tag in newTags {
            try append(tag)
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
            return tag === _tags[index]
        }
        return false
    }

    /// Determines whether this `CompoundTag` contains a tag with a specific name.
    /// - Parameter tagName: Tag name to search for.
    /// - Returns: `true` if a tag with given name was found; otherwise, `false`.
    public func contains(_ tagName: String) -> Bool {
        return _keys.keys.contains(tagName)
    }

    /// Gets the tag with the given name. May return `nil`.
    /// - Parameter tagName: The name of the tag to get.
    /// - Returns: The tag with the specified key. `nil` if no tag with the given name was not found.
    public func get(_ tagName: String) -> NBT? {
        guard let index = _keys[tagName] else { return nil }
        return _tags[index]
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

        let tag = _tags[index]
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
        guard _tags[index] === tag else { return false }

        _tags.remove(at: index)
        tag.parent = nil

        _keys.removeAll()
        for (index, tag) in _tags.enumerated() {
            _keys[tag.name!] = index
        }

        return true
    }

    /// Removes the tag with the specified name from this CompoundTag.
    /// - Parameter tagName: The name of the tag to remove.
    /// - Returns: `true` if the tag is successfully found and removed; otherwise, `false`.
    /// This method returns `false` if name is not found in the `CompoundTag`.
    public func remove(forKey tagName: String) -> Bool {
        guard let index = _keys[tagName] else { return false }

        let tag = _tags.remove(at: index)
        tag.parent = nil

        _keys.removeAll()
        for (index, tag) in _tags.enumerated() {
            _keys[tag.name!] = index
        }

        return true
    }

    /// Removes all tags from this CompoundTag
    public func removeAll() {
        for tag in _tags {
            tag.parent = nil
        }
        _tags.removeAll()
        _keys.removeAll()
    }

    func renameTag(oldName: String, newName: String) throws {
        guard oldName != newName else { return }
        guard !_keys.keys.contains(newName) else { throw CBStreamError.argumentError("Cannot rename: a tag with the same name already exists in this compound.") }
        guard let index = _keys[oldName] else { throw CBStreamError.argumentError("Cannot rename: no tag found to rename.") }

        let tag = _tags[index]
        // Rename tag
        tag._name = newName
        // Update _keys
        _keys.removeValue(forKey: oldName)
        _keys[newName] = index
    }

    override func readTag(_ readStream: CBBinaryReader, _ skip: (NBT) -> Bool) throws -> Bool {
        // Check if the tag needs to be skipped
        if parent != nil && skip(self) {
            try skipTag(readStream)
            return false
        }

        while true {
            let type = try readStream.readTagType()
            var newTag: NBT
            switch type {
                case .end:
                    return true
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
                    throw CBStreamError.invalidFormat("Unsupported tag type found in NBT_Compound: \(type)")
            }
            newTag.parent = self
            newTag._name = try readStream.readString()
            if try newTag.readTag(readStream, skip) {
                // (newTag.name is never nil)

                // Add to the _tags array
                _tags.append(newTag)
                // Get the index just added
                let index = _tags.endIndex - 1
                // Add to _keys
                _keys[newTag.name!] = index
            }
        }
    }

    override func skipTag(_ readStream: CBBinaryReader) throws {
        while true {
            let type = try readStream.readTagType()
            var newTag: NBT
            switch type {
                case .end:
                    return
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
                    throw CBStreamError.invalidFormat("Unsupported tag type found in NBT_Compound: \(type)")
            }

            try readStream.skipString()
            try newTag.skipTag(readStream)
        }
    }

    override func writeTag(_ writeStream: CBBinaryWriter) throws {
        try writeStream.write(TagType.compound)
        guard let name = name else { throw CBStreamError.invalidFormat("Name is nil") }
        try writeStream.write(name)
        try writeData(writeStream)
    }

    override func writeData(_ writeStream: CBBinaryWriter) throws {
        for tag in _tags {
            try tag.writeTag(writeStream)
        }
        try writeStream.write(TagType.end)
    }

    override public func clone() throws -> NBT {
        return try CompoundTag(from: self)
    }

    override func toString(indentString: String, indentLevel: Int) -> String {
        var formattedStr = ""
        for _ in 0..<indentLevel {
            formattedStr.append(indentString)
        }
        formattedStr.append("TAG_Compound")
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

extension CompoundTag: Sequence {
    public func makeIterator() -> Array<NBT>.Iterator {
        return _tags.makeIterator()
    }
}

extension CompoundTag: Collection {
    // Implement the startIndex and just pass straight to
    // the startIndex of the _tags array.
    public var startIndex: Int {
        return _tags.startIndex
    }

    // Implement the endIndex and just pass straight to
    // the endIndex of the _tags array.
    public var endIndex: Int {
        return _tags.endIndex
    }

    // Advances to the next index in the collection
    public func index(after i: Int) -> Int {
        return _tags.index(after: i)
    }
}

