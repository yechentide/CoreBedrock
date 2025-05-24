//
// Created by yechentide on 2025/04/22
//

public final class MCBiomeSection {
    public let chunkY: Int8
    public private(set) var palette: [MCBiomeType]
    public private(set) var indices: [UInt16]

    public init(chunkY: Int8) {
        self.chunkY = chunkY
        self.palette = []
        self.indices = []
    }

    public init(chunkY: Int8, palette: [MCBiomeType], indices: [UInt16]) {
        self.chunkY = chunkY
        self.palette = palette
        self.indices = indices
    }

    public init(chunkY: Int8, uniform type: MCBiomeType) {
        self.chunkY = chunkY
        self.palette = [type]
        self.indices = Array(repeating: 0, count: MCSubChunk.totalBlockCount)
    }

    public func biome(atLocalX localX: Int, localY: Int, localZ: Int) -> MCBiomeType? {
        guard let index = MCSubChunk.linearIndex(localX, localY, localZ),
              0..<indices.count ~= index
        else {
            return nil
        }
        let paletteIndex = Int(indices[index])
        guard paletteIndex < palette.count
        else {
            return nil
        }
        return palette[paletteIndex]
    }

    public func setBiome(_ type: MCBiomeType, localX: Int, localY: Int, localZ: Int) {
        guard let index = MCSubChunk.linearIndex(localX, localY, localZ),
              0..<indices.count ~= index
        else {
            return
        }

        if let existingIndex = palette.firstIndex(of: type),
           let paletteIndex = UInt16(exactly: existingIndex)
        {
            self.indices[index] = paletteIndex
            return
        }

        if let paletteIndex = UInt16(exactly: self.palette.count) {
            self.indices[index] = paletteIndex
            self.palette.append(type)
        }
    }

    @discardableResult
    public func setColumnBiomes(_ biomesXZ: [[MCBiomeType]]) -> Bool {
        let side = MCSubChunk.sideLength
        let blockCount = MCSubChunk.totalBlockCount

        guard biomesXZ.count == side, biomesXZ.allSatisfy({ $0.count == side }) else {
            return false
        }

        self.palette.removeAll()
        self.indices = Array(repeating: 0, count: blockCount)

        var lookup = [MCBiomeType: UInt16]()
        for x in 0..<MCSubChunk.sideLength {
            for z in 0..<MCSubChunk.sideLength {
                let biome = biomesXZ[x][z]
                if lookup[biome] == nil {
                    let nextIndex = UInt16(palette.count)
                    guard nextIndex <= UInt16(Int8.max) else {
                        return false
                    }
                    self.palette.append(biome)
                    lookup[biome] = nextIndex
                }
            }
        }

        var offset = 0
        for x in 0..<MCSubChunk.sideLength {
            for z in 0..<MCSubChunk.sideLength {
                guard let paletteIndex = lookup[biomesXZ[x][z]] else {
                    return false
                }
                for _ in 0..<side {
                    self.indices[offset] = paletteIndex
                    offset += 1
                }
            }
        }

        return true
    }

    public func fill(_ type: MCBiomeType) {
        self.palette = [type]
        self.indices = Array(repeating: 0, count: MCSubChunk.totalBlockCount)
    }
}
