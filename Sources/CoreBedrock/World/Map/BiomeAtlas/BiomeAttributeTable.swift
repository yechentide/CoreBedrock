//
// Created by yechentide on 2025/09/21
//

import Foundation
import OSLog

// MARK: - Protocols

private protocol BiomeAttributeTable: Sendable {
    associatedtype JSONValue: Codable & Equatable
    associatedtype Value

    static func loadPalette(from jsonData: Data) throws -> Self
    static func transform(from rawValue: JSONValue) -> Value?

    init(
        version: Int, palette: [Value], paletteIndices: [String: Int],
        stateConditions: [String: [BlockStateCondition]]
    )

    var version: Int { get }
    var palette: [Value] { get }
    var paletteIndices: [String: Int] { get }

    func index(of blockDataTag: CompoundTag) -> Int?
    func value(of blockDataTag: CompoundTag) -> Value?
}

public struct BiomeColorTable: Sendable {
    public struct BiomeData: Sendable {
        let id: UInt16
        let name: String
        let biomeColor: RGBA
        let liquidColor: RGBA
        let foliageColor: RGBA
    }

    let version: Int
    let palette: [BiomeData]
    let paletteIndices: [UInt16: Int]

    private init(
        version: Int, palette: [BiomeData], paletteIndices: [UInt16: Int]
    ) {
        self.version = version
        self.palette = palette
        self.paletteIndices = paletteIndices
    }

    private static func validate(version: Int, paletteIndices: [UInt16: Int]) throws {
        if paletteIndices.count < 87 {
            throw CBJSONParsingError.wrongEntryCount(paletteIndices.count)
        }
    }

    private static func resolveColor(ref: String, defaultColor: RGBA, table: [String: RGBA]) throws -> RGBA {
        if ref == "default" {
            return defaultColor
        } else if let color = table[ref] {
            return color
        } else {
            throw CBJSONParsingError.invalidHexRef(ref)
        }
    }

    public static func loadPalette(from jsonData: Data) throws -> Self {
        CBLogger.info("Loading biome attribute palette from JSON data.")
        let decoder = JSONDecoder()
        let file = try decoder.decode(BiomeAttributeJSON.self, from: jsonData)

        guard file.version == 1 else {
            CBLogger.error("Biome attribute file version (\(file.version)) is invalid. Only version 1 is supported.")
            throw CBJSONParsingError.invalidVersion(file.version)
        }

        var palette: [BiomeData] = []
        var paletteIndices: [UInt16: Int] = [:]

        guard let defaultLiquidColor = file.palette.defaults.liquid.toRGBA() else {
            throw CBJSONParsingError.invalidHexColor(file.palette.defaults.liquid)
        }
        guard let defaultFoliageColor = file.palette.defaults.foliage.toRGBA() else {
            throw CBJSONParsingError.invalidHexColor(file.palette.defaults.foliage)
        }

        var colorTable: [String: RGBA] = [:]
        for (name, hexColor) in file.palette.custom {
            guard let color = hexColor.toRGBA() else {
                fatalError()
            }
            colorTable[name] = color
        }

        var index = 0
        for entry in file.entries {
            guard let biomeColor = entry.biomeColor.toRGBA() else {
                throw CBJSONParsingError.invalidHexColor(entry.biomeColor)
            }
            paletteIndices[entry.id] = index
            palette.append(.init(
                id: entry.id,
                name: entry.name,
                biomeColor: biomeColor,
                liquidColor: try resolveColor(
                    ref: entry.liquidColorRef, defaultColor: defaultLiquidColor, table: colorTable
                ),
                foliageColor: try resolveColor(
                    ref: entry.foliageColorRef, defaultColor: defaultFoliageColor, table: colorTable
                )
            ))
            index += 1
        }

        try Self.validate(version: file.version, paletteIndices: paletteIndices)
        return .init(version: file.version, palette: palette, paletteIndices: paletteIndices)
    }

    public func value(of biomeID: UInt16) -> BiomeData? {
        guard let index = paletteIndices[biomeID] else {
            return nil
        }
        return palette[index]
    }
}
