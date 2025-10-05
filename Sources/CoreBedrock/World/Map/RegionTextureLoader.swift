////
//// Created by yechentide on 2025/09/19
////
//
//import OSLog
//import CoreGraphics
//import LvDBWrapper
//
///*
// Coordinate Naming Convention:
//
// World-space coordinates:
// - regionX, regionY       : Region position in the world
// - chunkX, chunkY         : Chunk position in the world
// - blockX, blockY         : Block position in the world
//
// Local coordinates:
// - chunkXInRegion, chunkYInRegion : Chunk position relative to its Region
// - blockXInChunk, blockYInChunk   : Block position relative to its Chunk
// */
//
//extension BlockColorTable {
//    func generateTexture() -> CGImage? {
//        let blockCount = self.palette.count
//        let k = Int(ceil(log2(Double(blockCount)) / 2))
//        let size = 1 << (k + 1)
//        return CGImage.from(colors: self.palette, width: size, height: size)
//    }
//}
//
//public struct RegionTextureLoader {
//    let db: LvDB
//    let tables: BlockDataTables
//
//    public func load(dimension: MCDimension, region: MCRegion, lastPlayed: Int64?, useCache: Bool) throws -> CGImage? {
//        CBLogger.debug("Loading Region (\(region.x),\(region.z)) ......")
//        var image: CGImage? = nil
//        autoreleasepool {
//            do {
//                let pixels: [RGBA] = try generateRegionPixelsFromDB(dimension: dimension, region: region)
//                if Task.isCancelled {
//                    return
//                }
//                image = CGImage.from(colors: pixels, width: MCRegion.sideLength, height: MCRegion.sideLength, flipVertically: true)
//            } catch {
//                CBLogger.warning(error.localizedDescription)
//                return
//            }
//        }
//        return image
//    }
//
//    private func generateRegionPixelsFromDB(dimension: MCDimension, region: MCRegion) throws -> [RGBA] {
//        let iter = try db.makeIterator()
//        defer {
//            iter.destroy()
//        }
//
//        let width = Int(MCRegion.sideLength)
//        let height = Int(MCRegion.sideLength)
//
//        var pixelDataList: [TexturePixelData] = .init(
//            repeating: .init(height: 0, waterDepth: 0, blockPaletteIndex: 0, biomeID: 0),
//            count: width * height
//        )
//        pixelDataList.reserveCapacity(width * height)
//        print("\(#line): pixelDataList's capacity = \(pixelDataList.capacity)")
//
//        Task {
//            await ExecutionTimer.shared.start()
//        }
//        for chunkZ in (region.z*32)..<(region.z*32+32) {
//            for chunkX in (region.x*32)..<(region.x*32+32) {
//                if Task.isCancelled {
//                    return []
//                }
//                autoreleasepool {
//                    let loader = ChunkTextureLoader(
//                        iterator: iter,
//                        dimension: dimension,
//                        chunkX: chunkX,
//                        chunkZ: chunkZ,
//                        blockDataTables: tables
//                    )
//                    loader.extractChunkData(texturePixels: &pixelDataList)
//                }
//            }
//        }
//        Task {
//            await ExecutionTimer.shared.stop(showMessage: true)
//        }
//
//        if Task.isCancelled {
//            return []
//        }
//        let pixels = convertToRGBAList(from: pixelDataList, width: width, height: height)
//        return pixels
//    }
//
//
//    private func convertToRGBAList(from pixelDataList: [TexturePixelData], width: Int, height: Int) -> [RGBA] {
//        let deltaPairs: [(Int, Int)] = [
//            (-1, -1), ( 1, -1), ( 1,  1), (-1,  1),
//            (-2, -2), ( 2, -2), ( 2,  2), (-2,  2),
//            ( 0, -2), ( 2,  0), ( 0,  2), (-2,  0),
//            // (-3, -3), ( 3, -3), ( 3,  3), (-3,  3),
//            (-4, -4), ( 4, -4), ( 4,  4), (-4,  4),
//            ( 0, -4), ( 4,  0), ( 0,  4), (-4,  0),
//            (-5, -2), (-2, -5), ( 2, -5), ( 2, -2),
//            ( 5,  2), ( 2,  5), (-2,  5), (-2,  2),
//            ( 0, -6), ( 6,  0), ( 0,  6), (-6,  0),
//            (-4, -7), (-2, -7), ( 2, -7), ( 4, -7),
//            ( 7, -4), ( 7, -2), ( 7,  2), ( 7,  4),
//            (-4,  7), (-2,  7), ( 2,  7), ( 4,  7),
//            (-7, -4), (-7, -2), (-7,  2), (-7,  4),
//            (-6, -6), ( 6, -6), ( 6,  6), (-6,  6),
//            // (-7, -7), ( 7, -7), ( 7,  7), (-7,  7),
//        ]
//        var pixels: [RGBA] = .init(repeating: (0,0,0,0), count: width * height)
////        var biomeRadiusCache: [UInt8] = .init(repeating: 0, count: width * height)
////        var isNearBorder: [Bool] = .init(repeating: false, count: width * height)
//
////        for z in stride(from: 1, to: height-1, by: 1) {
////            for x in stride(from: 1, to: width-1, by: 1) {
////                let index = z * width + x
////                let currentBiome = pixelDataList[index].biomeID
////                for dz in -1...1 {
////                    for dx in -1...1 where dx != 0 || dz != 0 {
////                        let neighborIndex = (z + dz) * width + (x + dx)
////                        if pixelDataList[neighborIndex].biomeID != currentBiome {
////                            isNearBorder[index] = true
////                            break
////                        }
////                    }
////                    if isNearBorder[index] { break }
////                }
////            }
////        }
////
////        for z in stride(from: 0, to: height, by: 1) {
////            for x in stride(from: 0, to: width, by: 1) {
////                let pixelIndex = z * width + x
////                let pixelData = pixelDataList[pixelIndex]
////                guard pixelData.height >= 0 else {
////                    continue
////                }
////                let biomeType = pixelDataList[pixelIndex].biomeID
////                var biomeRadius: UInt8 = 7
////                if isNearBorder[pixelIndex] && (7..<width-7) ~= x && (7..<height-7) ~= z {
////                    for delta in deltaPairs {
////                        let dx = delta.0, dz = delta.1
////                        let bx = x + dx, bz = z + dz
////                        let neighborIndex = bz * width + bx
////                        if pixelDataList[neighborIndex].biomeID != biomeType {
////                            biomeRadius = UInt8(min(7, max(1, min(abs(dx), abs(dz)))))
////                            break
////                        }
////                    }
////                } else {
////                    biomeRadius = 7
////                    if x > 0 && pixelDataList[pixelIndex - 1].biomeID == biomeType {
////                        biomeRadius = min(biomeRadius, biomeRadiusCache[pixelIndex - 1])
////                    }
////                    if z > 0 && pixelDataList[pixelIndex - width].biomeID == biomeType {
////                        biomeRadius = min(biomeRadius, biomeRadiusCache[pixelIndex - width])
////                    }
////                }
////                biomeRadiusCache[pixelIndex] = biomeRadius
////                pixels.withUnsafeMutableBufferPointer { ptr in
////                    ptr[pixelIndex] = packPixelInfomation(
////                        height: UInt32(truncatingIfNeeded: pixelData.height),
////                        waterDepth: UInt8(truncatingIfNeeded: pixelData.waterDepth),
////                        blockID: pixelData.blockPaletteIndex,
////                        biomeID: biomeType,
////                        biomeRadius: UInt8(truncatingIfNeeded: biomeRadius)
////                    )
////                }
////            }
////        }
//
//         for z in stride(from: 0, to: height, by: 1) {
//             for x in stride(from: 0, to: width, by: 1) {
//                 let pixelIndex = z * width + x
//                 let pixelData = pixelDataList[pixelIndex]
//                 guard pixelData.height >= 0 else {
//                     continue
//                 }
//                 let biomeType = pixelDataList[pixelIndex].biomeID
//                 var biomeRadius: Int = 7
////                 if (7..<width-7) ~= x && (7..<height-7) ~= z {
////                     for delta in deltaPairs {
////                         let biomeIndex = (z + delta.1) * width + x + delta.0
////                         let nextBiomeType = pixelDataList[biomeIndex].biomeID
////                         if nextBiomeType != biomeType {
////                             biomeRadius = min(min(biomeRadius, abs(delta.0)), abs(delta.1))
////                             break
////                         }
////                     }
////                 } else {
////                     biomeRadius = 0
////                 }
//                 pixels.withUnsafeMutableBufferPointer { ptr in
//                     ptr[pixelIndex] = packPixelInfomation(
//                         height: UInt32(truncatingIfNeeded: pixelData.height),
//                         waterDepth: UInt8(truncatingIfNeeded: pixelData.waterDepth),
//                         blockID: pixelData.blockPaletteIndex,
//                         biomeID: biomeType,
//                         biomeRadius: UInt8(truncatingIfNeeded: biomeRadius)
//                     )
//                 }
//             }
//         }
//
//        return pixels
//    }
//
//    private func packPixelInfomation(height: UInt32, waterDepth: UInt8, blockID: UInt32, biomeID: UInt32, biomeRadius: UInt8) -> RGBA {
//        if waterDepth > 0 {
//            return tables.color.valueOfWater
//        }
//        return tables.color.palette[Int(blockID)]
//        /*
//         // [v4 pixel info layout]
//         // height:                 9bit
//         // block/waterDepth flag:  1bit (1 = block, 0 = water depth)
//         // blockID or waterDepth: 16bit
//         // biomeID:                3bit
//         // biomeRadius:            3bit
//
//         Packed into 32-bit as:
//         AAAAAAAARRRRRRRRGGGGGGGGBBBBBBBB ----
//
//         hhhhhhhhhfwwwwwwwwwwwwwwwwbbbrrr : v4
//         hhhhhhhhhwwwwwwwbbboooooooooorrr : v3
//         hhhhhhhhwwwwwwwbbbboooooooooorrr : v2
//         */
//
////        // Convert waterDepth to a 7-bit scale (0–127)
////        var scaledDepth: UInt32 = UInt32(Double(waterDepth) / 255.0 * 127.0)
////        if waterDepth > 0 && scaledDepth == 0 {
////            scaledDepth = 1
////        }
////
////        // Clamp height to 9 bits
////        let h = min(height, 0x1FF)
////        let isBlock = waterDepth == 0
////        let blockOrDepth: UInt32 = isBlock ? blockID : scaledDepth
////        // Flag at bit 22
////        let f: UInt32 = isBlock ? 0x400000 : 0
////
////        let biome = UInt32(biomeID & 0x7)       // 3-bit biome
////        let radius = UInt32(biomeRadius & 0x7)  // 3-bit biome radius
////
////        let packed: UInt32 =
////            (h << 23) |                         // (bits 31–23) 9-bit height
////            f |                                 // (bit  22   ) 1-bit block/water flag
////            ((blockOrDepth & 0xFFFF) << 6) |    // (bits 21–6 ) 16-bit block ID or water depth
////            (biome << 3) |                      // (bits 5–3  ) 3-bit biome
////            radius                              // (bits 2–0  ) 3-bit biome radius
////
////        // Convert to RGBA components
////        let r = UInt8((packed >> 24) & 0xFF)
////        let g = UInt8((packed >> 16) & 0xFF)
////        let b = UInt8((packed >> 8) & 0xFF)
////        let a = UInt8(packed & 0xFF)
////
////        return (red: r, green: g, blue: b, alpha: a)
//    }
//}
