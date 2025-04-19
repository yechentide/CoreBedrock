//

//

extension MCBiomeType {
    public var id: UInt16 {
        switch self {
            case .unknown:                          UInt16.max
            case .ocean:                            0
            case .plains:                           1
            case .desert:                           2
            case .extremeHills:                     3
            case .forest:                           4
            case .taiga:                            5
            case .swampland:                        6
            case .river:                            7
            case .hell:                             8
            case .theEnd:                           9
            case .legacyFrozenOcean:                10
            case .frozenRiver:                      11
            case .icePlains:                        12
            case .iceMountains:                     13
            case .mushroomIsland:                   14
            case .mushroomIslandShore:              15
            case .beach:                            16
            case .desertHills:                      17
            case .forestHills:                      18
            case .taigaHills:                       19
            case .extremeHillsEdge:                 20
            case .jungle:                           21
            case .jungleHills:                      22
            case .jungleEdge:                       23
            case .deepOcean:                        24
            case .stoneBeach:                       25
            case .coldBeach:                        26
            case .birchForest:                      27
            case .birchForestHills:                 28
            case .roofedForest:                     29
            case .coldTaiga:                        30
            case .coldTaigaHills:                   31
            case .megaTaiga:                        32
            case .megaTaigaHills:                   33
            case .extremeHillsPlusTrees:            34
            case .savanna:                          35
            case .savannaPlateau:                   36
            case .mesa:                             37
            case .mesaPlateauStone:                 38
            case .mesaPlateau:                      39
            case .warmOcean:                        40
            case .deepWarmOcean:                    41
            case .lukewarmOcean:                    42
            case .deepLukewarmOcean:                43
            case .coldOcean:                        44
            case .deepColdOcean:                    45
            case .frozenOcean:                      46
            case .deepFrozenOcean:                  47
            case .bambooJungle:                     48
            case .bambooJungleHills:                49
            case .sunflowerPlains:                  129
            case .desertMutated:                    130
            case .extremeHillsMutated:              131
            case .flowerForest:                     132
            case .taigaMutated:                     133
            case .swamplandMutated:                 134
            case .icePlainsSpikes:                  140
            case .jungleMutated:                    149
            case .jungleEdgeMutated:                151
            case .birchForestMutated:               155
            case .birchForestHillsMutated:          156
            case .roofedForestMutated:              157
            case .coldTaigaMutated:                 158
            case .redwoodTaigaMutated:              160
            case .redwoodTaigaHillsMutated:         161
            case .extremeHillsPlusTreesMutated:     162
            case .savannaMutated:                   163
            case .savannaPlateauMutated:            164
            case .mesaBryce:                        165
            case .mesaPlateauStoneMutated:          166
            case .mesaPlateauMutated:               167
            case .soulsandValley:                   178
            case .crimsonForest:                    179
            case .warpedForest:                     180
            case .basaltDeltas:                     181
            case .jaggedPeaks:                      182
            case .frozenPeaks:                      183
            case .snowySlopes:                      184
            case .grove:                            185
            case .meadow:                           186
            case .lushCaves:                        187
            case .dripstoneCaves:                   188
            case .stonyPeaks:                       189
            case .deepDark:                         190
            case .mangroveSwamp:                    191
            case .cherryGrove:                      192
            case .paleGarden:                       193
        }
    }

    public static func from(_ id: UInt32) -> MCBiomeType {
        let uint16 = UInt16(id)
        return from(uint16)
    }

    public static func from(_ id: UInt16) -> MCBiomeType {
        switch id {
            case 0:         return .ocean
            case 1:         return .plains
            case 2:         return .desert
            case 3:         return .extremeHills
            case 4:         return .forest
            case 5:         return .taiga
            case 6:         return .swampland
            case 7:         return .river
            case 8:         return .hell
            case 9:         return .theEnd
            case 10:        return .legacyFrozenOcean
            case 11:        return .frozenRiver
            case 12:        return .icePlains
            case 13:        return .iceMountains
            case 14:        return .mushroomIsland
            case 15:        return .mushroomIslandShore
            case 16:        return .beach
            case 17:        return .desertHills
            case 18:        return .forestHills
            case 19:        return .taigaHills
            case 20:        return .extremeHillsEdge
            case 21:        return .jungle
            case 22:        return .jungleHills
            case 23:        return .jungleEdge
            case 24:        return .deepOcean
            case 25:        return .stoneBeach
            case 26:        return .coldBeach
            case 27:        return .birchForest
            case 28:        return .birchForestHills
            case 29:        return .roofedForest
            case 30:        return .coldTaiga
            case 31:        return .coldTaigaHills
            case 32:        return .megaTaiga
            case 33:        return .megaTaigaHills
            case 34:        return .extremeHillsPlusTrees
            case 35:        return .savanna
            case 36:        return .savannaPlateau
            case 37:        return .mesa
            case 38:        return .mesaPlateauStone
            case 39:        return .mesaPlateau
            case 40:        return .warmOcean
            case 41:        return .deepWarmOcean
            case 42:        return .lukewarmOcean
            case 43:        return .deepLukewarmOcean
            case 44:        return .coldOcean
            case 45:        return .deepColdOcean
            case 46:        return .frozenOcean
            case 47:        return .deepFrozenOcean
            case 48:        return .bambooJungle
            case 49:        return .bambooJungleHills
            case 129:       return .sunflowerPlains
            case 130:       return .desertMutated
            case 131:       return .extremeHillsMutated
            case 132:       return .flowerForest
            case 133:       return .taigaMutated
            case 134:       return .swamplandMutated
            case 140:       return .icePlainsSpikes
            case 149:       return .jungleMutated
            case 151:       return .jungleEdgeMutated
            case 155:       return .birchForestMutated
            case 156:       return .birchForestHillsMutated
            case 157:       return .roofedForestMutated
            case 158:       return .coldTaigaMutated
            case 160:       return .redwoodTaigaMutated
            case 161:       return .redwoodTaigaHillsMutated
            case 162:       return .extremeHillsPlusTreesMutated
            case 163:       return .savannaMutated
            case 164:       return .savannaPlateauMutated
            case 165:       return .mesaBryce
            case 166:       return .mesaPlateauStoneMutated
            case 167:       return .mesaPlateauMutated
            case 178:       return .soulsandValley
            case 179:       return .crimsonForest
            case 180:       return .warpedForest
            case 181:       return .basaltDeltas
            case 182:       return .jaggedPeaks
            case 183:       return .frozenPeaks
            case 184:       return .snowySlopes
            case 185:       return .grove
            case 186:       return .meadow
            case 187:       return .lushCaves
            case 188:       return .dripstoneCaves
            case 189:       return .stonyPeaks
            case 190:       return .deepDark
            case 191:       return .mangroveSwamp
            case 192:       return .cherryGrove
            case 193:       return .paleGarden
            default:        return .unknown
        }
    }
}
