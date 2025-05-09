//
// Created by yechentide on 2025/05/04
//

import CoreGraphics
import LvDBWrapper

// MARK: RegionToTexture
enum RegionTextureLoader {
//    struct Result {
//        let worldDirURL: URL
//        let dimension: MCDimension
//        let region: MCRegion
//        var pixels: [CGColor] = []
//    }

    public static func load(db: LvDB, worldDirURL: URL, dimension: MCDimension, region: MCRegion, lastPlayed: Int64?, useCache: Bool) throws -> CGImage? {
        //        let cacheFileURL = try RegionTextureCacheStore.makeCacheFileURL(worldDirURL: worldDirURL, dimension: dimension, region: region)
        //        let cacheFileExists = FileManager.default.fileExists(atPath: cacheFileURL.safePath(percentEncoded: false))
        //        if useCache && cacheFileExists {
        //            let (pixels, isCacheHit) = RegionTextureCacheStore.load(cacheFileURL: cacheFileURL, timestamp: lastPlayed)
        //            if isCacheHit {
        //                result.pixels = pixels
        //                return result
        //            }
        //        }

        let pixels = generatePixelsFromDB(db: db, dimension: dimension, region: region)
        // TODO: Abort task if needed
        //        let timestamp: Int64 = lastPlayed ?? Int64(Date().timeIntervalSince1970)
        //        try RegionTextureCacheStore.save(cacheFileURL: cacheFileURL, pixels: pixels, timestamp: timestamp)
        return CGImage.from(colors: pixels, width: MCRegion.sideLength, height: MCRegion.sideLength, flipVertically: true)
    }

    fileprivate struct WorldMapPixelData {
        let height: Int
        let waterdepth: Int
        let blockType: MCBlockType

        init() {
            self.height = -1
            self.waterdepth = -1
            self.blockType = .unknown
        }

        init(height: Int, waterdepth: Int, blockType: MCBlockType) {
            self.height = height
            self.waterdepth = waterdepth
            self.blockType = blockType
        }
    }

    private static func generatePixelsFromDB(db: LvDB, dimension: MCDimension, region: MCRegion) -> [CGColor] {
        let width = 512
        let height = 512
        let x0 = Int(region.x) * 512
        let z0 = Int(region.z) * 512

        var pixelDataList: [WorldMapPixelData] = .init(repeating: .init(), count: width * height)
        var biomeList: [MCBiomeType] = .init(repeating: .unknown, count: width * height)

//        await ExecutionTimer.shared.start("Task - Extract ALL blocks data")
        for chunkZ in (region.z*32)..<(region.z*32+32) {
            for chunkX in (region.x*32)..<(region.x*32+32) {
                // TODO: Abort task if needed
                let chunkZ = Int32(truncatingIfNeeded: chunkZ)
                let chunkX = Int32(truncatingIfNeeded: chunkX)
//                await ExecutionTimer.shared.start("Task - Extract blocks data")
                guard let chunk = ChunkBuilder.build(db: db, chunkX: chunkX, chunkZ: chunkZ, dimension: dimension, options: [.blockAndBiome]) else {
                    continue
                }
//                await ExecutionTimer.shared.stop()

                for blockZ in chunk.minBlockZ...chunk.maxBlockZ {
                    for blockX in chunk.minBlockX...chunk.maxBlockX {
                        guard let biome = chunk.biome(x: blockX, y: 0, z: blockZ) else {
                            continue
                        }
                        // TODO: convert biome
                        let biomeIndex = (blockZ - z0) * width + (blockX - x0)
                        biomeList[biomeIndex] = biome
                    }
                    // TODO: Abort task if needed
                }
//                await ExecutionTimer.shared.start("Task - Prepare block data")
                let blockIndexRange = 0..<(width * height)
                for blockZ in chunk.minBlockZ...chunk.maxBlockZ {
                    for blockX in chunk.minBlockX...chunk.maxBlockX {
                        let blockIndex = (blockZ - z0) * width + (blockX - x0)
                        guard blockIndexRange ~= blockIndex else {
                            continue
                        }
                        // TODO: Abort task if needed
                        if let pixelData = pillarPixelInfo(dimension: dimension, chunk: chunk, blockX: blockX, blockZ: blockZ) {
                            pixelDataList[blockIndex] = pixelData
                        }
                    }
                    // TODO: Abort task if needed
                }
                print()
//                await ExecutionTimer.shared.stop("Task - Prepare block data")
            }
        }
//        await ExecutionTimer.shared.stop("Task - Extract ALL blocks data")

        let retult = convertPixelData(
            pixelDataList: pixelDataList,
            biomes: biomeList,
            width: width,
            height: height
        )

        return retult
    }

    private static func pillarPixelInfo(dimension: MCDimension, chunk: MCChunk, blockX: Int, blockZ: Int) -> WorldMapPixelData? {
        var waterDepth: UInt8 = 0
        var yMin: Int = max(-64, chunk.minBlockY)
        var yMax: Int = min(319, chunk.maxBlockY)

        if dimension == .theNether {
            yMin = max(0, yMin)
            yMax = min(127, yMax)
            // FIXME: duplicated loop
            for blockY in stride(from: yMax, through: yMin, by: -1) {
                guard let block = chunk.block(x: blockX, y: blockY, z: blockZ) else {
                    continue
                }
                if block.type == .air {
                    yMax = blockY
                    break
                }
            }
        } else if dimension == .theEnd {
            yMin = max(0, yMin)
            yMax = min(255, yMax)
        }

        var allTransparent = true
        for blockY in stride(from: yMax, through: yMin, by: -1) {
//            await ExecutionTimer.shared.start("Task - - - chunk.block()")
            guard let block = chunk.block(x: blockX, y: blockY, z: blockZ) else {
//                await ExecutionTimer.shared.stop("Task - - - chunk.block()", showMessage: false)
                continue
            }
//            await ExecutionTimer.shared.stop("Task - - - chunk.block()", showMessage: true)
            if block.type.isWater {
                waterDepth += 1
                allTransparent = false
                continue
            }
            if block.type.isTransparent || block.type.isPlant {
                continue
            }
            allTransparent = false
            let h = min(max(blockY + 64, 0), 511)
            return WorldMapPixelData(height: h, waterdepth: Int(waterDepth), blockType: block.type)
        }
        if waterDepth > 0 {
            return WorldMapPixelData(height: 0, waterdepth: Int(waterDepth), blockType: .water)
        } else if allTransparent {
            return WorldMapPixelData(height: 0, waterdepth: 0, blockType: .air)
        } else {
            return nil
        }
    }

    private static func convertPixelData(pixelDataList: [WorldMapPixelData], biomes: [MCBiomeType], width: Int, height: Int) -> [CGColor] {
        var pixels: [CGColor] = .init(repeating: .from(red: 0, green: 0, blue: 0, alpha: 0), count: width * height)

        for z in 0..<height {
            for x in 0..<width {
                let pixelIndex = z * width + x
                let pixelData = pixelDataList[pixelIndex]
                guard pixelData.height >= 0 else { continue }
                let biomeType = biomes[pixelIndex]
                let biomeRadius: Int = 7
                //                if (7..<width-7) ~= x && (7..<height-7) ~= z {
                //                    for iz in -7...7 {
                //                        for ix in -7...7 {
                //                            let biomeIndex = (z + iz) * width + x + ix
                //                            let nextBiomeType = biomes[biomeIndex]
                //                            if nextBiomeType != biomeType {
                //                                biomeRadius = min(min(biomeRadius, abs(ix)), abs(iz))
                //                            }
                //                        }
                //                    }
                //                } else {
                //                    biomeRadius = 0
                //                }
                pixels[pixelIndex] = packPixelInfomation(
                    height: UInt32(truncatingIfNeeded: pixelData.height),
                    waterDepth: UInt8(truncatingIfNeeded: pixelData.waterdepth),
                    biomeType: biomeType,
                    blockType: pixelData.blockType,
                    biomeRadius: UInt8(truncatingIfNeeded: biomeRadius)
                )
            }
        }

        return pixels
    }

    // TODO: PackPixelInfoToARGB
    private static func packPixelInfomation(height: UInt32, waterDepth: UInt8, biomeType: MCBiomeType, blockType: MCBlockType, biomeRadius: UInt8) -> CGColor {
        return blockType.cgColor
    }
}
