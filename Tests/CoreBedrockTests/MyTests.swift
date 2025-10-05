//
// Created by yechentide on 2025/09/18
//

@testable import CoreBedrock
import Foundation
import LvDBWrapper
import Testing

// swiftlint:disable line_length comment_spacing

struct MyTests {
    @Test
    func extractChunkView() throws {
//        let blockColorTable = try BlockColorTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-color-template.json")))
//        let blockLiquidTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-liquid-template.json")))
//        let blockOpaqueTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-opaque-template.json")))
//        let blockPlantTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-plant-template.json")))
//
//        let db = try LvDB(dbPath: "/private/tmp/json/w01/db")
//        defer {
//            db.close()
//        }
//        let iter = try db.makeIterator()
//        defer {
//            iter.destroy()
//        }
//
//        var pixelDataList: [TexturePixelData] = .init(
//            repeating: .init(height: 0, waterDepth: 0, blockPaletteIndex: 0, biomeID: 0),
//            count: 512 * 512
//        )
//
//        await ExecutionTimer.shared.start()
//
//        let loader = ChunkTextureLoader(
//            iterator: iter,
//            dimension: .overworld,
//            chunkX: 0,
//            chunkZ: 0,
//            blockDataTables: .init(color: blockColorTable, liquid: blockLiquidTable, opaque: blockOpaqueTable, plant: blockPlantTable)
//        )
//        await loader.extractChunkData(texturePixels: &pixelDataList)
//
//        await ExecutionTimer.shared.stop(showMessage: true)
    }

//    @Test
//    func aaa() async throws {
//        let blockColorTable = try BlockColorTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-color-template.json")))
//        let blockLiquidTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-liquid-template.json")))
//        let blockOpaqueTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-opaque-template.json")))
//        let blockPlantTable = try BlockBoolTable.loadPalette(from: try Data(contentsOf: URL.from(filePath: "/private/tmp/json/block-plant-template.json")))
//
//        let db = try LvDB(dbPath: "/private/tmp/json/w01/db")
//        defer {
//            db.close()
//        }
//
//        let regionTextureLoader = RegionTextureLoader(db: db, tables: .init(
//            color: blockColorTable,
//            liquid: blockLiquidTable,
//            opaque: blockOpaqueTable,
//            plant: blockPlantTable
//        ))
//
//        if let image = try regionTextureLoader.load(
//            dimension: .overworld,
//            region: .init(x: 0, z: 0),
//            lastPlayed: nil,
//            useCache: false
//        ) {
//            try image.save(to: URL.from(filePath: "/private/tmp/json/r0.0.png"))
//        }
//    }
}

// func rgbaToHex(_ color: RGBA, includeAlpha: Bool = false) -> String {
//    if includeAlpha {
//        return String(format: "#%02X%02X%02X%02X", color.red, color.green, color.blue, color.alpha)
//    } else {
//        return String(format: "#%02X%02X%02X", color.red, color.green, color.blue)
//    }
// }

// swiftlint:enable line_length comment_spacing
