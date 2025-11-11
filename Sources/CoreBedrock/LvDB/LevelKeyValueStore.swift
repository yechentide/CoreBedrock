//
// Created by yechentide on 2025/11/12
//

import Foundation
import LvDBWrapper

/// Protocol abstraction for a key-value store used to persist Minecraft Bedrock world data.
///
/// This protocol defines the interface for accessing world data through a LevelDB-like store.
/// Implementations can provide real LevelDB access or mock stores for testing and SwiftUI Previews.
///
/// ## Topics
///
/// ### Database State
/// - ``isClosed``
/// - ``close()``
///
/// ### Key Operations
/// - ``containsKey(_:)``
/// - ``data(forKey:)``
/// - ``putData(_:forKey:)``
/// - ``removeValue(forKey:)``
///
/// ### Advanced Operations
/// - ``makeIterator()``
/// - ``writeBatch(_:)``
/// - ``compactRange(from:to:)``
///
/// ## Usage
///
/// The default implementation is `LvDB` from `LvDBWrapper`. To inject a custom store:
///
/// ```swift
/// let customStore: LevelKeyValueStore = MyCustomStore()
/// let world = try MCWorld(from: worldURL, database: customStore)
/// ```
///
/// This is especially useful for:
/// - **Testing**: Inject in-memory stores without file I/O
/// - **SwiftUI Previews**: Use mock data without real database files
/// - **Remote storage**: Implement cloud-backed world storage
public protocol LevelKeyValueStore: AnyObject {
    /// Returns `true` if the database has been closed.
    var isClosed: Bool { get }

    /// Closes the database and releases associated resources.
    ///
    /// After calling this method, all operations on this store will fail.
    /// All active iterators created by this store will also be destroyed.
    func close()

    /// Checks whether the specified key exists in the database.
    ///
    /// - Parameter key: The key to check for existence.
    /// - Returns: `true` if the key exists; otherwise, `false`.
    func containsKey(_ key: Data) -> Bool

    /// Retrieves the value associated with the specified key.
    ///
    /// - Parameter key: The key to retrieve the value for.
    /// - Returns: The data associated with the key.
    /// - Throws: An error if the operation fails or the key does not exist.
    func data(forKey key: Data) throws -> Data

    /// Stores a key-value pair in the database.
    ///
    /// If the key already exists, its value will be updated.
    ///
    /// - Parameters:
    ///   - key: The key to store.
    ///   - value: The data value to associate with the key.
    /// - Throws: An error if the operation fails.
    func putData(_ data: Data, forKey key: Data) throws

    /// Removes the key-value pair associated with the specified key.
    ///
    /// - Parameter key: The key to remove.
    /// - Throws: An error if the operation fails.
    func removeValue(forKey key: Data) throws

    /// Creates an iterator for traversing the database entries.
    ///
    /// - Returns: An `LvDBIterator` instance for iterating over the database.
    /// - Throws: An error if iterator creation fails.
    func makeIterator() throws -> LvDBIterator

    /// Applies a batch of write operations atomically.
    ///
    /// - Parameter batch: The write batch containing operations to apply.
    /// - Throws: An error if the batch write fails.
    func writeBatch(_ batch: LvDBWriteBatch) throws

    /// Compacts the database in the specified key range.
    ///
    /// This operation optimizes storage by removing deleted entries and reorganizing data.
    ///
    /// - Parameters:
    ///   - begin: The beginning of the range to compact, or `nil` for the start of the database.
    ///   - end: The end of the range to compact, or `nil` for the end of the database.
    /// - Throws: An error if the compaction fails.
    func compactRange(from begin: Data?, to end: Data?) throws
}

// MARK: - LvDB Conformance

/// Extends `LvDB` to conform to `LevelKeyValueStore`.
///
/// This extension allows `LvDB` from `LvDBWrapper` to be used as a `LevelKeyValueStore`
/// without requiring any changes to the `LvDBWrapper` package itself.
///
/// The Objective-C methods (`has:`, `get:error:`, `put::error:`, `remove:error:`,
/// `newIterator:`, `write:error:`, and `compactRange:end:error:`) are bridged to Swift
/// and called by the protocol methods.
extension LvDB: LevelKeyValueStore {
    /// Checks whether the specified key exists in the database.
    public func containsKey(_ key: Data) -> Bool {
        // Call the Objective-C has: method (bridged to Swift as has(_:))
        self.has(key)
    }

    /// Retrieves the value for the specified key.
    public func data(forKey key: Data) throws -> Data {
        // Call the Objective-C get:error: method (bridged to Swift as get(_:))
        try self.get(key)
    }

    /// Stores a key-value pair in the database.
    public func putData(_ data: Data, forKey key: Data) throws {
        // Call the Objective-C put::error: method (bridged to Swift as put(_:_:))
        try self.put(key, data)
    }

    /// Removes the key-value pair for the specified key.
    public func removeValue(forKey key: Data) throws {
        // Call the Objective-C remove:error: method (bridged to Swift as remove(_:))
        try self.remove(key)
    }

    /// Creates an iterator for traversing the database.
    public func makeIterator() throws -> LvDBIterator {
        // Call the Objective-C newIterator: method (bridged to Swift as newIterator())
        try self.newIterator()
    }

    /// Applies a write batch atomically.
    public func writeBatch(_ batch: LvDBWriteBatch) throws {
        // Call the Objective-C write:error: method (bridged to Swift as write(_:))
        try self.write(batch)
    }

    /// Compacts the database in the specified range.
    public func compactRange(from begin: Data?, to end: Data?) throws {
        // Call the Objective-C compactRange:end:error: method (bridged to Swift as compactRange(_:_:))
        try self.compactRange(begin, end)
    }
}
