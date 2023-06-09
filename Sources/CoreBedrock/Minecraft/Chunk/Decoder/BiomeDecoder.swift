import Foundation

public struct BiomeDecoder {
    public init() {}

    public func decode(data: Data, offset: Int) throws -> [MCBiomeLayer]? {
        guard data.count > offset else { return nil }
        let reader = CBReader(CBBuffer(data[offset...]))
        var layers = [MCBiomeLayer]()

        while true {
            let type = try reader.readUInt8()
            guard type != 0x00, type != 0xFF else {
                break
            }

            if type == 1 {
                let biomeId = try reader.readUInt32()
                guard let biome = MCBiomeType.fromUInt32(biomeId) else {
                    return nil
                }
                layers.append(MCBiomeLayer(singlePalette: biome))
                continue
            }

            let bitsPerBlock = Int(type / 2)
            guard let map = try reader.readWords(bitsPerBlock: bitsPerBlock) else {
                return nil
            }

            let paletteCount = try reader.readUInt32()
            guard let maxIndex = map.max(),
                  maxIndex < paletteCount,
                  paletteCount <= MCSubChunk.totalBlockCount,
                  reader.unreadCount >= paletteCount * 4
            else {
                return nil
            }

            var palettes = [MCBiomeType]()
            for _ in 0 ..< paletteCount {
                let biomeId = try reader.readUInt32()
                guard let biome = MCBiomeType.fromUInt32(biomeId) else {
                    return nil
                }
                palettes.append(biome)
            }
            layers.append(MCBiomeLayer(palettes: palettes, map: map))
        }

        return layers
    }
}
