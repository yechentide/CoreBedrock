//
// Created by yechentide on 2025/05/13
//

public enum MCBiomeGroup: UInt8, CaseIterable {
    case other
    case swamp, mangroveSwamp
    case ocean, lukewarmOcean, warmOcean, coldOcean
    case badlands

    public static func from(_ biome: MCBiomeType) -> Self {
        switch biome {
            case .ocean, .deepOcean:
                    .ocean
            case .lukewarmOcean, .deepLukewarmOcean:
                    .lukewarmOcean
            case .warmOcean, .deepWarmOcean:
                    .warmOcean
            case .coldOcean, .deepColdOcean, .frozenOcean, .deepFrozenOcean:
                    .coldOcean
            case .swampland, .swamplandMutated:
                    .swamp
            case .mangroveSwamp:
                    .mangroveSwamp
            case .mesa:
                    .badlands
            default:
                    .other
        }
    }

    public var oceanRGBA: RGBA {
        switch self {
            case .swamp:            (115, 133, 120, 255)
            case .mangroveSwamp:    ( 41,  81,  73, 255)
            case .ocean:            ( 51,  89, 162, 255)
            case .lukewarmOcean:    ( 43, 122, 170, 255)
            case .warmOcean:        ( 56, 150, 177, 255)
            case .coldOcean:        ( 50,  66, 158, 255)
            default:                ( 51,  89, 162, 255)
        }
    }

    public var foliageRGBA: RGBA {
        switch self {
            case .swamp:            (106, 116,  41, 255)
            case .badlands:         (158, 158, 157, 255)
            default:                ( 56,  95,  31, 255)
        }
    }
}
