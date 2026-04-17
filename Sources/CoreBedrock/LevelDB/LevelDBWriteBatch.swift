//
// Created by yechentide on 2025/11/12
//

public import Foundation
import LevelDBObjC

public final class LevelDBWriteBatch: KeyValueWriteBatch, @unchecked Sendable {
    let batch = LevelDBBridgeWriteBatch()

    public init() {}

    public func put(_ key: Data, value: Data) {
        self.batch.put(key, value: value)
    }

    public func remove(_ key: Data) {
        self.batch.remove(key)
    }

    public func clear() {
        self.batch.clear()
    }

    public func approximateSize() -> Int {
        self.batch.approximateSize()
    }
}
