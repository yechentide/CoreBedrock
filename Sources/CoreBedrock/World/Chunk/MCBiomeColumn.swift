//
// Created by yechentide on 2025/04/22
//

public final class MCBiomeColumn {
    public private(set) var sections: [MCBiomeSection]

    public init(sections: [MCBiomeSection]) {
        self.sections = sections
    }

    public init(minChunkY: Int8, maxChunkY: Int8) {
        self.sections = []
        for chunkY in minChunkY...maxChunkY {
            self.sections.append(MCBiomeSection(chunkY: chunkY))
        }
    }

    /// Adds a biome section from bottom to top (incremental Y)
    public func append(_ section: MCBiomeSection) {
        self.sections.append(section)
    }

    public func biome(atLocalX localX: Int, blockY: Int, localZ: Int) -> MCBiomeType? {
        guard let biomeSection = self.section(forBlockY: blockY) else {
            return nil
        }
        let chunkY = convertPos(from: blockY, .blockToChunk)
        let localY = blockY - chunkY * MCSubChunk.sideLength
        return biomeSection.biome(atLocalX: localX, localY: localY, localZ: localZ)
    }

    public func setBiome(_ type: MCBiomeType, atLocalX localX: Int, blockY: Int, localZ: Int) {
        guard let biomeSection = self.section(forBlockY: blockY) else {
            return
        }
        let chunkY = convertPos(from: blockY, .blockToChunk)
        let localY = blockY - chunkY * MCSubChunk.sideLength
        biomeSection.setBiome(type, localX: localX, localY: localY, localZ: localZ)
    }

    public func setColumnBiomes(_ biomesXZ: [[MCBiomeType]]) {
        for biomeSection in sections {
            biomeSection.setColumnBiomes(biomesXZ)
        }
    }

    private func section(forBlockY blockY: Int) -> MCBiomeSection? {
        let chunkY = convertPos(from: blockY, .blockToChunk)
        return self.sections.first(where: { $0.chunkY == chunkY })
    }
}
