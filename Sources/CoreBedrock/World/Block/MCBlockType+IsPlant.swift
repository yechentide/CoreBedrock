//
// Created by yechentide on 2025/03/20
//

extension MCBlockType {
    public var isFlower: Bool {
        switch self {
            case .crimsonRoots,
                 .warpedRoots,
                 .dandelion,
                 .poppy,
                 .blueOrchid,
                 .allium,
                 .azureBluet,
                 .redTulip,
                 .orangeTulip,
                 .whiteTulip,
                 .pinkTulip,
                 .oxeyeDaisy,
                 .cornflower,
                 .lilyOfTheValley,
                 .sunflower,
                 .lilac,
                 .roseBush,
                 .peony,
                 .pitcherPlant,
                 .pinkPetals,
                 .wildflowers,
                 .witherRose,
                 .torchflower,
                 .cactusFlower,
                 .closedEyeblossom,
                 .openEyeblossom:
                return true
            default:
                return false
        }
    }

    public var isPlant: Bool {
        if self.isFlower { return true }
        switch self {
            case .oakSapling,
                 .spruceSapling,
                 .birchSapling,
                 .jungleSapling,
                 .acaciaSapling,
                 .darkOakSapling,
                 .mangrovePropagule,
                 .cherrySapling,
                 .paleOakSapling,
                 .wheat,
                 .pumpkinStem,
                 .melonStem,
                 .beetroot,
                 .torchflowerCrop,
                 .pitcherCrop,
                 .potatoes,
                 .carrots,
                 .sweetBerryBush,
                 .caveVines,
                 .caveVinesHeadWithBerries,
                 .caveVinesBodyWithBerries,
                 .fern,
                 .largeFern,
                 .tallGrass,
                 .shortGrass,
                 .bush,
                 .shortDryGrass,
                 .tallDryGrass,
                 .netherSprouts,
                 .vine,
                 .weepingVines,
                 .twistingVines,
                 .waterlily,
                 .seagrass,
                 .kelp,
                 .deadbush,
                 .bambooSapling,
                 .leafLitter,
                 .bigDripleaf,
                 .smallDripleafBlock,
                 .sporeBlossom,
                 .fireflyBush,
                 .glowLichen,
                 .sugarCane,
                 .netherWart,
                 .chorusFlower,
                 .chorusPlant:
                return true
            default:
                return false
        }
    }
}
