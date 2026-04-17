//
// Created by yechentide on 2025/11/12
//

public import Foundation

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
/// ```swift
/// let customStore: KeyValueStore = MyCustomStore()
/// let world = try MCWorld(from: worldURL, database: customStore)
/// ```
///
/// This is especially useful for:
/// - **Testing**: Inject in-memory stores without file I/O
/// - **SwiftUI Previews**: Use mock data without real database files
/// - **Remote storage**: Implement cloud-backed world storage
public protocol KeyValueStore: Sendable {
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
    /// - Returns: A ``KeyValueStoreIterator`` instance for iterating over the database.
    /// - Throws: An error if iterator creation fails.
    func makeIterator() throws -> any KeyValueStoreIterator

    /// Applies a batch of write operations atomically.
    ///
    /// - Parameter batch: The write batch containing operations to apply.
    /// - Throws: An error if the batch write fails.
    func writeBatch(_ batch: any KeyValueWriteBatch) throws

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
