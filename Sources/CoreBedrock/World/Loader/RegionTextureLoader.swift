//
// Created by yechentide on 2025/05/10
//

import CoreGraphics
import OSLog
import LvDBWrapper

/*
 Coordinate Naming Convention:

 World-space coordinates:
 - regionX, regionY       : Region position in the world
 - chunkX, chunkY         : Chunk position in the world
 - blockX, blockY         : Block position in the world

 Local coordinates:
 - localChunkXInRegion, localChunkYInRegion : Chunk position relative to its Region
 - localBlockXInChunk, localBlockYInChunk   : Block position relative to its Chunk
 */

public enum RegionTextureLoader {
    public static func generateBlockColorTexture() -> CGImage? {
        let blockCount = MCBlockType.allCases.count
        let k = Int(ceil(log2(Double(blockCount)) / 2))
        let size = 1 << (k + 1)
        let pixelCount = size * size
        var pixels = Array(repeating: RGBA(0, 0, 0, 0), count: pixelCount)
        for block in MCBlockType.allCases {
            let index = block.id
            if index < pixels.count {
                pixels[index] = block.rgba
            }
        }
        return CGImage.from(colors: pixels, width: size, height: size)
    }

    public static func load(db: LvDB, worldDirURL: URL, dimension: MCDimension, region: MCRegion, lastPlayed: Int64?, useCache: Bool) throws -> CGImage? {
        CBLogger.debug("Loading Region (\(region.x),\(region.z)) ......")
        var image: CGImage? = nil
        autoreleasepool {
            let pixels: [RGBA] = generateRegionPixelsFromDB(db: db, dimension: dimension, region: region)
            if Task.isCancelled {
                return
            }
            image = CGImage.from(colors: pixels, width: MCRegion.sideLength, height: MCRegion.sideLength, flipVertically: true)
        }
        return image
    }

    private static func generateRegionPixelsFromDB(db: LvDB, dimension: MCDimension, region: MCRegion) -> [RGBA] {
        let width = Int(MCRegion.sideLength)
        let height = Int(MCRegion.sideLength)
        guard let iter = try? db.makeIterator() else {
            return .init(repeating: (0,0,0,0), count: width * height)
        }
        defer {
            iter.destroy()
        }

        var pixelDataList: [TexturePixelData] = .init(repeating: .init(), count: width * height)
        var biomeList: [MCBiomeGroup] = .init(repeating: .other, count: width * height)

        for chunkZ in (region.z*32)..<(region.z*32+32) {
            for chunkX in (region.x*32)..<(region.x*32+32) {
                if Task.isCancelled {
                    return []
                }
                autoreleasepool {
                    extractChunkPixelsDataFromDB(iter: iter, dimension: dimension, chunkX: chunkX, chunkZ: chunkZ, pixelDataList: &pixelDataList, biomeList: &biomeList)
                }
            }
        }

        if Task.isCancelled {
            return []
        }
        let pixels = convertToRGBAList(from: pixelDataList, biomes: biomeList, width: width, height: height)
        return pixels
    }

    private static func extractChunkPixelsDataFromDB(iter: LvDBIterator, dimension: MCDimension, chunkX: Int32, chunkZ: Int32, pixelDataList: inout [TexturePixelData], biomeList: inout [MCBiomeGroup]) {
        let chunkBaseKey = LvDBKeyFactory.makeBaseChunkKey(x: chunkX, z: chunkZ, dimension: dimension)
        let biomeColumn = ChunkDataLoader.loadBiomes(iter: iter, baseKey: chunkBaseKey, dimension: dimension)
        var subChunkCache: [Int8:MCSubChunk] = [:]
        var noExistsSubChunks: Set<Int8> = []
        let unknownBlock = TexturePixelData(height: 0, waterdepth: 0, blockType: .unknown)

        let localChunkXInRegion = Int(convertPos(from: chunkX, .chunkToIndexInRegion))
        let localChunkZInRegion = Int(convertPos(from: chunkZ, .chunkToIndexInRegion))
        let blockIndexOffset = localChunkZInRegion * MCSubChunk.sideLength * MCRegion.sideLength + localChunkXInRegion * MCSubChunk.sideLength

        for localBlockZInChunk in 0..<MCSubChunk.sideLength {
            for localBlockXInChunk in 0..<MCSubChunk.sideLength {
                let blockIndexInRegion = blockIndexOffset + localBlockZInChunk * MCRegion.sideLength + localBlockXInChunk
                if noExistsSubChunks.count == dimension.chunkYRange.count {
                    pixelDataList.withUnsafeMutableBufferPointer { buffer in
                        buffer[blockIndexInRegion] = unknownBlock
                    }
                    continue
                }

                var waterDepth: UInt8 = 0
                var allTransparent = true
                var pixel: TexturePixelData? = nil
                for chunkY in stride(from: dimension.chunkYRange.upperBound, through: dimension.chunkYRange.lowerBound, by: -1) {
                    guard !Task.isCancelled else {
                        return
                    }
                    guard !noExistsSubChunks.contains(chunkY) else {
                        continue
                    }
                    let subChunk: MCSubChunk
                    if let cached = subChunkCache[chunkY] {
                        subChunk = cached
                    } else if let loaded = ChunkDataLoader.loadSubChunk(iter: iter, baseKey: chunkBaseKey, chunkY: chunkY) {
                        subChunkCache[chunkY] = loaded
                        subChunk = loaded
                    } else {
                        noExistsSubChunks.insert(chunkY)
                        continue
                    }

                    subChunk.traverseYDescendingColumn(atLocalX: localBlockXInChunk, localZ: localBlockZInChunk) { localY, block in
                        if block.type.isWater {
                            waterDepth += 1
                            allTransparent = false
                            return false
                        }
                        if block.type.isTransparent || block.type.isPlant {
                            return false
                        }
                        allTransparent = false
                        let blockY = Int(chunkY) * MCSubChunk.sideLength + localY
                        let height = min(max(blockY-dimension.blockYRange.lowerBound, 0), 511)
                        pixel = TexturePixelData(height: height, waterdepth: Int(waterDepth), blockType: block.type)
                        if let biome = biomeColumn?.biome(atLocalX: localBlockXInChunk, blockY: blockY, localZ: localBlockZInChunk) {
                            biomeList.withUnsafeMutableBufferPointer { buffer in
                                buffer[blockIndexInRegion] = MCBiomeGroup.from(biome)
                            }
                        }
                        return true
                    }
                    if pixel != nil {
                        break
                    }
                }

                pixelDataList.withUnsafeMutableBufferPointer { buffer in
                    if let validPixel = pixel {
                        buffer[blockIndexInRegion] = validPixel
                    } else if waterDepth > 0 {
                        buffer[blockIndexInRegion] = TexturePixelData(height: 0, waterdepth: Int(waterDepth), blockType: .water)
                    } else if allTransparent {
                        buffer[blockIndexInRegion] = TexturePixelData(height: 0, waterdepth: 0, blockType: .air)
                    } else {
                        buffer[blockIndexInRegion] = TexturePixelData(height: 0, waterdepth: 0, blockType: .unknown)
                    }
                }
            }
        }
    }

    private static func convertToRGBAList(from pixelDataList: [TexturePixelData], biomes: [MCBiomeGroup], width: Int, height: Int) -> [RGBA] {
        let deltaPairs: [(Int, Int)] = [
            (-1, -1), ( 1, -1), ( 1,  1), (-1,  1),
            (-2, -2), ( 2, -2), ( 2,  2), (-2,  2),
            ( 0, -2), ( 2,  0), ( 0,  2), (-2,  0),
//            (-3, -3), ( 3, -3), ( 3,  3), (-3,  3),
            (-4, -4), ( 4, -4), ( 4,  4), (-4,  4),
            ( 0, -4), ( 4,  0), ( 0,  4), (-4,  0),
            (-5, -2), (-2, -5), ( 2, -5), ( 2, -2),
            ( 5,  2), ( 2,  5), (-2,  5), (-2,  2),
            ( 0, -6), ( 6,  0), ( 0,  6), (-6,  0),
            (-4, -7), (-2, -7), ( 2, -7), ( 4, -7),
            ( 7, -4), ( 7, -2), ( 7,  2), ( 7,  4),
            (-4,  7), (-2,  7), ( 2,  7), ( 4,  7),
            (-7, -4), (-7, -2), (-7,  2), (-7,  4),
            (-6, -6), ( 6, -6), ( 6,  6), (-6,  6),
//            (-7, -7), ( 7, -7), ( 7,  7), (-7,  7),
        ]
        var pixels: [RGBA] = .init(repeating: (0,0,0,0), count: width * height)
        var biomeRadiusCache: [UInt8] = .init(repeating: 0, count: width * height)
        var isNearBorder: [Bool] = .init(repeating: false, count: width * height)

        for z in stride(from: 1, to: height-1, by: 1) {
            for x in stride(from: 1, to: width-1, by: 1) {
                let index = z * width + x
                let currentBiome = biomes[index]
                for dz in -1...1 {
                    for dx in -1...1 where dx != 0 || dz != 0 {
                        let neighborIndex = (z + dz) * width + (x + dx)
                        if biomes[neighborIndex] != currentBiome {
                            isNearBorder[index] = true
                            break
                        }
                    }
                    if isNearBorder[index] { break }
                }
            }
        }

        for z in stride(from: 0, to: height, by: 1) {
            for x in stride(from: 0, to: width, by: 1) {
                let pixelIndex = z * width + x
                let pixelData = pixelDataList[pixelIndex]
                guard pixelData.height >= 0 else {
                    continue
                }
                let biomeType = biomes[pixelIndex]
                var biomeRadius: UInt8 = 7
                if isNearBorder[pixelIndex] && (7..<width-7) ~= x && (7..<height-7) ~= z {
                    for delta in deltaPairs {
                        let dx = delta.0, dz = delta.1
                        let bx = x + dx, bz = z + dz
                        let neighborIndex = bz * width + bx
                        if biomes[neighborIndex] != biomeType {
                            biomeRadius = UInt8(min(7, max(1, min(abs(dx), abs(dz)))))
                            break
                        }
                    }
                } else {
                    biomeRadius = 7
                    if x > 0 && biomes[pixelIndex - 1] == biomeType {
                        biomeRadius = min(biomeRadius, biomeRadiusCache[pixelIndex - 1])
                    }
                    if z > 0 && biomes[pixelIndex - width] == biomeType {
                        biomeRadius = min(biomeRadius, biomeRadiusCache[pixelIndex - width])
                    }
                }
                biomeRadiusCache[pixelIndex] = biomeRadius
                pixels.withUnsafeMutableBufferPointer { ptr in
                    ptr[pixelIndex] = packPixelInfomation(
                        height: UInt32(truncatingIfNeeded: pixelData.height),
                        waterDepth: UInt8(truncatingIfNeeded: pixelData.waterDepth),
                        blockType: pixelData.blockType,
                        biomeType: biomeType,
                        biomeRadius: UInt8(truncatingIfNeeded: biomeRadius)
                    )
                }
            }
        }

//        for z in stride(from: 0, to: height, by: 1) {
//            for x in stride(from: 0, to: width, by: 1) {
//                let pixelIndex = z * width + x
//                let pixelData = pixelDataList[pixelIndex]
//                guard pixelData.height >= 0 else {
//                    continue
//                }
//                let biomeType = biomes[pixelIndex]
//                var biomeRadius: Int = 7
//                if (7..<width-7) ~= x && (7..<height-7) ~= z {
//                    for delta in deltaPairs {
//                        let biomeIndex = (z + delta.1) * width + x + delta.0
//                        let nextBiomeType = biomes[biomeIndex]
//                        if nextBiomeType != biomeType {
//                            biomeRadius = min(min(biomeRadius, abs(delta.0)), abs(delta.1))
//                            break
//                        }
//                    }
//                } else {
//                    biomeRadius = 0
//                }
//                pixels.withUnsafeMutableBufferPointer { ptr in
//                    ptr[pixelIndex] = packPixelInfomation(
//                        height: UInt32(truncatingIfNeeded: pixelData.height),
//                        waterDepth: UInt8(truncatingIfNeeded: pixelData.waterDepth),
//                        blockType: pixelData.blockType,
//                        biomeType: biomeType,
//                        biomeRadius: UInt8(truncatingIfNeeded: biomeRadius)
//                    )
//                }
//            }
//        }

        return pixels
    }

    private static func packPixelInfomation(height: UInt32, waterDepth: UInt8, blockType: MCBlockType, biomeType: MCBiomeGroup, biomeRadius: UInt8) -> RGBA {
        /*
         // [v4 pixel info layout]
         // height:                 9bit
         // block/waterDepth flag:  1bit (1 = block, 0 = water depth)
         // blockID or waterDepth: 16bit
         // biomeID:                3bit
         // biomeRadius:            3bit

         Packed into 32-bit as:
         AAAAAAAARRRRRRRRGGGGGGGGBBBBBBBB ----

         hhhhhhhhhfwwwwwwwwwwwwwwwwbbbrrr : v4
         hhhhhhhhhwwwwwwwbbboooooooooorrr : v3
         hhhhhhhhwwwwwwwbbbboooooooooorrr : v2
         */
        #if DEBUG
        assert(MCBiomeGroup.allCases.count <= (1 << 3))  // biome ID must fit in 3 bits
        assert(MCBlockType.allCases.count <= (1 << 16)) // block ID must fit in 16 bits
        #endif

        // Convert waterDepth to a 7-bit scale (0–127)
        var scaledDepth: UInt32 = UInt32(Double(waterDepth) / 255.0 * 127.0)
        if waterDepth > 0 && scaledDepth == 0 {
            scaledDepth = 1
        }

        // Clamp height to 9 bits
        let h = min(height, 0x1FF)
        let isBlock = waterDepth == 0
        let blockOrDepth: UInt32 = isBlock ? UInt32(blockType.id) : scaledDepth
        // Flag at bit 22
        let f: UInt32 = isBlock ? 0x400000 : 0

        let biome = UInt32(biomeType.rawValue & 0x7)    // 3-bit biome
        let radius = UInt32(biomeRadius & 0x7)          // 3-bit biome radius

        let packed: UInt32 =
        (h << 23) |                         // (bits 31–23) 9-bit height
        f |                                 // (bit  22   ) 1-bit block/water flag
        ((blockOrDepth & 0xFFFF) << 6) |    // (bits 21–6 ) 16-bit block ID or water depth
        (biome << 3) |                      // (bits 5–3  ) 3-bit biome
        radius                              // (bits 2–0  ) 3-bit biome radius

        // Convert to RGBA components
        let r = UInt8((packed >> 24) & 0xFF)
        let g = UInt8((packed >> 16) & 0xFF)
        let b = UInt8((packed >> 8) & 0xFF)
        let a = UInt8(packed & 0xFF)

        return (red: r, green: g, blue: b, alpha: a)
    }
}
