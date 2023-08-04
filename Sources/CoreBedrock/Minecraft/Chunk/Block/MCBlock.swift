public class MCBlock {
    public let type: MCBlockType
    public let nameTag: StringTag
    public let states: CompoundTag
    public let version: Int32

    public init(type: MCBlockType, nameTag: StringTag, states: CompoundTag, version: Int32) {
        self.type = type
        self.nameTag = nameTag
        self.states = states
        self.version = version
    }

    public static func decode(_ tag: CompoundTag) -> MCBlock? {
        guard let nameTag = tag["name"] as? StringTag,
              let statesTag = tag["states"] as? CompoundTag,
              let versionTag = tag["version"] as? IntTag
        else {
            return nil
        }
        let blockType = MCBlockType(stringLiteral: nameTag.value)
        return MCBlock(type: blockType, nameTag: nameTag, states: statesTag, version: versionTag.value)
    }

    public func encode() -> CompoundTag {
        let rootTag = CompoundTag()
        let versionTag = IntTag(name: "version", version)
        try! rootTag.append(nameTag)
        try! rootTag.append(states)
        try! rootTag.append(versionTag)
        return rootTag
    }

    public var name: String {
        nameTag.value
    }

    public var argbHex: UInt32? {
        switch type {
            // log color
            // (141, 118, 71)
            // (141, 118, 71)
            // (252, 252, 252)
            // (149, 108, 76)
            // (104, 97, 88)
            // (101, 75, 50)

            // case .log:
            //     // FIX: format changed
            //     // [old_log_type] 0: oak log, 1: spruce log, 2: birch log, 3: jungle log
            //     return nil
            // case .log2:
            //     // FIX: format changed
            //     // [new_log_type] 0: acacia log, 1: dark oak log
            //     return nil
            // case .fence:
            //     // FIX: format changed
            //     // TODO: [wood_type] 0: oak, 1: spruce, 2: birch, 3: jungle, 4: acacia, 5: dark_oak
            //     return nil
            case .planks:
                guard let tag = states["wood_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "oak":         return MCBlockType.DefaultColor.oakPlanks.argb
                    case "spruce":      return MCBlockType.DefaultColor.sprucePlanks.argb
                    case "birch":       return MCBlockType.DefaultColor.birchPlanks.argb
                    case "jungle":      return MCBlockType.DefaultColor.junglePlanks.argb
                    case "acacia":      return MCBlockType.DefaultColor.acaciaPlanks.argb
                    case "dark_oak":    return MCBlockType.DefaultColor.darkOakPlanks.argb
                    default:            return nil
                }
            case .wood:
                guard let tag = states["wood_type"] as? StringTag, let stripped = states["stripped_bit"]?.byteValue else {
                    return nil
                }
                switch tag.value {
                    case "oak":         return stripped == 0 ? 0xFF8D7647 /*(141, 118, 071)*/ : 0xFF7F5530 /*(127, 085, 048)*/
                    case "spruce":      return stripped == 0 ? 0xFF8D7647 /*(141, 118, 071)*/ : 0xFF785A36 /*(120, 090, 054)*/
                    case "birch":       return stripped == 0 ? 0xFFFCFCFC /*(252, 252, 252)*/ : 0xFFCDBA7E /*(205, 186, 126)*/
                    case "jungle":      return stripped == 0 ? 0xFF58451A /*(088, 069, 026)*/ : 0xFFAD7E52 /*(173, 126, 082)*/
                    case "acacia":      return stripped == 0 ? 0xFFB86237 /*(184, 098, 055)*/ : 0xFFB95E3D /*(185, 094, 061)*/
                    case "dark_oak":    return stripped == 0 ? 0xFF3E301D /*(062, 048, 029)*/ : 0xFF6B5333 /*(107, 083, 051)*/
                    default:            return nil
                }
            case .leaves:
                guard let tag = states["old_leaf_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "oak":     return 0
                    case "spruce":  return 0
                    case "birch":   return 0
                    case "jungle":  return 0
                    default:        return nil
                }
            case .leaves2:
                guard let tag = states["new_leaf_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "acacia":      return 0
                    case "dark_oak":    return 0
                    default:            return nil
                }
            case .woodenSlab:
                guard let tag = states["wood_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "oak":         return MCBlockType.DefaultColor.oakPlanks.argb
                    case "spruce":      return MCBlockType.DefaultColor.sprucePlanks.argb
                    case "birch":       return MCBlockType.DefaultColor.birchPlanks.argb
                    case "jungle":      return MCBlockType.DefaultColor.junglePlanks.argb
                    case "acacia":      return MCBlockType.DefaultColor.acaciaPlanks.argb
                    case "dark_oak":    return MCBlockType.DefaultColor.darkOakPlanks.argb
                    default:            return nil
                }
            case .dirt:
                guard let tag = states["dirt_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "normal":  return 0xFF956C4C    // (149, 108, 076)
                    case "coarse":  return 0xFF60432D    // (096, 067, 045)
                    default:        return nil
                }
            case .stone:
                guard let tag = states["stone_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "stone":           return MCBlockType.DefaultColor.normalStone.argb
                    case "granite":         return MCBlockType.DefaultColor.granite.argb
                    case "granite_smooth":  return MCBlockType.DefaultColor.granite.argb
                    case "diorite":         return MCBlockType.DefaultColor.diorite.argb
                    case "diorite_smooth":  return MCBlockType.DefaultColor.diorite.argb
                    case "andesite":        return MCBlockType.DefaultColor.andesite.argb
                    case "andesite_smooth": return MCBlockType.DefaultColor.andesite.argb
                    default:                return nil
                }
            case .cobblestoneWall:
                guard let tag = states["wall_block_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "cobblestone":         return MCBlockType.DefaultColor.normalStone.argb
                    case "mossy_cobblestone":   return MCBlockType.DefaultColor.mossyStone.argb
                    case "granite":             return MCBlockType.DefaultColor.granite.argb
                    case "diorite":             return MCBlockType.DefaultColor.diorite.argb
                    case "andesite":            return MCBlockType.DefaultColor.andesite.argb
                    case "sandstone":           return MCBlockType.DefaultColor.sand.argb
                    case "brick":               return MCBlockType.DefaultColor.redBricks.argb
                    case "stone_brick":         return MCBlockType.DefaultColor.normalStone.argb
                    case "mossy_stone_brick":   return MCBlockType.DefaultColor.mossyStone.argb
                    case "nether_brick":        return MCBlockType.DefaultColor.netherBricks.argb
                    case "end_brick":           return MCBlockType.DefaultColor.endBricks.argb
                    case "prismarine":          return MCBlockType.DefaultColor.prismarineNormal.argb
                    case "red_sandstone":       return MCBlockType.DefaultColor.redSand.argb
                    case "red_nether_brick":    return MCBlockType.DefaultColor.redNetherBricks.argb
                    default:    return nil
                }
            case .stoneBlockSlab:
                guard let tag = states["stone_slab_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "smooth_stone":    return MCBlockType.DefaultColor.normalStone.argb
                    case "sandstone":       return MCBlockType.DefaultColor.sand.argb
                    case "wood":            return nil
                    case "cobblestone":     return MCBlockType.DefaultColor.normalStone.argb
                    case "brick":           return MCBlockType.DefaultColor.redBricks.argb
                    case "stone_brick":     return MCBlockType.DefaultColor.normalStone.argb
                    case "quartz":          return MCBlockType.DefaultColor.quartz.argb
                    case "nether_brick":    return MCBlockType.DefaultColor.netherBricks.argb
                    default:    return nil
                }
            case .stoneBlockSlab2:
                guard let tag = states["stone_slab_type_2"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "red_sandstone":       return MCBlockType.DefaultColor.redSand.argb
                    case "purpur":              return MCBlockType.DefaultColor.endPurple.argb
                    case "prismarine_rough":    return MCBlockType.DefaultColor.prismarineNormal.argb
                    case "prismarine_dark":     return MCBlockType.DefaultColor.prismarineDark.argb
                    case "prismarine_brick":    return MCBlockType.DefaultColor.prismarineNormal.argb
                    case "mossy_cobblestone":   return MCBlockType.DefaultColor.mossyStone.argb
                    case "smooth_sandstone":    return MCBlockType.DefaultColor.sand.argb
                    case "red_nether_brick":    return MCBlockType.DefaultColor.redNetherBricks.argb
                    default:    return nil
                }
            case .stoneBlockSlab3:
                guard let tag = states["stone_slab_type_3"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "end_stone_brick":     return MCBlockType.DefaultColor.endBricks.argb
                    case "smooth_red_sandstone":return MCBlockType.DefaultColor.redSand.argb
                    case "polished_andesite":   return MCBlockType.DefaultColor.andesite.argb
                    case "andesite":            return MCBlockType.DefaultColor.andesite.argb
                    case "diorite":             return MCBlockType.DefaultColor.diorite.argb
                    case "polished_diorite":    return MCBlockType.DefaultColor.diorite.argb
                    case "granite":             return MCBlockType.DefaultColor.granite.argb
                    case "polished_granite":    return MCBlockType.DefaultColor.granite.argb
                    default:    return nil
                }
            case .stoneBlockSlab4:
                guard let tag = states["stone_slab_type_4"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "mossy_stone_brick":   return MCBlockType.DefaultColor.mossyStone.argb
                    case "smooth_quartz":       return MCBlockType.DefaultColor.quartz.argb
                    case "stone":               return MCBlockType.DefaultColor.normalStone.argb
                    case "cut_sandstone":       return MCBlockType.DefaultColor.sand.argb
                    case "cut_red_sandstone":   return MCBlockType.DefaultColor.redSand.argb
                    default:    return nil
                }
            case .stonebrick:
                guard let tag = states["stone_brick_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "default":     return MCBlockType.DefaultColor.normalStone.argb
                    case "mossy":       return MCBlockType.DefaultColor.mossyStone.argb
                    case "cracked":     return MCBlockType.DefaultColor.normalStone.argb
                    case "chiseled":    return MCBlockType.DefaultColor.normalStone.argb
                    case "smooth":      return nil
                    default:            return nil
                }
            case .sand:
                guard let tag = states["sand_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "normal":  return MCBlockType.DefaultColor.sand.argb
                    case "red":     return MCBlockType.DefaultColor.redSand.argb
                    default: return nil
                }
            case .sandstone:
                guard let tag = states["sand_stone_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "default":     return MCBlockType.DefaultColor.sand.argb
                    case "heiroglyphs": return MCBlockType.DefaultColor.sand.argb
                    case "cut":         return MCBlockType.DefaultColor.sand.argb
                    case "smooth":      return MCBlockType.DefaultColor.sand.argb
                    default:            return nil
                }
            case .redSandstone:
                guard let tag = states["sand_stone_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "default":     return MCBlockType.DefaultColor.redSand.argb
                    case "heiroglyphs": return MCBlockType.DefaultColor.redSand.argb
                    case "cut":         return MCBlockType.DefaultColor.redSand.argb
                    case "smooth":      return MCBlockType.DefaultColor.redSand.argb
                    default:            return nil
                }
            case .coralBlock:
                guard let tag = states["coral_color"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "blue":    return 0xFF304EDA    // (048, 078, 218)
                    case "pink":    return 0xFFE17DB7    // (225, 125, 183)
                    case "purple":  return 0xFFC619B8    // (198, 025, 184)
                    case "red":     return 0xFFC42A36    // (196, 042, 054)
                    case "yellow":  return 0xFFEAE94C    // (234, 233, 076)
                    default:    return nil
                }
            case .prismarine:
                guard let tag = states["prismarine_block_type"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "default": return MCBlockType.DefaultColor.prismarineNormal.argb
                    case "dark":    return MCBlockType.DefaultColor.prismarineDark.argb
                    case "bricks":  return MCBlockType.DefaultColor.prismarineNormal.argb
                    default:        return nil
                }

            case .bed, .wool, .carpet:
                guard let tag = states["color"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "white":       return 0xFFF7F7F7    // (247, 247, 247)
                    case "orange":      return 0xFFF47A19    // (244, 122, 025)
                    case "magenta":     return 0xFFC149B7    // (193, 073, 183)
                    case "light_blue":  return 0xFF41BADC    // (065, 186, 220)
                    case "yellow":      return 0xFFF9CE2F    // (249, 206, 047)
                    case "lime":        return 0xFF7BC11B    // (123, 193, 027)
                    case "pink":        return 0xFFF1A0BA    // (241, 160, 186)
                    case "gray":        return 0xFF464E51    // (070, 078, 081)
                    case "silver":      return 0xFF979791    // (151, 151, 145)
                    case "cyan":        return 0xFF16999A    // (022, 153, 154)
                    case "purple":      return 0xFF842FB3    // (132, 047, 179)
                    case "blue":        return 0xFF393FA4    // (057, 063, 164)
                    case "brown":       return 0xFF7D4F2E    // (125, 079, 046)
                    case "green":       return 0xFF5B7716    // (091, 119, 022)
                    case "red":         return 0xFFAA2A24    // (170, 042, 036)
                    case "black":       return 0xFF1C1C20    // (028, 028, 032)
                    default:            return nil
                }
            case .shulkerBox:
                guard let tag = states["color"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "white":       return 0xFFE1E6E6    // (225, 230, 230)
                    case "orange":      return 0xFFE1E6E6    // (225, 230, 230)
                    case "magenta":     return 0xFFB73DAC    // (183, 061, 172)
                    case "light_blue":  return 0xFF39B1D7    // (057, 177, 215)
                    case "yellow":      return 0xFFF9C222    // (249, 194, 034)
                    case "lime":        return 0xFF6CB718    // (108, 183, 024)
                    case "pink":        return 0xFFEF87A6    // (239, 135, 166)
                    case "gray":        return 0xFF3B3F43    // (059, 063, 067)
                    case "silver":      return 0xFF87877E    // (135, 135, 126)
                    case "cyan":        return 0xFF168590    // (022, 133, 144)
                    case "purple":      return 0xFF7326A7    // (115, 038, 167)
                    case "blue":        return 0xFF313498    // (049, 052, 152)
                    case "brown":       return 0xFF6F4527    // (111, 069, 039)
                    case "green":       return 0xFF536B1D    // (083, 107, 029)
                    case "red":         return 0xFF982321    // (152, 035, 033)
                    case "black":       return 0xFF1F1F22    // (031, 031, 034)
                    default:            return nil
                }
            case .concretePowder, .hardenedClay:
                guard let tag = states["color"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "white":       return 0xFFDEDFE0    // (222, 223, 224)
                    case "orange":      return 0xFFE68014    // (230, 128, 020)
                    case "magenta":     return 0xFFC85DC1    // (200, 093, 193)
                    case "light_blue":  return 0xFF5BC2D8    // (091, 194, 216)
                    case "yellow":      return 0xFFEBD140    // (235, 209, 064)
                    case "lime":        return 0xFF8AC52D    // (138, 197, 045)
                    case "pink":        return 0xFFECACC3    // (236, 172, 195)
                    case "gray":        return 0xFF4B4F52    // (075, 079, 082)
                    case "silver":      return 0xFF9A9A94    // (154, 154, 148)
                    case "cyan":        return 0xFF259AA0    // (037, 154, 160)
                    case "purple":      return 0xFF8A3ABA    // (138, 058, 186)
                    case "blue":        return 0xFF484BAF    // (072, 075, 175)
                    case "brown":       return 0xFF785132    // (120, 081, 050)
                    case "green":       return 0xFF677E25    // (103, 126, 037)
                    case "red":         return 0xFFB43A37    // (180, 058, 055)
                    case "black":       return 0xFF16181D    // (022, 024, 029)
                    default:            return nil
                }
            case .concrete, .stainedHardenedClay:
                guard let tag = states["color"] as? StringTag else {
                    return nil
                }
                switch tag.value {
                    case "white":       return 0xFFCCD1D2    // (204, 209, 210)
                    case "orange":      return 0xFFDE6100    // (222, 097, 000)
                    case "magenta":     return 0xFFA8319E    // (168, 049, 158)
                    case "light_blue":  return 0xFF2588C6    // (037, 136, 198)
                    case "yellow":      return 0xFFEFAF16    // (239, 175, 022)
                    case "lime":        return 0xFF5DA718    // (093, 167, 024)
                    case "pink":        return 0xFFD2648D    // (210, 100, 141)
                    case "gray":        return 0xFF35393D    // (053, 057, 061)
                    case "silver":      return 0xFF7D7D73    // (125, 125, 115)
                    case "cyan":        return 0xFF157686    // (021, 118, 134)
                    case "purple":      return 0xFF63209A    // (099, 032, 154)
                    case "blue":        return 0xFF2C2E8E    // (044, 046, 142)
                    case "brown":       return 0xFF5F3A1F    // (095, 058, 031)
                    case "green":       return 0xFF485A23    // (072, 090, 035)
                    case "red":         return 0xFF8A2020    // (138, 032, 032)
                    case "black":       return 0xFF080A0F    // (008, 010, 015)
                    default:            return nil
                }

            default:
                return type.argb
        }


    }
}
