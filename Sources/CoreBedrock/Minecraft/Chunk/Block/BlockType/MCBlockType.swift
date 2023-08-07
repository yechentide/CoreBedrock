import Foundation

public enum MCBlockType {
    case unknown
    case air
    case bedrock
    case fire
    case water
    case lava
    case flowingWater
    case flowingLava
    case obsidian
    case cryingObsidian

    /* ---------- ---------- ---------- Overworld ---------- ---------- ---------- */
    case grass
    /* dirt: [dirt_type] normal(dirt) / coarse(coarse dirt) */
    /**/case dirt
    /**/case coarseDirt
    case farmland
    case dirtPath   // grassPath
    case podzol
    case mycelium

    case gravel
    /* sand: [sand_type] normal(sand) / red(red sand) */
    /**/case sand
    /**/case redSand
    case suspiciousGravel
    case suspiciousSand

    case web
    case beeNest

    case mobSpawner
    /* monsterEgg [monster_egg_stone_type] stone / cobblestone / stone_brick / mossy_stone_brick / cracked_stone_brick / chiseled_stone_brick */
    /**/case infestedStone
    /**/case infestedCobblestone
    /**/case infestedStoneBrick
    /**/case infestedMossyStoneBrick
    /**/case infestedCrackedStoneBrick
    /**/case infestedChiseledStoneBrick
    case infestedDeepslate
    case turtleEgg
    case snifferEgg
    case frogSpawn

    case pearlescentFroglight
    case verdantFroglight
    case ochreFroglight
    case sponge

    // Plants
    case cactus
    case reeds
    case wheat
    case pumpkinStem
    case melonStem
    case beetroot
    case cocoa
    case vine
    case torchflowerCrop
    case pitcherCrop
    case potatoes
    case carrots
    case melonBlock
    case pumpkin
    case carvedPumpkin
    case litPumpkin
    case sweetBerryBush
    case caveVines
    case caveVinesHeadWithBerries
    case caveVinesBodyWithBerries
    case bamboo
    case brownMushroom
    case redMushroom

    case brownMushroomBlock
    case redMushroomBlock

    case deadbush
    // [tall_grass_type] default(Unused variant which looks identical to grass) / tall(grass) / fern(fern) / snow(looks identical to actual fern)
    case tallgrass
    // [double_plant_type] sunflower / syringa(lilac) / grass(double tallgrass) / fern(large fern) / rose(rose bush) / paeonia
    case doublePlant
    // = dandelion
    case yellowFlower
    // [flower_type] poppy / orchid(blue orchid) / allium / houstonia(azure bluet) / tulip_red / tulip_orange
    //               / tulip_white / tulip_pink / oxeye(oxeye daisy) / cornflower / lily_of_the_valley(lily of the valley)
    case redFlower
    case pitcherPlant
    case pinkPetals
    case witherRose
    case torchflower

    case waterlily
    case seagrass
    case kelp
    case driedKelpBlock

    // Ocean Biome
    case bubbleColumn
    case seaPickle
    case seaLantern
    case conduit

    // Snow Biome
    case snow
    case snowLayer
    case powderSnow
    case ice
    case blueIce
    case packedIce
    case frostedIce

    // Caves & Cliffs
    case glowLichen
    case dripstoneBlock
    case pointedDripstone
    case mossBlock
    case mossCarpet
    case dirtWithRoots
    case hangingRoots
    case bigDripleaf
    case smallDripleafBlock
    case sporeBlossom
    case azalea
    case floweringAzalea
    case amethystBlock
    case buddingAmethyst
    case amethystCluster
    case largeAmethystBud
    case mediumAmethystBud
    case smallAmethystBud
    case tuff
    case calcite

    // Mangrove Swamp Biome
    case mud
    case muddyMangroveRoots
    case mangroveRoots

    // Deep Dark Biome
    case reinforcedDeepslate
    case sculk
    case sculkVein
    case sculkCatalyst
    case sculkShrieker
    case sculkSensor
    case calibratedSculkSensor

    /* ---------- ---------- ---------- The Nether ---------- ---------- ---------- */
    case netherrack
    case shroomlight
    case netherWartBlock
    case crimsonNylium
    case warpedWartBlock
    case warpedNylium

    case basalt
    case polishedBasalt
    case smoothBasalt
    case soulSoil
    case soulSand

    case portal
    case soulFire
    case magma
    case glowstone

    // Plants
    case netherWart
    case crimsonRoots
    case warpedRoots
    case netherSprouts
    case weepingVines
    case twistingVines
    case crimsonFungus
    case warpedFungus

    /* ---------- ---------- ---------- The End ---------- ---------- ---------- */
    case endStone
    case dragonEgg
    case chorusPlant
    case chorusFlower

    case endPortalFrame
    case endPortal
    case endGateway

    /* ---------- ---------- ---------- Ores & Ore Blocks ---------- ---------- ---------- */
    case coalOre
    case copperOre
    case ironOre
    case goldOre
    case diamondOre
    case lapisOre
    case redstoneOre
    case litRedstoneOre
    case emeraldOre
    case netherGoldOre
    case quartzOre

    case deepslateCoalOre
    case deepslateCopperOre
    case deepslateIronOre
    case deepslateGoldOre
    case deepslateDiamondOre
    case deepslateLapisOre
    case deepslateRedstoneOre
    case litDeepslateRedstoneOre
    case deepslateEmeraldOre

    case rawCopperBlock
    case rawIronBlock
    case rawGoldBlock

    case coalBlock
    case ironBlock
    case goldBlock
    case diamondBlock
    case lapisBlock
    case redstoneBlock
    case emeraldBlock
    case netheriteBlock
    case ancientDebris

    case copperBlock
    case exposedCopper
    case oxidizedCopper
    case weatheredCopper

    case cutCopper
    case exposedCutCopper
    case oxidizedCutCopper
    case weatheredCutCopper

    case waxedCopper
    case waxedExposedCopper
    case waxedOxidizedCopper
    case waxedWeatheredCopper

    case waxedCutCopper
    case waxedExposedCutCopper
    case waxedOxidizedCutCopper
    case waxedWeatheredCutCopper

    /* ---------- ---------- ---------- Stones ---------- ---------- ---------- */
    case boneBlock
    case cobblestone
    case mossyCobblestone
    case cobbledDeepslate
    /* stone: [stone_type]
        stone / granite / granite_smooth / diorite / diorite_smooth / andesite / andesite_smooth */
    /**/case stone
    /**/case granite
    /**/case diorite
    /**/case andesite
    /**/case polishedGranite
    /**/case polishedDiorite
    /**/case polishedAndesite

    /* stonebrick: [stone_brick_type]
        default(stone bricks) / mossy(mossy stone bricks) / cracked(cracked stone bricks)
        / chiseled(chiseled stone bricks) / smooth(smooth stone bricks: same texture as regular ones) */
    /**/case stonebricks
    /**/case mossyStoneBricks
    /**/case crackedStoneBricks
    /**/case chiseledStoneBricks
    /**/case smoothStoneBricks

    case blackstone
    case polishedBlackstone

    case deepslate
    case polishedDeepslate

    case polishedBlackstoneBricks
    case crackedPolishedBlackstoneBricks
    case chiseledPolishedBlackstone
    case gildedBlackstone

    case deepslateTiles
    case crackedDeepslateTiles
    case deepslateBricks
    case crackedDeepslateBricks
    case chiseledDeepslate

    case smoothStone
    case redBrickBlock // brickBlock
    case packedMud
    case mudBricks

    case netherBrick
    case redNetherBrick
    case chiseledNetherBricks
    case crackedNetherBricks
    case endBricks

    /* prismarine [prismarine_block_type] default / dark / bricks */
    /**/case prismarine
    /**/case darkPrismarine
    /**/case prismarineBricks

    case quartzBricks
    /* quartzBlock [chisel_type] default / chiseled / lines / smooth */
    /**/case quartzBlock
    /**/case pillarQuartzBlock
    /**/case chiseledQuartzBlock
    /**/case smoothQuartzBlock

    /* purpurBlock [chisel_type] default / chiseled / lines / smooth */
    /**/case purpurBlock
    /**/case pillarPurpurBlock
    /**/case chiseledPurpurBlock
    /**/case smoothPurpurBlock

    /* sandstone: [sand_stone_type] default(sandstone) / heiroglyphs(chiseled sandstone) / cut(cut sandstone) / smooth(smooth sandstone) */
    /**/case sandstone
    /**/case chiseledSandstone
    /**/case cutSandstone
    /**/case smoothSandstone
    /* redSandstone: [sand_stone_type] default(sandstone) / heiroglyphs(chiseled sandstone) / cut(cut sandstone) / smooth(smooth sandstone) */
    /**/case redSandstone
    /**/case chiseledRedSandstone
    /**/case cutRedSandstone
    /**/case smoothRedSandstone

    /* ---------- ---------- ---------- Trees ---------- ---------- ---------- */
    // case log     // before 1.20
    // case log2    // before 1.20
    case oakLog
    case spruceLog
    case birchLog
    case jungleLog
    case acaciaLog
    case darkOakLog
    case mangroveLog
    case cherryLog
    case crimsonStem
    case warpedStem

    case strippedOakLog
    case strippedSpruceLog
    case strippedBirchLog
    case strippedJungleLog
    case strippedAcaciaLog
    case strippedDarkOakLog
    case strippedMangroveLog
    case strippedCherryLog
    case strippedCrimsonStem
    case strippedWarpedStem

    /* wood [wood_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /* [stripped_bit] false / true */
    /**/case oakWood
    /**/case spruceWood
    /**/case birchWood
    /**/case jungleWood
    /**/case acaciaWood
    /**/case darkOakWood
    case mangroveWood
    case cherryWood
    case bambooBlock
    case crimsonHyphae
    case warpedHyphae

    /* strippedWood [wood_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /* [stripped_bit] false / true */
    /**/case strippedOakWood
    /**/case strippedSpruceWood
    /**/case strippedBirchWood
    /**/case strippedJungleWood
    /**/case strippedAcaciaWood
    /**/case strippedDarkOakWood
    case strippedMangroveWood
    case strippedCherryWood
    case strippedBambooBlock
    case strippedCrimsonHyphae
    case strippedWarpedHyphae

    /* planks [wood_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /**/case oakPlanks
    /**/case sprucePlanks
    /**/case birchPlanks
    /**/case junglePlanks
    /**/case acaciaPlanks
    /**/case darkOakPlanks
    case mangrovePlanks
    case cherryPlanks
    case bambooPlanks
    case bambooMosaic
    case crimsonPlanks
    case warpedPlanks

    /* leaves [old_leaf_type] oak / spruce / birch / jungle */
    /**/case oakLeaves
    /**/case spruceLeaves
    /**/case birchLeaves
    /**/case jungleLeaves
    /* leaves2 [new_leaf_type] acacia / dark_oak */
    /**/case acaciaLeaves
    /**/case darkOakLeaves
    case mangroveLeaves
    case cherryLeaves
    case azaleaLeaves
    case azaleaLeavesFlowered

    /* sapling [sapling_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /**/case oakSapling
    /**/case spruceSapling
    /**/case birchSapling
    /**/case jungleSapling
    /**/case acaciaSapling
    /**/case darkOakSapling
    case mangrovePropagule
    case cherrySapling
    case bambooSapling

    /* ---------- ---------- ---------- Fences & Gates ---------- ---------- ---------- */
    // case fence       // before 1.20
    case oakFence
    case spruceFence
    case birchFence
    case jungleFence
    case acaciaFence
    case darkOakFence
    case mangroveFence
    case cherryFence
    case bambooFence
    case crimsonFence
    case warpedFence
    case netherBrickFence

    case oakFenceGate
    case spruceFenceGate
    case birchFenceGate
    case jungleFenceGate
    case acaciaFenceGate
    case darkOakFenceGate
    case mangroveFenceGate
    case cherryFenceGate
    case bambooFenceGate
    case crimsonFenceGate
    case warpedFenceGate

    /* ---------- ---------- ---------- Walls ---------- ---------- ---------- */
    /* cobblestoneWall [wall_block_type]
        cobblestone / mossy_cobblestone / granite / diorite / andesite
        / sandstone / brick(red brick) / stone_brick / mossy_stone_brick / nether_brick
        / end_brick / prismarine / red_sandstone / red_nether_brick */
    /**/case cobblestoneWall
    /**/case mossyCobblestoneWall
    /**/case graniteWall
    /**/case dioriteWall
    /**/case andesiteWall
    /**/case sandstoneWall
    /**/case redSandstoneWall
    /**/case stoneBrickWall
    /**/case mossyStoneBrickWall
    /**/case redBrickWall
    /**/case netherBrickWall
    /**/case redNetherBrickWall
    /**/case endBrickWall
    /**/case prismarineWall

    case blackstoneWall
    case polishedBlackstoneWall
    case polishedBlackstoneBrickWall

    case cobbledDeepslateWall
    case deepslateTileWall
    case polishedDeepslateWall
    case deepslateBrickWall

    case mudBrickWall

    /* ---------- ---------- ---------- Stairs ---------- ---------- ---------- */
    case oakStairs
    case spruceStairs
    case birchStairs
    case jungleStairs
    case acaciaStairs
    case darkOakStairs
    case mangroveStairs
    case cherryStairs
    case bambooStairs
    case bambooMosaicStairs
    case crimsonStairs
    case warpedStairs

    case normalStoneStairs
    case cobblestoneStairs  // stoneStairs
    case mossyCobblestoneStairs
    case stoneBrickStairs
    case mossyStoneBrickStairs

    case graniteStairs
    case dioriteStairs
    case andesiteStairs
    case polishedGraniteStairs
    case polishedDioriteStairs
    case polishedAndesiteStairs

    case sandstoneStairs
    case redSandstoneStairs
    case smoothSandstoneStairs
    case smoothRedSandstoneStairs
    case redBrickStairs     // brickStairs
    case mudBrickStairs

    case blackstoneStairs
    case polishedBlackstoneStairs
    case polishedBlackstoneBrickStairs

    case cobbledDeepslateStairs
    case deepslateTileStairs
    case polishedDeepslateStairs
    case deepslateBrickStairs

    case netherBrickStairs
    case redNetherBrickStairs
    case endBrickStairs
    case quartzStairs
    case smoothQuartzStairs
    case purpurStairs
    case prismarineStairs
    case darkPrismarineStairs
    case prismarineBricksStairs

    case cutCopperStairs
    case exposedCutCopperStairs
    case oxidizedCutCopperStairs
    case weatheredCutCopperStairs
    case waxedCutCopperStairs
    case waxedExposedCutCopperStairs
    case waxedOxidizedCutCopperStairs
    case waxedWeatheredCutCopperStairs

    /* ---------- ---------- ---------- Slabs ---------- ---------- ---------- */
    /* woodenSlab [wood_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /**/case oakSlab
    /**/case spruceSlab
    /**/case birchSlab
    /**/case jungleSlab
    /**/case acaciaSlab
    /**/case darkOakSlab
    case mangroveSlab
    case cherrySlab
    case bambooSlab
    case bambooMosaicSlab
    case crimsonSlab
    case warpedSlab

    /* doubleWoodenSlab [wood_type] oak / spruce / birch / jungle / acacia / dark_oak */
    /**/case oakDoubleSlab
    /**/case spruceDoubleSlab
    /**/case birchDoubleSlab
    /**/case jungleDoubleSlab
    /**/case acaciaDoubleSlab
    /**/case darkOakDoubleSlab
    case mangroveDoubleSlab
    case cherryDoubleSlab
    case bambooDoubleSlab
    case bambooMosaicDoubleSlab
    case crimsonDoubleSlab
    case warpedDoubleSlab

    /* stoneBlockSlab [stone_slab_type] smooth_stone / sandstone / wood / cobblestone / brick(red brick) / stone_brick / quartz / nether_brick */
    /**/case smoothStoneSlab
    /**/case cobblestoneSlab
    /**/case stoneBrickSlab
    /**/case sandstoneSlab
    /**/case redBrickSlab
    /**/case netherBrickSlab
    /**/case quartzSlab
    /* doubleStoneBlockSlab [stone_slab_type] ... */
    /**/case smoothStoneDoubleSlab
    /**/case cobblestoneDoubleSlab
    /**/case stoneBrickDoubleSlab
    /**/case sandstoneDoubleSlab
    /**/case redBrickDoubleSlab
    /**/case netherBrickDoubleSlab
    /**/case quartzDoubleSlab

    /* stoneBlockSlab2 [stone_slab_type_2] red_sandstone / purpur / prismarine_rough / prismarine_dark / prismarine_brick / mossy_cobblestone / smooth_sandstone / red_nether_brick */
    /**/case mossyCobblestoneSlab
    /**/case smoothSandstoneSlab
    /**/case redSandstoneSlab
    /**/case redNetherBrickSlab
    /**/case purpurSlab
    /**/case prismarineRoughSlab
    /**/case prismarineDarkSlab
    /**/case prismarineBrickSlab
    /* doubleStoneBlockSlab2 [stone_slab_type_2] ... */
    /**/case mossyCobblestoneDoubleSlab
    /**/case smoothSandstoneDoubleSlab
    /**/case redSandstoneDoubleSlab
    /**/case redNetherBrickDoubleSlab
    /**/case purpurDoubleSlab
    /**/case prismarineRoughDoubleSlab
    /**/case prismarineDarkDoubleSlab
    /**/case prismarineBrickDoubleSlab

    /* stoneBlockSlab3 [stone_slab_type_3] end_stone_brick / smooth_red_sandstone / polished_andesite / andesite / diorite / polished_diorite / granite / polished_granite */
    /**/case smoothRedSandstoneSlab
    /**/case graniteSlab
    /**/case dioriteSlab
    /**/case andesiteSlab
    /**/case polishedGraniteSlab
    /**/case polishedDioriteSlab
    /**/case polishedAndesiteSlab
    /**/case endStoneBrickSlab
    /* doubleStoneBlockSlab3 [stone_slab_type_3] ... */
    /**/case smoothRedSandstoneDoubleSlab
    /**/case graniteDoubleSlab
    /**/case dioriteDoubleSlab
    /**/case andesiteDoubleSlab
    /**/case polishedGraniteDoubleSlab
    /**/case polishedDioriteDoubleSlab
    /**/case polishedAndesiteDoubleSlab
    /**/case endStoneBrickDoubleSlab

    /* stoneBlockSlab4 [stone_slab_type_4] mossy_stone_brick / smooth_quartz / stone / cut_sandstone / cut_red_sandstone */
    /**/case stoneSlab
    /**/case mossyStoneBrickSlab
    /**/case cutSandstoneSlab
    /**/case cutRedSandstoneSlab
    /**/case smoothQuartzSlab
    /* doubleStoneBlockSlab4 [stone_slab_type_4] ... */
    /**/case stoneDoubleSlab
    /**/case mossyStoneBrickDoubleSlab
    /**/case cutSandstoneDoubleSlab
    /**/case cutRedSandstoneDoubleSlab
    /**/case smoothQuartzDoubleSlab

    case blackstoneSlab
    case polishedBlackstoneSlab
    case polishedBlackstoneBrickSlab
    case blackstoneDoubleSlab
    case polishedBlackstoneDoubleSlab
    case polishedBlackstoneBrickDoubleSlab

    case cobbledDeepslateSlab
    case deepslateTileSlab
    case polishedDeepslateSlab
    case deepslateBrickSlab
    case cobbledDeepslateDoubleSlab
    case deepslateTileDoubleSlab
    case polishedDeepslateDoubleSlab
    case deepslateBrickDoubleSlab

    case mudBrickSlab
    case mudBrickDoubleSlab

    case cutCopperSlab
    case exposedCutCopperSlab
    case oxidizedCutCopperSlab
    case weatheredCutCopperSlab
    case waxedCutCopperSlab
    case waxedExposedCutCopperSlab
    case waxedOxidizedCutCopperSlab
    case waxedWeatheredCutCopperSlab

    case doubleCutCopperSlab
    case exposedDoubleCutCopperSlab
    case oxidizedDoubleCutCopperSlab
    case weatheredDoubleCutCopperSlab
    case waxedDoubleCutCopperSlab
    case waxedWeatheredDoubleCutCopperSlab
    case waxedOxidizedDoubleCutCopperSlab
    case waxedExposedDoubleCutCopperSlab

    /* ---------- ---------- ---------- Signs ---------- ---------- ---------- */
    case oakStandingSign
    case spruceStandingSign
    case birchStandingSign
    case acaciaStandingSign
    case jungleStandingSign
    case darkoakStandingSign
    case mangroveStandingSign
    case cherryStandingSign
    case bambooStandingSign
    case crimsonStandingSign
    case warpedStandingSign

    case oakHangingSign
    case spruceHangingSign
    case birchHangingSign
    case jungleHangingSign
    case acaciaHangingSign
    case darkOakHangingSign
    case mangroveHangingSign
    case cherryHangingSign
    case bambooHangingSign
    case crimsonHangingSign
    case warpedHangingSign

    case oakWallSign
    case spruceWallSign
    case birchWallSign
    case acaciaWallSign
    case jungleWallSign
    case darkoakWallSign
    case mangroveWallSign
    case cherryWallSign
    case bambooWallSign
    case crimsonWallSign
    case warpedWallSign

    /* ---------- ---------- ---------- Doors & Trapdoors ---------- ---------- ---------- */
    case oakDoor
    case spruceDoor
    case birchDoor
    case jungleDoor
    case acaciaDoor
    case darkOakDoor
    case mangroveDoor
    case cherryDoor
    case bambooDoor
    case crimsonDoor
    case warpedDoor
    case ironDoor

    case oakTrapdoor
    case spruceTrapdoor
    case birchTrapdoor
    case jungleTrapdoor
    case acaciaTrapdoor
    case darkOakTrapdoor
    case mangroveTrapdoor
    case cherryTrapdoor
    case bambooTrapdoor
    case crimsonTrapdoor
    case warpedTrapdoor
    case ironTrapdoor

    /* ---------- ---------- ---------- Village Blocks ---------- ---------- ---------- */
    case ironBars
    case ladder
    case scaffolding
    case honeycombBlock
    case lodestone
    case hayBlock

    case torch
    case soulTorch
    case lantern
    case soulLantern
    case campfire
    case soulCampfire

    case craftingTable
    case cartographyTable
    case fletchingTable
    case smithingTable
    case beehive
    case furnace
    case litFurnace
    case blastFurnace
    case litBlastFurnace
    case smoker
    case litSmoker
    case respawnAnchor
    case brewingStand
    case anvil
    case grindstone
    case enchantingTable
    case bookshelf
    case chiseledBookshelf
    case lectern
    case composter

    case emptyCauldron
    /* cauldron [cauldron_liquid] water / lava / power_snow */
    /**/case waterCauldron
    /**/case lavaCauldron
    /**/case powerSnowCauldron

    case chest
    case trappedChest
    case enderChest
    case barrel

    case noteblock
    case jukebox
    case frame
    case glowFrame
    case flowerPot
    case beacon
    case bell
    case stonecutterBlock
    case loom
    case decoratedPot
    case chain
    case endRod
    case lightningRod

    case skull
    case rail
    case goldenRail
    case detectorRail
    case activatorRail

    /* ---------- ---------- ---------- Tech Blocks ---------- ---------- ---------- */
    case commandBlock
    case repeatingCommandBlock
    case chainCommandBlock
    case structureBlock
    case structureVoid
    case movingBlock
    case lightBlock
    case barrier
    case jigsaw

    case woodenButton
    case spruceButton
    case birchButton
    case jungleButton
    case acaciaButton
    case darkOakButton
    case mangroveButton
    case cherryButton
    case bambooButton
    case crimsonButton
    case warpedButton
    case stoneButton
    case polishedBlackstoneButton

    case woodenPressurePlate
    case sprucePressurePlate
    case birchPressurePlate
    case junglePressurePlate
    case acaciaPressurePlate
    case darkOakPressurePlate
    case mangrovePressurePlate
    case cherryPressurePlate
    case bambooPressurePlate
    case crimsonPressurePlate
    case warpedPressurePlate
    case stonePressurePlate
    case lightWeightedPressurePlate
    case heavyWeightedPressurePlate
    case polishedBlackstonePressurePlate

    case redstoneWire
    case redstoneTorch
    case unlitRedstoneTorch
    case lever
    case tripwireHook
    case tripWire
    case redstoneLamp
    case litRedstoneLamp
    case observer
    case daylightDetector
    case daylightDetectorInverted
    case poweredRepeater
    case unpoweredRepeater
    case poweredComparator
    case unpoweredComparator
    case hopper
    case dropper
    case dispenser
    case piston
    case pistonArmCollision
    case stickyPiston
    case stickyPistonArmCollision
    case tnt
    case target
    case slime
    case honeyBlock

    /* ---------- ---------- ---------- Colored Blocks ---------- ---------- ---------- */
    case bed                // ???
    case standingBanner     // ???
    case wallBanner         // ???

    case tintedGlass
    case glass
    case glassPane
    /* stainedGlass [color] white / orange / magenta / light_blue / yellow / lime / pink / gray / light_gray / cyan / purple / blue / brown / green / red / black */
    /**/case whiteStainedGlass
    /**/case lightGrayStainedGlass
    /**/case grayStainedGlass
    /**/case blackStainedGlass
    /**/case brownStainedGlass
    /**/case redStainedGlass
    /**/case orangeStainedGlass
    /**/case yellowStainedGlass
    /**/case limeStainedGlass
    /**/case greenStainedGlass
    /**/case cyanStainedGlass
    /**/case lightBlueStainedGlass
    /**/case blueStainedGlass
    /**/case purpleStainedGlass
    /**/case magentaStainedGlass
    /**/case pinkStainedGlass
    /* stainedGlassPane [color] white / orange / magenta / light_blue / yellow / lime / pink / gray / light_gray / cyan / purple / blue / brown / green / red / black */
    /**/case whiteStainedGlassPane
    /**/case lightGrayStainedGlassPane
    /**/case grayStainedGlassPane
    /**/case blackStainedGlassPane
    /**/case brownStainedGlassPane
    /**/case redStainedGlassPane
    /**/case orangeStainedGlassPane
    /**/case yellowStainedGlassPane
    /**/case limeStainedGlassPane
    /**/case greenStainedGlassPane
    /**/case cyanStainedGlassPane
    /**/case lightBlueStainedGlassPane
    /**/case blueStainedGlassPane
    /**/case purpleStainedGlassPane
    /**/case magentaStainedGlassPane
    /**/case pinkStainedGlassPane

    // case shulkerBox      // before 1.20
    case undyedShulkerBox
    case whiteShulkerBox
    case lightGrayShulkerBox
    case grayShulkerBox
    case blackShulkerBox
    case brownShulkerBox
    case redShulkerBox
    case orangeShulkerBox
    case yellowShulkerBox
    case limeShulkerBox
    case greenShulkerBox
    case cyanShulkerBox
    case lightBlueShulkerBox
    case blueShulkerBox
    case purpleShulkerBox
    case magentaShulkerBox
    case pinkShulkerBox

    // case wool        // before 1.20
    case whiteWool
    case lightGrayWool
    case grayWool
    case blackWool
    case brownWool
    case redWool
    case orangeWool
    case yellowWool
    case limeWool
    case greenWool
    case cyanWool
    case lightBlueWool
    case blueWool
    case purpleWool
    case magentaWool
    case pinkWool

    // case carpet      // before 1.20
    case whiteCarpet
    case lightGrayCarpet
    case grayCarpet
    case blackCarpet
    case brownCarpet
    case redCarpet
    case orangeCarpet
    case yellowCarpet
    case limeCarpet
    case greenCarpet
    case cyanCarpet
    case lightBlueCarpet
    case blueCarpet
    case purpleCarpet
    case magentaCarpet
    case pinkCarpet

    case candle
    case whiteCandle
    case lightGrayCandle
    case grayCandle
    case blackCandle
    case brownCandle
    case redCandle
    case orangeCandle
    case yellowCandle
    case limeCandle
    case greenCandle
    case cyanCandle
    case lightBlueCandle
    case blueCandle
    case purpleCandle
    case magentaCandle
    case pinkCandle

    case cake
    case candleCake
    case whiteCandleCake
    case lightGrayCandleCake
    case grayCandleCake
    case blackCandleCake
    case brownCandleCake
    case redCandleCake
    case orangeCandleCake
    case yellowCandleCake
    case limeCandleCake
    case greenCandleCake
    case cyanCandleCake
    case lightBlueCandleCake
    case blueCandleCake
    case purpleCandleCake
    case magentaCandleCake
    case pinkCandleCake

    /* concretePowder [color] white / orange / magenta / light_blue / yellow / lime / pink / gray / silver / cyan / purple / blue / brown / green / red / black */
    /**/case whiteConcretePowder
    /**/case lightGrayConcretePowder
    /**/case grayConcretePowder
    /**/case blackConcretePowder
    /**/case brownConcretePowder
    /**/case redConcretePowder
    /**/case orangeConcretePowder
    /**/case yellowConcretePowder
    /**/case limeConcretePowder
    /**/case greenConcretePowder
    /**/case cyanConcretePowder
    /**/case lightBlueConcretePowder
    /**/case blueConcretePowder
    /**/case purpleConcretePowder
    /**/case magentaConcretePowder
    /**/case pinkConcretePowder

    case concrete
    case whiteConcrete
    case lightGrayConcrete
    case grayConcrete
    case blackConcrete
    case brownConcrete
    case redConcrete
    case orangeConcrete
    case yellowConcrete
    case limeConcrete
    case greenConcrete
    case cyanConcrete
    case lightBlueConcrete
    case blueConcrete
    case purpleConcrete
    case magentaConcrete
    case pinkConcrete

    case clay
    case hardenedClay
    /* stainedHardenedClay [color] white / orange / magenta / light_blue / yellow / lime / pink / gray / silver / cyan / purple / blue / brown / green / red / black */
    /**/case whiteStainedHardenedClay
    /**/case lightGrayStainedHardenedClay
    /**/case grayStainedHardenedClay
    /**/case blackStainedHardenedClay
    /**/case brownStainedHardenedClay
    /**/case redStainedHardenedClay
    /**/case orangeStainedHardenedClay
    /**/case yellowStainedHardenedClay
    /**/case limeStainedHardenedClay
    /**/case greenStainedHardenedClay
    /**/case cyanStainedHardenedClay
    /**/case lightBlueStainedHardenedClay
    /**/case blueStainedHardenedClay
    /**/case purpleStainedHardenedClay
    /**/case magentaStainedHardenedClay
    /**/case pinkStainedHardenedClay

    case whiteGlazedTerracotta
    case silverGlazedTerracotta
    case grayGlazedTerracotta
    case blackGlazedTerracotta
    case brownGlazedTerracotta
    case redGlazedTerracotta
    case orangeGlazedTerracotta
    case yellowGlazedTerracotta
    case limeGlazedTerracotta
    case greenGlazedTerracotta
    case cyanGlazedTerracotta
    case lightBlueGlazedTerracotta
    case blueGlazedTerracotta
    case purpleGlazedTerracotta
    case magentaGlazedTerracotta
    case pinkGlazedTerracotta

    // case coral           // before 1.20
    /* coralBlock [coral_color] blue / pink / purple / red / yellow */
    /* coralBlock [dead_bit] false(alive) / true(dead) */
    /**/case tubeCoralBlock
    /**/case brainCoralBlock
    /**/case bubbleCoralBlock
    /**/case fireCoralBlock
    /**/case hornCoralBlock
    /**/case deadTubeCoralBlock
    /**/case deadBrainCoralBlock
    /**/case deadBubbleCoralBlock
    /**/case deadFireCoralBlock
    /**/case deadHornCoralBlock

    case fireCoral
    case brainCoral
    case bubbleCoral
    case tubeCoral
    case hornCoral
    case deadFireCoral
    case deadBrainCoral
    case deadBubbleCoral
    case deadTubeCoral
    case deadHornCoral

    /* coralFan [coral_color] blue / pink / purple / red / yellow */
    /**/case tubeCoralFan
    /**/case brainCoralFan
    /**/case bubbleCoralFan
    /**/case fireCoralFan
    /**/case hornCoralFan

    /* coralFanDead [coral_color] blue / pink / purple / red / yellow */
    /**/case deadTubeCoralFan
    /**/case deadBrainCoralFan
    /**/case deadBubbleCoralFan
    /**/case deadFireCoralFan
    /**/case deadHornCoralFan

    /* coralFanHang [coral_hang_type_bit] false(tube) / true(brain) */
    /* coralFanHang [dead_bit] false(alive) / true(dead) */
    /**/case tubeCoralHang
    /**/case brainCoralHang
    /**/case deadTubeCoralHang
    /**/case deadBrainCoralHang
    /* coralFanHang2 [coral_hang_type_bit] false(bubble) / true(fire) */
    /* coralFanHang2 [dead_bit] false(alive) / true(dead) */
    /**/case bubbleCoralHang
    /**/case fireCoralHang
    /**/case deadBubbleCoralHang
    /**/case deadFireCoralHang
    /* coralFanHang3 [coral_hang_type_bit] false(horn) */
    /* coralFanHang3 [dead_bit] false(alive) / true(dead) */
    /**/case hornCoralHang
    /**/case deadHornCoralHang

    /* ---------- ---------- ---------- Other ---------- ---------- ---------- */
    case clientRequestPlaceholderBlock
    case invisibleBedrock   // legacy unobtainable block
    case reserved6          // legacy unobtainable block
    case netherreactor      // legacy unobtainable block
    case glowingobsidian    // legacy unobtainable block
    case stonecutter        // legacy unobtainable block
    case infoUpdate         // legacy unobtainable block
    case infoUpdate2        // legacy unobtainable block
}
