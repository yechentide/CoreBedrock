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
}
