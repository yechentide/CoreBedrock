import Foundation

extension MCBlockType {
    public var argb: UInt32? {
        switch self {
            case .unknown:                                  return nil
            case .air:                                      return nil
            case .bedrock:                                  return Self.DefaultColor.normalStone.argb
            case .fire:                                     return nil
            case .water:                                    return 0xFF3F76E4    // (063, 118, 228)
            case .lava:                                     return 0xFFB34703    // (179, 071, 003)
            case .flowingWater:                             return 0xFF3F76E4    // (063, 118, 228)
            case .flowingLava:                              return 0xFFB34703    // (179, 071, 003)
            case .obsidian:                                 return 0xFF1D0E34    // (029, 014, 052)
            case .cryingObsidian:                           return 0xFF2A0177    // (042, 001, 119)

            /* ---------- ---------- ---------- Overworld ---------- ---------- ---------- */
            case .grass:                                    return 0xFF82943A    // (130, 148, 058)
            case .dirt:                                     return 0xFF956C4C    // (149, 108, 76)
            case .coarseDirt:                               return 0xFF956C4C    // (149, 108, 76)
            case .farmland:                                 return 0xFF956C4C    // (149, 108, 076)
            case .dirtPath:                                 return 0xFFCCCCCC    // (204, 204, 204)
            case .podzol:                                   return 0xFF694317    // (105, 067, 023)
            case .mycelium:                                 return 0xFF726061    // (114, 096, 097)

            case .gravel:                                   return Self.DefaultColor.normalStone.argb
            case .sand:                                     return Self.DefaultColor.sand.argb
            case .redSand:                                  return Self.DefaultColor.redSand.argb
            case .suspiciousGravel:                         return Self.DefaultColor.normalStone.argb
            case .suspiciousSand:                           return Self.DefaultColor.sand.argb

            case .web:                                      return nil
            case .beeNest:                                  return 0xFFC68443    // (198, 132, 067)

            case .mobSpawner:                               return 0xFF182B38    // (024, 043, 056)
            case .infestedStone:                            return Self.DefaultColor.normalStone.argb
            case .infestedCobblestone:                      return Self.DefaultColor.normalStone.argb
            case .infestedStoneBrick:                       return Self.DefaultColor.normalStone.argb
            case .infestedMossyStoneBrick:                  return Self.DefaultColor.normalStone.argb
            case .infestedCrackedStoneBrick:                return Self.DefaultColor.normalStone.argb
            case .infestedChiseledStoneBrick:               return Self.DefaultColor.normalStone.argb
            case .infestedDeepslate:                        return Self.DefaultColor.deepslate.argb
            case .turtleEgg:                                return nil
            case .snifferEgg:                               return nil
            case .frogSpawn:                                return nil

            case .ochreFroglight:                           return 0xFFFCF9F2    // (252, 249, 242)
            case .verdantFroglight:                         return 0xFFFCF9F2    // (252, 249, 242)
            case .pearlescentFroglight:                     return 0xFFFCF9F2    // (252, 249, 242)
            case .sponge:                                   return 0xFFCBCC49    // (203, 204, 073)

            // Plants
            case .cactus:                                   return 0xFF5A8A2A    // (090, 138, 042)
            case .reeds:                                    return nil
            case .wheat:                                    return nil
            case .pumpkinStem:                              return nil
            case .melonStem:                                return nil
            case .beetroot:                                 return nil
            case .cocoa:                                    return nil
            case .vine:                                     return nil
            case .torchflowerCrop:                          return nil
            case .pitcherCrop:                              return nil
            case .potatoes:                                 return nil
            case .carrots:                                  return nil
            case .melonBlock:                               return 0xFF7DCA19    // (125, 202, 025)
            case .pumpkin:                                  return 0xFFD57D32    // (213, 125, 050)
            case .carvedPumpkin:                            return 0xFFD57D32    // (213, 125, 050)
            case .litPumpkin:                               return 0xFFD57D32    // (213, 125, 050)
            case .sweetBerryBush:                           return nil
            case .caveVines:                                return nil
            case .caveVinesHeadWithBerries:                 return nil
            case .caveVinesBodyWithBerries:                 return nil
            case .bamboo:                                   return nil
            case .brownMushroom:                            return nil
            case .redMushroom:                              return nil

            case .brownMushroomBlock:                       return 0xFF957150    // (149, 113, 080)
            case .redMushroomBlock:                         return 0xFFC72A29    // (199, 042, 041)

            case .deadbush:                                 return nil
            case .tallgrass:                                return nil
            case .doublePlant:                              return nil
            case .yellowFlower:                             return nil
            case .redFlower:                                return nil
            case .pitcherPlant:                             return nil
            case .pinkPetals:                               return nil
            case .witherRose:                               return nil
            case .torchflower:                              return nil

            case .waterlily:                                return nil
            case .seagrass:                                 return nil
            case .kelp:                                     return nil
            case .driedKelpBlock:                           return 0xFF2B3720    // (043, 055, 032)

            // Ocean Biome
            case .bubbleColumn:                             return nil
            case .seaPickle:                                return nil
            case .seaLantern:                               return 0xFFFCF9F2    // (252, 249, 242)
            case .conduit:                                  return nil

            // Snow Biome
            case .snow:                                     return 0xFFE5E5E5    // (229, 229, 229)
            case .snowLayer:                                return 0xFFFCFCFC    // (252, 252, 252)
            case .powderSnow:                               return 0xFFFCFCFC    // (252, 252, 252)
            case .ice:                                      return 0xFF9E9EFC    // (158, 158, 252)
            case .blueIce:                                  return 0xFF6697F6    // (102, 151, 246)
            case .packedIce:                                return 0xFF9E9EFC    // (158, 158, 252)
            case .frostedIce:                               return 0xFF6D92C1    // (109, 146, 193)

            // Caves & Cliffs
            case .glowLichen:                               return nil
            case .dripstoneBlock:                           return 0xFF8C7461    // (140, 116, 097)
            case .pointedDripstone:                         return 0xFF8C7461    // (140, 116, 097)
            case .mossBlock:                                return 0xFF6F902C    // (111, 144, 044)
            case .mossCarpet:                               return 0xFF6F902C    // (111, 144, 044)
            case .dirtWithRoots:                            return 0xFF956C4C    // (149, 108, 076)
            case .hangingRoots:                             return nil
            case .bigDripleaf:                              return nil
            case .smallDripleafBlock:                       return nil
            case .sporeBlossom:                             return nil
            case .azalea:                                   return 0xFF6F902C    // (111, 144, 044)
            case .floweringAzalea:                          return 0xFFB861CC    // (184, 097, 204)
            case .amethystBlock:                            return 0xFF9168AE    // (145, 104, 174)
            case .buddingAmethyst:                          return 0xFF9168AE    // (145, 104, 174)
            case .amethystCluster:                          return 0x7A9168AE    // (145, 104, 174)
            case .largeAmethystBud:                         return 0x5A9168AE    // (145, 104, 174)
            case .mediumAmethystBud:                        return 0x3A9168AE    // (145, 104, 174)
            case .smallAmethystBud:                         return 0x1A9168AE    // (145, 104, 174)
            case .tuff:                                     return Self.DefaultColor.normalStone.argb
            case .calcite:                                  return 0xFFFCF9F2    // (252, 249, 242)

            // Mangrove Swamp Biome
            case .mud:                                      return 0xFF39373C    // (057, 055, 060)
            case .muddyMangroveRoots:                       return 0xFF39373C    // (057, 055, 060)
            case .mangroveRoots:                            return 0xFF59472B    // (089, 071, 043)

            // Deep Dark Biome
            case .reinforcedDeepslate:                      return nil
            case .sculkSensor:                              return 0xFF074756    // (007, 071, 086)
            case .sculk:                                    return 0xFF052931    // (005, 041, 049)
            case .sculkVein:                                return nil
            case .sculkCatalyst:                            return 0xFF052931    // (005, 041, 049)
            case .sculkShrieker:                            return 0xFF052931    // (005, 041, 049)
            case .calibratedSculkSensor:                    return nil

            /* ---------- ---------- ---------- The Nether ---------- ---------- ---------- */
            case .netherrack:                               return 0xFF56201F    // (086, 032, 031)
            case .shroomlight:                              return 0xFFFBAA6C    // (251, 170, 108)
            case .netherWartBlock:                          return 0xFF7A0100    // (122, 001, 000)
            case .crimsonNylium:                            return 0xFF921818    // (146, 024, 024)
            case .warpedWartBlock:                          return 0xFF119983    // (017, 153, 131)
            case .warpedNylium:                             return 0xFF167D84    // (022, 125, 132)

            case .basalt:                                   return 0xFF5B5B5B    // (091, 091, 091)
            case .polishedBasalt:                           return 0xFF737373    // (115, 115, 115)
            case .smoothBasalt:                             return 0xFF5B5B5B    // (091, 091, 091)
            case .soulSoil:                                 return 0xFF5A4437    // (090, 068, 055)
            case .soulSand:                                 return 0xFF48362B    // (072, 054, 043)

            case .portal:                                   return 0xFF4E1E87    // (078, 030, 135)
            case .soulFire:                                 return nil
            case .magma:                                    return 0xFFB54009    // (181, 064, 009)
            case .glowstone:                                return 0xFFF8D773    // (248, 215, 115)

            // Plants
            case .netherWart:                               return nil
            case .crimsonRoots:                             return nil
            case .warpedRoots:                              return nil
            case .netherSprouts:                            return nil
            case .weepingVines:                             return nil
            case .twistingVines:                            return nil
            case .crimsonFungus:                            return nil
            case .warpedFungus:                             return nil

            /* ---------- ---------- ---------- The End ---------- ---------- ---------- */
            case .endStone:                                 return 0xFFDBDBAC    // (219, 219, 172)
            case .dragonEgg:                                return 0xFF090909    // (009, 009, 009)
            case .chorusPlant:                              return 0xFF5A335A    // (090, 051, 090)
            case .chorusFlower:                             return 0xFF9F779F    // (159, 119, 159)

            case .endPortalFrame:                           return 0xFF417266    // (065, 114, 102)
            case .endPortal:                                return 0xFF041218    // (004, 018, 024)
            case .endGateway:                               return 0xFF030D14    // (003, 013, 020)

            /* ---------- ---------- ---------- Ores & Ore Blocks ---------- ---------- ---------- */
            case .coalOre:                                  return Self.DefaultColor.normalStone.argb
            case .copperOre:                                return Self.DefaultColor.normalStone.argb
            case .ironOre:                                  return Self.DefaultColor.normalStone.argb
            case .goldOre:                                  return Self.DefaultColor.normalStone.argb
            case .diamondOre:                               return Self.DefaultColor.normalStone.argb
            case .lapisOre:                                 return Self.DefaultColor.normalStone.argb
            case .redstoneOre:                              return Self.DefaultColor.normalStone.argb
            case .litRedstoneOre:                           return Self.DefaultColor.normalStone.argb
            case .emeraldOre:                               return Self.DefaultColor.normalStone.argb
            case .netherGoldOre:                            return 0xFFF5AD2A    // (245, 173, 042)
            case .quartzOre:                                return 0xFFAA7069    // (170, 112, 105)

            case .deepslateCoalOre:                         return Self.DefaultColor.deepslate.argb
            case .deepslateCopperOre:                       return Self.DefaultColor.deepslate.argb
            case .deepslateIronOre:                         return Self.DefaultColor.deepslate.argb
            case .deepslateGoldOre:                         return Self.DefaultColor.deepslate.argb
            case .deepslateDiamondOre:                      return Self.DefaultColor.deepslate.argb
            case .deepslateLapisOre:                        return Self.DefaultColor.deepslate.argb
            case .deepslateRedstoneOre:                     return Self.DefaultColor.deepslate.argb
            case .litDeepslateRedstoneOre:                  return Self.DefaultColor.deepslate.argb
            case .deepslateEmeraldOre:                      return Self.DefaultColor.deepslate.argb

            case .rawCopperBlock:                           return 0xFF91533E    // (145, 083, 062)
            case .rawIronBlock:                             return 0xFF6D5940    // (109, 089, 064)
            case .rawGoldBlock:                             return 0xFFAD8922    // (173, 137, 034)

            case .coalBlock:                                return 0xFF0D0D0D    // (013, 013, 013)
            case .ironBlock:                                return 0xFFE3E3E3    // (227, 227, 227)
            case .goldBlock:                                return 0xFFFBDD48    // (251, 221, 072)
            case .diamondBlock:                             return 0xFF64F2E0    // (100, 242, 224)
            case .lapisBlock:                               return 0xFF183B73    // (024, 059, 115)
            case .redstoneBlock:                            return 0xFFA21808    // (162, 024, 008)
            case .emeraldBlock:                             return 0xFF3EF082    // (062, 240, 130)
            case .netheriteBlock:                           return 0xFF4C484C    // (076, 072, 076)
            case .ancientDebris:                            return 0xFF7D5F58    // (125, 095, 088)

            case .copperBlock:                              return 0xFFE0806B    // (224, 128, 107)
            case .exposedCopper:                            return 0xFF968A68    // (150, 138, 104)
            case .oxidizedCopper:                           return 0xFF4B9282    // (075, 146, 130)
            case .weatheredCopper:                          return 0xFF639E76    // (099, 158, 118)

            case .cutCopper:                                return 0xFFE0806B    // (224, 128, 107)
            case .exposedCutCopper:                         return 0xFF968A68    // (150, 138, 104)
            case .oxidizedCutCopper:                        return 0xFF4B9282    // (075, 146, 130)
            case .weatheredCutCopper:                       return 0xFF639E76    // (099, 158, 118)

            case .waxedCopper:                              return 0xFFE0806B    // (224, 128, 107)
            case .waxedExposedCopper:                       return 0xFF968A68    // (150, 138, 104)
            case .waxedOxidizedCopper:                      return 0xFF4B9282    // (075, 146, 130)
            case .waxedWeatheredCopper:                     return 0xFF639E76    // (099, 158, 118)

            case .waxedCutCopper:                           return 0xFFE0806B    // (224, 128, 107)
            case .waxedExposedCutCopper:                    return 0xFF968A68    // (150, 138, 104)
            case .waxedOxidizedCutCopper:                   return 0xFF4B9282    // (075, 146, 130)
            case .waxedWeatheredCutCopper:                  return 0xFF639E76    // (099, 158, 118)

            /* ---------- ---------- ---------- Stones ---------- ---------- ---------- */
            case .boneBlock:                                return 0xFFC7C3A5    // (199, 195, 165)
            case .cobblestone:                              return Self.DefaultColor.normalStone.argb
            case .mossyCobblestone:                         return 0xFF738352    // (115, 131, 082)
            case .cobbledDeepslate:                         return Self.DefaultColor.deepslate.argb

            case .stone:                                    return Self.DefaultColor.normalStone.argb
            case .granite:                                  return Self.DefaultColor.granite.argb
            case .diorite:                                  return Self.DefaultColor.diorite.argb
            case .andesite:                                 return Self.DefaultColor.andesite.argb
            case .polishedGranite:                          return Self.DefaultColor.granite.argb
            case .polishedDiorite:                          return Self.DefaultColor.diorite.argb
            case .polishedAndesite:                         return Self.DefaultColor.andesite.argb

            case .stonebricks:                              return Self.DefaultColor.normalStone.argb
            case .mossyStoneBricks:                         return Self.DefaultColor.mossyStone.argb
            case .crackedStoneBricks:                       return Self.DefaultColor.normalStone.argb
            case .chiseledStoneBricks:                      return Self.DefaultColor.normalStone.argb
            case .smoothStoneBricks:                        return Self.DefaultColor.mossyStone.argb

            case .blackstone:                               return Self.DefaultColor.blackStone.argb
            case .polishedBlackstone:                       return Self.DefaultColor.polishedBlackStone.argb

            case .deepslate:                                return Self.DefaultColor.deepslate.argb
            case .polishedDeepslate:                        return Self.DefaultColor.deepslate.argb

            case .polishedBlackstoneBricks:                 return Self.DefaultColor.polishedBlackStoneBricks.argb
            case .crackedPolishedBlackstoneBricks:          return Self.DefaultColor.polishedBlackStoneBricks.argb
            case .chiseledPolishedBlackstone:               return Self.DefaultColor.polishedBlackStone.argb
            case .gildedBlackstone:                         return 0xFF7D440E    // (125, 068, 014)

            case .deepslateTiles:                           return Self.DefaultColor.deepslate.argb
            case .crackedDeepslateTiles:                    return Self.DefaultColor.deepslate.argb
            case .deepslateBricks:                          return Self.DefaultColor.deepslate.argb
            case .crackedDeepslateBricks:                   return Self.DefaultColor.deepslate.argb
            case .chiseledDeepslate:                        return Self.DefaultColor.deepslate.argb

            case .smoothStone:                              return nil
            case .redBrickBlock:                            return Self.DefaultColor.redBricks.argb
            case .packedMud:                                return 0xFF93704F    // (147, 112, 079)
            case .mudBricks:                                return 0xFF93704F    // (147, 112, 079)

            case .netherBrick:                              return Self.DefaultColor.netherBricks.argb
            case .redNetherBrick:                           return Self.DefaultColor.redNetherBricks.argb
            case .chiseledNetherBricks:                     return Self.DefaultColor.netherBricks.argb
            case .crackedNetherBricks:                      return Self.DefaultColor.netherBricks.argb
            case .endBricks:                                return Self.DefaultColor.endBricks.argb

            case .prismarine:                               return Self.DefaultColor.prismarineNormal.argb
            case .darkPrismarine:                           return Self.DefaultColor.prismarineDark.argb
            case .prismarineBricks:                         return Self.DefaultColor.prismarineNormal.argb

            case .quartzBricks:                             return Self.DefaultColor.quartz.argb
            case .quartzBlock:                              return Self.DefaultColor.quartz.argb
            case .pillarQuartzBlock:                        return Self.DefaultColor.quartz.argb
            case .chiseledQuartzBlock:                      return Self.DefaultColor.quartz.argb
            case .smoothQuartzBlock:                        return Self.DefaultColor.quartz.argb

            case .purpurBlock:                              return Self.DefaultColor.endPurple.argb
            case .pillarPurpurBlock:                        return Self.DefaultColor.endPurple.argb
            case .chiseledPurpurBlock:                      return Self.DefaultColor.endPurple.argb
            case .smoothPurpurBlock:                        return Self.DefaultColor.endPurple.argb

            case .sandstone:                                return Self.DefaultColor.sand.argb
            case .chiseledSandstone:                        return Self.DefaultColor.sand.argb
            case .cutSandstone:                             return Self.DefaultColor.sand.argb
            case .smoothSandstone:                          return Self.DefaultColor.sand.argb
            case .redSandstone:                             return Self.DefaultColor.redSand.argb
            case .chiseledRedSandstone:                     return Self.DefaultColor.redSand.argb
            case .cutRedSandstone:                          return Self.DefaultColor.redSand.argb
            case .smoothRedSandstone:                       return Self.DefaultColor.redSand.argb

            /* ---------- ---------- ---------- Trees ---------- ---------- ---------- */
            case .oakLog:                                   return nil
            case .spruceLog:                                return nil
            case .birchLog:                                 return nil
            case .jungleLog:                                return nil
            case .acaciaLog:                                return nil
            case .darkOakLog:                               return nil
            case .mangroveLog:                              return 0xFF59472B    // (089, 071, 043)
            case .cherryLog:                                return nil
            case .crimsonStem:                              return Self.DefaultColor.crimsonPlanks.argb
            case .warpedStem:                               return Self.DefaultColor.warpedPlanks.argb

            case .strippedOakLog:                           return 0xFF947340    // (148, 115, 064)
            case .strippedSpruceLog:                        return 0xFF785A36    // (120, 090, 054)
            case .strippedBirchLog:                         return 0xFFCDBA7E    // (205, 186, 126)
            case .strippedJungleLog:                        return 0xFFAD7E52    // (173, 126, 082)
            case .strippedAcaciaLog:                        return 0xFFB86237    // (184, 098, 055)
            case .strippedDarkOakLog:                       return 0xFF6B5333    // (107, 083, 051)
            case .strippedMangroveLog:                      return Self.DefaultColor.mangrovePlanks.argb
            case .strippedCherryLog:                        return nil
            case .strippedCrimsonStem:                      return 0xFF943D61    // (148, 061, 097)
            case .strippedWarpedStem:                       return 0xFF439F9D    // (067, 159, 157)

            case .oakWood:                                  return nil
            case .spruceWood:                               return nil
            case .birchWood:                                return nil
            case .jungleWood:                               return nil
            case .acaciaWood:                               return nil
            case .darkOakWood:                              return nil
            case .mangroveWood:                             return 0xFF59472B    // (089, 071, 043)
            case .cherryWood:                               return nil
            case .bambooBlock:                              return nil
            case .crimsonHyphae:                            return 0xFF941515    // (148, 021, 021)
            case .warpedHyphae:                             return 0xFF16605A    // (022, 096, 090)

            case .strippedOakWood:                          return nil
            case .strippedSpruceWood:                       return nil
            case .strippedBirchWood:                        return nil
            case .strippedJungleWood:                       return nil
            case .strippedAcaciaWood:                       return nil
            case .strippedDarkOakWood:                      return nil
            case .strippedMangroveWood:                     return Self.DefaultColor.mangrovePlanks.argb
            case .strippedCherryWood:                       return nil
            case .strippedBambooBlock:                      return nil
            case .strippedCrimsonHyphae:                    return 0xFF943D61    // (148, 061, 097)
            case .strippedWarpedHyphae:                     return 0xFF439F9D    // (067, 159, 157)

            case .oakPlanks:                                return nil
            case .sprucePlanks:                             return nil
            case .birchPlanks:                              return nil
            case .junglePlanks:                             return nil
            case .acaciaPlanks:                             return nil
            case .darkOakPlanks:                            return nil
            case .mangrovePlanks:                           return Self.DefaultColor.mangrovePlanks.argb
            case .cherryPlanks:                             return nil
            case .bambooPlanks:                             return nil
            case .bambooMosaic:                             return nil
            case .crimsonPlanks:                            return Self.DefaultColor.crimsonPlanks.argb
            case .warpedPlanks:                             return Self.DefaultColor.warpedPlanks.argb

            case .oakLeaves:                                return nil
            case .spruceLeaves:                             return nil
            case .birchLeaves:                              return nil
            case .jungleLeaves:                             return nil
            case .acaciaLeaves:                             return nil
            case .darkOakLeaves:                            return nil
            case .mangroveLeaves:                           return 0xFF3B4910    // (059, 073, 016)
            case .cherryLeaves:                             return nil
            case .azaleaLeaves:                             return 0xFF6F902C    // (111, 144, 044)
            case .azaleaLeavesFlowered:                     return 0xFFB861CC    // (184, 097, 204)

            case .oakSapling:                               return nil
            case .spruceSapling:                            return nil
            case .birchSapling:                             return nil
            case .jungleSapling:                            return nil
            case .acaciaSapling:                            return nil
            case .darkOakSapling:                           return nil
            case .mangrovePropagule:                        return nil
            case .cherrySapling:                            return nil
            case .bambooSapling:                            return nil

            /* ---------- ---------- ---------- Fences & Gates ---------- ---------- ---------- */
            case .oakFence:                                 return nil
            case .spruceFence:                              return nil
            case .birchFence:                               return nil
            case .jungleFence:                              return nil
            case .acaciaFence:                              return nil
            case .darkOakFence:                             return nil
            case .mangroveFence:                            return Self.DefaultColor.mangrovePlanks.argb
            case .cherryFence:                              return nil
            case .bambooFence:                              return nil
            case .crimsonFence:                             return Self.DefaultColor.crimsonPlanks.argb
            case .warpedFence:                              return Self.DefaultColor.warpedPlanks.argb
            case .netherBrickFence:                         return Self.DefaultColor.netherBricks.argb

            case .oakFenceGate:                             return Self.DefaultColor.oakPlanks.argb
            case .spruceFenceGate:                          return Self.DefaultColor.sprucePlanks.argb
            case .birchFenceGate:                           return Self.DefaultColor.birchPlanks.argb
            case .jungleFenceGate:                          return Self.DefaultColor.junglePlanks.argb
            case .acaciaFenceGate:                          return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakFenceGate:                         return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveFenceGate:                        return Self.DefaultColor.mangrovePlanks.argb
            case .cherryFenceGate:                          return nil
            case .bambooFenceGate:                          return nil
            case .crimsonFenceGate:                         return Self.DefaultColor.crimsonPlanks.argb
            case .warpedFenceGate:                          return Self.DefaultColor.warpedPlanks.argb

            /* ---------- ---------- ---------- Walls ---------- ---------- ---------- */
            case .cobblestoneWall:                          return Self.DefaultColor.normalStone.argb
            case .mossyCobblestoneWall:                     return Self.DefaultColor.mossyStone.argb
            case .graniteWall:                              return Self.DefaultColor.granite.argb
            case .dioriteWall:                              return Self.DefaultColor.diorite.argb
            case .andesiteWall:                             return Self.DefaultColor.andesite.argb
            case .sandstoneWall:                            return Self.DefaultColor.sand.argb
            case .redSandstoneWall:                         return Self.DefaultColor.redSand.argb
            case .stoneBrickWall:                           return Self.DefaultColor.normalStone.argb
            case .mossyStoneBrickWall:                      return Self.DefaultColor.mossyStone.argb
            case .redBrickWall:                             return Self.DefaultColor.redBricks.argb
            case .netherBrickWall:                          return Self.DefaultColor.netherBricks.argb
            case .redNetherBrickWall:                       return Self.DefaultColor.redNetherBricks.argb
            case .endBrickWall:                             return Self.DefaultColor.endBricks.argb
            case .prismarineWall:                           return Self.DefaultColor.prismarineNormal.argb

            case .blackstoneWall:                           return Self.DefaultColor.blackStone.argb
            case .polishedBlackstoneWall:                   return Self.DefaultColor.polishedBlackStone.argb
            case .polishedBlackstoneBrickWall:              return Self.DefaultColor.polishedBlackStoneBricks.argb

            case .cobbledDeepslateWall:                     return Self.DefaultColor.deepslate.argb
            case .deepslateTileWall:                        return Self.DefaultColor.deepslate.argb
            case .polishedDeepslateWall:                    return Self.DefaultColor.deepslate.argb
            case .deepslateBrickWall:                       return Self.DefaultColor.deepslate.argb

            case .mudBrickWall:                             return 0xFF93704F    // (147, 112, 079)

            /* ---------- ---------- ---------- Stairs ---------- ---------- ---------- */
            case .oakStairs:                                return Self.DefaultColor.oakPlanks.argb
            case .spruceStairs:                             return Self.DefaultColor.sprucePlanks.argb
            case .birchStairs:                              return Self.DefaultColor.birchPlanks.argb
            case .jungleStairs:                             return Self.DefaultColor.junglePlanks.argb
            case .acaciaStairs:                             return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakStairs:                            return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveStairs:                           return Self.DefaultColor.mangrovePlanks.argb
            case .cherryStairs:                             return nil
            case .bambooStairs:                             return nil
            case .bambooMosaicStairs:                       return nil
            case .crimsonStairs:                            return Self.DefaultColor.crimsonPlanks.argb
            case .warpedStairs:                             return Self.DefaultColor.warpedPlanks.argb

            case .normalStoneStairs:                        return Self.DefaultColor.normalStone.argb
            case .cobblestoneStairs:                        return Self.DefaultColor.normalStone.argb
            case .mossyStoneBrickStairs:                    return Self.DefaultColor.mossyStone.argb
            case .stoneBrickStairs:                         return Self.DefaultColor.normalStone.argb
            case .mossyCobblestoneStairs:                   return Self.DefaultColor.mossyStone.argb

            case .graniteStairs:                            return Self.DefaultColor.granite.argb
            case .dioriteStairs:                            return Self.DefaultColor.diorite.argb
            case .andesiteStairs:                           return Self.DefaultColor.andesite.argb
            case .polishedGraniteStairs:                    return Self.DefaultColor.granite.argb
            case .polishedDioriteStairs:                    return Self.DefaultColor.diorite.argb
            case .polishedAndesiteStairs:                   return Self.DefaultColor.andesite.argb

            case .sandstoneStairs:                          return Self.DefaultColor.sand.argb
            case .redSandstoneStairs:                       return Self.DefaultColor.redSand.argb
            case .smoothSandstoneStairs:                    return Self.DefaultColor.sand.argb
            case .smoothRedSandstoneStairs:                 return Self.DefaultColor.redSand.argb
            case .redBrickStairs:                           return Self.DefaultColor.redBricks.argb
            case .mudBrickStairs:                           return 0xFF93704F    // (147, 112, 079)

            case .blackstoneStairs:                         return Self.DefaultColor.blackStone.argb
            case .polishedBlackstoneStairs:                 return Self.DefaultColor.polishedBlackStone.argb
            case .polishedBlackstoneBrickStairs:            return Self.DefaultColor.polishedBlackStone.argb

            case .cobbledDeepslateStairs:                   return Self.DefaultColor.deepslate.argb
            case .deepslateTileStairs:                      return Self.DefaultColor.deepslate.argb
            case .polishedDeepslateStairs:                  return Self.DefaultColor.deepslate.argb
            case .deepslateBrickStairs:                     return Self.DefaultColor.deepslate.argb

            case .netherBrickStairs:                        return Self.DefaultColor.netherBricks.argb
            case .redNetherBrickStairs:                     return Self.DefaultColor.redNetherBricks.argb
            case .endBrickStairs:                           return Self.DefaultColor.endBricks.argb
            case .quartzStairs:                             return Self.DefaultColor.quartz.argb
            case .smoothQuartzStairs:                       return Self.DefaultColor.quartz.argb
            case .purpurStairs:                             return Self.DefaultColor.endPurple.argb
            case .prismarineStairs:                         return Self.DefaultColor.prismarineNormal.argb
            case .darkPrismarineStairs:                     return Self.DefaultColor.prismarineDark.argb
            case .prismarineBricksStairs:                   return 0xFF59ADA2    // (089, 173, 162)

            case .cutCopperStairs:                          return Self.DefaultColor.copper.argb
            case .exposedCutCopperStairs:                   return Self.DefaultColor.exposedCopper.argb
            case .oxidizedCutCopperStairs:                  return Self.DefaultColor.oxidizedCopper.argb
            case .weatheredCutCopperStairs:                 return Self.DefaultColor.weatheredCopper.argb
            case .waxedCutCopperStairs:                     return Self.DefaultColor.copper.argb
            case .waxedExposedCutCopperStairs:              return Self.DefaultColor.exposedCopper.argb
            case .waxedOxidizedCutCopperStairs:             return Self.DefaultColor.oxidizedCopper.argb
            case .waxedWeatheredCutCopperStairs:            return Self.DefaultColor.weatheredCopper.argb

            /* ---------- ---------- ---------- Slabs ---------- ---------- ---------- */
            case .oakSlab:                                  return Self.DefaultColor.oakPlanks.argb
            case .spruceSlab:                               return Self.DefaultColor.sprucePlanks.argb
            case .birchSlab:                                return Self.DefaultColor.birchPlanks.argb
            case .jungleSlab:                               return Self.DefaultColor.junglePlanks.argb
            case .acaciaSlab:                               return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakSlab:                              return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveSlab:                             return Self.DefaultColor.mangrovePlanks.argb
            case .cherrySlab:                               return nil
            case .bambooSlab:                               return nil
            case .bambooMosaicSlab:                         return nil
            case .crimsonSlab:                              return Self.DefaultColor.crimsonPlanks.argb
            case .warpedSlab:                               return Self.DefaultColor.warpedPlanks.argb

            case .oakDoubleSlab:                            return Self.DefaultColor.oakPlanks.argb
            case .spruceDoubleSlab:                         return Self.DefaultColor.sprucePlanks.argb
            case .birchDoubleSlab:                          return Self.DefaultColor.birchPlanks.argb
            case .jungleDoubleSlab:                         return Self.DefaultColor.junglePlanks.argb
            case .acaciaDoubleSlab:                         return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakDoubleSlab:                        return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveDoubleSlab:                       return Self.DefaultColor.mangrovePlanks.argb
            case .cherryDoubleSlab:                         return nil
            case .bambooDoubleSlab:                         return nil
            case .bambooMosaicDoubleSlab:                   return nil
            case .crimsonDoubleSlab:                        return Self.DefaultColor.crimsonPlanks.argb
            case .warpedDoubleSlab:                         return Self.DefaultColor.warpedPlanks.argb

            case .smoothStoneSlab:                          return nil
            case .cobblestoneSlab:                          return nil
            case .stoneBrickSlab:                           return nil
            case .sandstoneSlab:                            return nil
            case .redBrickSlab:                             return nil
            case .netherBrickSlab:                          return nil
            case .quartzSlab:                               return nil
            case .smoothStoneDoubleSlab:                    return nil
            case .cobblestoneDoubleSlab:                    return nil
            case .stoneBrickDoubleSlab:                     return nil
            case .sandstoneDoubleSlab:                      return nil
            case .redBrickDoubleSlab:                       return nil
            case .netherBrickDoubleSlab:                    return nil
            case .quartzDoubleSlab:                         return nil

            case .mossyCobblestoneSlab:                     return nil
            case .smoothSandstoneSlab:                      return nil
            case .redSandstoneSlab:                         return nil
            case .redNetherBrickSlab:                       return nil
            case .purpurSlab:                               return nil
            case .prismarineRoughSlab:                      return nil
            case .prismarineDarkSlab:                       return nil
            case .prismarineBrickSlab:                      return nil
            case .mossyCobblestoneDoubleSlab:               return nil
            case .smoothSandstoneDoubleSlab:                return nil
            case .redSandstoneDoubleSlab:                   return nil
            case .redNetherBrickDoubleSlab:                 return nil
            case .purpurDoubleSlab:                         return nil
            case .prismarineRoughDoubleSlab:                return nil
            case .prismarineDarkDoubleSlab:                 return nil
            case .prismarineBrickDoubleSlab:                return nil

            case .smoothRedSandstoneSlab:                   return nil
            case .graniteSlab:                              return nil
            case .dioriteSlab:                              return nil
            case .andesiteSlab:                             return nil
            case .polishedGraniteSlab:                      return nil
            case .polishedDioriteSlab:                      return nil
            case .polishedAndesiteSlab:                     return nil
            case .endStoneBrickSlab:                        return nil
            case .smoothRedSandstoneDoubleSlab:             return nil
            case .graniteDoubleSlab:                        return nil
            case .dioriteDoubleSlab:                        return nil
            case .andesiteDoubleSlab:                       return nil
            case .polishedGraniteDoubleSlab:                return nil
            case .polishedDioriteDoubleSlab:                return nil
            case .polishedAndesiteDoubleSlab:               return nil
            case .endStoneBrickDoubleSlab:                  return nil

            case .stoneSlab:                                return nil
            case .mossyStoneBrickSlab:                      return nil
            case .cutSandstoneSlab:                         return nil
            case .cutRedSandstoneSlab:                      return nil
            case .smoothQuartzSlab:                         return nil
            case .stoneDoubleSlab:                          return nil
            case .mossyStoneBrickDoubleSlab:                return nil
            case .cutSandstoneDoubleSlab:                   return nil
            case .cutRedSandstoneDoubleSlab:                return nil
            case .smoothQuartzDoubleSlab:                   return nil

            case .blackstoneSlab:                           return Self.DefaultColor.blackStone.argb
            case .polishedBlackstoneSlab:                   return Self.DefaultColor.polishedBlackStone.argb
            case .polishedBlackstoneBrickSlab:              return Self.DefaultColor.polishedBlackStoneBricks.argb
            case .blackstoneDoubleSlab:                     return Self.DefaultColor.blackStone.argb
            case .polishedBlackstoneDoubleSlab:             return Self.DefaultColor.polishedBlackStone.argb
            case .polishedBlackstoneBrickDoubleSlab:        return Self.DefaultColor.polishedBlackStoneBricks.argb

            case .cobbledDeepslateSlab:                     return Self.DefaultColor.deepslate.argb
            case .deepslateTileSlab:                        return Self.DefaultColor.deepslate.argb
            case .polishedDeepslateSlab:                    return Self.DefaultColor.deepslate.argb
            case .deepslateBrickSlab:                       return Self.DefaultColor.deepslate.argb
            case .cobbledDeepslateDoubleSlab:               return Self.DefaultColor.deepslate.argb
            case .deepslateTileDoubleSlab:                  return Self.DefaultColor.deepslate.argb
            case .polishedDeepslateDoubleSlab:              return Self.DefaultColor.deepslate.argb
            case .deepslateBrickDoubleSlab:                 return Self.DefaultColor.deepslate.argb

            case .mudBrickSlab:                             return 0xFF93704F    // (147, 112, 079)
            case .mudBrickDoubleSlab:                       return 0xFF93704F    // (147, 112, 079)

            case .cutCopperSlab:                            return Self.DefaultColor.copper.argb
            case .exposedCutCopperSlab:                     return Self.DefaultColor.exposedCopper.argb
            case .oxidizedCutCopperSlab:                    return Self.DefaultColor.oxidizedCopper.argb
            case .weatheredCutCopperSlab:                   return Self.DefaultColor.weatheredCopper.argb
            case .waxedCutCopperSlab:                       return Self.DefaultColor.copper.argb
            case .waxedExposedCutCopperSlab:                return Self.DefaultColor.exposedCopper.argb
            case .waxedOxidizedCutCopperSlab:               return Self.DefaultColor.oxidizedCopper.argb
            case .waxedWeatheredCutCopperSlab:              return Self.DefaultColor.weatheredCopper.argb

            case .doubleCutCopperSlab:                      return Self.DefaultColor.copper.argb
            case .exposedDoubleCutCopperSlab:               return Self.DefaultColor.exposedCopper.argb
            case .oxidizedDoubleCutCopperSlab:              return Self.DefaultColor.oxidizedCopper.argb
            case .weatheredDoubleCutCopperSlab:             return Self.DefaultColor.weatheredCopper.argb
            case .waxedDoubleCutCopperSlab:                 return Self.DefaultColor.copper.argb
            case .waxedExposedDoubleCutCopperSlab:          return Self.DefaultColor.exposedCopper.argb
            case .waxedOxidizedDoubleCutCopperSlab:         return Self.DefaultColor.oxidizedCopper.argb
            case .waxedWeatheredDoubleCutCopperSlab:        return Self.DefaultColor.weatheredCopper.argb

            /* ---------- ---------- ---------- Signs ---------- ---------- ---------- */
            case .oakStandingSign:                          return nil
            case .spruceStandingSign:                       return nil
            case .birchStandingSign:                        return nil
            case .acaciaStandingSign:                       return nil
            case .jungleStandingSign:                       return nil
            case .darkoakStandingSign:                      return nil
            case .mangroveStandingSign:                     return nil
            case .cherryStandingSign:                       return nil
            case .bambooStandingSign:                       return nil
            case .crimsonStandingSign:                      return nil
            case .warpedStandingSign:                       return nil

            case .oakHangingSign:                           return nil
            case .spruceHangingSign:                        return nil
            case .birchHangingSign:                         return nil
            case .jungleHangingSign:                        return nil
            case .acaciaHangingSign:                        return nil
            case .darkOakHangingSign:                       return nil
            case .mangroveHangingSign:                      return nil
            case .cherryHangingSign:                        return nil
            case .bambooHangingSign:                        return nil
            case .crimsonHangingSign:                       return nil
            case .warpedHangingSign:                        return nil

            case .oakWallSign:                              return nil
            case .spruceWallSign:                           return nil
            case .birchWallSign:                            return nil
            case .acaciaWallSign:                           return nil
            case .jungleWallSign:                           return nil
            case .darkoakWallSign:                          return nil
            case .mangroveWallSign:                         return nil
            case .cherryWallSign:                           return nil
            case .bambooWallSign:                           return nil
            case .crimsonWallSign:                          return nil
            case .warpedWallSign:                           return nil

            /* ---------- ---------- ---------- Doors & Trapdoors ---------- ---------- ---------- */
            case .oakDoor:                                  return nil
            case .spruceDoor:                               return nil
            case .birchDoor:                                return nil
            case .jungleDoor:                               return nil
            case .acaciaDoor:                               return nil
            case .darkOakDoor:                              return nil
            case .mangroveDoor:                             return nil
            case .cherryDoor:                               return nil
            case .bambooDoor:                               return nil
            case .crimsonDoor:                              return nil
            case .warpedDoor:                               return nil
            case .ironDoor:                                 return nil

            case .oakTrapdoor:                              return nil
            case .spruceTrapdoor:                           return nil
            case .birchTrapdoor:                            return nil
            case .jungleTrapdoor:                           return nil
            case .acaciaTrapdoor:                           return nil
            case .darkOakTrapdoor:                          return nil
            case .mangroveTrapdoor:                         return nil
            case .cherryTrapdoor:                           return nil
            case .bambooTrapdoor:                           return nil
            case .crimsonTrapdoor:                          return nil
            case .warpedTrapdoor:                           return nil
            case .ironTrapdoor:                             return nil

            /* ---------- ---------- ---------- Village Blocks ---------- ---------- ---------- */
            case .ironBars:                                 return nil
            case .ladder:                                   return nil
            case .scaffolding:                              return 0xFFE1C473    // (225, 196, 115)
            case .honeycombBlock:                           return 0xFFE58A08    // (229, 138, 008)
            case .lodestone:                                return 0xFFA0A2AA    // (160, 162, 170)
            case .hayBlock:                                 return 0xFFCBB007    // (203, 176, 007)

            case .torch:                                    return nil
            case .soulTorch:                                return nil
            case .lantern:                                  return 0xFF484F64    // (072, 079, 100)
            case .soulLantern:                              return nil
            case .campfire:                                 return nil
            case .soulCampfire:                             return nil

            case .craftingTable:                            return 0xFF9C5831    // (156, 088, 049)
            case .cartographyTable:                         return 0xFF563518    // (086, 053, 024)
            case .fletchingTable:                           return 0xFFD4BF83    // (212, 191, 131)
            case .smithingTable:                            return 0xFF3F4152    // (063, 065, 082)
            case .beehive:                                  return 0xFFB6925E    // (182, 146, 094)
            case .furnace:                                  return Self.DefaultColor.furnace.argb
            case .litFurnace:                               return Self.DefaultColor.furnace.argb
            case .blastFurnace:                             return Self.DefaultColor.furnace.argb
            case .litBlastFurnace:                          return Self.DefaultColor.furnace.argb
            case .smoker:                                   return Self.DefaultColor.furnace.argb
            case .litSmoker:                                return Self.DefaultColor.furnace.argb
            case .respawnAnchor:                            return 0xFF8108E1    // (129, 008, 225)
            case .brewingStand:                             return nil
            case .anvil:                                    return Self.DefaultColor.anvil.argb
            case .grindstone:                               return 0xFF8D8D8D    // (141, 141, 141)
            case .enchantingTable:                          return 0xFF49EACF    // (073, 234, 207)
            case .bookshelf:                                return 0xFFC09B61    // (192, 155, 097)
            case .chiseledBookshelf:                        return nil
            case .lectern:                                  return 0xFFA48049    // (164, 128, 073)
            case .composter:                                return 0xFF8B5B31    // (139, 091, 049)

            case .emptyCauldron:                            return 0xFF353434    // (053, 052, 052)
            case .waterCauldron:                            return nil
            case .lavaCauldron:                             return nil
            case .powerSnowCauldron:                        return nil

            case .chest:                                    return Self.DefaultColor.chest.argb
            case .trappedChest:                             return Self.DefaultColor.chest.argb
            case .enderChest:                               return 0xFF273638    // (039, 054, 056)
            case .barrel:                                   return 0xFF89663C    // (137, 102, 060)

            case .noteblock:                                return 0xFF925C40    // (146, 092, 064)
            case .jukebox:                                  return 0xFF7A4F38    // (122, 079, 056)
            case .frame:                                    return nil
            case .glowFrame:                                return nil
            case .flowerPot:                                return nil
            case .beacon:                                   return 0xFF48D2CA    // (072, 210, 202)
            case .bell:                                     return 0xFFFAD338    // (250, 211, 056)
            case .stonecutterBlock:                         return Self.DefaultColor.furnace.argb
            case .loom:                                     return 0xFFC8A470    // (200, 164, 112)
            case .decoratedPot:                             return nil
            case .chain:                                    return nil
            case .endRod:                                   return nil
            case .lightningRod:                             return nil

            case .skull:                                    return nil
            case .rail:                                     return Self.DefaultColor.rail.argb
            case .goldenRail:                               return Self.DefaultColor.rail.argb
            case .detectorRail:                             return Self.DefaultColor.rail.argb
            case .activatorRail:                            return Self.DefaultColor.rail.argb

            /* ---------- ---------- ---------- Tech Blocks ---------- ---------- ---------- */
            case .commandBlock:                             return 0xFFC47D4E    // (196, 125, 078)
            case .repeatingCommandBlock:                    return 0xFF694EC5    // (105, 078, 197)
            case .chainCommandBlock:                        return 0xFF9FC1B2    // (159, 193, 178)
            case .structureBlock:                           return 0xFF937894    // (147, 120, 148)
            case .structureVoid:                            return nil
            case .movingBlock:                              return nil
            case .lightBlock:                               return nil
            case .barrier:                                  return nil
            case .jigsaw:                                   return nil

            case .woodenButton:                             return nil
            case .spruceButton:                             return nil
            case .birchButton:                              return nil
            case .jungleButton:                             return nil
            case .acaciaButton:                             return nil
            case .darkOakButton:                            return nil
            case .mangroveButton:                           return nil
            case .cherryButton:                             return nil
            case .bambooButton:                             return nil
            case .crimsonButton:                            return nil
            case .warpedButton:                             return nil
            case .stoneButton:                              return nil
            case .polishedBlackstoneButton:                 return nil

            case .woodenPressurePlate:                      return nil
            case .sprucePressurePlate:                      return nil
            case .birchPressurePlate:                       return nil
            case .junglePressurePlate:                      return nil
            case .acaciaPressurePlate:                      return nil
            case .darkOakPressurePlate:                     return nil
            case .mangrovePressurePlate:                    return nil
            case .cherryPressurePlate:                      return nil
            case .bambooPressurePlate:                      return nil
            case .crimsonPressurePlate:                     return nil
            case .warpedPressurePlate:                      return nil
            case .stonePressurePlate:                       return nil
            case .lightWeightedPressurePlate:               return nil
            case .heavyWeightedPressurePlate:               return nil
            case .polishedBlackstonePressurePlate:          return nil

            case .redstoneWire:                             return nil
            case .redstoneTorch:                            return nil
            case .unlitRedstoneTorch:                       return nil
            case .lever:                                    return nil
            case .tripwireHook:                             return nil
            case .tripWire:                                 return nil
            case .redstoneLamp:                             return 0xFFAD683A    // (173, 104, 058)
            case .litRedstoneLamp:                          return 0xFFF8D773    // (248, 215, 115)
            case .observer:                                 return 0xFF646464    // (100, 100, 100)
            case .daylightDetector:                         return 0xFFBCA88C    // (188, 168, 140)
            case .daylightDetectorInverted:                 return 0xFFBCA88C    // (188, 168, 140)
            case .poweredRepeater:                          return nil
            case .unpoweredRepeater:                        return nil
            case .poweredComparator:                        return nil
            case .unpoweredComparator:                      return nil
            case .hopper:                                   return 0xFF464646    // (070, 070, 070)
            case .dropper:                                  return Self.DefaultColor.furnace.argb
            case .dispenser:                                return Self.DefaultColor.furnace.argb
            case .piston:                                   return Self.DefaultColor.furnace.argb
            case .pistonArmCollision:                       return Self.DefaultColor.furnace.argb
            case .stickyPiston:                             return Self.DefaultColor.furnace.argb
            case .stickyPistonArmCollision:                 return Self.DefaultColor.furnace.argb
            case .tnt:                                      return 0xFFD82E1A    // (216, 046, 026)
            case .target:                                   return 0xFFB73131    // (183, 049, 049)
            case .slime:                                    return 0x7A70BB5E    // (112, 187, 094)
            case .honeyBlock:                               return 0x7AE99126    // (233, 145, 038)

            /* ---------- ---------- ---------- Colored Blocks ---------- ---------- ---------- */
            case .bed:                                      return nil
            case .standingBanner:                           return nil
            case .wallBanner:                               return nil

            case .tintedGlass:                              return nil
            case .glass:                                    return 0x11FFFFFF
            case .glassPane:                                return nil
            case .whiteStainedGlass:                        return nil
            case .lightGrayStainedGlass:                    return nil
            case .grayStainedGlass:                         return nil
            case .blackStainedGlass:                        return nil
            case .brownStainedGlass:                        return nil
            case .redStainedGlass:                          return nil
            case .orangeStainedGlass:                       return nil
            case .yellowStainedGlass:                       return nil
            case .limeStainedGlass:                         return nil
            case .greenStainedGlass:                        return nil
            case .cyanStainedGlass:                         return nil
            case .lightBlueStainedGlass:                    return nil
            case .blueStainedGlass:                         return nil
            case .purpleStainedGlass:                       return nil
            case .magentaStainedGlass:                      return nil
            case .pinkStainedGlass:                         return nil
            case .whiteStainedGlassPane:                    return nil
            case .lightGrayStainedGlassPane:                return nil
            case .grayStainedGlassPane:                     return nil
            case .blackStainedGlassPane:                    return nil
            case .brownStainedGlassPane:                    return nil
            case .redStainedGlassPane:                      return nil
            case .orangeStainedGlassPane:                   return nil
            case .yellowStainedGlassPane:                   return nil
            case .limeStainedGlassPane:                     return nil
            case .greenStainedGlassPane:                    return nil
            case .cyanStainedGlassPane:                     return nil
            case .lightBlueStainedGlassPane:                return nil
            case .blueStainedGlassPane:                     return nil
            case .purpleStainedGlassPane:                   return nil
            case .magentaStainedGlassPane:                  return nil
            case .pinkStainedGlassPane:                     return nil

            case .undyedShulkerBox:                         return 0xFF956595    // (149, 101, 149)
            case .whiteShulkerBox:                          return nil
            case .lightGrayShulkerBox:                      return nil
            case .grayShulkerBox:                           return nil
            case .blackShulkerBox:                          return nil
            case .brownShulkerBox:                          return nil
            case .redShulkerBox:                            return nil
            case .orangeShulkerBox:                         return nil
            case .yellowShulkerBox:                         return nil
            case .limeShulkerBox:                           return nil
            case .greenShulkerBox:                          return nil
            case .cyanShulkerBox:                           return nil
            case .lightBlueShulkerBox:                      return nil
            case .blueShulkerBox:                           return nil
            case .purpleShulkerBox:                         return nil
            case .magentaShulkerBox:                        return nil
            case .pinkShulkerBox:                           return nil

            // case .wool:                                  return nil
            case .whiteWool:                                return nil
            case .lightGrayWool:                            return nil
            case .grayWool:                                 return nil
            case .blackWool:                                return nil
            case .brownWool:                                return nil
            case .redWool:                                  return nil
            case .orangeWool:                               return nil
            case .yellowWool:                               return nil
            case .limeWool:                                 return nil
            case .greenWool:                                return nil
            case .cyanWool:                                 return nil
            case .lightBlueWool:                            return nil
            case .blueWool:                                 return nil
            case .purpleWool:                               return nil
            case .magentaWool:                              return nil
            case .pinkWool:                                 return nil

            // case .carpet:                                return nil
            case .whiteCarpet:                              return nil
            case .lightGrayCarpet:                          return nil
            case .grayCarpet:                               return nil
            case .blackCarpet:                              return nil
            case .brownCarpet:                              return nil
            case .redCarpet:                                return nil
            case .orangeCarpet:                             return nil
            case .yellowCarpet:                             return nil
            case .limeCarpet:                               return nil
            case .greenCarpet:                              return nil
            case .cyanCarpet:                               return nil
            case .lightBlueCarpet:                          return nil
            case .blueCarpet:                               return nil
            case .purpleCarpet:                             return nil
            case .magentaCarpet:                            return nil
            case .pinkCarpet:                               return nil

            case .candle:                                   return nil
            case .whiteCandle:                              return nil
            case .lightGrayCandle:                          return nil
            case .grayCandle:                               return nil
            case .blackCandle:                              return nil
            case .brownCandle:                              return nil
            case .redCandle:                                return nil
            case .orangeCandle:                             return nil
            case .yellowCandle:                             return nil
            case .limeCandle:                               return nil
            case .greenCandle:                              return nil
            case .cyanCandle:                               return nil
            case .lightBlueCandle:                          return nil
            case .blueCandle:                               return nil
            case .purpleCandle:                             return nil
            case .magentaCandle:                            return nil
            case .pinkCandle:                               return nil

            case .cake:                                     return nil
            case .candleCake:                               return nil
            case .whiteCandleCake:                          return nil
            case .lightGrayCandleCake:                      return nil
            case .grayCandleCake:                           return nil
            case .blackCandleCake:                          return nil
            case .brownCandleCake:                          return nil
            case .redCandleCake:                            return nil
            case .orangeCandleCake:                         return nil
            case .yellowCandleCake:                         return nil
            case .limeCandleCake:                           return nil
            case .greenCandleCake:                          return nil
            case .cyanCandleCake:                           return nil
            case .lightBlueCandleCake:                      return nil
            case .blueCandleCake:                           return nil
            case .purpleCandleCake:                         return nil
            case .magentaCandleCake:                        return nil
            case .pinkCandleCake:                           return nil

            case .whiteConcretePowder:                      return nil
            case .lightGrayConcretePowder:                  return nil
            case .grayConcretePowder:                       return nil
            case .blackConcretePowder:                      return nil
            case .brownConcretePowder:                      return nil
            case .redConcretePowder:                        return nil
            case .orangeConcretePowder:                     return nil
            case .yellowConcretePowder:                     return nil
            case .limeConcretePowder:                       return nil
            case .greenConcretePowder:                      return nil
            case .cyanConcretePowder:                       return nil
            case .lightBlueConcretePowder:                  return nil
            case .blueConcretePowder:                       return nil
            case .purpleConcretePowder:                     return nil
            case .magentaConcretePowder:                    return nil
            case .pinkConcretePowder:                       return nil

            case .concrete:                                 return nil
            case .whiteConcrete:                            return nil
            case .lightGrayConcrete:                        return nil
            case .grayConcrete:                             return nil
            case .blackConcrete:                            return nil
            case .brownConcrete:                            return nil
            case .redConcrete:                              return nil
            case .orangeConcrete:                           return nil
            case .yellowConcrete:                           return nil
            case .limeConcrete:                             return nil
            case .greenConcrete:                            return nil
            case .cyanConcrete:                             return nil
            case .lightBlueConcrete:                        return nil
            case .blueConcrete:                             return nil
            case .purpleConcrete:                           return nil
            case .magentaConcrete:                          return nil
            case .pinkConcrete:                             return nil

            case .clay:                                     return 0xFFA2A6B6    // (162, 166, 182)
            case .hardenedClay:                             return 0xFFA2A6B6    // (162, 166, 182)
            case .whiteStainedHardenedClay:                 return nil
            case .lightGrayStainedHardenedClay:             return nil
            case .grayStainedHardenedClay:                  return nil
            case .blackStainedHardenedClay:                 return nil
            case .brownStainedHardenedClay:                 return nil
            case .redStainedHardenedClay:                   return nil
            case .orangeStainedHardenedClay:                return nil
            case .yellowStainedHardenedClay:                return nil
            case .limeStainedHardenedClay:                  return nil
            case .greenStainedHardenedClay:                 return nil
            case .cyanStainedHardenedClay:                  return nil
            case .lightBlueStainedHardenedClay:             return nil
            case .blueStainedHardenedClay:                  return nil
            case .purpleStainedHardenedClay:                return nil
            case .magentaStainedHardenedClay:               return nil
            case .pinkStainedHardenedClay:                  return nil

            case .whiteGlazedTerracotta:                    return 0xFFF6FCFB    // (246, 252, 251)
            case .silverGlazedTerracotta:                   return 0xFFC7CBCF    // (199, 203, 207)
            case .grayGlazedTerracotta:                     return 0xFF5E7276    // (094, 114, 118)
            case .blackGlazedTerracotta:                    return 0xFF18181B    // (024, 024, 027)
            case .brownGlazedTerracotta:                    return 0xFFA7784F    // (167, 120, 079)
            case .redGlazedTerracotta:                      return 0xFFCA4139    // (202, 065, 057)
            case .orangeGlazedTerracotta:                   return 0xFF1AC4C5    // (026, 196, 197)
            case .yellowGlazedTerracotta:                   return 0xFFFBDB5D    // (251, 219, 093)
            case .limeGlazedTerracotta:                     return 0xFF89D623    // (137, 214, 035)
            case .greenGlazedTerracotta:                    return 0xFF6F9724    // (111, 151, 036)
            case .cyanGlazedTerracotta:                     return 0xFF149FA0    // (020, 159, 160)
            case .lightBlueGlazedTerracotta:                return 0xFF56BBDC    // (086, 187, 220)
            case .blueGlazedTerracotta:                     return 0xFF3B42A7    // (059, 066, 167)
            case .purpleGlazedTerracotta:                   return 0xFF9235C6    // (146, 053, 198)
            case .magentaGlazedTerracotta:                  return 0xFFC957C0    // (201, 087, 192)
            case .pinkGlazedTerracotta:                     return 0xFFF1B3C9    // (241, 179, 201)

            case .tubeCoralBlock:                           return nil
            case .brainCoralBlock:                          return nil
            case .bubbleCoralBlock:                         return nil
            case .fireCoralBlock:                           return nil
            case .hornCoralBlock:                           return nil
            case .deadTubeCoralBlock:                       return nil
            case .deadBrainCoralBlock:                      return nil
            case .deadBubbleCoralBlock:                     return nil
            case .deadFireCoralBlock:                       return nil
            case .deadHornCoralBlock:                       return nil

            case .fireCoral:                                return nil
            case .brainCoral:                               return nil
            case .bubbleCoral:                              return nil
            case .tubeCoral:                                return nil
            case .hornCoral:                                return nil
            case .deadFireCoral:                            return nil
            case .deadBrainCoral:                           return nil
            case .deadBubbleCoral:                          return nil
            case .deadTubeCoral:                            return nil
            case .deadHornCoral:                            return nil

            case .tubeCoralFan:                             return nil
            case .brainCoralFan:                            return nil
            case .bubbleCoralFan:                           return nil
            case .fireCoralFan:                             return nil
            case .hornCoralFan:                             return nil

            case .deadTubeCoralFan:                         return nil
            case .deadBrainCoralFan:                        return nil
            case .deadBubbleCoralFan:                       return nil
            case .deadFireCoralFan:                         return nil
            case .deadHornCoralFan:                         return nil

            case .tubeCoralHang:                            return nil
            case .brainCoralHang:                           return nil
            case .deadTubeCoralHang:                        return nil
            case .deadBrainCoralHang:                       return nil
            case .bubbleCoralHang:                          return nil
            case .fireCoralHang:                            return nil
            case .deadBubbleCoralHang:                      return nil
            case .deadFireCoralHang:                        return nil
            case .hornCoralHang:                            return nil
            case .deadHornCoralHang:                        return nil

            /* ---------- ---------- ---------- Other ---------- ---------- ---------- */
            case .clientRequestPlaceholderBlock:            return nil
            case .invisibleBedrock:                         return nil
            case .reserved6:                                return nil
            case .netherreactor:                            return 0xFF211114    // (033, 017, 020)
            case .glowingobsidian:                          return nil
            case .stonecutter:                              return Self.DefaultColor.furnace.argb
            case .infoUpdate:                               return nil
            case .infoUpdate2:                              return nil
        }
    }
}
