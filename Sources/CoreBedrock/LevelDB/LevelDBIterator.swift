//
// Created by yechentide on 2025/11/12
//

public import Foundation
import LevelDBObjC

public final class LevelDBIterator: KeyValueStoreIterator, @unchecked Sendable {
    private let iter: LevelDBBridgeIterator

    init(_ iter: LevelDBBridgeIterator) {
        self.iter = iter
    }

    public var isClosed: Bool {
        self.iter.isDestroyed
    }

    public var isValid: Bool {
        self.iter.valid()
    }

    public var currentKey: Data? {
        self.iter.key()
    }

    public var currentValue: Data? {
        self.iter.value()
    }

    public func close() {
        self.iter.destroy()
    }

    public func moveToFirst() {
        self.iter.seekToFirst()
    }

    public func moveToLast() {
        self.iter.seekToLast()
    }

    public func move(to key: Data) {
        self.iter.seek(key)
    }

    public func moveToNext() {
        self.iter.next()
    }

    public func moveToPrevious() {
        self.iter.prev()
    }
}
