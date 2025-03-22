//
// Created by yechentide on 2025/03/21
//

public enum MCOldBlockType: String, CaseIterable, Sendable {
    case mysteriousFrameSlot                = "minecraft:mysterious_frame_slot"
    case leaves                             = "minecraft:leaves"
    case stainedHardenedClay                = "minecraft:stained_hardened_clay"
    case fence                              = "minecraft:fence"
    case hardenedGlass                      = "minecraft:hardened_glass"
    case doubleStoneSlab2                   = "minecraft:double_stone_slab2"
    case invisibleBedrock1                  = "minecraft:invisibleBedrock"
    case invisibleBedrock2                  = "minecraft:invisible_bedrock"
    case invisibleBedrock3                  = "minecraft:invisiblebedrock"
    case doubleStoneSlab3                   = "minecraft:double_stone_slab3"
    case stickyPistonArmCollision           = "minecraft:stickypistonarmcollision"
    case coral                              = "minecraft:coral"
    case doubleStoneSlab                    = "minecraft:double_stone_slab"
    case stainedGlassPane                   = "minecraft:stained_glass_pane"
    case seaLantern                         = "minecraft:sealantern"
    case wood                               = "minecraft:wood"
    case coralFan                           = "minecraft:coral_fan"
    case doubleWoodenSlab                   = "minecraft:double_wooden_slab"
    case movingBlock1                       = "minecraft:movingblock"
    case movingBlock2                       = "minecraft:movingBlock"
    case doubleStoneSlab4                   = "minecraft:double_stone_slab4"
    case stoneSlab3                         = "minecraft:stone_slab3"
    case lavaCauldron                       = "minecraft:lava_cauldron"
    case tripwire                           = "minecraft:tripwire"
    case shulkerBox                         = "minecraft:shulker_box"
    case coralBlock                         = "minecraft:coral_block"
    case planks                             = "minecraft:planks"
    case carpet                             = "minecraft:carpet"
    case coralFanDead                       = "minecraft:coral_fan_dead"
    case concrete                           = "minecraft:concrete"
    case stoneSlab                          = "minecraft:stone_slab"
    case stainedGlass                       = "minecraft:stained_glass"
    case mysteriousFrame                    = "minecraft:mysterious_frame"
    case log                                = "minecraft:log"
    case leaves2                            = "minecraft:leaves2"
    case log2                               = "minecraft:log2"
    case pistonArmCollision                 = "minecraft:pistonarmcollision"
    case woodenSlab                         = "minecraft:wooden_slab"
    case hardStainedGlassPane               = "minecraft:hard_stained_glass_pane"
    case wool                               = "minecraft:wool"
    case hardStainedGlass                   = "minecraft:hard_stained_glass"
    case stoneSlab4                         = "minecraft:stone_slab4"
    case stoneSlab2                         = "minecraft:stone_slab2"

    case smallDripleaf                      = "minecraft:small_dripleaf"
    case grass                              = "minecraft:grass"
    case deepslateLapisLazuliOre            = "minecraft:deepslate_lapis_lazuli_ore"
    case caveVinesHeadBerries               = "minecraft:cave_vines_head_berries"
    case exposedDoubleCopperSlab            = "minecraft:exposed_double_copper_slab"
    case caveVinesBodyBerries               = "minecraft:cave_vines_body_berries"

    case oakDoor                            = "minecraft:oak_door"
    case concretePowder1                    = "minecraft:concretepowder"
    case concretePowder2                    = "minecraft:concrete_powder"
    case beetroots                          = "minecraft:beetroots"
    case border                             = "minecraft:border"
    case glowStick                          = "minecraft:glow_stick"
    case impulseCommandBlock                = "minecraft:impulse_command_block"
    case woodenTrapdoor                     = "minecraft:wooden_trapdoor"
    case netherBrickBlock                   = "minecraft:nether_brick_block"

    case netherreactor                      = "minecraft:netherreactor"
    case glowingobsidian                    = "minecraft:glowingobsidian"
    case stonecutter                        = "minecraft:stonecutter"
    case skull                              = "minecraft:skull"
    case monsterEgg                         = "minecraft:monster_egg"
    case chemistryTable                     = "minecraft:chemistry_table"
    case yellowFlower                       = "minecraft:yellow_flower"
    case redFlower                          = "minecraft:red_flower"
    case tallgrass                          = "minecraft:tallgrass"
    case doublePlant                        = "minecraft:double_plant"
    case sapling                            = "minecraft:sapling"

    case stonebrick                         = "minecraft:stonebrick"

    case stoneBlockSlab                     = "minecraft:stone_block_slab"
    case doubleStoneBlockSlab               = "minecraft:double_stone_block_slab"
    case stoneBlockSlab2                    = "minecraft:stone_block_slab2"
    case doubleStoneBlockSlab2              = "minecraft:double_stone_block_slab2"
    case stoneBlockSlab3                    = "minecraft:stone_block_slab3"
    case doubleStoneBlockSlab3              = "minecraft:double_stone_block_slab3"
    case stoneBlockSlab4                    = "minecraft:stone_block_slab4"
    case doubleStoneBlockSlab4              = "minecraft:double_stone_block_slab4"

    case petrifiedOakSlab                   = "minecraft:petrified_oak_slab"
    case petrifiedOakDoubleSlab             = "minecraft:petrified_oak_double_slab"

    case coralFanHang                       = "minecraft:coral_fan_hang"
    case coralFanHang2                      = "minecraft:coral_fan_hang2"
    case coralFanHang3                      = "minecraft:coral_fan_hang3"

    // Education Edition
    case coloredTorchRg                     = "minecraft:colored_torch_rg"
    case coloredTorchBp                     = "minecraft:colored_torch_bp"

    // Inaccessible in Survival mode
    case camera                             = "minecraft:camera"
    case lightBlock                         = "minecraft:light_block"
    case infoUpdate                         = "minecraft:info_update"
    case infoUpdate2                        = "minecraft:info_update2"
    case clientRequestPlaceholderBlock      = "minecraft:client_request_placeholder_block"
}

extension MCOldBlockType {
    var isFlower: Bool {
        if [.yellowFlower, .redFlower, .doublePlant].contains(self) {
            return true
        }
        return false
    }

    var isPlant: Bool {
        return self.isFlower
    }

    var isTransparent: Bool {
        if self.isPlant { return true }
        return switch self {
            default:
                false
        }
    }
}
