//
// Created by yechentide on 2025/10/05
//

typealias VariantID = Int

struct VariantKey: Hashable {
    let block: BlockID
    let state: StateKey
}

//protocol AttributeAtlas {
//    associatedtype Value: Hashable & Equatable
//    var palette: [Value] { get }
//    func value(for tag: CompoundTag) -> Value
//    func paletteIndex(for tag: CompoundTag) -> Int
//    func paletteIndex(for variant: VariantID) -> Int
//}

extension BlockAttributeAtlas {
    private static var airBlockTag: CompoundTag {
        (try? CompoundTag([
            StringTag(name: "name", "minecraft:air")
        ]))!
    }
    private static var waterBlockTag: CompoundTag {
        (try? CompoundTag([
            StringTag(name: "name", "minecraft:water")
        ]))!
    }
}

extension BlockAttributeAtlas<NewRGBA> {
    var indexOfAir: Int {
        return paletteIndex(for: Self.airBlockTag)
    }
    var indexOfWater: Int {
        return paletteIndex(for: Self.waterBlockTag)
    }
}

final class BlockAttributeAtlas<T: Hashable & Equatable> {
    private final class PaletteBuilder<V: Hashable & Equatable> {
        private var valueToIndex: [V:Int] = [:]
        private(set) var values: [V] = []

        func index(for value: V) -> Int {
            if let i = valueToIndex[value] { return i }
            let i = values.count
            values.append(value)
            valueToIndex[value] = i
            return i
        }
    }

    let palette: [T]
    private let relevantKeysByBlock: [BlockID: Set<Int>]

    // Cache
    private var indexByVariant: [VariantID: Int] = [:]
    private let blockRegistry: BlockRegistry

    init(ir: BlockAttributeIR<T>, pool: InternIDPool) {
        let paletteBuilder = PaletteBuilder<T>()
        var defaults: [BlockID:Int] = [:]
        var overrides: [BlockID:[StateKey:Int]] = [:]
        var relevant: [BlockID: Set<Int>] = [:]

        for (bid, bir) in ir.entries {
            defaults[bid] = paletteBuilder.index(for: bir.defaultValue)

            var map: [StateKey:Int] = [:]
            for (k, v) in bir.overrides {
                map[k] = paletteBuilder.index(for: v)
            }
            overrides[bid] = map
        }
        for (bid, be) in ir.entries {
            relevant[bid] = be.relevantStateKeys
        }

        self.palette = paletteBuilder.values
        self.relevantKeysByBlock = relevant
        self.blockRegistry = .init(pool: pool, defaultIndexByBlock: defaults, overrideIndexByBlock: overrides)
    }

    func value(for tag: CompoundTag) -> T {
        palette[paletteIndex(for: tag)]
    }

    func paletteIndex(for tag: CompoundTag) -> Int {
        let vid = blockRegistry.variantID(for: tag, relevantKeysByBlock: relevantKeysByBlock)
        return paletteIndex(for: vid)
    }

    func paletteIndex(for variant: VariantID) -> Int {
        if let hit = indexByVariant[variant] { return hit }

        let index = blockRegistry.lookupForAtlas(variant: variant)
        indexByVariant[variant] = index
        return index
    }
}

final class BlockRegistry {
    private let pool: InternIDPool

    // 正規化キャッシュ
    private var variantToBlock: [VariantID: BlockID] = [:]
    private var variantToStateKey: [VariantID: StateKey] = [:]

    // （任意）name+statesの→VariantIDの一意化テーブル
    private var keyToVariant: [VariantKey: VariantID] = [:]
    private var nextVariantID: VariantID = 0

    private let defaultIndexByBlock: [BlockID: Int]
    private let overrideIndexByBlock: [BlockID: [StateKey: Int]]

    init(pool: InternIDPool, defaultIndexByBlock: [BlockID: Int], overrideIndexByBlock: [BlockID: [StateKey: Int]]) {
        self.pool = pool
        self.defaultIndexByBlock = defaultIndexByBlock
        self.overrideIndexByBlock = overrideIndexByBlock
    }

    // Atlasサイドから使うヘルパ：VariantID→（BlockID, StateKey, defaultIndex, overrideMap）
    func lookupForAtlas(variant: VariantID) -> (Int) {
        let bid = variantToBlock[variant]!          // 正規化済み
        let stateKey  = variantToStateKey[variant]! // 正規化済み
        // Atlasビルド済みの辞書
        let defaultIndex = defaultIndexByBlock[bid]!
        return overrideIndexByBlock[bid]?[stateKey] ?? defaultIndex
    }

    func variantID(for tag: CompoundTag, relevantKeysByBlock: [BlockID: Set<Int>]) -> VariantID {
        let bid = pool.id(for: tag.name ?? "") // "minecraft:stone"
        let allowedStateKey = relevantKeysByBlock[bid] ?? []
        // states（辞書）→ StateKey（ソート済みペア列）へ
        let sk = normalizedStateKey(from: tag["states"] as? CompoundTag, allowing: allowedStateKey)
        let key = VariantKey(block: bid, state: sk)

        if let v = keyToVariant[key] { return v }
        let v = nextVariantID
        nextVariantID += 1
        keyToVariant[key] = v
        variantToBlock[v] = bid
        variantToStateKey[v] = sk
        return v
    }

    private func normalizedStateKey(from statesTag: CompoundTag?, allowing allowedStateKey: Set<Int> = []) -> StateKey {
        guard let statesTag, !allowedStateKey.isEmpty else {
            return StateKey(pairs: [])
        }
        var pairs: [StateConditionPair] = []
        pairs.reserveCapacity(statesTag.count)
        for tag in statesTag.tags {
            let key = pool.id(for: tag.name ?? "")
            if allowedStateKey.contains(key) {
                pairs.append(.init(
                    key: key,
                    value: pool.id(for: tag.stringValue)
                ))
            }
        }
        pairs.sort { $0.key < $1.key }
        return StateKey(pairs: pairs)
    }
}
