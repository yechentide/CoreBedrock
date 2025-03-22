//
// Created by yechentide on 2025/03/20
//

extension MCBlockType {
    var isFlower: Bool {
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
                 .witherRose,
                 .torchflower,
                 .closedEyeblossom,
                 .openEyeblossom:
                 true
            default:
                false
        }
    }

    var isPlant: Bool {
        if self.isFlower { return true }
        return switch self {
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
                 .fern,
                 .largeFern,
                 .shortGrass,
                 .tallGrass,
                 .netherSprouts,
                 .waterlily,
                 .seagrass,
                 .kelp,
                 .deadbush,
                 .bambooSapling,
                 .bamboo,
                 .brownMushroom,
                 .redMushroom,
                 .crimsonFungus,
                 .warpedFungus,
                 .bigDripleaf,
                 .reeds:
                true
            default:
                false
        }
    }
}
