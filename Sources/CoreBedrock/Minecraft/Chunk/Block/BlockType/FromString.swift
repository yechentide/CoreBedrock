import Foundation

extension MCBlockType {
    public static func parse(name: String, stateTag: CompoundTag? = nil) -> MCBlockType {
        guard let stateTag = stateTag else {
            return MCBlockType(stringLiteral: name)
        }
        switch name {
            case "minecraft:dirt":
                guard let tag = stateTag["dirt_type"] as? StringTag else {
                    return .dirt
                }
                return tag.value == "coarse" ? .coarseDirt : .dirt
            case "minecraft:sand":
                guard let tag = stateTag["sand_type"] as? StringTag else {
                    return .sand
                }
                return tag.value == "red" ? .redSand : .sand
            case "minecraft:monster_egg":
                guard let tag = stateTag["monster_egg_stone_type"] as? StringTag else {
                    return .infestedStone
                }
                switch tag.value {
                    case "stone":                   return .infestedStone
                    case "cobblestone":             return .infestedCobblestone
                    case "stone_brick":             return .infestedStoneBrick
                    case "mossy_stone_brick":       return .infestedMossyStoneBrick
                    case "cracked_stone_brick":     return .infestedCrackedStoneBrick
                    case "chiseled_stone_brick":    return .infestedChiseledStoneBrick
                    default:                        return .infestedStone
                }
            case "minecraft:stone":
                guard let tag = stateTag["stone_type"] as? StringTag else {
                    return .stone
                }
                switch tag.value {
                    case "stone":               return .stone
                    case "granite":             return .granite
                    case "diorite":             return .diorite
                    case "andesite":            return .andesite
                    case "granite_smooth":      return .polishedGranite
                    case "diorite_smooth":      return .polishedDiorite
                    case "andesite_smooth":     return .polishedAndesite
                    default:                    return .stone
                }
            case "minecraft:stonebrick":
                guard let tag = stateTag["stone_brick_type"] as? StringTag else {
                    return .stonebricks
                }
                switch tag.value {
                    case "default":     return .stonebricks
                    case "mossy":       return .mossyStoneBricks
                    case "cracked":     return .crackedStoneBricks
                    case "chiseled":    return .chiseledStoneBricks
                    default:            return .stonebricks
                }
            case "minecraft:prismarine":
                guard let tag = stateTag["prismarine_block_type"] as? StringTag else {
                    return .prismarine
                }
                switch tag.value {
                    case "default":     return .prismarine
                    case "dark":        return .darkPrismarine
                    case "bricks":      return .prismarineBricks
                    default:            return .prismarine
                }
            case "minecraft:quartz_block":
                guard let tag = stateTag["chisel_type"] as? StringTag else {
                    return .quartzBlock
                }
                switch tag.value {
                    case "default":     return .quartzBlock
                    case "chiseled":    return .chiseledQuartzBlock
                    case "lines":       return .pillarQuartzBlock
                    case "smooth":      return .smoothQuartzBlock
                    default:            return .quartzBlock
                }
            case "minecraft:purpur_block":
                guard let tag = stateTag["chisel_type"] as? StringTag else {
                    return .purpurBlock
                }
                switch tag.value {
                    case "default":     return .purpurBlock
                    case "chiseled":    return .chiseledPurpurBlock
                    case "lines":       return .pillarPurpurBlock
                    case "smooth":      return .smoothPurpurBlock
                    default:            return .purpurBlock
                }
            case "minecraft:sandstone":
                guard let tag = stateTag["sand_stone_type"] as? StringTag else {
                    return .sandstone
                }
                switch tag.value {
                    case "default":         return .sandstone
                    case "heiroglyphs":     return .chiseledSandstone
                    case "cut":             return .cutSandstone
                    case "smooth":          return .smoothSandstone
                    default:                return .sandstone
                }
            case "minecraft:red_sandstone":
                guard let tag = stateTag["sand_stone_type"] as? StringTag else {
                    return .redSandstone
                }
                switch tag.value {
                    case "default":         return .redSandstone
                    case "heiroglyphs":     return .chiseledRedSandstone
                    case "cut":             return .cutRedSandstone
                    case "smooth":          return .smoothRedSandstone
                    default:                return .redSandstone
                }
            case "minecraft:wood":
                guard let tag01 = stateTag["sand_stone_type"] as? StringTag,
                      let tag02 = stateTag["stripped_bit"] as? ByteTag
                else {
                    return .oakWood
                }
                let noStripped = tag02.value == 0
                switch tag01.value {
                    case "oak":         return noStripped ? .oakWood : .strippedOakWood
                    case "spruce":      return noStripped ? .spruceWood : .strippedSpruceWood
                    case "birch":       return noStripped ? .birchWood : .strippedBirchWood
                    case "jungle":      return noStripped ? .jungleWood : .strippedJungleWood
                    case "acacia":      return noStripped ? .acaciaWood : .strippedAcaciaWood
                    case "dark_oak":    return noStripped ? .darkOakWood : .strippedDarkOakWood
                    default:            return noStripped ? .oakWood : .strippedOakWood
                }
            case "minecraft:planks":
                guard let tag = stateTag["wood_type"] as? StringTag else {
                    return .oakPlanks
                }
                switch tag.value {
                    case "oak":         return .oakPlanks
                    case "spruce":      return .sprucePlanks
                    case "birch":       return .birchPlanks
                    case "jungle":      return .junglePlanks
                    case "acacia":      return .acaciaPlanks
                    case "dark_oak":    return .darkOakPlanks
                    default:            return .oakPlanks
                }
            case "minecraft:leaves":
                guard let tag = stateTag["old_leaf_type"] as? StringTag else {
                    return .oakLeaves
                }
                switch tag.value {
                    case "oak":         return .oakLeaves
                    case "spruce":      return .spruceLeaves
                    case "birch":       return .birchLeaves
                    case "jungle":      return .jungleLeaves
                    default:            return .oakLeaves
                }
            case "minecraft:leaves2":
                guard let tag = stateTag["new_leaf_type"] as? StringTag else {
                    return .acaciaLeaves
                }
                switch tag.value {
                    case "acacia":      return .acaciaLeaves
                    case "dark_oak":    return .darkOakLeaves
                    default:            return .acaciaLeaves
                }
            case "minecraft:sapling":
                guard let tag = stateTag["sapling_type"] as? StringTag else {
                    return .oakSapling
                }
                switch tag.value {
                    case "oak":         return .oakSapling
                    case "spruce":      return .spruceSapling
                    case "birch":       return .birchSapling
                    case "jungle":      return .jungleSapling
                    case "acacia":      return .acaciaSapling
                    case "dark_oak":    return .darkOakSapling
                    default:            return .oakSapling
                }
            case "minecraft:cobblestone_wall":
                guard let tag = stateTag["wall_block_type"] as? StringTag else {
                    return .cobblestoneWall
                }
                switch tag.value {
                    case "cobblestoneWall":         return .cobblestoneWall
                    case "mossyCobblestoneWall":    return .mossyCobblestoneWall
                    case "graniteWall":             return .graniteWall
                    case "dioriteWall":             return .dioriteWall
                    case "andesiteWall":            return .andesiteWall
                    case "sandstoneWall":           return .sandstoneWall
                    case "redSandstoneWall":        return .redSandstoneWall
                    case "stoneBrickWall":          return .stoneBrickWall
                    case "mossyStoneBrickWall":     return .mossyStoneBrickWall
                    case "redBrickWall":            return .redBrickWall
                    case "netherBrickWall":         return .netherBrickWall
                    case "redNetherBrickWall":      return .redNetherBrickWall
                    case "endBrickWall":            return .endBrickWall
                    case "prismarineWall":          return .prismarineWall
                    default:                        return .cobblestoneWall
                }
            case "minecraft:wooden_slab":
                guard let tag = stateTag["wood_type"] as? StringTag else {
                    return .oakSlab
                }
                switch tag.value {
                    case "oak":         return .oakSlab
                    case "spruce":      return .spruceSlab
                    case "birch":       return .birchSlab
                    case "jungle":      return .jungleSlab
                    case "acacia":      return .acaciaSlab
                    case "dark_oak":    return .darkOakSlab
                    default:            return .oakSlab
                }
            case "minecraft:double_wooden_slab":
                guard let tag = stateTag["wood_type"] as? StringTag else {
                    return .oakDoubleSlab
                }
                switch tag.value {
                    case "oak":         return .oakDoubleSlab
                    case "spruce":      return .spruceDoubleSlab
                    case "birch":       return .birchDoubleSlab
                    case "jungle":      return .jungleDoubleSlab
                    case "acacia":      return .acaciaDoubleSlab
                    case "dark_oak":    return .darkOakDoubleSlab
                    default:            return .oakDoubleSlab
                }
            case "minecraft:stone_block_slab":
                guard let tag = stateTag["stone_slab_type"] as? StringTag else {
                    return .smoothStoneSlab
                }
                switch tag.value {
                    case "smooth_stone":    return .smoothStoneSlab
                    case "sandstone":       return .sandstoneSlab
                    case "cobblestone":     return .cobblestoneSlab
                    case "brick":           return .redBrickSlab
                    case "stone_brick":     return .stoneBrickSlab
                    case "quartz":          return .quartzSlab
                    case "nether_brick":    return .netherBrickSlab
                    default:                return .smoothStoneSlab
                }
            case "minecraft:double_stone_block_slab":
                guard let tag = stateTag["stone_slab_type"] as? StringTag else {
                    return .smoothStoneDoubleSlab
                }
                switch tag.value {
                    case "smooth_stone":    return .smoothStoneDoubleSlab
                    case "sandstone":       return .sandstoneDoubleSlab
                    case "cobblestone":     return .cobblestoneDoubleSlab
                    case "brick":           return .redBrickDoubleSlab
                    case "stone_brick":     return .stoneBrickDoubleSlab
                    case "quartz":          return .quartzDoubleSlab
                    case "nether_brick":    return .netherBrickDoubleSlab
                    default:                return .smoothStoneDoubleSlab
                }
            case "minecraft:stone_block_slab2":
                guard let tag = stateTag["stone_slab_type_2"] as? StringTag else {
                    return .redSandstoneSlab
                }
                switch tag.value {
                    case "red_sandstone":       return .redSandstoneSlab
                    case "purpur":              return .purpurSlab
                    case "prismarine_rough":    return .prismarineRoughSlab
                    case "prismarine_dark":     return .prismarineDarkSlab
                    case "prismarine_brick":    return .prismarineBrickSlab
                    case "mossy_cobblestone":   return .mossyCobblestoneSlab
                    case "smooth_sandstone":    return .smoothSandstoneSlab
                    case "red_nether_brick":    return .redNetherBrickSlab
                    default:                    return .redSandstoneSlab
                }
            case "minecraft:double_stone_block_slab2":
                guard let tag = stateTag["stone_slab_type_2"] as? StringTag else {
                    return .redSandstoneDoubleSlab
                }
                switch tag.value {
                    case "red_sandstone":       return .redSandstoneDoubleSlab
                    case "purpur":              return .purpurDoubleSlab
                    case "prismarine_rough":    return .prismarineRoughDoubleSlab
                    case "prismarine_dark":     return .prismarineDarkDoubleSlab
                    case "prismarine_brick":    return .prismarineBrickDoubleSlab
                    case "mossy_cobblestone":   return .mossyCobblestoneDoubleSlab
                    case "smooth_sandstone":    return .smoothSandstoneDoubleSlab
                    case "red_nether_brick":    return .redNetherBrickDoubleSlab
                    default:                    return .redSandstoneDoubleSlab
                }
            case "minecraft:stone_block_slab3":
                guard let tag = stateTag["stone_slab_type_3"] as? StringTag else {
                    return .smoothRedSandstoneSlab
                }
                switch tag.value {
                    case "end_stone_brick":         return .endStoneBrickSlab
                    case "smooth_red_sandstone":    return .smoothRedSandstoneSlab
                    case "polished_andesite":       return .polishedAndesiteSlab
                    case "andesite":                return .andesiteSlab
                    case "diorite":                 return .dioriteSlab
                    case "polished_diorite":        return .polishedDioriteSlab
                    case "granite":                 return .graniteSlab
                    case "polished_granite":        return .polishedGraniteSlab
                    default:                        return .smoothRedSandstoneSlab
                }
            case "minecraft:double_stone_block_slab3":
                guard let tag = stateTag["stone_slab_type_3"] as? StringTag else {
                    return .smoothRedSandstoneDoubleSlab
                }
                switch tag.value {
                    case "end_stone_brick":         return .endStoneBrickDoubleSlab
                    case "smooth_red_sandstone":    return .smoothRedSandstoneDoubleSlab
                    case "polished_andesite":       return .polishedAndesiteDoubleSlab
                    case "andesite":                return .andesiteDoubleSlab
                    case "diorite":                 return .dioriteDoubleSlab
                    case "polished_diorite":        return .polishedDioriteDoubleSlab
                    case "granite":                 return .graniteDoubleSlab
                    case "polished_granite":        return .polishedGraniteDoubleSlab
                    default:                        return .smoothRedSandstoneDoubleSlab
                }
            case "minecraft:stone_block_slab4":
                guard let tag = stateTag["stone_slab_type_4"] as? StringTag else {
                    return .mossyStoneBrickSlab
                }
                switch tag.value {
                    case "mossy_stone_brick":   return .mossyStoneBrickSlab
                    case "smooth_quartz":       return .smoothQuartzSlab
                    case "stone":               return .stoneSlab
                    case "cut_sandstone":       return .cutSandstoneSlab
                    case "cut_red_sandstone":   return .cutRedSandstoneSlab
                    default:                    return .mossyStoneBrickSlab
                }
            case "minecraft:double_stone_block_slab4":
                guard let tag = stateTag["stone_slab_type_4"] as? StringTag else {
                    return .mossyStoneBrickDoubleSlab
                }
                switch tag.value {
                    case "mossy_stone_brick":   return .mossyStoneBrickDoubleSlab
                    case "smooth_quartz":       return .smoothQuartzDoubleSlab
                    case "stone":               return .stoneDoubleSlab
                    case "cut_sandstone":       return .cutSandstoneDoubleSlab
                    case "cut_red_sandstone":   return .cutRedSandstoneDoubleSlab
                    default:                    return .mossyStoneBrickDoubleSlab
                }
            case "minecraft:cauldron":
                guard let tag01 = stateTag["cauldron_liquid"] as? StringTag,
                      let tag02 = stateTag["fill_level"] as? IntTag,
                      tag02.value > 0
                else {
                    return .emptyCauldron
                }
                switch tag01.value {
                    case "water":           return .waterCauldron
                    case "lava":            return .lavaCauldron
                    case "power_snow":      return .powerSnowCauldron
                    default:                return .emptyCauldron
                }
            case "minecraft:stained_glass":
                guard let tag = stateTag["color"] as? StringTag else {
                    return .whiteStainedGlass
                }
                switch tag.value {
                    case "white":           return .whiteStainedGlass
                    case "orange":          return .orangeStainedGlass
                    case "magenta":         return .magentaStainedGlass
                    case "light_blue":      return .lightBlueStainedGlass
                    case "yellow":          return .yellowStainedGlass
                    case "lime":            return .limeStainedGlass
                    case "pink":            return .pinkStainedGlass
                    case "gray":            return .grayStainedGlass
                    case "light_gray":      return .lightGrayStainedGlass
                    case "cyan":            return .cyanStainedGlass
                    case "purple":          return .purpleStainedGlass
                    case "blue":            return .blueStainedGlass
                    case "brown":           return .brownStainedGlass
                    case "green":           return .greenStainedGlass
                    case "red":             return .redStainedGlass
                    case "black":           return .blackStainedGlass
                    default:                return .whiteStainedGlass
                }
            case "minecraft:stained_glass_pane":
                guard let tag = stateTag["color"] as? StringTag else {
                    return .whiteStainedGlassPane
                }
                switch tag.value {
                    case "white":           return .whiteStainedGlassPane
                    case "orange":          return .orangeStainedGlassPane
                    case "magenta":         return .magentaStainedGlassPane
                    case "light_blue":      return .lightBlueStainedGlassPane
                    case "yellow":          return .yellowStainedGlassPane
                    case "lime":            return .limeStainedGlassPane
                    case "pink":            return .pinkStainedGlassPane
                    case "gray":            return .grayStainedGlassPane
                    case "light_gray":      return .lightGrayStainedGlassPane
                    case "cyan":            return .cyanStainedGlassPane
                    case "purple":          return .purpleStainedGlassPane
                    case "blue":            return .blueStainedGlassPane
                    case "brown":           return .brownStainedGlassPane
                    case "green":           return .greenStainedGlassPane
                    case "red":             return .redStainedGlassPane
                    case "black":           return .blackStainedGlassPane
                    default:                return .whiteStainedGlassPane
                }
            case "concrete_powder":
                guard let tag = stateTag["color"] as? StringTag else {
                    return .whiteConcretePowder
                }
                switch tag.value {
                    case "white":           return .whiteConcretePowder
                    case "orange":          return .orangeConcretePowder
                    case "magenta":         return .magentaConcretePowder
                    case "light_blue":      return .lightBlueConcretePowder
                    case "yellow":          return .yellowConcretePowder
                    case "lime":            return .limeConcretePowder
                    case "pink":            return .pinkConcretePowder
                    case "gray":            return .grayConcretePowder
                    case "silver":          return .lightGrayConcretePowder
                    case "cyan":            return .cyanConcretePowder
                    case "purple":          return .purpleConcretePowder
                    case "blue":            return .blueConcretePowder
                    case "brown":           return .brownConcretePowder
                    case "green":           return .greenConcretePowder
                    case "red":             return .redConcretePowder
                    case "black":           return .blackConcretePowder
                    default:                return .whiteConcretePowder
                }
            case "minecraft:stained_hardened_clay":
                guard let tag = stateTag["color"] as? StringTag else {
                    return .whiteStainedHardenedClay
                }
                switch tag.value {
                    case "white":           return .whiteStainedHardenedClay
                    case "orange":          return .orangeStainedHardenedClay
                    case "magenta":         return .magentaStainedHardenedClay
                    case "light_blue":      return .lightBlueStainedHardenedClay
                    case "yellow":          return .yellowStainedHardenedClay
                    case "lime":            return .limeStainedHardenedClay
                    case "pink":            return .pinkStainedHardenedClay
                    case "gray":            return .grayStainedHardenedClay
                    case "silver":          return .lightGrayStainedHardenedClay
                    case "cyan":            return .cyanStainedHardenedClay
                    case "purple":          return .purpleStainedHardenedClay
                    case "blue":            return .blueStainedHardenedClay
                    case "brown":           return .brownStainedHardenedClay
                    case "green":           return .greenStainedHardenedClay
                    case "red":             return .redStainedHardenedClay
                    case "black":           return .blackStainedHardenedClay
                    default:                return .whiteStainedHardenedClay
                }
            // coralBlock
            case "minecraft:coral_block":
                guard let tag01 = stateTag["coral_color"] as? StringTag,
                      let tag02 = stateTag["dead_bit"] as? ByteTag
                else {
                    return .tubeCoralBlock
                }
                let noDead = tag02.value == 0
                switch tag01.value {
                    case "blue":           return noDead ? .tubeCoralBlock : .deadTubeCoralBlock
                    case "pink":           return noDead ? .brainCoralBlock : .deadBrainCoralBlock
                    case "purple":         return noDead ? .bubbleCoralBlock : .deadBubbleCoralBlock
                    case "red":            return noDead ? .fireCoralBlock : .deadFireCoralBlock
                    case "yellow":         return noDead ? .hornCoralBlock : .deadHornCoralBlock
                    default:               return noDead ? .tubeCoralBlock : .deadTubeCoralBlock
                }
            case "minecraft:coral_fan":
                guard let tag = stateTag["coral_color"] as? StringTag else {
                    return .tubeCoralFan
                }
                switch tag.value {
                    case "blue":           return .tubeCoralFan
                    case "pink":           return .brainCoralFan
                    case "purple":         return .bubbleCoralFan
                    case "red":            return .fireCoralFan
                    case "yellow":         return .hornCoralFan
                    default:               return .tubeCoralFan
                }
            case "minecraft:coral_fan_dead":
                guard let tag = stateTag["coral_color"] as? StringTag else {
                    return .deadTubeCoralFan
                }
                switch tag.value {
                    case "blue":           return .deadTubeCoralFan
                    case "pink":           return .deadBrainCoralFan
                    case "purple":         return .deadBubbleCoralFan
                    case "red":            return .deadFireCoralFan
                    case "yellow":         return .deadHornCoralFan
                    default:               return .deadTubeCoralFan
                }
            case "minecraft:coral_fan_hang":
                guard let tag01 = stateTag["coral_hang_type_bit"] as? ByteTag,
                      let tag02 = stateTag["dead_bit"] as? ByteTag
                else {
                    return .tubeCoralHang
                }
                switch (tag01.value, tag02.value) {
                    case (0, 0):    return .tubeCoralHang
                    case (1, 0):    return .brainCoralHang
                    case (0, 1):    return .deadTubeCoralHang
                    case (1, 1):    return .deadBrainCoralHang
                    default:        return .tubeCoralHang
                }
            case "minecraft:coral_fan_hang2":
                guard let tag01 = stateTag["coral_hang_type_bit"] as? ByteTag,
                      let tag02 = stateTag["dead_bit"] as? ByteTag
                else {
                    return .bubbleCoralHang
                }
                switch (tag01.value, tag02.value) {
                    case (0, 0):    return .bubbleCoralHang
                    case (1, 0):    return .fireCoralHang
                    case (0, 1):    return .deadBubbleCoralHang
                    case (1, 1):    return .deadFireCoralHang
                    default:        return .bubbleCoralHang
                }
            case "minecraft:coral_fan_hang3":
                guard let tag01 = stateTag["coral_hang_type_bit"] as? ByteTag,
                      let tag02 = stateTag["dead_bit"] as? ByteTag
                else {
                    return .hornCoralHang
                }
                switch (tag01.value, tag02.value) {
                    case (0, 0):    return .hornCoralHang
                    case (0, 1):    return .deadHornCoralHang
                    default:        return .hornCoralHang
                }
            default:
                return MCBlockType(stringLiteral: name)
        }
    }
}

extension MCBlockType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
            case "minecraft:air":                                    self = .air
            case "minecraft:bedrock":                                self = .bedrock
            case "minecraft:fire":                                   self = .fire
            case "minecraft:water":                                  self = .water
            case "minecraft:lava":                                   self = .lava
            case "minecraft:flowing_water":                          self = .flowingWater
            case "minecraft:flowing_lava":                           self = .flowingLava
            case "minecraft:obsidian":                               self = .obsidian
            case "minecraft:crying_obsidian":                        self = .cryingObsidian

            /* ---------- ---------- ---------- Overworld ---------- ---------- ---------- */
            case "minecraft:grass":                                  self = .grass
            case "minecraft:dirt":                                   self = .dirt
            case "minecraft:farmland":                               self = .farmland
            case "minecraft:grass_path":                             self = .dirtPath
            case "minecraft:podzol":                                 self = .podzol
            case "minecraft:mycelium":                               self = .mycelium

            case "minecraft:gravel":                                 self = .gravel
            case "minecraft:sand":                                   self = .sand
            case "minecraft:suspicious_gravel":                      self = .suspiciousGravel
            case "minecraft:suspicious_sand":                        self = .suspiciousSand

            case "minecraft:web":                                    self = .web
            case "minecraft:bee_nest":                               self = .beeNest

            case "minecraft:mob_spawner":                            self = .mobSpawner
            case "minecraft:monster_egg":                            self = .infestedStone
            case "minecraft:infested_deepslate":                     self = .infestedDeepslate
            case "minecraft:turtle_egg":                             self = .turtleEgg
            case "minecraft:sniffer_egg":                            self = .snifferEgg
            case "minecraft:frog_spawn":                             self = .frogSpawn

            case "minecraft:ochre_froglight":                        self = .ochreFroglight
            case "minecraft:verdant_froglight":                      self = .verdantFroglight
            case "minecraft:pearlescent_froglight":                  self = .pearlescentFroglight
            case "minecraft:sponge":                                 self = .sponge

            // Plants
            case "minecraft:cactus":                                 self = .cactus
            case "minecraft:reeds":                                  self = .reeds
            case "minecraft:wheat":                                  self = .wheat
            case "minecraft:pumpkin_stem":                           self = .pumpkinStem
            case "minecraft:melon_stem":                             self = .melonStem
            case "minecraft:beetroot":                               self = .beetroot
            case "minecraft:cocoa":                                  self = .cocoa
            case "minecraft:vine":                                   self = .vine
            case "minecraft:torchflower_crop":                       self = .torchflowerCrop
            case "minecraft:pitcher_crop":                           self = .pitcherCrop
            case "minecraft:potatoes":                               self = .potatoes
            case "minecraft:carrots":                                self = .carrots
            case "minecraft:melon_block":                            self = .melonBlock
            case "minecraft:pumpkin":                                self = .pumpkin
            case "minecraft:carved_pumpkin":                         self = .carvedPumpkin
            case "minecraft:lit_pumpkin":                            self = .litPumpkin
            case "minecraft:sweet_berry_bush":                       self = .sweetBerryBush
            case "minecraft:cave_vines":                             self = .caveVines
            case "minecraft:cave_vines_head_with_berries":           self = .caveVinesHeadWithBerries
            case "minecraft:cave_vines_body_with_berries":           self = .caveVinesBodyWithBerries
            case "minecraft:bamboo":                                 self = .bamboo
            case "minecraft:brown_mushroom":                         self = .brownMushroom
            case "minecraft:red_mushroom":                           self = .redMushroom

            case "minecraft:brown_mushroom_block":                   self = .brownMushroomBlock
            case "minecraft:red_mushroom_block":                     self = .redMushroomBlock

            case "minecraft:deadbush":                               self = .deadbush
            case "minecraft:tallgrass":                              self = .tallgrass
            case "minecraft:double_plant":                           self = .doublePlant
            case "minecraft:yellow_flower":                          self = .yellowFlower
            case "minecraft:red_flower":                             self = .redFlower
            case "minecraft:pitcher_plant":                          self = .pitcherPlant
            case "minecraft:pink_petals":                            self = .pinkPetals
            case "minecraft:wither_rose":                            self = .witherRose
            case "minecraft:torchflower":                            self = .torchflower

            case "minecraft:waterlily":                              self = .waterlily
            case "minecraft:seagrass":                               self = .seagrass
            case "minecraft:kelp":                                   self = .kelp
            case "minecraft:dried_kelp_block":                       self = .driedKelpBlock

            // Ocean Biome
            case "minecraft:bubble_column":                          self = .bubbleColumn
            case "minecraft:sea_pickle":                             self = .seaPickle
            case "minecraft:sea_lantern":                            self = .seaLantern
            case "minecraft:conduit":                                self = .conduit

            // Snow Biome
            case "minecraft:snow":                                   self = .snow
            case "minecraft:snow_layer":                             self = .snowLayer
            case "minecraft:powder_snow":                            self = .powderSnow
            case "minecraft:ice":                                    self = .ice
            case "minecraft:blue_ice":                               self = .blueIce
            case "minecraft:packed_ice":                             self = .packedIce
            case "minecraft:frosted_ice":                            self = .frostedIce

            // Caves & Cliffs
            case "minecraft:glow_lichen":                            self = .glowLichen
            case "minecraft:dripstone_block":                        self = .dripstoneBlock
            case "minecraft:pointed_dripstone":                      self = .pointedDripstone
            case "minecraft:moss_block":                             self = .mossBlock
            case "minecraft:moss_carpet":                            self = .mossCarpet
            case "minecraft:dirt_with_roots":                        self = .dirtWithRoots
            case "minecraft:hanging_roots":                          self = .hangingRoots
            case "minecraft:big_dripleaf":                           self = .bigDripleaf
            case "minecraft:small_dripleaf_block":                   self = .smallDripleafBlock
            case "minecraft:spore_blossom":                          self = .sporeBlossom
            case "minecraft:azalea":                                 self = .azalea
            case "minecraft:flowering_azalea":                       self = .floweringAzalea
            case "minecraft:amethyst_block":                         self = .amethystBlock
            case "minecraft:budding_amethyst":                       self = .buddingAmethyst
            case "minecraft:amethyst_cluster":                       self = .amethystCluster
            case "minecraft:large_amethyst_bud":                     self = .largeAmethystBud
            case "minecraft:medium_amethyst_bud":                    self = .mediumAmethystBud
            case "minecraft:small_amethyst_bud":                     self = .smallAmethystBud
            case "minecraft:tuff":                                   self = .tuff
            case "minecraft:calcite":                                self = .calcite

            // Mangrove Swamp Biome
            case "minecraft:mud":                                    self = .mud
            case "minecraft:muddy_mangrove_roots":                   self = .muddyMangroveRoots
            case "minecraft:mangrove_roots":                         self = .mangroveRoots

            // Deep Dark Biome
            case "minecraft:reinforced_deepslate":                   self = .reinforcedDeepslate
            case "minecraft:sculk_sensor":                           self = .sculkSensor
            case "minecraft:sculk":                                  self = .sculk
            case "minecraft:sculk_vein":                             self = .sculkVein
            case "minecraft:sculk_catalyst":                         self = .sculkCatalyst
            case "minecraft:sculk_shrieker":                         self = .sculkShrieker
            case "minecraft:calibrated_sculk_sensor":                self = .calibratedSculkSensor

            /* ---------- ---------- ---------- The Nether ---------- ---------- ---------- */
            case "minecraft:netherrack":                             self = .netherrack
            case "minecraft:shroomlight":                            self = .shroomlight
            case "minecraft:nether_wart_block":                      self = .netherWartBlock
            case "minecraft:crimson_nylium":                         self = .crimsonNylium
            case "minecraft:warped_wart_block":                      self = .warpedWartBlock
            case "minecraft:warped_nylium":                          self = .warpedNylium

            case "minecraft:basalt":                                 self = .basalt
            case "minecraft:polished_basalt":                        self = .polishedBasalt
            case "minecraft:smooth_basalt":                          self = .smoothBasalt
            case "minecraft:soul_soil":                              self = .soulSoil
            case "minecraft:soul_sand":                              self = .soulSand

            case "minecraft:portal":                                 self = .portal
            case "minecraft:soul_fire":                              self = .soulFire
            case "minecraft:magma":                                  self = .magma
            case "minecraft:glowstone":                              self = .glowstone

            // Plants
            case "minecraft:nether_wart":                            self = .netherWart
            case "minecraft:crimson_roots":                          self = .crimsonRoots
            case "minecraft:warped_roots":                           self = .warpedRoots
            case "minecraft:nether_sprouts":                         self = .netherSprouts
            case "minecraft:weeping_vines":                          self = .weepingVines
            case "minecraft:twisting_vines":                         self = .twistingVines
            case "minecraft:crimson_fungus":                         self = .crimsonFungus
            case "minecraft:warped_fungus":                          self = .warpedFungus

            /* ---------- ---------- ---------- The End ---------- ---------- ---------- */
            case "minecraft:end_stone":                              self = .endStone
            case "minecraft:dragon_egg":                             self = .dragonEgg
            case "minecraft:chorus_plant":                           self = .chorusPlant
            case "minecraft:chorus_flower":                          self = .chorusFlower

            case "minecraft:end_portal_frame":                       self = .endPortalFrame
            case "minecraft:end_portal":                             self = .endPortal
            case "minecraft:end_gateway":                            self = .endGateway

            /* ---------- ---------- ---------- Ores & Ore Blocks ---------- ---------- ---------- */
            case "minecraft:coal_ore":                               self = .coalOre
            case "minecraft:copper_ore":                             self = .copperOre
            case "minecraft:iron_ore":                               self = .ironOre
            case "minecraft:gold_ore":                               self = .goldOre
            case "minecraft:diamond_ore":                            self = .diamondOre
            case "minecraft:lapis_ore":                              self = .lapisOre
            case "minecraft:redstone_ore":                           self = .redstoneOre
            case "minecraft:lit_redstone_ore":                       self = .litRedstoneOre
            case "minecraft:emerald_ore":                            self = .emeraldOre
            case "minecraft:nether_gold_ore":                        self = .netherGoldOre
            case "minecraft:quartz_ore":                             self = .quartzOre

            case "minecraft:deepslate_coal_ore":                     self = .deepslateCoalOre
            case "minecraft:deepslate_copper_ore":                   self = .deepslateCopperOre
            case "minecraft:deepslate_iron_ore":                     self = .deepslateIronOre
            case "minecraft:deepslate_gold_ore":                     self = .deepslateGoldOre
            case "minecraft:deepslate_diamond_ore":                  self = .deepslateDiamondOre
            case "minecraft:deepslate_lapis_ore":                    self = .deepslateLapisOre
            case "minecraft:deepslate_redstone_ore":                 self = .deepslateRedstoneOre
            case "minecraft:lit_deepslate_redstone_ore":             self = .litDeepslateRedstoneOre
            case "minecraft:deepslate_emerald_ore":                  self = .deepslateEmeraldOre

            case "minecraft:raw_copper_block":                       self = .rawCopperBlock
            case "minecraft:raw_iron_block":                         self = .rawIronBlock
            case "minecraft:raw_gold_block":                         self = .rawGoldBlock

            case "minecraft:coal_block":                             self = .coalBlock
            case "minecraft:iron_block":                             self = .ironBlock
            case "minecraft:gold_block":                             self = .goldBlock
            case "minecraft:diamond_block":                          self = .diamondBlock
            case "minecraft:lapis_block":                            self = .lapisBlock
            case "minecraft:redstone_block":                         self = .redstoneBlock
            case "minecraft:emerald_block":                          self = .emeraldBlock
            case "minecraft:netherite_block":                        self = .netheriteBlock
            case "minecraft:ancient_debris":                         self = .ancientDebris

            case "minecraft:copper_block":                           self = .copperBlock
            case "minecraft:exposed_copper":                         self = .exposedCopper
            case "minecraft:oxidized_copper":                        self = .oxidizedCopper
            case "minecraft:weathered_copper":                       self = .weatheredCopper

            case "minecraft:cut_copper":                             self = .cutCopper
            case "minecraft:exposed_cut_copper":                     self = .exposedCutCopper
            case "minecraft:oxidized_cut_copper":                    self = .oxidizedCutCopper
            case "minecraft:weathered_cut_copper":                   self = .weatheredCutCopper

            case "minecraft:waxed_copper":                           self = .waxedCopper
            case "minecraft:waxed_exposed_copper":                   self = .waxedExposedCopper
            case "minecraft:waxed_oxidized_copper":                  self = .waxedOxidizedCopper
            case "minecraft:waxed_weathered_copper":                 self = .waxedWeatheredCopper

            case "minecraft:waxed_cut_copper":                       self = .waxedCutCopper
            case "minecraft:waxed_exposed_cut_copper":               self = .waxedExposedCutCopper
            case "minecraft:waxed_oxidized_cut_copper":              self = .waxedOxidizedCutCopper
            case "minecraft:waxed_weathered_cut_copper":             self = .waxedWeatheredCutCopper

            /* ---------- ---------- ---------- Stones ---------- ---------- ---------- */
            case "minecraft:bone_block":                             self = .boneBlock
            case "minecraft:cobblestone":                            self = .cobblestone
            case "minecraft:mossy_cobblestone":                      self = .mossyCobblestone
            case "minecraft:cobbled_deepslate":                      self = .cobbledDeepslate

            case "minecraft:stone":                                  self = .stone
            case "minecraft:stonebrick":                             self = .stonebricks

            case "minecraft:blackstone":                             self = .blackstone
            case "minecraft:polished_blackstone":                    self = .polishedBlackstone

            case "minecraft:deepslate":                              self = .deepslate
            case "minecraft:polished_deepslate":                     self = .polishedDeepslate

            case "minecraft:polished_blackstone_bricks":             self = .polishedBlackstoneBricks
            case "minecraft:cracked_polished_blackstone_bricks":     self = .crackedPolishedBlackstoneBricks
            case "minecraft:chiseled_polished_blackstone":           self = .chiseledPolishedBlackstone
            case "minecraft:gilded_blackstone":                      self = .gildedBlackstone

            case "minecraft:deepslate_tiles":                        self = .deepslateTiles
            case "minecraft:cracked_deepslate_tiles":                self = .crackedDeepslateTiles
            case "minecraft:deepslate_bricks":                       self = .deepslateBricks
            case "minecraft:cracked_deepslate_bricks":               self = .crackedDeepslateBricks
            case "minecraft:chiseled_deepslate":                     self = .chiseledDeepslate

            case "minecraft:smooth_stone":                           self = .smoothStone
            case "minecraft:brick_block":                            self = .redBrickBlock
            case "minecraft:packed_mud":                             self = .packedMud
            case "minecraft:mud_bricks":                             self = .mudBricks

            case "minecraft:nether_brick":                           self = .netherBrick
            case "minecraft:red_nether_brick":                       self = .redNetherBrick
            case "minecraft:chiseled_nether_bricks":                 self = .chiseledNetherBricks
            case "minecraft:cracked_nether_bricks":                  self = .crackedNetherBricks
            case "minecraft:end_bricks":                             self = .endBricks

            case "minecraft:prismarine":                             self = .prismarine
            case "minecraft:quartz_bricks":                          self = .quartzBricks
            case "minecraft:quartz_block":                           self = .quartzBlock
            case "minecraft:purpur_block":                           self = .purpurBlock

            case "minecraft:sandstone":                              self = .sandstone
            case "minecraft:red_sandstone":                          self = .redSandstone

            /* ---------- ---------- ---------- Trees ---------- ---------- ---------- */
            case "minecraft:oak_log":                                self = .oakLog
            case "minecraft:spruce_log":                             self = .spruceLog
            case "minecraft:birch_log":                              self = .birchLog
            case "minecraft:jungle_log":                             self = .jungleLog
            case "minecraft:acacia_log":                             self = .acaciaLog
            case "minecraft:dark_oak_log":                           self = .darkOakLog
            case "minecraft:mangrove_log":                           self = .mangroveLog
            case "minecraft:cherry_log":                             self = .cherryLog
            case "minecraft:crimson_stem":                           self = .crimsonStem
            case "minecraft:warped_stem":                            self = .warpedStem

            case "minecraft:stripped_oak_log":                       self = .strippedOakLog
            case "minecraft:stripped_spruce_log":                    self = .strippedSpruceLog
            case "minecraft:stripped_birch_log":                     self = .strippedBirchLog
            case "minecraft:stripped_jungle_log":                    self = .strippedJungleLog
            case "minecraft:stripped_acacia_log":                    self = .strippedAcaciaLog
            case "minecraft:stripped_dark_oak_log":                  self = .strippedDarkOakLog
            case "minecraft:stripped_mangrove_log":                  self = .strippedMangroveLog
            case "minecraft:stripped_cherry_log":                    self = .strippedCherryLog
            case "minecraft:stripped_crimson_stem":                  self = .strippedCrimsonStem
            case "minecraft:stripped_warped_stem":                   self = .strippedWarpedStem

            case "minecraft:wood":                                   self = .oakWood
            case "minecraft:mangrove_wood":                          self = .mangroveWood
            case "minecraft:cherry_wood":                            self = .cherryWood
            case "minecraft:bamboo_block":                           self = .bambooBlock
            case "minecraft:crimson_hyphae":                         self = .crimsonHyphae
            case "minecraft:warped_hyphae":                          self = .warpedHyphae

            case "minecraft:stripped_mangrove_wood":                 self = .strippedMangroveWood
            case "minecraft:stripped_cherry_wood":                   self = .strippedCherryWood
            case "minecraft:stripped_bamboo_block":                  self = .strippedBambooBlock
            case "minecraft:stripped_crimson_hyphae":                self = .strippedCrimsonHyphae
            case "minecraft:stripped_warped_hyphae":                 self = .strippedWarpedHyphae

            case "minecraft:planks":                                 self = .oakPlanks
            case "minecraft:mangrove_planks":                        self = .mangrovePlanks
            case "minecraft:cherry_planks":                          self = .cherryPlanks
            case "minecraft:bamboo_planks":                          self = .bambooPlanks
            case "minecraft:bamboo_mosaic":                          self = .bambooMosaic
            case "minecraft:crimson_planks":                         self = .crimsonPlanks
            case "minecraft:warped_planks":                          self = .warpedPlanks

            case "minecraft:leaves":                                 self = .oakLeaves
            case "minecraft:leaves2":                                self = .acaciaLeaves
            case "minecraft:mangrove_leaves":                        self = .mangroveLeaves
            case "minecraft:cherry_leaves":                          self = .cherryLeaves
            case "minecraft:azalea_leaves":                          self = .azaleaLeaves
            case "minecraft:azalea_leaves_flowered":                 self = .azaleaLeavesFlowered

            case "minecraft:sapling":                                self = .oakSapling
            case "minecraft:mangrove_propagule":                     self = .mangrovePropagule
            case "minecraft:cherry_sapling":                         self = .cherrySapling
            case "minecraft:bamboo_sapling":                         self = .bambooSapling

            /* ---------- ---------- ---------- Fences & Gates ---------- ---------- ---------- */
            // case "minecraft:fence":                                  self = .fence
            case "minecraft:oak_fence":                              self = .oakFence
            case "minecraft:spruce_fence":                           self = .spruceFence
            case "minecraft:birch_fence":                            self = .birchFence
            case "minecraft:jungle_fence":                           self = .jungleFence
            case "minecraft:acacia_fence":                           self = .acaciaFence
            case "minecraft:dark_oak_fence":                         self = .darkOakFence
            case "minecraft:mangrove_fence":                         self = .mangroveFence
            case "minecraft:cherry_fence":                           self = .cherryFence
            case "minecraft:bamboo_fence":                           self = .bambooFence
            case "minecraft:crimson_fence":                          self = .crimsonFence
            case "minecraft:warped_fence":                           self = .warpedFence
            case "minecraft:nether_brick_fence":                     self = .netherBrickFence

            case "minecraft:fence_gate":                             self = .oakFenceGate
            case "minecraft:spruce_fence_gate":                      self = .spruceFenceGate
            case "minecraft:birch_fence_gate":                       self = .birchFenceGate
            case "minecraft:jungle_fence_gate":                      self = .jungleFenceGate
            case "minecraft:acacia_fence_gate":                      self = .acaciaFenceGate
            case "minecraft:dark_oak_fence_gate":                    self = .darkOakFenceGate
            case "minecraft:mangrove_fence_gate":                    self = .mangroveFenceGate
            case "minecraft:cherry_fence_gate":                      self = .cherryFenceGate
            case "minecraft:bamboo_fence_gate":                      self = .bambooFenceGate
            case "minecraft:crimson_fence_gate":                     self = .crimsonFenceGate
            case "minecraft:warped_fence_gate":                      self = .warpedFenceGate

            /* ---------- ---------- ---------- Walls ---------- ---------- ---------- */
            case "minecraft:cobblestone_wall":                       self = .cobblestoneWall

            case "minecraft:blackstone_wall":                        self = .blackstoneWall
            case "minecraft:polished_blackstone_wall":               self = .polishedBlackstoneWall
            case "minecraft:polished_blackstone_brick_wall":         self = .polishedBlackstoneBrickWall

            case "minecraft:cobbled_deepslate_wall":                 self = .cobbledDeepslateWall
            case "minecraft:polished_deepslate_wall":                self = .polishedDeepslateWall
            case "minecraft:deepslate_tile_wall":                    self = .deepslateTileWall
            case "minecraft:deepslate_brick_wall":                   self = .deepslateBrickWall

            case "minecraft:mud_brick_wall":                         self = .mudBrickWall

            /* ---------- ---------- ---------- Stairs ---------- ---------- ---------- */
            case "minecraft:oak_stairs":                             self = .oakStairs
            case "minecraft:spruce_stairs":                          self = .spruceStairs
            case "minecraft:birch_stairs":                           self = .birchStairs
            case "minecraft:jungle_stairs":                          self = .jungleStairs
            case "minecraft:acacia_stairs":                          self = .acaciaStairs
            case "minecraft:dark_oak_stairs":                        self = .darkOakStairs
            case "minecraft:mangrove_stairs":                        self = .mangroveStairs
            case "minecraft:cherry_stairs":                          self = .cherryStairs
            case "minecraft:bamboo_stairs":                          self = .bambooStairs
            case "minecraft:bamboo_mosaic_stairs":                   self = .bambooMosaicStairs
            case "minecraft:crimson_stairs":                         self = .crimsonStairs
            case "minecraft:warped_stairs":                          self = .warpedStairs

            case "minecraft:normal_stone_stairs":                    self = .normalStoneStairs
            case "minecraft:stone_stairs":                           self = .cobblestoneStairs
            case "minecraft:stone_brick_stairs":                     self = .stoneBrickStairs
            case "minecraft:mossy_stone_brick_stairs":               self = .mossyStoneBrickStairs
            case "minecraft:mossy_cobblestone_stairs":               self = .mossyCobblestoneStairs

            case "minecraft:granite_stairs":                         self = .graniteStairs
            case "minecraft:diorite_stairs":                         self = .dioriteStairs
            case "minecraft:andesite_stairs":                        self = .andesiteStairs
            case "minecraft:polished_granite_stairs":                self = .polishedGraniteStairs
            case "minecraft:polished_diorite_stairs":                self = .polishedDioriteStairs
            case "minecraft:polished_andesite_stairs":               self = .polishedAndesiteStairs

            case "minecraft:sandstone_stairs":                       self = .sandstoneStairs
            case "minecraft:red_sandstone_stairs":                   self = .redSandstoneStairs
            case "minecraft:smooth_sandstone_stairs":                self = .smoothSandstoneStairs
            case "minecraft:smooth_red_sandstone_stairs":            self = .smoothRedSandstoneStairs
            case "minecraft:brick_stairs":                           self = .redBrickStairs
            case "minecraft:mud_brick_stairs":                       self = .mudBrickStairs

            case "minecraft:blackstone_stairs":                      self = .blackstoneStairs
            case "minecraft:polished_blackstone_stairs":             self = .polishedBlackstoneStairs
            case "minecraft:polished_blackstone_brick_stairs":       self = .polishedBlackstoneBrickStairs

            case "minecraft:cobbled_deepslate_stairs":               self = .cobbledDeepslateStairs
            case "minecraft:deepslate_tile_stairs":                  self = .deepslateTileStairs
            case "minecraft:polished_deepslate_stairs":              self = .polishedDeepslateStairs
            case "minecraft:deepslate_brick_stairs":                 self = .deepslateBrickStairs

            case "minecraft:nether_brick_stairs":                    self = .netherBrickStairs
            case "minecraft:red_nether_brick_stairs":                self = .redNetherBrickStairs
            case "minecraft:end_brick_stairs":                       self = .endBrickStairs
            case "minecraft:quartz_stairs":                          self = .quartzStairs
            case "minecraft:smooth_quartz_stairs":                   self = .smoothQuartzStairs
            case "minecraft:purpur_stairs":                          self = .purpurStairs
            case "minecraft:prismarine_stairs":                      self = .prismarineStairs
            case "minecraft:dark_prismarine_stairs":                 self = .darkPrismarineStairs
            case "minecraft:prismarine_bricks_stairs":               self = .prismarineBricksStairs

            case "minecraft:cut_copper_stairs":                      self = .cutCopperStairs
            case "minecraft:exposed_cut_copper_stairs":              self = .exposedCutCopperStairs
            case "minecraft:oxidized_cut_copper_stairs":             self = .oxidizedCutCopperStairs
            case "minecraft:weathered_cut_copper_stairs":            self = .weatheredCutCopperStairs
            case "minecraft:waxed_cut_copper_stairs":                self = .waxedCutCopperStairs
            case "minecraft:waxed_exposed_cut_copper_stairs":        self = .waxedExposedCutCopperStairs
            case "minecraft:waxed_oxidized_cut_copper_stairs":       self = .waxedOxidizedCutCopperStairs
            case "minecraft:waxed_weathered_cut_copper_stairs":      self = .waxedWeatheredCutCopperStairs

            /* ---------- ---------- ---------- Slabs ---------- ---------- ---------- */
            case "minecraft:wooden_slab":                            self = .oakSlab
            case "minecraft:mangrove_slab":                          self = .mangroveSlab
            case "minecraft:cherry_slab":                            self = .cherrySlab
            case "minecraft:bamboo_slab":                            self = .bambooSlab
            case "minecraft:bamboo_mosaic_slab":                     self = .bambooMosaicSlab
            case "minecraft:crimson_slab":                           self = .crimsonSlab
            case "minecraft:warped_slab":                            self = .warpedSlab

            case "minecraft:double_wooden_slab":                     self = .oakDoubleSlab
            case "minecraft:mangrove_double_slab":                   self = .mangroveDoubleSlab
            case "minecraft:cherry_double_slab":                     self = .cherryDoubleSlab
            case "minecraft:bamboo_double_slab":                     self = .bambooDoubleSlab
            case "minecraft:bamboo_mosaic_double_slab":              self = .bambooMosaicDoubleSlab
            case "minecraft:crimson_double_slab":                    self = .crimsonDoubleSlab
            case "minecraft:warped_double_slab":                     self = .warpedDoubleSlab

            case "minecraft:stone_block_slab":                       self = .cobblestoneSlab
            case "minecraft:double_stone_block_slab":                self = .cobblestoneDoubleSlab

            case "minecraft:stone_block_slab2":                      self = .mossyCobblestoneSlab
            case "minecraft:double_stone_block_slab2":               self = .mossyCobblestoneDoubleSlab

            case "minecraft:stone_block_slab3":                      self = .graniteSlab
            case "minecraft:double_stone_block_slab3":               self = .graniteDoubleSlab

            case "minecraft:stone_block_slab4":                      self = .stoneSlab
            case "minecraft:double_stone_block_slab4":               self = .stoneDoubleSlab

            case "minecraft:blackstone_slab":                        self = .blackstoneSlab
            case "minecraft:polished_blackstone_slab":               self = .polishedBlackstoneSlab
            case "minecraft:polished_blackstone_brick_slab":         self = .polishedBlackstoneBrickSlab
            case "minecraft:blackstone_double_slab":                 self = .blackstoneDoubleSlab
            case "minecraft:polished_blackstone_double_slab":        self = .polishedBlackstoneDoubleSlab
            case "minecraft:polished_blackstone_brick_double_slab":  self = .polishedBlackstoneBrickDoubleSlab

            case "minecraft:cobbled_deepslate_slab":                 self = .cobbledDeepslateSlab
            case "minecraft:deepslate_tile_slab":                    self = .deepslateTileSlab
            case "minecraft:polished_deepslate_slab":                self = .polishedDeepslateSlab
            case "minecraft:deepslate_brick_slab":                   self = .deepslateBrickSlab
            case "minecraft:cobbled_deepslate_double_slab":          self = .cobbledDeepslateDoubleSlab
            case "minecraft:deepslate_tile_double_slab":             self = .deepslateTileDoubleSlab
            case "minecraft:polished_deepslate_double_slab":         self = .polishedDeepslateDoubleSlab
            case "minecraft:deepslate_brick_double_slab":            self = .deepslateBrickDoubleSlab

            case "minecraft:mud_brick_slab":                         self = .mudBrickSlab
            case "minecraft:mud_brick_double_slab":                  self = .mudBrickDoubleSlab

            case "minecraft:cut_copper_slab":                        self = .cutCopperSlab
            case "minecraft:exposed_cut_copper_slab":                self = .exposedCutCopperSlab
            case "minecraft:oxidized_cut_copper_slab":               self = .oxidizedCutCopperSlab
            case "minecraft:weathered_cut_copper_slab":              self = .weatheredCutCopperSlab
            case "minecraft:waxed_cut_copper_slab":                  self = .waxedCutCopperSlab
            case "minecraft:waxed_exposed_cut_copper_slab":          self = .waxedExposedCutCopperSlab
            case "minecraft:waxed_oxidized_cut_copper_slab":         self = .waxedOxidizedCutCopperSlab
            case "minecraft:waxed_weathered_cut_copper_slab":        self = .waxedWeatheredCutCopperSlab

            case "minecraft:double_cut_copper_slab":                 self = .doubleCutCopperSlab
            case "minecraft:exposed_double_cut_copper_slab":         self = .exposedDoubleCutCopperSlab
            case "minecraft:oxidized_double_cut_copper_slab":        self = .oxidizedDoubleCutCopperSlab
            case "minecraft:weathered_double_cut_copper_slab":       self = .weatheredDoubleCutCopperSlab
            case "minecraft:waxed_double_cut_copper_slab":           self = .waxedDoubleCutCopperSlab
            case "minecraft:waxed_exposed_double_cut_copper_slab":   self = .waxedExposedDoubleCutCopperSlab
            case "minecraft:waxed_oxidized_double_cut_copper_slab":  self = .waxedOxidizedDoubleCutCopperSlab
            case "minecraft:waxed_weathered_double_cut_copper_slab": self = .waxedWeatheredDoubleCutCopperSlab

            /* ---------- ---------- ---------- Signs ---------- ---------- ---------- */
            case "minecraft:standing_sign":                          self = .oakStandingSign
            case "minecraft:spruce_standing_sign":                   self = .spruceStandingSign
            case "minecraft:birch_standing_sign":                    self = .birchStandingSign
            case "minecraft:acacia_standing_sign":                   self = .acaciaStandingSign
            case "minecraft:jungle_standing_sign":                   self = .jungleStandingSign
            case "minecraft:darkoak_standing_sign":                  self = .darkoakStandingSign
            case "minecraft:mangrove_standing_sign":                 self = .mangroveStandingSign
            case "minecraft:cherry_standing_sign":                   self = .cherryStandingSign
            case "minecraft:bamboo_standing_sign":                   self = .bambooStandingSign
            case "minecraft:crimson_standing_sign":                  self = .crimsonStandingSign
            case "minecraft:warped_standing_sign":                   self = .warpedStandingSign

            case "minecraft:oak_hanging_sign":                       self = .oakHangingSign
            case "minecraft:spruce_hanging_sign":                    self = .spruceHangingSign
            case "minecraft:birch_hanging_sign":                     self = .birchHangingSign
            case "minecraft:acacia_hanging_sign":                    self = .acaciaHangingSign
            case "minecraft:jungle_hanging_sign":                    self = .jungleHangingSign
            case "minecraft:dark_oak_hanging_sign":                  self = .darkOakHangingSign
            case "minecraft:mangrove_hanging_sign":                  self = .mangroveHangingSign
            case "minecraft:cherry_hanging_sign":                    self = .cherryHangingSign
            case "minecraft:bamboo_hanging_sign":                    self = .bambooHangingSign
            case "minecraft:crimson_hanging_sign":                   self = .crimsonHangingSign
            case "minecraft:warped_hanging_sign":                    self = .warpedHangingSign

            case "minecraft:wall_sign":                              self = .oakWallSign
            case "minecraft:spruce_wall_sign":                       self = .spruceWallSign
            case "minecraft:birch_wall_sign":                        self = .birchWallSign
            case "minecraft:acacia_wall_sign":                       self = .acaciaWallSign
            case "minecraft:jungle_wall_sign":                       self = .jungleWallSign
            case "minecraft:darkoak_wall_sign":                      self = .darkoakWallSign
            case "minecraft:mangrove_wall_sign":                     self = .mangroveWallSign
            case "minecraft:cherry_wall_sign":                       self = .cherryWallSign
            case "minecraft:bamboo_wall_sign":                       self = .bambooWallSign
            case "minecraft:crimson_wall_sign":                      self = .crimsonWallSign
            case "minecraft:warped_wall_sign":                       self = .warpedWallSign

            /* ---------- ---------- ---------- Doors & Trapdoors ---------- ---------- ---------- */
            case "minecraft:wooden_door":                            self = .oakDoor
            case "minecraft:spruce_door":                            self = .spruceDoor
            case "minecraft:birch_door":                             self = .birchDoor
            case "minecraft:jungle_door":                            self = .jungleDoor
            case "minecraft:acacia_door":                            self = .acaciaDoor
            case "minecraft:dark_oak_door":                          self = .darkOakDoor
            case "minecraft:mangrove_door":                          self = .mangroveDoor
            case "minecraft:cherry_door":                            self = .cherryDoor
            case "minecraft:bamboo_door":                            self = .bambooDoor
            case "minecraft:crimson_door":                           self = .crimsonDoor
            case "minecraft:warped_door":                            self = .warpedDoor
            case "minecraft:iron_door":                              self = .ironDoor

            case "minecraft:trapdoor":                               self = .oakTrapdoor
            case "minecraft:spruce_trapdoor":                        self = .spruceTrapdoor
            case "minecraft:birch_trapdoor":                         self = .birchTrapdoor
            case "minecraft:jungle_trapdoor":                        self = .jungleTrapdoor
            case "minecraft:acacia_trapdoor":                        self = .acaciaTrapdoor
            case "minecraft:dark_oak_trapdoor":                      self = .darkOakTrapdoor
            case "minecraft:mangrove_trapdoor":                      self = .mangroveTrapdoor
            case "minecraft:cherry_trapdoor":                        self = .cherryTrapdoor
            case "minecraft:bamboo_trapdoor":                        self = .bambooTrapdoor
            case "minecraft:crimson_trapdoor":                       self = .crimsonTrapdoor
            case "minecraft:warped_trapdoor":                        self = .warpedTrapdoor
            case "minecraft:iron_trapdoor":                          self = .ironTrapdoor

            /* ---------- ---------- ---------- Village Blocks ---------- ---------- ---------- */
            case "minecraft:iron_bars":                              self = .ironBars
            case "minecraft:ladder":                                 self = .ladder
            case "minecraft:scaffolding":                            self = .scaffolding
            case "minecraft:honeycomb_block":                        self = .honeycombBlock
            case "minecraft:lodestone":                              self = .lodestone
            case "minecraft:hay_block":                              self = .hayBlock

            case "minecraft:torch":                                  self = .torch
            case "minecraft:soul_torch":                             self = .soulTorch
            case "minecraft:lantern":                                self = .lantern
            case "minecraft:soul_lantern":                           self = .soulLantern
            case "minecraft:campfire":                               self = .campfire
            case "minecraft:soul_campfire":                          self = .soulCampfire

            case "minecraft:crafting_table":                         self = .craftingTable
            case "minecraft:cartography_table":                      self = .cartographyTable
            case "minecraft:fletching_table":                        self = .fletchingTable
            case "minecraft:smithing_table":                         self = .smithingTable
            case "minecraft:beehive":                                self = .beehive
            case "minecraft:furnace":                                self = .furnace
            case "minecraft:lit_furnace":                            self = .litFurnace
            case "minecraft:blast_furnace":                          self = .blastFurnace
            case "minecraft:lit_blast_furnace":                      self = .litBlastFurnace
            case "minecraft:smoker":                                 self = .smoker
            case "minecraft:lit_smoker":                             self = .litSmoker
            case "minecraft:respawn_anchor":                         self = .respawnAnchor
            case "minecraft:brewing_stand":                          self = .brewingStand
            case "minecraft:anvil":                                  self = .anvil
            case "minecraft:grindstone":                             self = .grindstone
            case "minecraft:enchanting_table":                       self = .enchantingTable
            case "minecraft:bookshelf":                              self = .bookshelf
            case "minecraft:chiseled_bookshelf":                     self = .chiseledBookshelf
            case "minecraft:lectern":                                self = .lectern
            case "minecraft:composter":                              self = .composter
            case "minecraft:cauldron":                               self = .emptyCauldron

            case "minecraft:chest":                                  self = .chest
            case "minecraft:trapped_chest":                          self = .trappedChest
            case "minecraft:ender_chest":                            self = .enderChest
            case "minecraft:barrel":                                 self = .barrel

            case "minecraft:noteblock":                              self = .noteblock
            case "minecraft:jukebox":                                self = .jukebox
            case "minecraft:frame":                                  self = .frame
            case "minecraft:glow_frame":                             self = .glowFrame
            case "minecraft:flower_pot":                             self = .flowerPot
            case "minecraft:beacon":                                 self = .beacon
            case "minecraft:bell":                                   self = .bell
            case "minecraft:stonecutter_block":                      self = .stonecutterBlock
            case "minecraft:loom":                                   self = .loom
            case "minecraft:decorated_pot":                          self = .decoratedPot
            case "minecraft:chain":                                  self = .chain
            case "minecraft:end_rod":                                self = .endRod
            case "minecraft:lightning_rod":                          self = .lightningRod

            case "minecraft:skull":                                  self = .skull
            case "minecraft:rail":                                   self = .rail
            case "minecraft:golden_rail":                            self = .goldenRail
            case "minecraft:detector_rail":                          self = .detectorRail
            case "minecraft:activator_rail":                         self = .activatorRail

            /* ---------- ---------- ---------- Tech Blocks ---------- ---------- ---------- */
            case "minecraft:command_block":                          self = .commandBlock
            case "minecraft:repeating_command_block":                self = .repeatingCommandBlock
            case "minecraft:chain_command_block":                    self = .chainCommandBlock
            case "minecraft:structure_block":                        self = .structureBlock
            case "minecraft:structure_void":                         self = .structureVoid
            case "minecraft:moving_block":                           self = .movingBlock
            case "minecraft:light_block":                            self = .lightBlock
            case "minecraft:barrier":                                self = .barrier
            case "minecraft:jigsaw":                                 self = .jigsaw

            case "minecraft:wooden_button":                          self = .woodenButton
            case "minecraft:spruce_button":                          self = .spruceButton
            case "minecraft:birch_button":                           self = .birchButton
            case "minecraft:jungle_button":                          self = .jungleButton
            case "minecraft:acacia_button":                          self = .acaciaButton
            case "minecraft:dark_oak_button":                        self = .darkOakButton
            case "minecraft:mangrove_button":                        self = .mangroveButton
            case "minecraft:cherry_button":                          self = .cherryButton
            case "minecraft:bamboo_button":                          self = .bambooButton
            case "minecraft:crimson_button":                         self = .crimsonButton
            case "minecraft:warped_button":                          self = .warpedButton
            case "minecraft:stone_button":                           self = .stoneButton
            case "minecraft:polished_blackstone_button":             self = .polishedBlackstoneButton

            case "minecraft:wooden_pressure_plate":                  self = .woodenPressurePlate
            case "minecraft:spruce_pressure_plate":                  self = .sprucePressurePlate
            case "minecraft:birch_pressure_plate":                   self = .birchPressurePlate
            case "minecraft:jungle_pressure_plate":                  self = .junglePressurePlate
            case "minecraft:acacia_pressure_plate":                  self = .acaciaPressurePlate
            case "minecraft:dark_oak_pressure_plate":                self = .darkOakPressurePlate
            case "minecraft:mangrove_pressure_plate":                self = .mangrovePressurePlate
            case "minecraft:cherry_pressure_plate":                  self = .cherryPressurePlate
            case "minecraft:bamboo_pressure_plate":                  self = .bambooPressurePlate
            case "minecraft:crimson_pressure_plate":                 self = .crimsonPressurePlate
            case "minecraft:warped_pressure_plate":                  self = .warpedPressurePlate
            case "minecraft:stone_pressure_plate":                   self = .stonePressurePlate
            case "minecraft:light_weighted_pressure_plate":          self = .lightWeightedPressurePlate
            case "minecraft:heavy_weighted_pressure_plate":          self = .heavyWeightedPressurePlate
            case "minecraft:polished_blackstone_pressure_plate":     self = .polishedBlackstonePressurePlate

            case "minecraft:redstone_wire":                          self = .redstoneWire
            case "minecraft:redstone_torch":                         self = .redstoneTorch
            case "minecraft:unlit_redstone_torch":                   self = .unlitRedstoneTorch
            case "minecraft:lever":                                  self = .lever
            case "minecraft:tripwire_hook":                          self = .tripwireHook
            case "minecraft:trip_wire":                              self = .tripWire
            case "minecraft:redstone_lamp":                          self = .redstoneLamp
            case "minecraft:lit_redstone_lamp":                      self = .litRedstoneLamp
            case "minecraft:observer":                               self = .observer
            case "minecraft:daylight_detector":                      self = .daylightDetector
            case "minecraft:daylight_detector_inverted":             self = .daylightDetectorInverted
            case "minecraft:powered_repeater":                       self = .poweredRepeater
            case "minecraft:unpowered_repeater":                     self = .unpoweredRepeater
            case "minecraft:powered_comparator":                     self = .poweredComparator
            case "minecraft:unpowered_comparator":                   self = .unpoweredComparator
            case "minecraft:hopper":                                 self = .hopper
            case "minecraft:dropper":                                self = .dropper
            case "minecraft:dispenser":                              self = .dispenser
            case "minecraft:piston":                                 self = .piston
            case "minecraft:piston_arm_collision":                   self = .pistonArmCollision
            case "minecraft:sticky_piston":                          self = .stickyPiston
            case "minecraft:sticky_piston_arm_collision":            self = .stickyPistonArmCollision
            case "minecraft:tnt":                                    self = .tnt
            case "minecraft:target":                                 self = .target
            case "minecraft:slime":                                  self = .slime
            case "minecraft:honey_block":                            self = .honeyBlock

            /* ---------- ---------- ---------- Colored Blocks ---------- ---------- ---------- */
            case "minecraft:bed":                                    self = .bed
            case "minecraft:standing_banner":                        self = .standingBanner
            case "minecraft:wall_banner":                            self = .wallBanner

            case "minecraft:tinted_glass":                           self = .tintedGlass
            case "minecraft:glass":                                  self = .glass
            case "minecraft:glass_pane":                             self = .glassPane
            case "minecraft:stained_glass":                          self = .whiteStainedGlass
            case "minecraft:stained_glass_pane":                     self = .whiteStainedGlassPane

            case "minecraft:undyed_shulker_box":                     self = .undyedShulkerBox
            case "minecraft:white_shulker_box":                      self = .whiteShulkerBox
            case "minecraft:light_gray_shulker_box":                 self = .lightGrayShulkerBox
            case "minecraft:gray_shulker_box":                       self = .grayShulkerBox
            case "minecraft:black_shulker_box":                      self = .blackShulkerBox
            case "minecraft:brown_shulker_box":                      self = .brownShulkerBox
            case "minecraft:red_shulker_box":                        self = .redShulkerBox
            case "minecraft:orange_shulker_box":                     self = .orangeShulkerBox
            case "minecraft:yellow_shulker_box":                     self = .yellowShulkerBox
            case "minecraft:lime_shulker_box":                       self = .limeShulkerBox
            case "minecraft:green_shulker_box":                      self = .greenShulkerBox
            case "minecraft:cyan_shulker_box":                       self = .cyanShulkerBox
            case "minecraft:light_blue_shulker_box":                 self = .lightBlueShulkerBox
            case "minecraft:blue_shulker_box":                       self = .blueShulkerBox
            case "minecraft:purple_shulker_box":                     self = .purpleShulkerBox
            case "minecraft:magenta_shulker_box":                    self = .magentaShulkerBox
            case "minecraft:pink_shulker_box":                       self = .pinkShulkerBox

            case "minecraft:white_wool":                             self = .whiteWool
            case "minecraft:light_gray_wool":                        self = .lightGrayWool
            case "minecraft:gray_wool":                              self = .grayWool
            case "minecraft:black_wool":                             self = .blackWool
            case "minecraft:brown_wool":                             self = .brownWool
            case "minecraft:red_wool":                               self = .redWool
            case "minecraft:orange_wool":                            self = .orangeWool
            case "minecraft:yellow_wool":                            self = .yellowWool
            case "minecraft:lime_wool":                              self = .limeWool
            case "minecraft:green_wool":                             self = .greenWool
            case "minecraft:cyan_wool":                              self = .cyanWool
            case "minecraft:light_blue_wool":                        self = .lightBlueWool
            case "minecraft:blue_wool":                              self = .blueWool
            case "minecraft:purple_wool":                            self = .purpleWool
            case "minecraft:magenta_wool":                           self = .magentaWool
            case "minecraft:pink_wool":                              self = .pinkWool

            case "minecraft:white_carpet":                           self = .whiteCarpet
            case "minecraft:light_gray_carpet":                      self = .lightGrayCarpet
            case "minecraft:gray_carpet":                            self = .grayCarpet
            case "minecraft:black_carpet":                           self = .blackCarpet
            case "minecraft:brown_carpet":                           self = .brownCarpet
            case "minecraft:red_carpet":                             self = .redCarpet
            case "minecraft:orange_carpet":                          self = .orangeCarpet
            case "minecraft:yellow_carpet":                          self = .yellowCarpet
            case "minecraft:lime_carpet":                            self = .limeCarpet
            case "minecraft:green_carpet":                           self = .greenCarpet
            case "minecraft:cyan_carpet":                            self = .cyanCarpet
            case "minecraft:light_blue_carpet":                      self = .lightBlueCarpet
            case "minecraft:blue_carpet":                            self = .blueCarpet
            case "minecraft:purple_carpet":                          self = .purpleCarpet
            case "minecraft:magenta_carpet":                         self = .magentaCarpet
            case "minecraft:pink_carpet":                            self = .pinkCarpet

            case "minecraft:candle":                                 self = .candle
            case "minecraft:white_candle":                           self = .whiteCandle
            case "minecraft:light_gray_candle":                      self = .lightGrayCandle
            case "minecraft:gray_candle":                            self = .grayCandle
            case "minecraft:black_candle":                           self = .blackCandle
            case "minecraft:brown_candle":                           self = .brownCandle
            case "minecraft:red_candle":                             self = .redCandle
            case "minecraft:orange_candle":                          self = .orangeCandle
            case "minecraft:yellow_candle":                          self = .yellowCandle
            case "minecraft:lime_candle":                            self = .limeCandle
            case "minecraft:green_candle":                           self = .greenCandle
            case "minecraft:cyan_candle":                            self = .cyanCandle
            case "minecraft:light_blue_candle":                      self = .lightBlueCandle
            case "minecraft:blue_candle":                            self = .blueCandle
            case "minecraft:purple_candle":                          self = .purpleCandle
            case "minecraft:magenta_candle":                         self = .magentaCandle
            case "minecraft:pink_candle":                            self = .pinkCandle

            case "minecraft:cake":                                   self = .cake
            case "minecraft:candle_cake":                            self = .candleCake
            case "minecraft:white_candle_cake":                      self = .whiteCandleCake
            case "minecraft:light_gray_candle_cake":                 self = .lightGrayCandleCake
            case "minecraft:gray_candle_cake":                       self = .grayCandleCake
            case "minecraft:black_candle_cake":                      self = .blackCandleCake
            case "minecraft:brown_candle_cake":                      self = .brownCandleCake
            case "minecraft:red_candle_cake":                        self = .redCandleCake
            case "minecraft:orange_candle_cake":                     self = .orangeCandleCake
            case "minecraft:yellow_candle_cake":                     self = .yellowCandleCake
            case "minecraft:lime_candle_cake":                       self = .limeCandleCake
            case "minecraft:green_candle_cake":                      self = .greenCandleCake
            case "minecraft:cyan_candle_cake":                       self = .cyanCandleCake
            case "minecraft:light_blue_candle_cake":                 self = .lightBlueCandleCake
            case "minecraft:blue_candle_cake":                       self = .blueCandleCake
            case "minecraft:purple_candle_cake":                     self = .purpleCandleCake
            case "minecraft:magenta_candle_cake":                    self = .magentaCandleCake
            case "minecraft:pink_candle_cake":                       self = .pinkCandleCake

            case "minecraft:concrete_powder":                        self = .whiteConcretePowder

            case "minecraft:concrete":                               self = .concrete
            case "minecraft:white_concrete":                         self = .whiteConcrete
            case "minecraft:light_gray_concrete":                    self = .lightGrayConcrete
            case "minecraft:gray_concrete":                          self = .grayConcrete
            case "minecraft:black_concrete":                         self = .blackConcrete
            case "minecraft:brown_concrete":                         self = .brownConcrete
            case "minecraft:red_concrete":                           self = .redConcrete
            case "minecraft:orange_concrete":                        self = .orangeConcrete
            case "minecraft:yellow_concrete":                        self = .yellowConcrete
            case "minecraft:lime_concrete":                          self = .limeConcrete
            case "minecraft:green_concrete":                         self = .greenConcrete
            case "minecraft:cyan_concrete":                          self = .cyanConcrete
            case "minecraft:light_blue_concrete":                    self = .lightBlueConcrete
            case "minecraft:blue_concrete":                          self = .blueConcrete
            case "minecraft:purple_concrete":                        self = .purpleConcrete
            case "minecraft:magenta_concrete":                       self = .magentaConcrete
            case "minecraft:pink_concrete":                          self = .pinkConcrete

            case "minecraft:clay":                                   self = .clay
            case "minecraft:hardened_clay":                          self = .hardenedClay
            case "minecraft:stained_hardened_clay":                  self = .whiteStainedHardenedClay

            case "minecraft:white_glazed_terracotta":                self = .whiteGlazedTerracotta
            case "minecraft:silver_glazed_terracotta":               self = .silverGlazedTerracotta
            case "minecraft:gray_glazed_terracotta":                 self = .grayGlazedTerracotta
            case "minecraft:black_glazed_terracotta":                self = .blackGlazedTerracotta
            case "minecraft:brown_glazed_terracotta":                self = .brownGlazedTerracotta
            case "minecraft:red_glazed_terracotta":                  self = .redGlazedTerracotta
            case "minecraft:orange_glazed_terracotta":               self = .orangeGlazedTerracotta
            case "minecraft:yellow_glazed_terracotta":               self = .yellowGlazedTerracotta
            case "minecraft:lime_glazed_terracotta":                 self = .limeGlazedTerracotta
            case "minecraft:green_glazed_terracotta":                self = .greenGlazedTerracotta
            case "minecraft:cyan_glazed_terracotta":                 self = .cyanGlazedTerracotta
            case "minecraft:light_blue_glazed_terracotta":           self = .lightBlueGlazedTerracotta
            case "minecraft:blue_glazed_terracotta":                 self = .blueGlazedTerracotta
            case "minecraft:purple_glazed_terracotta":               self = .purpleGlazedTerracotta
            case "minecraft:magenta_glazed_terracotta":              self = .magentaGlazedTerracotta
            case "minecraft:pink_glazed_terracotta":                 self = .pinkGlazedTerracotta

            case "minecraft:coral_block":                            self = .tubeCoralBlock

            case "minecraft:fire_coral":                             self = .fireCoral
            case "minecraft:brain_coral":                            self = .brainCoral
            case "minecraft:bubble_coral":                           self = .bubbleCoral
            case "minecraft:tube_coral":                             self = .tubeCoral
            case "minecraft:horn_coral":                             self = .hornCoral
            case "minecraft:dead_fire_coral":                        self = .deadFireCoral
            case "minecraft:dead_brain_coral":                       self = .deadBrainCoral
            case "minecraft:dead_bubble_coral":                      self = .deadBubbleCoral
            case "minecraft:dead_tube_coral":                        self = .deadTubeCoral
            case "minecraft:dead_horn_coral":                        self = .deadHornCoral

            case "minecraft:coral_fan":                              self = .tubeCoralFan
            case "minecraft:coral_fan_dead":                         self = .deadTubeCoralFan

            case "minecraft:coral_fan_hang":                         self = .tubeCoralHang
            case "minecraft:coral_fan_hang2":                        self = .bubbleCoralHang
            case "minecraft:coral_fan_hang3":                        self = .hornCoralHang

            /* ---------- ---------- ---------- Other ---------- ---------- ---------- */
            case "minecraft:client_request_placeholder_block":       self = .clientRequestPlaceholderBlock
            case "minecraft:invisible_bedrock":                      self = .invisibleBedrock
            case "minecraft:reserved6":                              self = .reserved6
            case "minecraft:netherreactor":                          self = .netherreactor
            case "minecraft:glowingobsidian":                        self = .glowingobsidian
            case "minecraft:stonecutter":                            self = .stonecutter
            case "minecraft:info_update":                            self = .infoUpdate
            case "minecraft:info_update2":                           self = .infoUpdate2

            default:                                                 self = .unknown
        }
    }
}
