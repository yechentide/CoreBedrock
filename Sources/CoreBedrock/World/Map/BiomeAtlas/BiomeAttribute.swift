//
// Created by yechentide on 2025/09/19
//


internal struct BiomeAttributeJSON: Codable {
    let version: Int
    let description: String
    let palette: BiomeAttributePaletteJSON
    let entries: [BiomeAttributeEntryJSON]
}

internal struct BiomeAttributePaletteJSON: Codable {
    let defaults: BiomeAttributePaletteDefaultJSON
    let custom: [String:String]
}

internal struct BiomeAttributePaletteDefaultJSON: Codable {
    let liquid: String
    let foliage: String
}

internal struct BiomeAttributeEntryJSON: Codable {
    let id: UInt16
    let name: String
    let biomeColor: String
    let liquidColorRef: String
    let foliageColorRef: String
}
