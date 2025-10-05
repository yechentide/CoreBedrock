//
// Created by yechentide on 2025/09/18
//

import Foundation
import OSLog

// MARK: - Protocols

internal protocol OldBlockAttributeTable: Sendable {
    associatedtype JSONValue: Codable & Hashable & Equatable
    associatedtype Value

    static func loadPalette(from jsonData: Data) throws -> Self
    static func transform(from rawValue: JSONValue) throws -> Value
    static func validate(version: Int, paletteIndices: [String: Int]) throws

    init(
        version: Int, palette: [Value], paletteIndices: [String: Int],
        stateConditions: [String: [BlockStateCondition]]
    )

    var version: Int { get }
    var palette: [Value] { get }
    var paletteIndices: [String: Int] { get }
    var stateConditions: [String: [BlockStateCondition]] { get }

    func index(of blockDataTag: CompoundTag) -> Int
    func value(of blockDataTag: CompoundTag) -> Value
}

extension OldBlockAttributeTable {
    fileprivate static var defaultBlockName: String { "other_blocks" }
    fileprivate static var airBlockName: String { "minecraft:air" }
    fileprivate static var waterBlockName: String { "minecraft:water" }
    fileprivate static var defaultBlockTag: CompoundTag {
        try! CompoundTag([  StringTag(name: "name", Self.defaultBlockName)  ])
    }
    fileprivate static var airBlockTag: CompoundTag {
        try! CompoundTag([  StringTag(name: "name", Self.airBlockName)  ])
    }
    fileprivate static var waterBlockTag: CompoundTag {
        try! CompoundTag([  StringTag(name: "name", Self.waterBlockName)  ])
    }

    private static func makePaletteKey(blockName: String, condition: BlockStateCondition?) -> String {
        guard let condition, !condition.isEmpty else { return blockName }
        let stringStateCondition = condition
            .sorted(by: { $0.0 < $1.0 })
            .map { "\($0.0)=\($0.1)" }
            .joined(separator: ",")
        return "\(blockName)|\(stringStateCondition)"
    }

    public static func loadPalette(from jsonData: Data) throws -> Self {
        CBLogger.info("Loading block attribute palette from JSON data.")
        let decoder = JSONDecoder()
        let file = try decoder.decode(BlockAttributeJSON<JSONValue>.self, from: jsonData)

        guard file.version == 1 else {
            CBLogger.error("Block attribute file version (\(file.version)) is invalid. Only version 1 is supported.")
            throw CBJSONParsingError.invalidVersion(file.version)
        }

        var palette: [Value] = []
        var paletteIndices: [String: Int] = [:]
        var stateConditions: [String: [BlockStateCondition]] = [:]
        var index = 0
        let addValueToPalette: (String, JSONValue) throws -> Void = { (key, jsonValue) in
            let value = try Self.transform(from: jsonValue)
            paletteIndices[key] = index
            palette.append(value)
            index += 1
        }

        for entry in file.entries {
            let key = entry.id
            try addValueToPalette(key, entry.defaultValue)
            var overrides: [BlockStateCondition] = []
            for override in entry.overrides {
                let key = makePaletteKey(blockName: entry.id, condition: override.condition)
                try addValueToPalette(key, override.value)
                overrides.append(override.condition)
            }
            stateConditions[entry.id] = overrides
        }
        try Self.validate(version: file.version, paletteIndices: paletteIndices)
        CBLogger.info("Successfully loaded block attribute palette.")
        return Self.init(
            version: file.version,
            palette: palette,
            paletteIndices: paletteIndices,
            stateConditions: stateConditions
        )
    }

    public var indexOfAir: Int { index(of: Self.airBlockTag) }
    public var indexOfWater: Int { index(of: Self.waterBlockTag) }
    public var valueOfAir: Value { value(of: Self.airBlockTag) }
    public var valueOfWater: Value { value(of: Self.waterBlockTag) }

    @inline(__always)
    internal func value(of blockDataTag: CompoundTag) -> Value {
        let index = index(of: blockDataTag)
        return palette[index]
    }
}

extension OldBlockAttributeTable where Value == RGBA {
    @inline(__always)
    internal func index(of blockDataTag: CompoundTag) -> Int {
        let defaultBlockIndex = paletteIndices[Self.defaultBlockName]!
        guard let blockName = blockDataTag["name"]?.stringValue else {
            return defaultBlockIndex
        }

        if let statesTag = blockDataTag["states"] as? CompoundTag {
            for conditionMap in self.stateConditions[blockName] ?? [] {
                if conditionMap.allSatisfy({ statesTag[$0.key]?.stringValue == $0.value }) {
                    let key = Self.makePaletteKey(blockName: blockName, condition: conditionMap)
                    return paletteIndices[key] ?? defaultBlockIndex
                }
            }
        }
        return paletteIndices[blockName] ?? defaultBlockIndex
    }
}

extension OldBlockAttributeTable where Value == Bool {
    @inline(__always)
    internal func index(of blockDataTag: CompoundTag) -> Int {
        guard let blockName = blockDataTag["name"]?.stringValue else {
            return paletteIndices[Self.defaultBlockName]!
        }
        return paletteIndices[blockName] ?? paletteIndices[Self.defaultBlockName]!
    }
}

// MARK: - Implements

public struct OldBlockColorTable: OldBlockAttributeTable {
    public static func validate(version: Int, paletteIndices: [String : Int]) throws {
        let requiredBlockNames = [OldBlockColorTable.defaultBlockName, OldBlockColorTable.airBlockName, OldBlockColorTable.waterBlockName]
        for blockName in requiredBlockNames {
            if paletteIndices[blockName] == nil {
                throw CBJSONParsingError.blockNotDifined(blockName)
            }
        }
    }
    public static func transform(from rawValue: String) throws -> RGBA {
        guard let color = rawValue.toRGBA() else {
            throw CBJSONParsingError.invalidJSONValue(rawValue)
        }
        return color
    }

    public let version: Int
    internal let palette: [RGBA]
    internal let paletteIndices: [String: Int]
    internal let stateConditions: [String: [BlockStateCondition]]

    internal init(
        version: Int, palette: [RGBA], paletteIndices: [String: Int],
        stateConditions: [String: [BlockStateCondition]]
    ) {
        self.version = version
        self.palette = palette
        self.paletteIndices = paletteIndices
        self.stateConditions = stateConditions
    }
}

// isLiquid, isOpaque, isPlant, isFlower, ......
public struct OldBlockBoolTable: OldBlockAttributeTable {
    public static func validate(version: Int, paletteIndices: [String : Int]) throws {
        let requiredBlockNames = [OldBlockBoolTable.defaultBlockName]
        for blockName in requiredBlockNames {
            if paletteIndices[blockName] == nil {
                throw CBJSONParsingError.blockNotDifined(blockName)
            }
        }
    }
    public static func transform(from rawValue: Bool) -> Bool { rawValue }

    public let version: Int
    internal let palette: [Bool]
    internal let paletteIndices: [String: Int]
    internal let stateConditions: [String: [BlockStateCondition]]

    internal init(
        version: Int, palette: [Bool], paletteIndices: [String: Int],
        stateConditions: [String: [BlockStateCondition]]
    ) {
        self.version = version
        self.palette = palette
        self.paletteIndices = paletteIndices
        self.stateConditions = stateConditions
    }
}
