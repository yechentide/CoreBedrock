//
// Created by yechentide on 2025/11/21
//

public import CoreGraphics
public import Foundation

public typealias MapArtGenerationEvent = CBOperationEvent<MapArtGenerationProgress, Never, Never, Never>

public enum MapArtGenerationProgress: Sendable {
    case splittingImage(processedTileCount: Int, totalTileCount: Int)
    case allocatingMapIDs(allocatedCount: Int, totalCount: Int)
    case generatingMapData(processedMapCount: Int, totalMapCount: Int)
    case savingMapData(savedMapCount: Int, totalMapCount: Int)
    case injectingItem
}

public enum MapArtGenerator {
    private static let tileSize = 128

    /// Generates map art from an image, packs the maps into a shulker box,
    /// and inserts it into the specified player's inventory.
    /// Reports progress via an AsyncThrowingStream of MapArtGenerationEvent.
    ///
    /// - Parameters:
    ///   - database: The level database used to store generated map data
    ///   - image: The source image to convert into map art
    ///   - playerKey: The database key identifying the target player
    ///   - shulkerBoxName: Optional custom name for the shulker box containing the maps
    public static func generateAndGiveToPlayer(
        database: any LevelKeyValueStore,
        image: CGImage,
        playerKey: Data,
        shulkerBoxName: String? = nil
    ) -> AsyncThrowingStream<MapArtGenerationEvent, any Error> {
        AsyncThrowingStream(MapArtGenerationEvent.self) { continuation in
            let task = Task {
                do {
                    try self.run(
                        database: database,
                        image: image,
                        playerKey: playerKey,
                        shulkerBoxName: shulkerBoxName,
                        report: { continuation.yield(.progress($0)) }
                    )
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    // MARK: - Private workers

    private static func run(
        database: any LevelKeyValueStore,
        image: CGImage,
        playerKey: Data,
        shulkerBoxName: String?,
        report: @Sendable @escaping (MapArtGenerationProgress) -> Void
    ) throws {
        let (mapItems, mapDataDict) = try buildMapItemsAndData(
            image: image, database: database, report: report
        )

        let totalMapCount = mapDataDict.count
        var savedCount = 0
        do {
            for (lvdbKey, mapData) in mapDataDict {
                try Task.checkCancellation()
                try autoreleasepool {
                    let entryData = try mapData.toData()
                    try database.putData(entryData, forKey: lvdbKey.data)
                }
                savedCount += 1
                report(.savingMapData(savedMapCount: savedCount, totalMapCount: totalMapCount))
            }
            try Task.checkCancellation()
            report(.injectingItem)
            let shulkerBox = try ShulkerNestingPacker.pack(items: mapItems, rootName: shulkerBoxName)
            try ItemInjector.giveItemToPlayer(item: shulkerBox, playerKey: playerKey, in: database)
        } catch is CancellationError {
            for lvdbKey in mapDataDict.keys {
                try? autoreleasepool {
                    try database.removeValue(forKey: lvdbKey.data)
                }
            }
            throw CancellationError()
        } catch {
            for lvdbKey in mapDataDict.keys {
                try? autoreleasepool {
                    try database.removeValue(forKey: lvdbKey.data)
                }
            }
            throw CBError.failedToSaveMapDataTag
        }
    }

    private static func buildMapItemsAndData(
        image: CGImage,
        database: any LevelKeyValueStore,
        report: @Sendable @escaping (MapArtGenerationProgress) -> Void
    ) throws -> (items: [CompoundTag], data: [LvDBKey: CompoundTag]) {
        var mapItemTagList = [CompoundTag]()
        var mapDataTagDict = [LvDBKey: CompoundTag]()

        try autoreleasepool {
            try Task.checkCancellation()
            let tiles = try split(image: image, report: report)
            try Task.checkCancellation()
            let mapIDList = try allocateMapIDs(in: database, count: tiles.count, report: report)

            let totalMapCount = tiles.count
            for (index, tilePixels) in tiles.enumerated() {
                try Task.checkCancellation()
                try autoreleasepool {
                    let mapID = mapIDList[index]
                    let mapDataTag = try generateMapDataTag(id: mapID, from: tilePixels)
                    let mapItemTag = try ItemGenerator.generate(ItemGenerator.ItemMeta.map(
                        slot: 0, mapID: mapID, name: "Map [\(index + 1)/\(tiles.count)]"
                    ))
                    mapItemTagList.append(mapItemTag)
                    mapDataTagDict[LvDBKey.map(mapID)] = mapDataTag
                    report(.generatingMapData(processedMapCount: index + 1, totalMapCount: totalMapCount))
                }
            }
        }

        return (mapItemTagList, mapDataTagDict)
    }

    private static func generateMapDataTag(id: Int64, from pixels: [CGColor]) throws -> CompoundTag {
        var bytes = [UInt8]()
        bytes.reserveCapacity(pixels.count * 4)
        try autoreleasepool {
            for (index, color) in pixels.enumerated() {
                if index.isMultiple(of: 1024) {
                    try Task.checkCancellation()
                }

                guard let components = color.components else {
                    bytes.append(contentsOf: [0, 0, 0, 0])
                    continue
                }

                let r = UInt8((!components.isEmpty ? components[0] : 0) * 255)
                let g = UInt8((components.count > 1 ? components[1] : 0) * 255)
                let b = UInt8((components.count > 2 ? components[2] : 0) * 255)
                let a = UInt8((components.count > 3 ? components[3] : 1) * 255)

                bytes.append(r)
                bytes.append(g)
                bytes.append(b)
                bytes.append(a)
            }
        }
        return try CompoundTag([
            LongTag(name: "mapId", id),
            LongTag(name: "parentMapId", -1),
            ByteArrayTag(name: "colors", bytes),
            ByteTag(name: "dimension", UInt8.max),
            IntTag(name: "xCenter", 0),
            IntTag(name: "zCenter", 0),
            ShortTag(name: "width", 128),
            ShortTag(name: "height", 128),
            ByteTag(name: "scale", 4),
            ByteTag(name: "fullyExplored", 1),
            ByteTag(name: "mapLocked", 1),
            ByteTag(name: "unlimitedTracking", 0),
        ])
    }

    private static func allocateMapIDs(
        in database: any LevelKeyValueStore,
        count: Int,
        report: @Sendable @escaping (MapArtGenerationProgress) -> Void
    ) throws -> [Int64] {
        let iter = try database.makeIterator()
        iter.moveToFirst()
        defer {
            iter.close()
        }
        var currentID: Int64 = 0
        var ids = [Int64]()

        while ids.count < count {
            try Task.checkCancellation()
            let keyData = LvDBKey.map(currentID).data
            iter.move(to: keyData)
            if !(iter.isValid && iter.currentKey == keyData) {
                ids.append(currentID)
                report(.allocatingMapIDs(allocatedCount: ids.count, totalCount: count))
            }
            currentID += 1

            // Safety check to prevent infinite loop
            guard currentID < Int64.max - 1000 else {
                throw CBError.failedToAllocateMapIDs
            }
        }

        guard ids.count == count else {
            throw CBError.failedToAllocateMapIDs
        }

        return ids
    }

    // swiftlint:disable function_body_length
    private static func split(
        image: CGImage,
        report: @Sendable @escaping (MapArtGenerationProgress) -> Void
    ) throws -> [[CGColor]] {
        let rgbSpace = CGColorSpaceCreateDeviceRGB()
        let tilesX = (image.width + self.tileSize - 1) / self.tileSize
        let tilesY = (image.height + self.tileSize - 1) / self.tileSize
        let totalTileCount = tilesX * tilesY

        var tiles: [[CGColor]] = []

        let bytesPerPixel = 4
        var pixelData = [UInt8](repeating: 0, count: image.width * image.height * bytesPerPixel)

        guard let context = CGContext(
            data: &pixelData,
            width: image.width,
            height: image.height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerPixel * image.width,
            space: rgbSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw CBError.failedCreateImageContext
        }

        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))

        report(.splittingImage(processedTileCount: 0, totalTileCount: totalTileCount))

        for tileY in 0..<tilesY {
            try Task.checkCancellation()
            for tileX in 0..<tilesX {
                try Task.checkCancellation()
                let tilePixels: [CGColor] = try autoreleasepool {
                    var tilePixels: [CGColor] = []
                    tilePixels.reserveCapacity(self.tileSize * self.tileSize)

                    for y in 0..<self.tileSize {
                        if y.isMultiple(of: 32) {
                            try Task.checkCancellation()
                        }
                        for x in 0..<self.tileSize {
                            let sourceX = tileX * self.tileSize + x
                            let sourceY = tileY * self.tileSize + y

                            if sourceX < image.width, sourceY < image.height {
                                let pixelIndex = (sourceY * image.width + sourceX) * bytesPerPixel

                                let r = CGFloat(pixelData[pixelIndex]) / 255.0
                                let g = CGFloat(pixelData[pixelIndex + 1]) / 255.0
                                let b = CGFloat(pixelData[pixelIndex + 2]) / 255.0
                                let a = CGFloat(pixelData[pixelIndex + 3]) / 255.0

                                if let color = CGColor(colorSpace: rgbSpace, components: [r, g, b, a]) {
                                    tilePixels.append(color)
                                }
                            } else {
                                // Padding: transparent
                                if let color = CGColor(colorSpace: rgbSpace, components: [0, 0, 0, 0]) {
                                    tilePixels.append(color)
                                }
                            }
                        }
                    }

                    return tilePixels
                }
                tiles.append(tilePixels)
                report(.splittingImage(processedTileCount: tiles.count, totalTileCount: totalTileCount))
            }
        }

        return tiles
    }
    // swiftlint:enable function_body_length
}
