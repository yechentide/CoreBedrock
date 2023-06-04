public enum MCBiomeType: UInt16 {
    case unknown                      = 65535
    case ocean                        = 0
    case plains                       = 1
    case desert                       = 2
    case extremeHills                 = 3
    case forest                       = 4
    case taiga                        = 5
    case swampland                    = 6
    case river                        = 7
    case hell                         = 8
    case theEnd                       = 9
    case legacyFrozenOcean            = 10
    case frozenRiver                  = 11
    case icePlains                    = 12
    case iceMountains                 = 13
    case mushroomIsland               = 14
    case mushroomIslandShore          = 15
    case beach                        = 16
    case desertHills                  = 17
    case forestHills                  = 18
    case taigaHills                   = 19
    case extremeHillsEdge             = 20
    case jungle                       = 21
    case jungleHills                  = 22
    case jungleEdge                   = 23
    case deepOcean                    = 24
    case stoneBeach                   = 25
    case coldBeach                    = 26
    case birchForest                  = 27
    case birchForestHills             = 28
    case roofedForest                 = 29
    case coldTaiga                    = 30
    case coldTaigaHills               = 31
    case megaTaiga                    = 32
    case megaTaigaHills               = 33
    case extremeHillsPlusTrees        = 34
    case savanna                      = 35
    case savannaPlateau               = 36
    case mesa                         = 37
    case mesaPlateauStone             = 38
    case mesaPlateau                  = 39
    case warmOcean                    = 40
    case deepWarmOcean                = 41
    case lukewarmOcean                = 42
    case deepLukewarmOcean            = 43
    case coldOcean                    = 44
    case deepColdOcean                = 45
    case frozenOcean                  = 46
    case deepFrozenOcean              = 47
    case bambooJungle                 = 48
    case bambooJungleHills            = 49
    case sunflowerPlains              = 129
    case desertMutated                = 130
    case extremeHillsMutated          = 131
    case flowerForest                 = 132
    case taigaMutated                 = 133
    case swamplandMutated             = 134
    case icePlainsSpikes              = 140
    case jungleMutated                = 149
    case jungleEdgeMutated            = 151
    case birchForestMutated           = 155
    case birchForestHillsMutated      = 156
    case roofedForestMutated          = 157
    case coldTaigaMutated             = 158
    case redwoodTaigaMutated          = 160
    case redwoodTaigaHillsMutated     = 161
    case extremeHillsPlusTreesMutated = 162
    case savannaMutated               = 163
    case savannaPlateauMutated        = 164
    case mesaBryce                    = 165
    case mesaPlateauStoneMutated      = 166
    case mesaPlateauMutated           = 167
    case soulsandValley               = 178
    case crimsonForest                = 179
    case warpedForest                 = 180
    case basaltDeltas                 = 181
    case jaggedPeaks                  = 182
    case frozenPeaks                  = 183
    case snowySlopes                  = 184
    case grove                        = 185
    case meadow                       = 186
    case lushCaves                    = 187
    case dripstoneCaves               = 188
    case stonyPeaks                   = 189
    case deepDark                     = 190
    case mangroveSwamp                = 191
}

extension MCBiomeType: CustomStringConvertible {
    public var description: String {
        switch self {
            case .unknown:                      return "unknown"
            case .ocean:                        return "ocean"
            case .plains:                       return "plains"
            case .desert:                       return "desert"
            case .extremeHills:                 return "extreme_hills"
            case .forest:                       return "forest"
            case .taiga:                        return "taiga"
            case .swampland:                    return "swampland"
            case .river:                        return "river"
            case .hell:                         return "hell"
            case .theEnd:                       return "the_end"
            case .legacyFrozenOcean:            return "legacy_frozen_ocean"
            case .frozenRiver:                  return "frozen_river"
            case .icePlains:                    return "ice_plains"
            case .iceMountains:                 return "ice_mountains"
            case .mushroomIsland:               return "mushroom_island"
            case .mushroomIslandShore:          return "mushroom_island_shore"
            case .beach:                        return "beach"
            case .desertHills:                  return "desert_hills"
            case .forestHills:                  return "forest_hills"
            case .taigaHills:                   return "taiga_hills"
            case .extremeHillsEdge:             return "extreme_hills_edge"
            case .jungle:                       return "jungle"
            case .jungleHills:                  return "jungle_hills"
            case .jungleEdge:                   return "jungle_edge"
            case .deepOcean:                    return "deep_ocean"
            case .stoneBeach:                   return "stone_beach"
            case .coldBeach:                    return "cold_beach"
            case .birchForest:                  return "birch_forest"
            case .birchForestHills:             return "birch_forest_hills"
            case .roofedForest:                 return "roofed_forest"
            case .coldTaiga:                    return "cold_taiga"
            case .coldTaigaHills:               return "cold_taiga_hills"
            case .megaTaiga:                    return "mega_taiga"
            case .megaTaigaHills:               return "mega_taiga_hills"
            case .extremeHillsPlusTrees:        return "extreme_hills_plus_trees"
            case .savanna:                      return "savanna"
            case .savannaPlateau:               return "savanna_plateau"
            case .mesa:                         return "mesa"
            case .mesaPlateauStone:             return "mesa_plateau_stone"
            case .mesaPlateau:                  return "mesa_plateau"
            case .warmOcean:                    return "warm_ocean"
            case .deepWarmOcean:                return "deep_warm_ocean"
            case .lukewarmOcean:                return "lukewarm_ocean"
            case .deepLukewarmOcean:            return "deep_lukewarm_ocean"
            case .coldOcean:                    return "cold_ocean"
            case .deepColdOcean:                return "deep_cold_ocean"
            case .frozenOcean:                  return "frozen_ocean"
            case .deepFrozenOcean:              return "deep_frozen_ocean"
            case .bambooJungle:                 return "bamboo_jungle"
            case .bambooJungleHills:            return "bamboo_jungle_hills"
            case .sunflowerPlains:              return "sunflower_plains"
            case .desertMutated:                return "desert_mutated"
            case .extremeHillsMutated:          return "extreme_hills_mutated"
            case .flowerForest:                 return "flower_forest"
            case .taigaMutated:                 return "taiga_mutated"
            case .swamplandMutated:             return "swampland_mutated"
            case .icePlainsSpikes:              return "ice_plains_spikes"
            case .jungleMutated:                return "jungle_mutated"
            case .jungleEdgeMutated:            return "jungle_edge_mutated"
            case .birchForestMutated:           return "birch_forest_mutated"
            case .birchForestHillsMutated:      return "birch_forest_hills_mutated"
            case .roofedForestMutated:          return "roofed_forest_mutated"
            case .coldTaigaMutated:             return "cold_taiga_mutated"
            case .redwoodTaigaMutated:          return "redwood_taiga_mutated"
            case .redwoodTaigaHillsMutated:     return "redwood_taiga_hills_mutated"
            case .extremeHillsPlusTreesMutated: return "extreme_hills_plus_trees_mutated"
            case .savannaMutated:               return "savanna_mutated"
            case .savannaPlateauMutated:        return "savanna_plateau_mutated"
            case .mesaBryce:                    return "mesa_bryce"
            case .mesaPlateauStoneMutated:      return "mesa_plateau_stone_mutated"
            case .mesaPlateauMutated:           return "mesa_plateau_mutated"
            case .soulsandValley:               return "soulsand_valley"
            case .crimsonForest:                return "crimson_forest"
            case .warpedForest:                 return "warped_forest"
            case .basaltDeltas:                 return "basalt_deltas"
            case .jaggedPeaks:                  return "jagged_peaks"
            case .frozenPeaks:                  return "frozen_peaks"
            case .snowySlopes:                  return "snowy_slopes"
            case .grove:                        return "grove"
            case .meadow:                       return "meadow"
            case .lushCaves:                    return "lush_caves"
            case .dripstoneCaves:               return "dripstone_caves"
            case .stonyPeaks:                   return "stony_peaks"
            case .deepDark:                     return "deep_dark"
            case .mangroveSwamp:                return "mangrove_swamp"
        }
    }
}

extension MCBiomeType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
            case "ocean":                        self = .ocean
            case "plains":                       self = .plains
            case "desert":                       self = .desert
            case "extremeHills":                 self = .extremeHills
            case "forest":                       self = .forest
            case "taiga":                        self = .taiga
            case "swampland":                    self = .swampland
            case "river":                        self = .river
            case "hell":                         self = .hell
            case "theEnd":                       self = .theEnd
            case "legacyFrozenOcean":            self = .legacyFrozenOcean
            case "frozenRiver":                  self = .frozenRiver
            case "icePlains":                    self = .icePlains
            case "iceMountains":                 self = .iceMountains
            case "mushroomIsland":               self = .mushroomIsland
            case "mushroomIslandShore":          self = .mushroomIslandShore
            case "beach":                        self = .beach
            case "desertHills":                  self = .desertHills
            case "forestHills":                  self = .forestHills
            case "taigaHills":                   self = .taigaHills
            case "extremeHillsEdge":             self = .extremeHillsEdge
            case "jungle":                       self = .jungle
            case "jungleHills":                  self = .jungleHills
            case "jungleEdge":                   self = .jungleEdge
            case "deepOcean":                    self = .deepOcean
            case "stoneBeach":                   self = .stoneBeach
            case "coldBeach":                    self = .coldBeach
            case "birchForest":                  self = .birchForest
            case "birchForestHills":             self = .birchForestHills
            case "roofedForest":                 self = .roofedForest
            case "coldTaiga":                    self = .coldTaiga
            case "coldTaigaHills":               self = .coldTaigaHills
            case "megaTaiga":                    self = .megaTaiga
            case "megaTaigaHills":               self = .megaTaigaHills
            case "extremeHillsPlusTrees":        self = .extremeHillsPlusTrees
            case "savanna":                      self = .savanna
            case "savannaPlateau":               self = .savannaPlateau
            case "mesa":                         self = .mesa
            case "mesaPlateauStone":             self = .mesaPlateauStone
            case "mesaPlateau":                  self = .mesaPlateau
            case "warmOcean":                    self = .warmOcean
            case "deepWarmOcean":                self = .deepWarmOcean
            case "lukewarmOcean":                self = .lukewarmOcean
            case "deepLukewarmOcean":            self = .deepLukewarmOcean
            case "coldOcean":                    self = .coldOcean
            case "deepColdOcean":                self = .deepColdOcean
            case "frozenOcean":                  self = .frozenOcean
            case "deepFrozenOcean":              self = .deepFrozenOcean
            case "bambooJungle":                 self = .bambooJungle
            case "bambooJungleHills":            self = .bambooJungleHills
            case "sunflowerPlains":              self = .sunflowerPlains
            case "desertMutated":                self = .desertMutated
            case "extremeHillsMutated":          self = .extremeHillsMutated
            case "flowerForest":                 self = .flowerForest
            case "taigaMutated":                 self = .taigaMutated
            case "swamplandMutated":             self = .swamplandMutated
            case "icePlainsSpikes":              self = .icePlainsSpikes
            case "jungleMutated":                self = .jungleMutated
            case "jungleEdgeMutated":            self = .jungleEdgeMutated
            case "birchForestMutated":           self = .birchForestMutated
            case "birchForestHillsMutated":      self = .birchForestHillsMutated
            case "roofedForestMutated":          self = .roofedForestMutated
            case "coldTaigaMutated":             self = .coldTaigaMutated
            case "redwoodTaigaMutated":          self = .redwoodTaigaMutated
            case "redwoodTaigaHillsMutated":     self = .redwoodTaigaHillsMutated
            case "extremeHillsPlusTreesMutated": self = .extremeHillsPlusTreesMutated
            case "savannaMutated":               self = .savannaMutated
            case "savannaPlateauMutated":        self = .savannaPlateauMutated
            case "mesaBryce":                    self = .mesaBryce
            case "mesaPlateauStoneMutated":      self = .mesaPlateauStoneMutated
            case "mesaPlateauMutated":           self = .mesaPlateauMutated
            case "soulsandValley":               self = .soulsandValley
            case "crimsonForest":                self = .crimsonForest
            case "warpedForest":                 self = .warpedForest
            case "basaltDeltas":                 self = .basaltDeltas
            case "jaggedPeaks":                  self = .jaggedPeaks
            case "frozenPeaks":                  self = .frozenPeaks
            case "snowySlopes":                  self = .snowySlopes
            case "grove":                        self = .grove
            case "meadow":                       self = .meadow
            case "lushCaves":                    self = .lushCaves
            case "dripstoneCaves":               self = .dripstoneCaves
            case "stonyPeaks":                   self = .stonyPeaks
            case "deepDark":                     self = .deepDark
            case "mangroveSwamp":                self = .mangroveSwamp
            default:                             self = .unknown
        }
    }
}

extension MCBiomeType {
    public static func fromUInt32(_ value: UInt32) -> MCBiomeType? {
        let uint16 = UInt16(value)
        return MCBiomeType(rawValue: uint16)
    }
}
