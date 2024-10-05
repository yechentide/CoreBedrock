//
// Created by yechentide on 2024/10/05
//

import Foundation

//enum PaletteMetaType: UInt8 {
//    case persistence = 0
//    case runtime = 1
//}

public struct BlockDecoder: Sendable {
    private init() {}
    public static let shared = BlockDecoder()

    public func decodeV9(data: Data, offset: Int, layerCount: Int) throws -> [MCBlockLayer]? {
        guard data.count > offset, layerCount > 0 else { return nil }
        let reader = CBTagReader(CBBuffer(data[offset...]))
        var layers = [MCBlockLayer]()

        for _ in 1...layerCount {
            let type = try reader.readUInt8()
            // let paletteType = type & 0x01
            let bitsPerBlock = Int(type >> 1)
            guard 0 < bitsPerBlock, bitsPerBlock <= CBTagReader.wordBitSize,
                  let map = try reader.readWords(bitsPerBlock: bitsPerBlock)
            else {
                return nil
            }

            let paletteCount = try reader.readUInt32()
            guard let maxIndex = map.max(),
                  maxIndex < paletteCount,
                  paletteCount <= MCSubChunk.totalBlockCount
            else {
                return nil
            }

            var palettes = [MCBlock]()
            for _ in 1...paletteCount {
                guard let paletteTag = try? reader.readAsTag() as? CompoundTag,
                      let block = MCBlock.decode(paletteTag)
                else {
                    return nil
                }
                palettes.append(block)
                reader.resetState()
            }
            layers.append(MCBlockLayer(palettes: palettes, map: map))
        }

        return layers
    }
}
