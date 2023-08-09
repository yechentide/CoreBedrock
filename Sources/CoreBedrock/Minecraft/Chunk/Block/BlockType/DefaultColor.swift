import Foundation

extension MCBlockType {
    public enum dyeColor {
        case white
        case lightGray
        case gray
        case black
        case brown
        case red
        case orange
        case yellow
        case lime
        case green
        case cyan
        case lightBlue
        case blue
        case purple
        case magenta
        case pink

        var argb: UInt32 {
            switch self {
                case .white:                    return 0xFF
                case .lightGray:                return 0xFF
                case .gray:                     return 0xFF
                case .black:                    return 0xFF
                case .brown:                    return 0xFF
                case .red:                      return 0xFF
                case .orange:                   return 0xFF
                case .yellow:                   return 0xFF
                case .lime:                     return 0xFF
                case .green:                    return 0xFF
                case .cyan:                     return 0xFF
                case .lightBlue:                return 0xFF
                case .blue:                     return 0xFF
                case .purple:                   return 0xFF
                case .magenta:                  return 0xFF
                case .pink:                     return 0xFF
            }
        }
    }

    public enum DefaultColor {
        case oakPlanks
        case sprucePlanks
        case birchPlanks
        case junglePlanks
        case acaciaPlanks
        case darkOakPlanks
        case mangrovePlanks
        case crimsonPlanks
        case warpedPlanks

        case normalStone
        case deepslate
        case blackStone
        case mossyStone
        case polishedBlackStone
        case polishedBlackStoneBricks

        case andesite
        case diorite
        case granite

        case redBricks
        case sand
        case redSand
        case quartz
        case prismarineNormal
        case prismarineDark

        case netherBricks
        case redNetherBricks
        case endPurple
        case endBricks

        case furnace
        case chest
        case anvil
        case deadCoral
        case rail

        case copper
        case exposedCopper
        case oxidizedCopper
        case weatheredCopper

        var argb: UInt32 {
            switch self {
                case .water:                    return 0xFF3359A2

                case .oakPlanks:                return 0xFF7F5530    // (127, 085, 048)
                case .birchPlanks:              return 0xFFF4E6A1    // (244, 230, 161)
                case .sprucePlanks:             return 0xFF7A5933    // (122, 089, 051)
                case .junglePlanks:             return 0xFF956C4C    // (149, 108, 076)
                case .acaciaPlanks:             return 0xFFB86237    // (184, 098, 055)
                case .darkOakPlanks:            return 0xFF654B32    // (101, 075, 050)
                case .mangrovePlanks:           return 0xFF894C39    // (137, 076, 057)
                case .cherryPlanks:             return 0xFF // (228, 200, 195)
                case .bambooPlanks:             return 0xFF // (224, 202, 105)
                case .crimsonPlanks:            return 0xFF7D3955    // (125, 057, 085)
                case .warpedPlanks:             return 0xFF388180    // (056, 129, 128)

                case .oakLog:                   return 0xFF // (141, 118, 71)
                case .birchLog:                 return 0xFF // 252, 252, 252
                case .spruceLog:                return 0xFF // (58, 39, 19)
                case .jungleLog:                return 0xFF // 149, 108, 76
                case .acaciaLog:                return 0xFF // 104, 97, 88
                case .darkOakLog:               return 0xFF // 101, 75, 50
                case .mangroveLog:              return 0xFF59472B    // (089, 071, 043)
                case .cherryLog:                return 0xFF // (83, 52, 66)

                case .normalStone:              return 0xFF6F6F6F    // (111, 111, 111)
                case .deepslate:                return 0xFF686868    // (104, 104, 104)
                case .mossyStone:               return 0xFF738352    // (115, 131, 082)

                case .blackStone:               return 0xFF302B35    // (048, 043, 053)
                case .polishedBlackStone:       return 0xFF3B3846    // (059, 056, 070)
                case .polishedBlackStoneBricks: return 0xFF201C17    // (032, 028, 023)

                case .andesite:                 return 0xFFA5A897    // (165, 168, 151)
                case .diorite:                  return 0xFFFCF9F2    // (252, 249, 242)
                case .granite:                  return 0xFF956C4C    // (149, 108, 076)
//^.+_slab,.+$
                case .sand:                     return 0xFFC9C09A    // (201, 192, 154)
                case .redSand:                  return 0xFFB86621    // (184, 102, 033)
                case .redBricks:                return 0xFFAF624C    // (175, 098, 076)
                case .mudBricks:                return 0xFF // (147, 112, 79)

                case .quartz:                   return 0xFFEBE3DB    // (235, 227, 219)
                case .netherBricks:             return 0xFF211114    // (033, 017, 020)
                case .redNetherBricks:          return 0xFF590000    // (089, 000, 000)
                case .endPurple:                return 0xFFAA7AAA    // (170, 122, 170)
                case .endBricks:                return 0xFFE9F8AD    // (233, 248, 173)
                case .prismarineNormal:         return 0xFF4B7D97    // (075, 125, 151)
                case .prismarineDark:           return 0xFF376150    // (055, 097, 080)

                case .furnace:                  return 0xFF838383    // (131, 131, 131)
                case .chest:                    return 0xFF8D7647    // (141, 118, 071)
                case .anvil:                    return 0xFF494949    // (073, 073, 073)
                case .deadCoral:                return 0xFF736966    // (115, 105, 102)
                case .rail:                     return 0xFF9A9A9A    // (154, 154, 154)
                case .bookshelf:                return 0xFF // (192, 155, 97)

                case .copper:                   return 0xFFE0806B    // (224, 128, 107)
                case .exposedCopper:            return 0xFF968A68    // (150, 138, 104)
                case .oxidizedCopper:           return 0xFF4B9282    // (075, 146, 130)
                case .weatheredCopper:          return 0xFF639E76    // (099, 158, 118)

                case .potter:                   return 0xFF // (135, 75, 58)
                case .sculkSensor:              return 0xFF // (7, 71, 86)
                case .sculk:                    return 0xFF // (5, 41, 49)
                case .torchFlower:              return 0xFF // (243, 183, 39)
                case .pitcher:                  return 0xFF // (188, 154, 252)
            }
        }
    }
}
