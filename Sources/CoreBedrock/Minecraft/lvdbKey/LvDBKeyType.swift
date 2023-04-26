public enum LvDBKeyType {
    case subChunk(MCDimension, MCChunkKeyType)
    case string(MCStringKeyType)
    case player
    case map
    case village
    case structure
    case actorprefix
    case digp
    case unknown

    public var isNBT: Bool {
        switch self {
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
