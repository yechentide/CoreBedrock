//
// Created by yechentide on 2025/10/03
//

import Foundation

enum OldBlockPropertyType: Hashable {
    case color, isLiquid, isOpaque, isPlant
}

// struct BlockPropertyTable {
//     // typealias BlockStateCondition = [String:String]
//     struct PropertyValue {
//         let palette: [Any]
//         let paletteIndices: [String: Int] // key = "minecraft:stone" or "minecraft:door|lit=0,open=1"
//         let stateConditions: [String: [BlockStateCondition]] // key = "minecraft:stone"
//     }
//     let version: Int
//     private let table: [String:[BlockPropertyType:PropertyValue]]

// }

struct OldBlockPropertyTable {
    private struct StateConditionPair: Hashable {
        let key: String
        let value: String
    }

    // Precomputes sorted state condition pairs so lookups avoid rebuilding strings every time.
    private struct StateConditionKey: Hashable {
        let pairs: [StateConditionPair]

        init(condition: BlockStateCondition) {
            pairs = condition
                .map { StateConditionPair(key: $0.key, value: $0.value) }
                .sorted { $0.key < $1.key }
        }

        @inline(__always)
        func matches(states: CompoundTag) -> Bool {
            for pair in pairs {
                guard states[pair.key]?.stringValue == pair.value else {
                    return false
                }
            }
            return true
        }
    }

    private struct OverrideEntry {
        let conditionKey: StateConditionKey
        let value: Any

        init(condition: BlockStateCondition, value: Any) {
            self.conditionKey = StateConditionKey(condition: condition)
            self.value = value
        }

        init(conditionKey: StateConditionKey, value: Any) {
            self.conditionKey = conditionKey
            self.value = value
        }

        @inline(__always)
        func matches(states: CompoundTag) -> Bool {
            conditionKey.matches(states: states)
        }
    }

    struct PropertyValue {
        private let defaultValue: Any
        private let overrides: [OverrideEntry]

        private init(defaultValue: Any, overrides: [OverrideEntry] = []) {
            self.defaultValue = defaultValue
            self.overrides = overrides
        }

        init<Value>(defaultValue: Value, overrides: [(BlockStateCondition, Value)]) {
            self.init(
                defaultValue: defaultValue,
                overrides: overrides.map { OverrideEntry(condition: $0.0, value: $0.1) }
            )
        }

        @inline(__always)
        func resolvedValue(for states: CompoundTag?) -> Any {
            guard let states else {
                return defaultValue
            }
            for entry in overrides {
                if entry.matches(states: states) {
                    return entry.value
                }
            }
            return defaultValue
        }
    }

    private struct BlockEntry {
        private let properties: [OldBlockPropertyType: PropertyValue]

        init(properties: [OldBlockPropertyType: PropertyValue]) {
            self.properties = properties
        }

        @inline(__always)
        func value(for propertyType: OldBlockPropertyType, states: CompoundTag?) -> Any? {
            guard let property = properties[propertyType] else {
                return nil
            }
            return property.resolvedValue(for: states)
        }

        func hasProperty(_ propertyType: OldBlockPropertyType) -> Bool {
            properties[propertyType] != nil
        }
    }

    let version: Int
    private let table: [String: BlockEntry]

    init(version: Int, entries: [String: [OldBlockPropertyType: PropertyValue]]) throws {
        self.version = version
        self.table = Dictionary(
            uniqueKeysWithValues: entries.map { item in
                (item.key, BlockEntry(properties: item.value))
            }
        )
    }

    @inline(__always)
    func value(
        for propertyType: OldBlockPropertyType,
        blockDataTag: CompoundTag
    ) -> Any? {
        let states = blockDataTag["states"] as? CompoundTag
        guard let blockName = blockDataTag["name"]?.stringValue else {
            return nil
        }
        return value(for: propertyType, blockName: blockName, states: states)
    }

    @inline(__always)
    func value<T>(
        for propertyType: OldBlockPropertyType,
        blockDataTag: CompoundTag,
        as type: T.Type
    ) -> T? {
        value(for: propertyType, blockDataTag: blockDataTag) as? T
    }

    func value(
        for propertyType: OldBlockPropertyType,
        blockName: String,
        states: CompoundTag?
    ) -> Any? {
        if let entry = table[blockName],
           let resolved = entry.value(for: propertyType, states: states) {
            return resolved
        }
        return nil
    }

    func hasValue(
        for propertyType: OldBlockPropertyType,
        blockName: String
    ) -> Bool {
        if let entry = table[blockName], entry.hasProperty(propertyType) {
            return true
        }
        return false
    }
}
