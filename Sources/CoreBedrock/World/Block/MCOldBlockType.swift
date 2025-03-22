//
// Created by yechentide on 2025/03/21
//

public enum MCOldBlockType: String, CaseIterable, Sendable {
    case netherreactor                      = "minecraft:netherreactor"
    case glowingobsidian                    = "minecraft:glowingobsidian"
    case invisibleBedrock                   = "minecraft:invisible_bedrock"
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
