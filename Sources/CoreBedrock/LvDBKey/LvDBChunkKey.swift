//
// Created by yechentide on 2026/08/02
//

//
// A structural LevelDB chunk key. Unlike `LvDBKey`, this type accepts unknown
// record tags so bulk operations can preserve future Bedrock data.
//

import Foundation

struct LvDBChunkKey: Sendable, Hashable {
    let x: Int32
    let z: Int32
    let dimension: MCDimension
    let tag: UInt8
    let subChunkY: Int8?

    init?(data: Data) {
        // Some fixed string keys happen to be 9 bytes long and therefore have
        // the same length as an overworld chunk key (for example `BiomeData`).
        // Classify known non-chunk keys first to avoid destructive callers
        // treating them as chunk records.
        guard LvDBKey.parseStringKey(data: data) == nil,
              LvDBKey.parsePlayerKey(data: data) == nil,
              LvDBKey.parseMapKey(data: data) == nil,
              LvDBKey.parseVillageKey(data: data) == nil,
              LvDBKey.parseStructureKey(data: data) == nil,
              LvDBKey.parseActorKey(data: data) == nil,
              LvDBKey.parseDigpKey(data: data) == nil,
              LvDBKey.parseRealmsStoriesDataKey(data: data) == nil,
              LvDBKey.parsePositionTrackKey(data: data) == nil,
              LvDBKey.parseTickingAreaKey(data: data) == nil,
              LvDBKey.parseChunkLoadedRequestKey(data: data) == nil
        else {
            return nil
        }
        guard [9, 10, 13, 14].contains(data.count),
              let x = data[0..<4].int32,
              let z = data[4..<8].int32
        else {
            return nil
        }

        let hasDimension = data.count == 13 || data.count == 14
        let tagOffset = hasDimension ? 12 : 8
        let hasY = data.count == 10 || data.count == 14
        let tag = data[tagOffset]

        // Only SubChunk records have a trailing byte in documented formats.
        // Do not mistake an arbitrary future record shape for a subchunk.
        guard !hasY || tag == LvDBChunkKeyType.subChunkPrefix.rawValue else {
            return nil
        }

        let dimension: MCDimension
        if hasDimension {
            guard let raw = data[8..<12].int32,
                  let parsed = MCDimension(rawValue: raw)
            else {
                return nil
            }

            dimension = parsed
        } else {
            dimension = .overworld
        }

        self.x = x
        self.z = z
        self.dimension = dimension
        self.tag = tag
        self.subChunkY = hasY ? Int8(bitPattern: data[tagOffset + 1]) : nil
    }
}
