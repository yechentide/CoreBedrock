//
// Created by yechentide on 2025/11/12
//

public import Foundation

/// Protocol abstraction for batch write operations on a key-value store.
///
/// This protocol wraps the underlying `LevelDBBridgeWriteBatch` so that consumers of
/// `CoreBedrock` never need to depend on the `LevelDBObjC` module directly.
public protocol KeyValueWriteBatch: Sendable {
    /// Adds a key-value pair to the batch.
    func put(_ key: Data, value: Data)

    /// Queues a key for deletion in the batch.
    func remove(_ key: Data)

    /// Removes all queued operations from the batch.
    func clear()

    /// Returns the approximate size of the batch in bytes.
    func approximateSize() -> Int
}
