//
// Created by yechentide on 2025/08/11
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

}
