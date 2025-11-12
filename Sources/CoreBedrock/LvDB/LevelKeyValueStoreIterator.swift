//
// Created by yechentide on 2025/11/12
//

import Foundation
import LvDBWrapper

/// Iterator abstraction that mirrors the functionality exposed by ``LvDBIterator``.
/// Wrapping the iterator into a protocol allows tests and SwiftUI previews to supply
/// lightweight mocks without depending on the Objective-C implementation.
public protocol LevelKeyValueStoreIterator {
    /// Indicates whether the iterator instance has already been closed and its resources released.
    var isClosed: Bool { get }

    /// Indicates whether the iterator currently points to a valid key–value entry.
    var isValid: Bool { get }

    /// Returns the key at the iterator's current position or `nil` if it is invalid.
    var currentKey: Data? { get }

    /// Returns the value at the iterator's current position or `nil` if it is invalid.
    var currentValue: Data? { get }

    /// Closes the iterator and releases any associated resources.
    func close()

    /// Moves the iterator to the first key in the database.
    func moveToFirst()

    /// Moves the iterator to the last key in the database.
    func moveToLast()

    /// Moves the iterator to the first key that is at or after the supplied key.
    ///
    /// - Parameter key: The key to align the iterator with.
    func move(to key: Data)

    /// Advances the iterator to the next entry.
    func moveToNext()

    /// Moves the iterator to the previous entry.
    func moveToPrevious()
}

extension LvDBIterator: LevelKeyValueStoreIterator {
    public var isClosed: Bool { isDestroyed }

    public var isValid: Bool { valid() }

    public var currentKey: Data? { key() }

    public var currentValue: Data? { value() }

    public func close() {
        destroy()
    }

    public func moveToFirst() {
        seekToFirst()
    }

    public func moveToLast() {
        seekToLast()
    }

    public func move(to key: Data) {
        seek(key)
    }

    public func moveToNext() {
        next()
    }

    public func moveToPrevious() {
        prev()
    }
}
