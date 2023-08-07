import Foundation

extension MCBlockType {
    public var isOpaque: Bool {
        switch self {
            case .unknown:                                  return false
            case .air:                                      return false
            case .bedrock:                                  return true
            case .fire:                                     return false
            case .water:                                    return false
            case .lava:                                     return false
            case .flowingWater:                             return false
            case .flowingLava:                              return false
            case .obsidian:                                 return true
            case .cryingObsidian:                           return true

            /* ---------- ---------- ---------- Overworld ---------- ---------- ---------- */
            case .grass:                                    return true
            case .dirt:                                     return true
            case .coarseDirt:                               return true
            case .farmland:                                 return true
            case .dirtPath:                                 return true
            case .podzol:                                   return true
            case .mycelium:                                 return true

            case .gravel:                                   return true
            case .sand:                                     return true
            case .redSand:                                  return true
            case .suspiciousGravel:                         return true
            case .suspiciousSand:                           return true

            case .web:                                      return false
            case .beeNest:                                  return true

            case .mobSpawner:                               return true
            case .infestedStone:                            return true
            case .infestedCobblestone:                      return true
            case .infestedStoneBrick:                       return true
            case .infestedMossyStoneBrick:                  return true
            case .infestedCrackedStoneBrick:                return true
            case .infestedChiseledStoneBrick:               return true
            case .infestedDeepslate:                        return true
            case .turtleEgg:                                return false
            case .snifferEgg:                               return false
            case .frogSpawn:                                return false

            case .ochreFroglight:                           return true
            case .verdantFroglight:                         return true
            case .pearlescentFroglight:                     return true
            case .sponge:                                   return true

            // Plants
            case .cactus:                                   return false
            case .reeds:                                    return false
            case .wheat:                                    return false
            case .pumpkinStem:                              return false
            case .melonStem:                                return false
            case .beetroot:                                 return false
            case .cocoa:                                    return false
            case .vine:                                     return false
            case .torchflowerCrop:                          return false
            case .pitcherCrop:                              return false
            case .potatoes:                                 return false
            case .carrots:                                  return false
            case .melonBlock:                               return false
            case .pumpkin:                                  return false
            case .carvedPumpkin:                            return false
            case .litPumpkin:                               return false
            case .sweetBerryBush:                           return false
            case .caveVines:                                return false
            case .caveVinesHeadWithBerries:                 return false
            case .caveVinesBodyWithBerries:                 return false
            case .bamboo:                                   return false
            case .brownMushroom:                            return false
            case .redMushroom:                              return false

            case .brownMushroomBlock:                       return true
            case .redMushroomBlock:                         return true

            case .deadbush:                                 return false
            case .tallgrass:                                return false
            case .doublePlant:                              return false
            case .yellowFlower:                             return false
            case .redFlower:                                return false
            case .pitcherPlant:                             return false
            case .pinkPetals:                               return false
            case .witherRose:                               return false
            case .torchflower:                              return false

            case .waterlily:                                return false
            case .seagrass:                                 return false
            case .kelp:                                     return false
            case .driedKelpBlock:                           return true

            // Ocean Biome
            case .bubbleColumn:                             return false
            case .seaPickle:                                return false
            case .seaLantern:                               return true
            case .conduit:                                  return false

            // Snow Biome
            case .snow:                                     return true
            case .snowLayer:                                return false
            case .powderSnow:                               return true
            case .ice:                                      return true
            case .blueIce:                                  return true
            case .packedIce:                                return true
            case .frostedIce:                               return true

            // Caves & Cliffs
            case .glowLichen:                               return false
            case .dripstoneBlock:                           return true
            case .pointedDripstone:                         return false
            case .mossBlock:                                return true
            case .mossCarpet:                               return false
            case .dirtWithRoots:                            return true
            case .hangingRoots:                             return false
            case .bigDripleaf:                              return false
            case .smallDripleafBlock:                       return false
            case .sporeBlossom:                             return false
            case .azalea:                                   return false
            case .floweringAzalea:                          return false
            case .amethystBlock:                            return true
            case .buddingAmethyst:                          return true
            case .amethystCluster:                          return false
            case .largeAmethystBud:                         return false
            case .mediumAmethystBud:                        return false
            case .smallAmethystBud:                         return false
            case .tuff:                                     return true
            case .calcite:                                  return true

            // Mangrove Swamp Biome
            case .mud:                                      return true
            case .muddyMangroveRoots:                       return true
            case .mangroveRoots:                            return true

            // Deep Dark Biome
            case .reinforcedDeepslate:                      return true
            case .sculkSensor:                              return true
            case .sculk:                                    return false
            case .sculkVein:                                return false
            case .sculkCatalyst:                            return true
            case .sculkShrieker:                            return true
            case .calibratedSculkSensor:                    return true

            /* ---------- ---------- ---------- The Nether ---------- ---------- ---------- */
            case .netherrack:                               return true
            case .shroomlight:                              return true
            case .netherWartBlock:                          return true
            case .crimsonNylium:                            return true
            case .warpedWartBlock:                          return true
            case .warpedNylium:                             return true

            case .basalt:                                   return true
            case .polishedBasalt:                           return true
            case .smoothBasalt:                             return true
            case .soulSoil:                                 return true
            case .soulSand:                                 return true

            case .portal:                                   return false
            case .soulFire:                                 return false
            case .magma:                                    return true
            case .glowstone:                                return true

            // Plants
            case .netherWart:                               return false
            case .crimsonRoots:                             return false
            case .warpedRoots:                              return false
            case .netherSprouts:                            return false
            case .weepingVines:                             return false
            case .twistingVines:                            return false
            case .crimsonFungus:                            return false
            case .warpedFungus:                             return false

            /* ---------- ---------- ---------- The End ---------- ---------- ---------- */
            case .endStone:                                 return true
            case .dragonEgg:                                return false
            case .chorusPlant:                              return false
            case .chorusFlower:                             return false

            case .endPortalFrame:                           return true
            case .endPortal:                                return false
            case .endGateway:                               return false

            /* ---------- ---------- ---------- Ores & Ore Blocks ---------- ---------- ---------- */
            case .coalOre:                                  return true
            case .copperOre:                                return true
            case .ironOre:                                  return true
            case .goldOre:                                  return true
            case .diamondOre:                               return true
            case .lapisOre:                                 return true
            case .redstoneOre:                              return true
            case .litRedstoneOre:                           return true
            case .emeraldOre:                               return true
            case .netherGoldOre:                            return true
            case .quartzOre:                                return true

            case .deepslateCoalOre:                         return true
            case .deepslateCopperOre:                       return true
            case .deepslateIronOre:                         return true
            case .deepslateGoldOre:                         return true
            case .deepslateDiamondOre:                      return true
            case .deepslateLapisOre:                        return true
            case .deepslateRedstoneOre:                     return true
            case .litDeepslateRedstoneOre:                  return true
            case .deepslateEmeraldOre:                      return true

            case .rawCopperBlock:                           return true
            case .rawIronBlock:                             return true
            case .rawGoldBlock:                             return true

            case .coalBlock:                                return true
            case .ironBlock:                                return true
            case .goldBlock:                                return true
            case .diamondBlock:                             return true
            case .lapisBlock:                               return true
            case .redstoneBlock:                            return true
            case .emeraldBlock:                             return true
            case .netheriteBlock:                           return true
            case .ancientDebris:                            return true

            case .copperBlock:                              return true
            case .exposedCopper:                            return true
            case .oxidizedCopper:                           return true
            case .weatheredCopper:                          return true

            case .cutCopper:                                return true
            case .exposedCutCopper:                         return true
            case .oxidizedCutCopper:                        return true
            case .weatheredCutCopper:                       return true

            case .waxedCopper:                              return true
            case .waxedExposedCopper:                       return true
            case .waxedOxidizedCopper:                      return true
            case .waxedWeatheredCopper:                     return true

            case .waxedCutCopper:                           return true
            case .waxedExposedCutCopper:                    return true
            case .waxedOxidizedCutCopper:                   return true
            case .waxedWeatheredCutCopper:                  return true

            /* ---------- ---------- ---------- Stones ---------- ---------- ---------- */
            case .boneBlock:                                return true
            case .cobblestone:                              return true
            case .mossyCobblestone:                         return true
            case .cobbledDeepslate:                         return true

            case .stone:                                    return true
            case .granite:                                  return true
            case .diorite:                                  return true
            case .andesite:                                 return true
            case .polishedGranite:                          return true
            case .polishedDiorite:                          return true
            case .polishedAndesite:                         return true

            case .stonebricks:                              return true
            case .mossyStoneBricks:                         return true
            case .crackedStoneBricks:                       return true
            case .chiseledStoneBricks:                      return true
            case .smoothStoneBricks:                        return true

            case .blackstone:                               return true
            case .polishedBlackstone:                       return true

            case .deepslate:                                return true
            case .polishedDeepslate:                        return true

            case .polishedBlackstoneBricks:                 return true
            case .crackedPolishedBlackstoneBricks:          return true
            case .chiseledPolishedBlackstone:               return true
            case .gildedBlackstone:                         return true

            case .deepslateTiles:                           return true
            case .crackedDeepslateTiles:                    return true
            case .deepslateBricks:                          return true
            case .crackedDeepslateBricks:                   return true
            case .chiseledDeepslate:                        return true

            case .smoothStone:                              return true
            case .redBrickBlock:                            return true
            case .packedMud:                                return true
            case .mudBricks:                                return true

            case .netherBrick:                              return true
            case .redNetherBrick:                           return true
            case .chiseledNetherBricks:                     return true
            case .crackedNetherBricks:                      return true
            case .endBricks:                                return true

            case .prismarine:                               return true
            case .darkPrismarine:                           return true
            case .prismarineBricks:                         return true

            case .quartzBricks:                             return true
            case .quartzBlock:                              return true
            case .pillarQuartzBlock:                        return true
            case .chiseledQuartzBlock:                      return true
            case .smoothQuartzBlock:                        return true

            case .purpurBlock:                              return true
            case .pillarPurpurBlock:                        return true
            case .chiseledPurpurBlock:                      return true
            case .smoothPurpurBlock:                        return true

            case .sandstone:                                return true
            case .chiseledSandstone:                        return true
            case .cutSandstone:                             return true
            case .smoothSandstone:                          return true
            case .redSandstone:                             return true
            case .chiseledRedSandstone:                     return true
            case .cutRedSandstone:                          return true
            case .smoothRedSandstone:                       return true

            /* ---------- ---------- ---------- Trees ---------- ---------- ---------- */
            case .oakLog:                                   return true
            case .spruceLog:                                return true
            case .birchLog:                                 return true
            case .jungleLog:                                return true
            case .acaciaLog:                                return true
            case .darkOakLog:                               return true
            case .mangroveLog:                              return true
            case .cherryLog:                                return true
            case .crimsonStem:                              return true
            case .warpedStem:                               return true

            case .strippedOakLog:                           return true
            case .strippedSpruceLog:                        return true
            case .strippedBirchLog:                         return true
            case .strippedJungleLog:                        return true
            case .strippedAcaciaLog:                        return true
            case .strippedDarkOakLog:                       return true
            case .strippedMangroveLog:                      return true
            case .strippedCherryLog:                        return true
            case .strippedCrimsonStem:                      return true
            case .strippedWarpedStem:                       return true

            case .oakWood:                                  return true
            case .spruceWood:                               return true
            case .birchWood:                                return true
            case .jungleWood:                               return true
            case .acaciaWood:                               return true
            case .darkOakWood:                              return true
            case .mangroveWood:                             return true
            case .cherryWood:                               return true
            case .bambooBlock:                              return true
            case .crimsonHyphae:                            return true
            case .warpedHyphae:                             return true

            case .strippedOakWood:                          return true
            case .strippedSpruceWood:                       return true
            case .strippedBirchWood:                        return true
            case .strippedJungleWood:                       return true
            case .strippedAcaciaWood:                       return true
            case .strippedDarkOakWood:                      return true
            case .strippedMangroveWood:                     return true
            case .strippedCherryWood:                       return true
            case .strippedBambooBlock:                      return true
            case .strippedCrimsonHyphae:                    return true
            case .strippedWarpedHyphae:                     return true

            case .oakPlanks:                                return true
            case .sprucePlanks:                             return true
            case .birchPlanks:                              return true
            case .junglePlanks:                             return true
            case .acaciaPlanks:                             return true
            case .darkOakPlanks:                            return true
            case .mangrovePlanks:                           return true
            case .cherryPlanks:                             return true
            case .bambooPlanks:                             return true
            case .bambooMosaic:                             return true
            case .crimsonPlanks:                            return true
            case .warpedPlanks:                             return true

            case .oakLeaves:                                return false
            case .spruceLeaves:                             return false
            case .birchLeaves:                              return false
            case .jungleLeaves:                             return false
            case .acaciaLeaves:                             return false
            case .darkOakLeaves:                            return false
            case .mangroveLeaves:                           return false
            case .cherryLeaves:                             return false
            case .azaleaLeaves:                             return false
            case .azaleaLeavesFlowered:                     return false

            case .oakSapling:                               return false
            case .spruceSapling:                            return false
            case .birchSapling:                             return false
            case .jungleSapling:                            return false
            case .acaciaSapling:                            return false
            case .darkOakSapling:                           return false
            case .mangrovePropagule:                        return false
            case .cherrySapling:                            return false
            case .bambooSapling:                            return false

            /* ---------- ---------- ---------- Fences & Gates ---------- ---------- ---------- */
            case .oakFence:                                 return false
            case .spruceFence:                              return false
            case .birchFence:                               return false
            case .jungleFence:                              return false
            case .acaciaFence:                              return false
            case .darkOakFence:                             return false
            case .mangroveFence:                            return false
            case .cherryFence:                              return false
            case .bambooFence:                              return false
            case .crimsonFence:                             return false
            case .warpedFence:                              return false
            case .netherBrickFence:                         return false

            case .oakFenceGate:                             return false
            case .spruceFenceGate:                          return false
            case .birchFenceGate:                           return false
            case .jungleFenceGate:                          return false
            case .acaciaFenceGate:                          return false
            case .darkOakFenceGate:                         return false
            case .mangroveFenceGate:                        return false
            case .cherryFenceGate:                          return false
            case .bambooFenceGate:                          return false
            case .crimsonFenceGate:                         return false
            case .warpedFenceGate:                          return false

            /* ---------- ---------- ---------- Walls ---------- ---------- ---------- */
            case .cobblestoneWall:                          return false
            case .mossyCobblestoneWall:                     return false
            case .graniteWall:                              return false
            case .dioriteWall:                              return false
            case .andesiteWall:                             return false
            case .sandstoneWall:                            return false
            case .redSandstoneWall:                         return false
            case .stoneBrickWall:                           return false
            case .mossyStoneBrickWall:                      return false
            case .redBrickWall:                             return false
            case .netherBrickWall:                          return false
            case .redNetherBrickWall:                       return false
            case .endBrickWall:                             return false
            case .prismarineWall:                           return false

            case .blackstoneWall:                           return false
            case .polishedBlackstoneWall:                   return false
            case .polishedBlackstoneBrickWall:              return false

            case .cobbledDeepslateWall:                     return false
            case .deepslateTileWall:                        return false
            case .polishedDeepslateWall:                    return false
            case .deepslateBrickWall:                       return false

            case .mudBrickWall:                             return false

            /* ---------- ---------- ---------- Stairs ---------- ---------- ---------- */
            case .oakStairs:                                return false
            case .spruceStairs:                             return false
            case .birchStairs:                              return false
            case .jungleStairs:                             return false
            case .acaciaStairs:                             return false
            case .darkOakStairs:                            return false
            case .mangroveStairs:                           return false
            case .cherryStairs:                             return false
            case .bambooStairs:                             return false
            case .bambooMosaicStairs:                       return false
            case .crimsonStairs:                            return false
            case .warpedStairs:                             return false

            case .normalStoneStairs:                        return false
            case .cobblestoneStairs:                        return false
            case .mossyStoneBrickStairs:                    return false
            case .stoneBrickStairs:                         return false
            case .mossyCobblestoneStairs:                   return false

            case .graniteStairs:                            return false
            case .dioriteStairs:                            return false
            case .andesiteStairs:                           return false
            case .polishedGraniteStairs:                    return false
            case .polishedDioriteStairs:                    return false
            case .polishedAndesiteStairs:                   return false

            case .sandstoneStairs:                          return false
            case .redSandstoneStairs:                       return false
            case .smoothSandstoneStairs:                    return false
            case .smoothRedSandstoneStairs:                 return false
            case .redBrickStairs:                           return false
            case .mudBrickStairs:                           return false

            case .blackstoneStairs:                         return false
            case .polishedBlackstoneStairs:                 return false
            case .polishedBlackstoneBrickStairs:            return false

            case .cobbledDeepslateStairs:                   return false
            case .deepslateTileStairs:                      return false
            case .polishedDeepslateStairs:                  return false
            case .deepslateBrickStairs:                     return false

            case .netherBrickStairs:                        return false
            case .redNetherBrickStairs:                     return false
            case .endBrickStairs:                           return false
            case .quartzStairs:                             return false
            case .smoothQuartzStairs:                       return false
            case .purpurStairs:                             return false
            case .prismarineStairs:                         return false
            case .darkPrismarineStairs:                     return false
            case .prismarineBricksStairs:                   return false

            case .cutCopperStairs:                          return false
            case .exposedCutCopperStairs:                   return false
            case .oxidizedCutCopperStairs:                  return false
            case .weatheredCutCopperStairs:                 return false
            case .waxedCutCopperStairs:                     return false
            case .waxedExposedCutCopperStairs:              return false
            case .waxedOxidizedCutCopperStairs:             return false
            case .waxedWeatheredCutCopperStairs:            return false

            /* ---------- ---------- ---------- Slabs ---------- ---------- ---------- */
            case .oakSlab:                                  return false
            case .spruceSlab:                               return false
            case .birchSlab:                                return false
            case .jungleSlab:                               return false
            case .acaciaSlab:                               return false
            case .darkOakSlab:                              return false
            case .mangroveSlab:                             return false
            case .cherrySlab:                               return false
            case .bambooSlab:                               return false
            case .bambooMosaicSlab:                         return false
            case .crimsonSlab:                              return false
            case .warpedSlab:                               return false

            case .oakDoubleSlab:                            return false
            case .spruceDoubleSlab:                         return false
            case .birchDoubleSlab:                          return false
            case .jungleDoubleSlab:                         return false
            case .acaciaDoubleSlab:                         return false
            case .darkOakDoubleSlab:                        return false
            case .mangroveDoubleSlab:                       return false
            case .cherryDoubleSlab:                         return false
            case .bambooDoubleSlab:                         return false
            case .bambooMosaicDoubleSlab:                   return false
            case .crimsonDoubleSlab:                        return false
            case .warpedDoubleSlab:                         return false

            case .smoothStoneSlab:                          return false
            case .cobblestoneSlab:                          return false
            case .stoneBrickSlab:                           return false
            case .sandstoneSlab:                            return false
            case .redBrickSlab:                             return false
            case .netherBrickSlab:                          return false
            case .quartzSlab:                               return false
            case .smoothStoneDoubleSlab:                    return false
            case .cobblestoneDoubleSlab:                    return false
            case .stoneBrickDoubleSlab:                     return false
            case .sandstoneDoubleSlab:                      return false
            case .redBrickDoubleSlab:                       return false
            case .netherBrickDoubleSlab:                    return false
            case .quartzDoubleSlab:                         return false

            case .mossyCobblestoneSlab:                     return false
            case .smoothSandstoneSlab:                      return false
            case .redSandstoneSlab:                         return false
            case .redNetherBrickSlab:                       return false
            case .purpurSlab:                               return false
            case .prismarineRoughSlab:                      return false
            case .prismarineDarkSlab:                       return false
            case .prismarineBrickSlab:                      return false
            case .mossyCobblestoneDoubleSlab:               return false
            case .smoothSandstoneDoubleSlab:                return false
            case .redSandstoneDoubleSlab:                   return false
            case .redNetherBrickDoubleSlab:                 return false
            case .purpurDoubleSlab:                         return false
            case .prismarineRoughDoubleSlab:                return false
            case .prismarineDarkDoubleSlab:                 return false
            case .prismarineBrickDoubleSlab:                return false

            case .smoothRedSandstoneSlab:                   return false
            case .graniteSlab:                              return false
            case .dioriteSlab:                              return false
            case .andesiteSlab:                             return false
            case .polishedGraniteSlab:                      return false
            case .polishedDioriteSlab:                      return false
            case .polishedAndesiteSlab:                     return false
            case .endStoneBrickSlab:                        return false
            case .smoothRedSandstoneDoubleSlab:             return false
            case .graniteDoubleSlab:                        return false
            case .dioriteDoubleSlab:                        return false
            case .andesiteDoubleSlab:                       return false
            case .polishedGraniteDoubleSlab:                return false
            case .polishedDioriteDoubleSlab:                return false
            case .polishedAndesiteDoubleSlab:               return false
            case .endStoneBrickDoubleSlab:                  return false

            case .stoneSlab:                                return false
            case .mossyStoneBrickSlab:                      return false
            case .cutSandstoneSlab:                         return false
            case .cutRedSandstoneSlab:                      return false
            case .smoothQuartzSlab:                         return false
            case .stoneDoubleSlab:                          return false
            case .mossyStoneBrickDoubleSlab:                return false
            case .cutSandstoneDoubleSlab:                   return false
            case .cutRedSandstoneDoubleSlab:                return false
            case .smoothQuartzDoubleSlab:                   return false

            case .blackstoneSlab:                           return false
            case .polishedBlackstoneSlab:                   return false
            case .polishedBlackstoneBrickSlab:              return false
            case .blackstoneDoubleSlab:                     return false
            case .polishedBlackstoneDoubleSlab:             return false
            case .polishedBlackstoneBrickDoubleSlab:        return false

            case .cobbledDeepslateSlab:                     return false
            case .deepslateTileSlab:                        return false
            case .polishedDeepslateSlab:                    return false
            case .deepslateBrickSlab:                       return false
            case .cobbledDeepslateDoubleSlab:               return false
            case .deepslateTileDoubleSlab:                  return false
            case .polishedDeepslateDoubleSlab:              return false
            case .deepslateBrickDoubleSlab:                 return false

            case .mudBrickSlab:                             return false
            case .mudBrickDoubleSlab:                       return false

            case .cutCopperSlab:                            return false
            case .exposedCutCopperSlab:                     return false
            case .oxidizedCutCopperSlab:                    return false
            case .weatheredCutCopperSlab:                   return false
            case .waxedCutCopperSlab:                       return false
            case .waxedExposedCutCopperSlab:                return false
            case .waxedOxidizedCutCopperSlab:               return false
            case .waxedWeatheredCutCopperSlab:              return false

            case .doubleCutCopperSlab:                      return false
            case .exposedDoubleCutCopperSlab:               return false
            case .oxidizedDoubleCutCopperSlab:              return false
            case .weatheredDoubleCutCopperSlab:             return false
            case .waxedDoubleCutCopperSlab:                 return false
            case .waxedExposedDoubleCutCopperSlab:          return false
            case .waxedOxidizedDoubleCutCopperSlab:         return false
            case .waxedWeatheredDoubleCutCopperSlab:        return false

            /* ---------- ---------- ---------- Signs ---------- ---------- ---------- */
            case .oakStandingSign:                          return false
            case .spruceStandingSign:                       return false
            case .birchStandingSign:                        return false
            case .acaciaStandingSign:                       return false
            case .jungleStandingSign:                       return false
            case .darkoakStandingSign:                      return false
            case .mangroveStandingSign:                     return false
            case .cherryStandingSign:                       return false
            case .bambooStandingSign:                       return false
            case .crimsonStandingSign:                      return false
            case .warpedStandingSign:                       return false

            case .oakHangingSign:                           return false
            case .spruceHangingSign:                        return false
            case .birchHangingSign:                         return false
            case .jungleHangingSign:                        return false
            case .acaciaHangingSign:                        return false
            case .darkOakHangingSign:                       return false
            case .mangroveHangingSign:                      return false
            case .cherryHangingSign:                        return false
            case .bambooHangingSign:                        return false
            case .crimsonHangingSign:                       return false
            case .warpedHangingSign:                        return false

            case .oakWallSign:                              return false
            case .spruceWallSign:                           return false
            case .birchWallSign:                            return false
            case .acaciaWallSign:                           return false
            case .jungleWallSign:                           return false
            case .darkoakWallSign:                          return false
            case .mangroveWallSign:                         return false
            case .cherryWallSign:                           return false
            case .bambooWallSign:                           return false
            case .crimsonWallSign:                          return false
            case .warpedWallSign:                           return false

            /* ---------- ---------- ---------- Doors & Trapdoors ---------- ---------- ---------- */
            case .oakDoor:                                  return false
            case .spruceDoor:                               return false
            case .birchDoor:                                return false
            case .jungleDoor:                               return false
            case .acaciaDoor:                               return false
            case .darkOakDoor:                              return false
            case .mangroveDoor:                             return false
            case .cherryDoor:                               return false
            case .bambooDoor:                               return false
            case .crimsonDoor:                              return false
            case .warpedDoor:                               return false
            case .ironDoor:                                 return false

            case .oakTrapdoor:                              return false
            case .spruceTrapdoor:                           return false
            case .birchTrapdoor:                            return false
            case .jungleTrapdoor:                           return false
            case .acaciaTrapdoor:                           return false
            case .darkOakTrapdoor:                          return false
            case .mangroveTrapdoor:                         return false
            case .cherryTrapdoor:                           return false
            case .bambooTrapdoor:                           return false
            case .crimsonTrapdoor:                          return false
            case .warpedTrapdoor:                           return false
            case .ironTrapdoor:                             return false

            /* ---------- ---------- ---------- Village Blocks ---------- ---------- ---------- */
            case .ironBars:                                 return false
            case .ladder:                                   return false
            case .scaffolding:                              return false
            case .honeycombBlock:                           return false
            case .lodestone:                                return false
            case .hayBlock:                                 return false

            case .torch:                                    return false
            case .soulTorch:                                return false
            case .lantern:                                  return false
            case .soulLantern:                              return false
            case .campfire:                                 return false
            case .soulCampfire:                             return false

            case .craftingTable:                            return false
            case .cartographyTable:                         return false
            case .fletchingTable:                           return false
            case .smithingTable:                            return false
            case .beehive:                                  return false
            case .furnace:                                  return false
            case .litFurnace:                               return false
            case .blastFurnace:                             return false
            case .litBlastFurnace:                          return false
            case .smoker:                                   return false
            case .litSmoker:                                return false
            case .respawnAnchor:                            return false
            case .brewingStand:                             return false
            case .anvil:                                    return false
            case .grindstone:                               return false
            case .enchantingTable:                          return false
            case .bookshelf:                                return false
            case .chiseledBookshelf:                        return false
            case .lectern:                                  return false
            case .composter:                                return false

            case .emptyCauldron:                            return false
            case .waterCauldron:                            return false
            case .lavaCauldron:                             return false
            case .powerSnowCauldron:                        return false

            case .chest:                                    return false
            case .trappedChest:                             return false
            case .enderChest:                               return false
            case .barrel:                                   return false

            case .noteblock:                                return false
            case .jukebox:                                  return false
            case .frame:                                    return false
            case .glowFrame:                                return false
            case .flowerPot:                                return false
            case .beacon:                                   return false
            case .bell:                                     return false
            case .stonecutterBlock:                         return false
            case .loom:                                     return false
            case .decoratedPot:                             return false
            case .chain:                                    return false
            case .endRod:                                   return false
            case .lightningRod:                             return false

            case .skull:                                    return false
            case .rail:                                     return false
            case .goldenRail:                               return false
            case .detectorRail:                             return false
            case .activatorRail:                            return false

            /* ---------- ---------- ---------- Tech Blocks ---------- ---------- ---------- */
            case .commandBlock:                             return false
            case .repeatingCommandBlock:                    return false
            case .chainCommandBlock:                        return false
            case .structureBlock:                           return false
            case .structureVoid:                            return false
            case .movingBlock:                              return false
            case .lightBlock:                               return false
            case .barrier:                                  return false
            case .jigsaw:                                   return false

            case .woodenButton:                             return false
            case .spruceButton:                             return false
            case .birchButton:                              return false
            case .jungleButton:                             return false
            case .acaciaButton:                             return false
            case .darkOakButton:                            return false
            case .mangroveButton:                           return false
            case .cherryButton:                             return false
            case .bambooButton:                             return false
            case .crimsonButton:                            return false
            case .warpedButton:                             return false
            case .stoneButton:                              return false
            case .polishedBlackstoneButton:                 return false

            case .woodenPressurePlate:                      return false
            case .sprucePressurePlate:                      return false
            case .birchPressurePlate:                       return false
            case .junglePressurePlate:                      return false
            case .acaciaPressurePlate:                      return false
            case .darkOakPressurePlate:                     return false
            case .mangrovePressurePlate:                    return false
            case .cherryPressurePlate:                      return false
            case .bambooPressurePlate:                      return false
            case .crimsonPressurePlate:                     return false
            case .warpedPressurePlate:                      return false
            case .stonePressurePlate:                       return false
            case .lightWeightedPressurePlate:               return false
            case .heavyWeightedPressurePlate:               return false
            case .polishedBlackstonePressurePlate:          return false

            case .redstoneWire:                             return false
            case .redstoneTorch:                            return false
            case .unlitRedstoneTorch:                       return false
            case .lever:                                    return false
            case .tripwireHook:                             return false
            case .tripWire:                                 return false
            case .redstoneLamp:                             return false
            case .litRedstoneLamp:                          return false
            case .observer:                                 return false
            case .daylightDetector:                         return false
            case .daylightDetectorInverted:                 return false
            case .poweredRepeater:                          return false
            case .unpoweredRepeater:                        return false
            case .poweredComparator:                        return false
            case .unpoweredComparator:                      return false
            case .hopper:                                   return false
            case .dropper:                                  return false
            case .dispenser:                                return false
            case .piston:                                   return false
            case .pistonArmCollision:                       return false
            case .stickyPiston:                             return false
            case .stickyPistonArmCollision:                 return false
            case .tnt:                                      return false
            case .target:                                   return false
            case .slime:                                    return false
            case .honeyBlock:                               return false

            /* ---------- ---------- ---------- Colored Blocks ---------- ---------- ---------- */
            case .bed:                                      return false
            case .standingBanner:                           return false
            case .wallBanner:                               return false

            case .tintedGlass:                              return false
            case .glass:                                    return false
            case .glassPane:                                return false
            case .whiteStainedGlass:                        return false
            case .lightGrayStainedGlass:                    return false
            case .grayStainedGlass:                         return false
            case .blackStainedGlass:                        return false
            case .brownStainedGlass:                        return false
            case .redStainedGlass:                          return false
            case .orangeStainedGlass:                       return false
            case .yellowStainedGlass:                       return false
            case .limeStainedGlass:                         return false
            case .greenStainedGlass:                        return false
            case .cyanStainedGlass:                         return false
            case .lightBlueStainedGlass:                    return false
            case .blueStainedGlass:                         return false
            case .purpleStainedGlass:                       return false
            case .magentaStainedGlass:                      return false
            case .pinkStainedGlass:                         return false
            case .whiteStainedGlassPane:                    return false
            case .lightGrayStainedGlassPane:                return false
            case .grayStainedGlassPane:                     return false
            case .blackStainedGlassPane:                    return false
            case .brownStainedGlassPane:                    return false
            case .redStainedGlassPane:                      return false
            case .orangeStainedGlassPane:                   return false
            case .yellowStainedGlassPane:                   return false
            case .limeStainedGlassPane:                     return false
            case .greenStainedGlassPane:                    return false
            case .cyanStainedGlassPane:                     return false
            case .lightBlueStainedGlassPane:                return false
            case .blueStainedGlassPane:                     return false
            case .purpleStainedGlassPane:                   return false
            case .magentaStainedGlassPane:                  return false
            case .pinkStainedGlassPane:                     return false

            case .undyedShulkerBox:                         return false
            case .whiteShulkerBox:                          return false
            case .lightGrayShulkerBox:                      return false
            case .grayShulkerBox:                           return false
            case .blackShulkerBox:                          return false
            case .brownShulkerBox:                          return false
            case .redShulkerBox:                            return false
            case .orangeShulkerBox:                         return false
            case .yellowShulkerBox:                         return false
            case .limeShulkerBox:                           return false
            case .greenShulkerBox:                          return false
            case .cyanShulkerBox:                           return false
            case .lightBlueShulkerBox:                      return false
            case .blueShulkerBox:                           return false
            case .purpleShulkerBox:                         return false
            case .magentaShulkerBox:                        return false
            case .pinkShulkerBox:                           return false

            // case .wool:                                  return false
            case .whiteWool:                                return false
            case .lightGrayWool:                            return false
            case .grayWool:                                 return false
            case .blackWool:                                return false
            case .brownWool:                                return false
            case .redWool:                                  return false
            case .orangeWool:                               return false
            case .yellowWool:                               return false
            case .limeWool:                                 return false
            case .greenWool:                                return false
            case .cyanWool:                                 return false
            case .lightBlueWool:                            return false
            case .blueWool:                                 return false
            case .purpleWool:                               return false
            case .magentaWool:                              return false
            case .pinkWool:                                 return false

            // case .carpet:                                return false
            case .whiteCarpet:                              return false
            case .lightGrayCarpet:                          return false
            case .grayCarpet:                               return false
            case .blackCarpet:                              return false
            case .brownCarpet:                              return false
            case .redCarpet:                                return false
            case .orangeCarpet:                             return false
            case .yellowCarpet:                             return false
            case .limeCarpet:                               return false
            case .greenCarpet:                              return false
            case .cyanCarpet:                               return false
            case .lightBlueCarpet:                          return false
            case .blueCarpet:                               return false
            case .purpleCarpet:                             return false
            case .magentaCarpet:                            return false
            case .pinkCarpet:                               return false

            case .candle:                                   return false
            case .whiteCandle:                              return false
            case .lightGrayCandle:                          return false
            case .grayCandle:                               return false
            case .blackCandle:                              return false
            case .brownCandle:                              return false
            case .redCandle:                                return false
            case .orangeCandle:                             return false
            case .yellowCandle:                             return false
            case .limeCandle:                               return false
            case .greenCandle:                              return false
            case .cyanCandle:                               return false
            case .lightBlueCandle:                          return false
            case .blueCandle:                               return false
            case .purpleCandle:                             return false
            case .magentaCandle:                            return false
            case .pinkCandle:                               return false

            case .cake:                                     return false
            case .candleCake:                               return false
            case .whiteCandleCake:                          return false
            case .lightGrayCandleCake:                      return false
            case .grayCandleCake:                           return false
            case .blackCandleCake:                          return false
            case .brownCandleCake:                          return false
            case .redCandleCake:                            return false
            case .orangeCandleCake:                         return false
            case .yellowCandleCake:                         return false
            case .limeCandleCake:                           return false
            case .greenCandleCake:                          return false
            case .cyanCandleCake:                           return false
            case .lightBlueCandleCake:                      return false
            case .blueCandleCake:                           return false
            case .purpleCandleCake:                         return false
            case .magentaCandleCake:                        return false
            case .pinkCandleCake:                           return false

            case .whiteConcretePowder:                      return false
            case .lightGrayConcretePowder:                  return false
            case .grayConcretePowder:                       return false
            case .blackConcretePowder:                      return false
            case .brownConcretePowder:                      return false
            case .redConcretePowder:                        return false
            case .orangeConcretePowder:                     return false
            case .yellowConcretePowder:                     return false
            case .limeConcretePowder:                       return false
            case .greenConcretePowder:                      return false
            case .cyanConcretePowder:                       return false
            case .lightBlueConcretePowder:                  return false
            case .blueConcretePowder:                       return false
            case .purpleConcretePowder:                     return false
            case .magentaConcretePowder:                    return false
            case .pinkConcretePowder:                       return false

            case .concrete:                                 return false
            case .whiteConcrete:                            return false
            case .lightGrayConcrete:                        return false
            case .grayConcrete:                             return false
            case .blackConcrete:                            return false
            case .brownConcrete:                            return false
            case .redConcrete:                              return false
            case .orangeConcrete:                           return false
            case .yellowConcrete:                           return false
            case .limeConcrete:                             return false
            case .greenConcrete:                            return false
            case .cyanConcrete:                             return false
            case .lightBlueConcrete:                        return false
            case .blueConcrete:                             return false
            case .purpleConcrete:                           return false
            case .magentaConcrete:                          return false
            case .pinkConcrete:                             return false

            case .clay:                                     return false
            case .hardenedClay:                             return false
            case .whiteStainedHardenedClay:                 return false
            case .lightGrayStainedHardenedClay:             return false
            case .grayStainedHardenedClay:                  return false
            case .blackStainedHardenedClay:                 return false
            case .brownStainedHardenedClay:                 return false
            case .redStainedHardenedClay:                   return false
            case .orangeStainedHardenedClay:                return false
            case .yellowStainedHardenedClay:                return false
            case .limeStainedHardenedClay:                  return false
            case .greenStainedHardenedClay:                 return false
            case .cyanStainedHardenedClay:                  return false
            case .lightBlueStainedHardenedClay:             return false
            case .blueStainedHardenedClay:                  return false
            case .purpleStainedHardenedClay:                return false
            case .magentaStainedHardenedClay:               return false
            case .pinkStainedHardenedClay:                  return false

            case .whiteGlazedTerracotta:                    return false
            case .silverGlazedTerracotta:                   return false
            case .grayGlazedTerracotta:                     return false
            case .blackGlazedTerracotta:                    return false
            case .brownGlazedTerracotta:                    return false
            case .redGlazedTerracotta:                      return false
            case .orangeGlazedTerracotta:                   return false
            case .yellowGlazedTerracotta:                   return false
            case .limeGlazedTerracotta:                     return false
            case .greenGlazedTerracotta:                    return false
            case .cyanGlazedTerracotta:                     return false
            case .lightBlueGlazedTerracotta:                return false
            case .blueGlazedTerracotta:                     return false
            case .purpleGlazedTerracotta:                   return false
            case .magentaGlazedTerracotta:                  return false
            case .pinkGlazedTerracotta:                     return false

            case .tubeCoralBlock:                           return false
            case .brainCoralBlock:                          return false
            case .bubbleCoralBlock:                         return false
            case .fireCoralBlock:                           return false
            case .hornCoralBlock:                           return false
            case .deadTubeCoralBlock:                       return false
            case .deadBrainCoralBlock:                      return false
            case .deadBubbleCoralBlock:                     return false
            case .deadFireCoralBlock:                       return false
            case .deadHornCoralBlock:                       return false

            case .fireCoral:                                return false
            case .brainCoral:                               return false
            case .bubbleCoral:                              return false
            case .tubeCoral:                                return false
            case .hornCoral:                                return false
            case .deadFireCoral:                            return false
            case .deadBrainCoral:                           return false
            case .deadBubbleCoral:                          return false
            case .deadTubeCoral:                            return false
            case .deadHornCoral:                            return false

            case .tubeCoralFan:                             return false
            case .brainCoralFan:                            return false
            case .bubbleCoralFan:                           return false
            case .fireCoralFan:                             return false
            case .hornCoralFan:                             return false

            case .deadTubeCoralFan:                         return false
            case .deadBrainCoralFan:                        return false
            case .deadBubbleCoralFan:                       return false
            case .deadFireCoralFan:                         return false
            case .deadHornCoralFan:                         return false

            case .tubeCoralHang:                            return false
            case .brainCoralHang:                           return false
            case .deadTubeCoralHang:                        return false
            case .deadBrainCoralHang:                       return false
            case .bubbleCoralHang:                          return false
            case .fireCoralHang:                            return false
            case .deadBubbleCoralHang:                      return false
            case .deadFireCoralHang:                        return false
            case .hornCoralHang:                            return false
            case .deadHornCoralHang:                        return false

            /* ---------- ---------- ---------- Other ---------- ---------- ---------- */
            case .clientRequestPlaceholderBlock:            return false
            case .invisibleBedrock:                         return false
            case .reserved6:                                return false
            case .netherreactor:                            return false
            case .glowingobsidian:                          return false
            case .stonecutter:                              return false
            case .infoUpdate:                               return false
            case .infoUpdate2:                              return false
        }
    }
}
