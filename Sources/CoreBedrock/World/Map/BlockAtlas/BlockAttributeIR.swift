//
// Created by yechentide on 2025/10/04
//

import Foundation

typealias BlockID = Int       // interned "minecraft:stone" など
typealias StateKeyID = Int    // interned state key
typealias StateValueID = Int  // interned state value

//enum PropertyKind { case color, isLiquid, isOpaque, isPlant }

struct StateConditionPair: Hashable {
    let key: StateKeyID
    let value: StateValueID
}

struct StateKey: Hashable {
    // 常に key 昇順。生成時にソートしてハッシュを安定化
    let pairs: [StateConditionPair]
}

struct BlockAttributeIR<Value> {
    struct BlockIR {
        let defaultValue: Value
        // 完全一致条件のみをサポート（例のスキーマに合わせる）
        let overrides: [StateKey: Value]
        // 最適化用：このブロックで参照されるstateキーの集合
        let relevantStateKeys: Set<StateKeyID>
    }

    let version: Int
    // ブロックごとの定義
    let entries: [BlockID: BlockIR]

    private init() {
        self.version = -1
        self.entries = [:]
    }

    private init(version: Int, entries: [BlockID : BlockIR]) {
        self.version = version
        self.entries = entries
    }

    private static func makeStateKey(_ condition: [String:String], pool: InternIDPool) -> StateKey {
        var pairs: [StateConditionPair] = []
        pairs.reserveCapacity(condition.count)
        for (k, v) in condition {
            let kID = pool.id(for: k)
            let vID = pool.id(for: v)
            pairs.append(.init(key: kID, value: vID))
        }
        pairs.sort { $0.key < $1.key }
        return StateKey(pairs: pairs)
    }

    public static func build<T>(
        from json: BlockAttributeJSON<T>,
        pool: InternIDPool
    ) throws -> BlockAttributeIR<T> {
        var entryMap: [BlockID: BlockAttributeIR<T>.BlockIR] = [:]
        entryMap.reserveCapacity(json.entries.count)

        for entry in json.entries {
            let blockID = pool.id(for: entry.id)
            var relevantKeys = Set<Int>()
            var overrides: [StateKey: T] = [:]
            overrides.reserveCapacity(entry.overrides.count)

            for ov in entry.overrides {
                let sk = makeStateKey(ov.condition, pool: pool)
                for p in sk.pairs { relevantKeys.insert(p.key) }
                overrides[sk] = ov.value
            }

            entryMap[blockID] = .init(
                defaultValue: entry.defaultValue,
                overrides: overrides,
                relevantStateKeys: relevantKeys
            )
        }

        if !json.entries.isEmpty && type(of: json.entries[0].defaultValue) == NewRGBA.self {
            // TODO: check color data for air & water
            let count = pool.idByString.count
            let _ = pool.idByString["minecraft:air"]
            let _ = pool.idByString["minecraft:water"]
            if count != pool.idByString.count {
                fatalError()
            }
        }

        return .init(version: json.version, entries: entryMap)
    }
}

final class InternIDPool {
    private(set) var idByString: [String: Int] = [:]

    /// 文字列をインターンし、そのIDを返す。既存なら既存IDを返す。
    @discardableResult
    public func id(for string: String) -> Int {
        if let existing = idByString[string] {
            return existing
        }
        let newID = idByString.count
        idByString[string] = newID
        return newID
    }
}
