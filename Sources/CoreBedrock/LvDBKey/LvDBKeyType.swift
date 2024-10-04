//
// Created by yechentide on 2024/10/04
//

public enum LvDBKeyType: Equatable {
    case subChunk(MCDimension, MCChunkKeyType)
    case string(MCStringKeyType)
    case player
    case map
    case village
    case structure
    case actorprefix
    case digp
    case unknown

    public var isNBTKey: Bool {
        switch self {
            case .subChunk(_, let subChunkType):
                switch subChunkType {
                    case .blockEntity, .pendingTicks, .randomTicks, .biomeState:
                        return true
                    default:
                        return false
                }
            case .string(let strType):
                switch strType {
                    case .localPlayer, .autonomousEntities, .biomeData,
                            .levelChunkMetaDataDictionary, .mobevents,
                            .overworld, .schedulerWT, .scoreboard:
                        return true
                    default:
                        return false
                }
            case .player, .map, .village, .structure, .actorprefix:
                return true
            default:
                return false
        }
    }
}
