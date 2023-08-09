import Foundation

extension MCBlockType {
    public var argb: UInt32? {
        switch self {
            case .unknown:                                  return nil
            case .air:                                      return nil
            case .bedrock:                                  return Self.DefaultColor.normalStone.argb
            case .fire:                                     return 0xFF // (202, 115, 3)
            case .water:                                    return Self.DefaultColor.water.argb
            case .lava:                                     return 0xFFB34703    // (179, 071, 003)
            case .flowingWater:                             return Self.DefaultColor.water.argb
            case .flowingLava:                              return 0xFFB34703    // (179, 071, 003)
            case .obsidian:                                 return 0xFF1D0E34    // (029, 014, 052)
            case .cryingObsidian:                           return 0xFF2A0177    // (042, 001, 119)

            /* ---------- ---------- ---------- Overworld ---------- ---------- ---------- */
            case .grass:                                    return 0xFF82943A    // (130, 148, 058)
            case .dirt:                                     return 0xFF956C4C    // (149, 108, 76)
            case .coarseDirt:                               return 0xFF // (96, 67, 45)
            case .farmland:                                 return 0xFF956C4C    // (149, 108, 076)
            case .dirtPath:                                 return 0xFFCCCCCC    // (204, 204, 204)
            case .podzol:                                   return 0xFF694317    // (105, 067, 023)
            case .mycelium:                                 return 0xFF726061    // (114, 096, 097)

            case .gravel:                                   return Self.DefaultColor.normalStone.argb
            case .sand:                                     return Self.DefaultColor.sand.argb
            case .redSand:                                  return 0xFF // 201, 109, 36
            case .suspiciousGravel:                         return Self.DefaultColor.normalStone.argb
            case .suspiciousSand:                           return Self.DefaultColor.sand.argb

            case .web:                                      return 0xFF // 255, 255, 255
            case .beeNest:                                  return 0xFFC68443    // (198, 132, 067)

            case .mobSpawner:                               return 0xFF182B38    // (024, 043, 056)
            case .infestedStone:                            return Self.DefaultColor.normalStone.argb
            case .infestedCobblestone:                      return Self.DefaultColor.normalStone.argb
            case .infestedStoneBrick:                       return Self.DefaultColor.normalStone.argb
            case .infestedMossyStoneBrick:                  return Self.DefaultColor.mossyStone.argb
            case .infestedCrackedStoneBrick:                return Self.DefaultColor.normalStone.argb
            case .infestedChiseledStoneBrick:               return Self.DefaultColor.normalStone.argb
            case .infestedDeepslate:                        return Self.DefaultColor.deepslate.argb
            case .turtleEgg:                                return 0xFF // 224, 219, 197
            case .snifferEgg:                               return 0xFF // 186, 77, 57
            case .frogSpawn:                                return 0xFF // 55, 55, 220

            case .ochreFroglight:                           return 0xFF // 213, 201, 140
            case .verdantFroglight:                         return 0xFF // 109, 144, 129
            case .pearlescentFroglight:                     return 0xFF // 208, 109, 142
            case .sponge:                                   return 0xFFCBCC49    // (203, 204, 073)

            // Plants
            case .cactus:                                   return 0xFF5A8A2A    // (090, 138, 042)
            case .reeds:                                    return nil
            case .wheat:                                    return 0xFF // 0, 123, 0
            case .pumpkinStem:                              return 0xFF // 72, 65, 9
            case .melonStem:                                return 0xFF // 72, 65, 9
            case .beetroot:                                 return 0xFF // 0, 106, 0
            case .cocoa:                                    return 0xFF // 109, 112, 52
            case .vine:                                     return 0xFF // 67, 97, 26
            case .torchflowerCrop:                          return Self.DefaultColor.torchFlower.argb
            case .pitcherCrop:                              return Self.DefaultColor.pitcher.argb
            case .potatoes:                                 return 0xFF // 0, 106, 0
            case .carrots:                                  return 0xFF // 0, 106, 0
            case .melonBlock:                               return 0xFF7DCA19    // (125, 202, 025)
            case .pumpkin:                                  return 0xFFD57D32    // (213, 125, 050)
            case .carvedPumpkin:                            return 0xFFD57D32    // (213, 125, 050)
            case .litPumpkin:                               return 0xFFD57D32    // (213, 125, 050)
            case .sweetBerryBush:                           return 0xFF // 40, 97, 63
            case .caveVines:                                return 0xFF // 106, 126, 48
            case .caveVinesHeadWithBerries:                 return 0xFF // 106, 126, 48
            case .caveVinesBodyWithBerries:                 return 0xFF // 106, 126, 48
            case .bamboo:                                   return 0xFF // 67, 103, 8
            case .brownMushroom:                            return 0xFF // 0, 123, 0
            case .redMushroom:                              return 0xFF // 0, 123, 0

            case .brownMushroomBlock:                       return 0xFF957150    // (149, 113, 080)
            case .redMushroomBlock:                         return 0xFFC72A29    // (199, 042, 041)

            case .deadbush:                                 return 0xFF // 146, 99, 40
            case .tallgrass:                                return 0xFF // 109, 141, 35
            case .doublePlant:                              return 0xFF // 109, 141, 35
            case .yellowFlower:                             return nil
            case .redFlower:                                return nil
            case .pitcherPlant:                             return Self.DefaultColor.pitcher.argb
            case .pinkPetals:                               return Self.DefaultColor.cheryLeaves.argb
            case .witherRose:                               return 0xFF // 23, 18, 16
            case .torchflower:                              return Self.DefaultColor.torchFlower.argb

            case .waterlily:                                return 0xFF // 0, 123, 0
            case .seagrass:                                 return 0xFF // 55, 55, 220
            case .kelp:                                     return 0xFF // 55, 55, 220
            case .driedKelpBlock:                           return 0xFF // 88, 109, 44

            // Ocean Biome
            case .bubbleColumn:                             return 0xFF // 55, 55, 220
            case .seaPickle:                                return 0xFF // 106, 113, 42
            case .seaLantern:                               return 0xFFFCF9F2    // (252, 249, 242)
            case .conduit:                                  return 0xFF // 126, 113, 81

            // Snow Biome
            case .snow:                                     return 0xFFFCFCFC    // (252, 252, 252)
            case .snowLayer:                                return 0xFFE5E5E5    // (229, 229, 229)
            case .powderSnow:                               return 0xFFFCFCFC    // (252, 252, 252)
            case .ice:                                      return 0xFF9E9EFC    // (158, 158, 252)
            case .blueIce:                                  return 0xFF6697F6    // (102, 151, 246)
            case .packedIce:                                return 0xFF9E9EFC    // (158, 158, 252)
            case .frostedIce:                               return 0xFF6D92C1    // (109, 146, 193)

            // Caves & Cliffs
            case .glowLichen:                               return 0xFF // 109, 144, 129
            case .dripstoneBlock:                           return 0xFF8C7461    // (140, 116, 097)
            case .pointedDripstone:                         return 0xFF8C7461    // (140, 116, 097)
            case .mossBlock:                                return 0xFF6F902C    // (111, 144, 044)
            case .mossCarpet:                               return 0xFF6F902C    // (111, 144, 044)
            case .dirtWithRoots:                            return 0xFF956C4C    // (149, 108, 076)
            case .hangingRoots:                             return 0xFF // 0, 106, 0
            case .bigDripleaf:                              return 0xFF // 0, 106, 0
            case .smallDripleafBlock:                       return 0xFF // 0, 106, 0
            case .sporeBlossom:                             return 0xFF // 184, 97, 204
            case .azalea:                                   return 0xFF6F902C    // (111, 144, 044)
            case .floweringAzalea:                          return 0xFFB861CC    // (184, 097, 204)
            case .amethystBlock:                            return 0xFF9168AE    // (145, 104, 174)
            case .buddingAmethyst:                          return 0xFF9168AE    // (145, 104, 174)
            case .amethystCluster:                          return 0x7A9168AE    // (145, 104, 174)
            case .largeAmethystBud:                         return 0x5A9168AE    // (145, 104, 174)
            case .mediumAmethystBud:                        return 0x3A9168AE    // (145, 104, 174)
            case .smallAmethystBud:                         return 0x1A9168AE    // (145, 104, 174)
            case .tuff:                                     return Self.DefaultColor.normalStone.argb
            case .calcite:                                  return Self.DefaultColor.diorite.argb

            // Mangrove Swamp Biome
            case .mud:                                      return 0xFF39373C    // (057, 055, 060)
            case .muddyMangroveRoots:                       return 0xFF39373C    // (057, 055, 060)
            case .mangroveRoots:                            return 0xFF59472B    // (089, 071, 043)

            // Deep Dark Biome
            case .reinforcedDeepslate:                      return Self.DefaultColor.deepslate.argb
            case .sculkSensor:                              return Self.DefaultColor.sculkSensor.argb
            case .sculk:                                    return Self.DefaultColor.sculk.argb
            case .sculkVein:                                return 0xFF // 11, 15, 19
            case .sculkCatalyst:                            return Self.DefaultColor.sculk.argb
            case .sculkShrieker:                            return Self.DefaultColor.sculk.argb
            case .calibratedSculkSensor:                    return Self.DefaultColor.sculkSensor.argb

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
            case .soulFire:                                 return 0xFF // 123, 239, 242
            case .magma:                                    return 0xFFB54009    // (181, 064, 009)
            case .glowstone:                                return 0xFFF8D773    // (248, 215, 115)

            // Plants
            case .netherWart:                               return 0xFF // 163, 35, 41
            case .crimsonRoots:                             return 0xFF // 171, 16, 28
            case .warpedRoots:                              return 0xFF // 20, 178, 131
            case .netherSprouts:                            return 0xFF // 20, 178, 131
            case .weepingVines:                             return 0xFF // 171, 16, 28
            case .twistingVines:                            return 0xFF // 20, 178, 131
            case .crimsonFungus:                            return 0xFF // 162, 36, 40
            case .warpedFungus:                             return 0xFF // 20, 178, 131

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

            case .copperBlock:                              return Self.DefaultColor.copper.argb
            case .exposedCopper:                            return Self.DefaultColor.exposedCopper.argb
            case .oxidizedCopper:                           return Self.DefaultColor.oxidizedCopper.argb
            case .weatheredCopper:                          return Self.DefaultColor.weatheredCopper.argb

            case .cutCopper:                                return Self.DefaultColor.copper.argb
            case .exposedCutCopper:                         return Self.DefaultColor.exposedCopper.argb
            case .oxidizedCutCopper:                        return Self.DefaultColor.oxidizedCopper.argb
            case .weatheredCutCopper:                       return Self.DefaultColor.weatheredCopper.argb

            case .waxedCopper:                              return Self.DefaultColor.copper.argb
            case .waxedExposedCopper:                       return Self.DefaultColor.exposedCopper.argb
            case .waxedOxidizedCopper:                      return Self.DefaultColor.oxidizedCopper.argb
            case .waxedWeatheredCopper:                     return Self.DefaultColor.weatheredCopper.argb

            case .waxedCutCopper:                           return Self.DefaultColor.copper.argb
            case .waxedExposedCutCopper:                    return Self.DefaultColor.exposedCopper.argb
            case .waxedOxidizedCutCopper:                   return Self.DefaultColor.oxidizedCopper.argb
            case .waxedWeatheredCutCopper:                  return Self.DefaultColor.weatheredCopper.argb

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

            case .smoothStone:                              return 0xFF // 96, 96, 96
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
            case .oakLog:                                   return Self.DefaultColor.oakLog.argb
            case .spruceLog:                                return Self.DefaultColor.spruceLog.argb
            case .birchLog:                                 return Self.DefaultColor.birchLog.argb
            case .jungleLog:                                return Self.DefaultColor.jungleLog.argb
            case .acaciaLog:                                return Self.DefaultColor.acaciaLog.argb
            case .darkOakLog:                               return Self.DefaultColor.darkOakLog.argb
            case .mangroveLog:                              return Self.DefaultColor.mangroveLog.argb
            case .cherryLog:                                return Self.DefaultColor.cherryLog.argb
            case .crimsonStem:                              return Self.DefaultColor.crimsonPlanks.argb
            case .warpedStem:                               return Self.DefaultColor.warpedPlanks.argb

            case .strippedOakLog:                           return 0xFF947340    // (148, 115, 064)
            case .strippedSpruceLog:                        return 0xFF785A36    // (120, 090, 054)
            case .strippedBirchLog:                         return 0xFFCDBA7E    // (205, 186, 126)
            case .strippedJungleLog:                        return 0xFFAD7E52    // (173, 126, 082)
            case .strippedAcaciaLog:                        return 0xFFB86237    // (184, 098, 055)
            case .strippedDarkOakLog:                       return 0xFF6B5333    // (107, 083, 051)
            case .strippedMangroveLog:                      return 0xFF894C39    // (137, 076, 057)
            case .strippedCherryLog:                        return 0xFF // (214, 146, 151)
            case .strippedCrimsonStem:                      return 0xFF943D61    // (148, 061, 097)
            case .strippedWarpedStem:                       return 0xFF439F9D    // (067, 159, 157)

            case .oakWood:                                  return Self.DefaultColor.oakLog.argb
            case .spruceWood:                               return Self.DefaultColor.spruceLog.argb
            case .birchWood:                                return Self.DefaultColor.birchLog.argb
            case .jungleWood:                               return Self.DefaultColor.jungleLog.argb
            case .acaciaWood:                               return Self.DefaultColor.acaciaLog.argb
            case .darkOakWood:                              return Self.DefaultColor.darkOakLog.argb
            case .mangroveWood:                             return Self.DefaultColor.mangroveLog.argb
            case .cherryWood:                               return Self.DefaultColor.cherryLog.argb
            case .bambooBlock:                              return 0xFF // 127, 132, 56
            case .crimsonHyphae:                            return 0xFF941515    // (148, 021, 021)
            case .warpedHyphae:                             return 0xFF16605A    // (022, 096, 090)

            case .strippedOakWood:                          return 0xFF // 127, 85, 48
            case .strippedSpruceWood:                       return 0xFF // 120, 90, 54
            case .strippedBirchWood:                        return 0xFF // 205, 186, 126
            case .strippedJungleWood:                       return 0xFF // 173, 126, 82
            case .strippedAcaciaWood:                       return 0xFF // 185, 94, 61
            case .strippedDarkOakWood:                      return 0xFF // 107, 83, 51
            case .strippedMangroveWood:                     return Self.DefaultColor.mangrovePlanks.argb
            case .strippedCherryWood:                       return 0xFF // (214, 146, 151)
            case .strippedBambooBlock:                      return Self.DefaultColor.bambooPlanks.argb
            case .strippedCrimsonHyphae:                    return 0xFF943D61    // (148, 061, 097)
            case .strippedWarpedHyphae:                     return 0xFF439F9D    // (067, 159, 157)

            case .oakPlanks:                                return Self.DefaultColor.oakPlanks.argb
            case .sprucePlanks:                             return Self.DefaultColor.sprucePlanks.argb
            case .birchPlanks:                              return Self.DefaultColor.birchPlanks.argb
            case .junglePlanks:                             return Self.DefaultColor.junglePlanks.argb
            case .acaciaPlanks:                             return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakPlanks:                            return Self.DefaultColor.darkOakPlanks.argb
            case .mangrovePlanks:                           return Self.DefaultColor.mangrovePlanks.argb
            case .cherryPlanks:                             return Self.DefaultColor.cherryPlanks.argb
            case .bambooPlanks:                             return Self.DefaultColor.bambooPlanks.argb
            case .bambooMosaic:                             return Self.DefaultColor.bambooPlanks.argb
            case .crimsonPlanks:                            return Self.DefaultColor.crimsonPlanks.argb
            case .warpedPlanks:                             return Self.DefaultColor.warpedPlanks.argb

            case .oakLeaves:                                return 0xFF // 56, 95, 31
            case .spruceLeaves:                             return 0xFF // 56, 95, 31
            case .birchLeaves:                              return 0xFF // 67, 124, 37
            case .jungleLeaves:                             return 0xFF // 56, 95, 31
            case .acaciaLeaves:                             return 0xFF // 63, 89, 25
            case .darkOakLeaves:                            return 0xFF // 58, 82, 23
            case .mangroveLeaves:                           return 0xFF3B4910    // (059, 073, 016)
            case .cherryLeaves:                             return 0xFF // 243, 159, 209
            case .azaleaLeaves:                             return 0xFF6F902C    // (111, 144, 044)
            case .azaleaLeavesFlowered:                     return 0xFFB861CC    // (184, 097, 204)

            case .oakSapling:                               return 0xFF // 63, 141, 46
            case .spruceSapling:                            return 0xFF // 34, 52, 34
            case .birchSapling:                             return 0xFF // 107, 156, 55
            case .jungleSapling:                            return 0xFF // 41, 73, 12
            case .acaciaSapling:                            return 0xFF // 125, 150, 33
            case .darkOakSapling:                           return 0xFF // 31, 100, 25
            case .mangrovePropagule:                        return 0xFF // 0, 106, 0
            case .cherrySapling:                            return 0xFF // 243, 159, 209
            case .bambooSapling:                            return 0xFF // 67, 103, 8

            /* ---------- ---------- ---------- Fences & Gates ---------- ---------- ---------- */
            case .oakFence:                                 return Self.DefaultColor.oakPlanks.argb
            case .spruceFence:                              return Self.DefaultColor.sprucePlanks.argb
            case .birchFence:                               return Self.DefaultColor.birchPlanks.argb
            case .jungleFence:                              return Self.DefaultColor.junglePlanks.argb
            case .acaciaFence:                              return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakFence:                             return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveFence:                            return Self.DefaultColor.mangrovePlanks.argb
            case .cherryFence:                              return Self.DefaultColor.cherryPlanks.argb
            case .bambooFence:                              return Self.DefaultColor.bambooPlanks.argb
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
            case .cherryFenceGate:                          return Self.DefaultColor.cherryPlanks.argb
            case .bambooFenceGate:                          return Self.DefaultColor.bambooPlanks.argb
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

            case .mudBrickWall:                             return Self.DefaultColor.mudBricks.argb

            /* ---------- ---------- ---------- Stairs ---------- ---------- ---------- */
            case .oakStairs:                                return Self.DefaultColor.oakPlanks.argb
            case .spruceStairs:                             return Self.DefaultColor.sprucePlanks.argb
            case .birchStairs:                              return Self.DefaultColor.birchPlanks.argb
            case .jungleStairs:                             return Self.DefaultColor.junglePlanks.argb
            case .acaciaStairs:                             return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakStairs:                            return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveStairs:                           return Self.DefaultColor.mangrovePlanks.argb
            case .cherryStairs:                             return Self.DefaultColor.cherryPlanks.argb
            case .bambooStairs:                             return Self.DefaultColor.bambooPlanks.argb
            case .bambooMosaicStairs:                       return Self.DefaultColor.bambooPlanks.argb
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
            case .mudBrickStairs:                           return Self.DefaultColor.mudBricks.argb

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
            case .cherrySlab:                               return Self.DefaultColor.cherryPlanks.argb
            case .bambooSlab:                               return Self.DefaultColor.bambooPlanks.argb
            case .bambooMosaicSlab:                         return Self.DefaultColor.bambooPlanks.argb
            case .crimsonSlab:                              return Self.DefaultColor.crimsonPlanks.argb
            case .warpedSlab:                               return Self.DefaultColor.warpedPlanks.argb

            case .oakDoubleSlab:                            return Self.DefaultColor.oakPlanks.argb
            case .spruceDoubleSlab:                         return Self.DefaultColor.sprucePlanks.argb
            case .birchDoubleSlab:                          return Self.DefaultColor.birchPlanks.argb
            case .jungleDoubleSlab:                         return Self.DefaultColor.junglePlanks.argb
            case .acaciaDoubleSlab:                         return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakDoubleSlab:                        return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveDoubleSlab:                       return Self.DefaultColor.mangrovePlanks.argb
            case .cherryDoubleSlab:                         return Self.DefaultColor.cherryPlanks.argb
            case .bambooDoubleSlab:                         return Self.DefaultColor.bambooPlanks.argb
            case .bambooMosaicDoubleSlab:                   return Self.DefaultColor.bambooPlanks.argb
            case .crimsonDoubleSlab:                        return Self.DefaultColor.crimsonPlanks.argb
            case .warpedDoubleSlab:                         return Self.DefaultColor.warpedPlanks.argb

            case .smoothStoneSlab:                          return Self.DefaultColor.normalStone.argb
            case .cobblestoneSlab:                          return Self.DefaultColor.normalStone.argb
            case .stoneBrickSlab:                           return Self.DefaultColor.normalStone.argb
            case .sandstoneSlab:                            return Self.DefaultColor.sand.argb
            case .redBrickSlab:                             return Self.DefaultColor.redBricks.argb
            case .netherBrickSlab:                          return Self.DefaultColor.netherBricks.argb
            case .quartzSlab:                               return Self.DefaultColor.quartz.argb
            case .smoothStoneDoubleSlab:                    return Self.DefaultColor.normalStone.argb
            case .cobblestoneDoubleSlab:                    return Self.DefaultColor.normalStone.argb
            case .stoneBrickDoubleSlab:                     return Self.DefaultColor.normalStone.argb
            case .sandstoneDoubleSlab:                      return Self.DefaultColor.sand.argb
            case .redBrickDoubleSlab:                       return Self.DefaultColor.redBricks.argb
            case .netherBrickDoubleSlab:                    return Self.DefaultColor.netherBricks.argb
            case .quartzDoubleSlab:                         return Self.DefaultColor.quartz.argb

            case .mossyCobblestoneSlab:                     return Self.DefaultColor.mossyStone.argb
            case .smoothSandstoneSlab:                      return Self.DefaultColor.sand.argb
            case .redSandstoneSlab:                         return Self.DefaultColor.redSand.argb
            case .redNetherBrickSlab:                       return Self.DefaultColor.redNetherBricks.argb
            case .purpurSlab:                               return Self.DefaultColor.endPurple.argb
            case .prismarineRoughSlab:                      return Self.DefaultColor.prismarineNormal.argb
            case .prismarineDarkSlab:                       return Self.DefaultColor.prismarineDark.argb
            case .prismarineBrickSlab:                      return 0xFF // 89, 173, 162
            case .mossyCobblestoneDoubleSlab:               return Self.DefaultColor.mossyStone.argb
            case .smoothSandstoneDoubleSlab:                return Self.DefaultColor.sand.argb
            case .redSandstoneDoubleSlab:                   return Self.DefaultColor.redSand.argb
            case .redNetherBrickDoubleSlab:                 return Self.DefaultColor.redNetherBricks.argb
            case .purpurDoubleSlab:                         return Self.DefaultColor.endPurple.argb
            case .prismarineRoughDoubleSlab:                return Self.DefaultColor.prismarineNormal.argb
            case .prismarineDarkDoubleSlab:                 return Self.DefaultColor.prismarineDark.argb
            case .prismarineBrickDoubleSlab:                return 0xFF // 89, 173, 162

            case .smoothRedSandstoneSlab:                   return Self.DefaultColor.redSand.argb
            case .graniteSlab:                              return Self.DefaultColor.granite.argb
            case .dioriteSlab:                              return Self.DefaultColor.diorite.argb
            case .andesiteSlab:                             return Self.DefaultColor.andesite.argb
            case .polishedGraniteSlab:                      return Self.DefaultColor.granite.argb
            case .polishedDioriteSlab:                      return Self.DefaultColor.diorite.argb
            case .polishedAndesiteSlab:                     return Self.DefaultColor.andesite.argb
            case .endStoneBrickSlab:                        return Self.DefaultColor.endBricks.argb
            case .smoothRedSandstoneDoubleSlab:             return Self.DefaultColor.redSand.argb
            case .graniteDoubleSlab:                        return Self.DefaultColor.granite.argb
            case .dioriteDoubleSlab:                        return Self.DefaultColor.diorite.argb
            case .andesiteDoubleSlab:                       return Self.DefaultColor.andesite.argb
            case .polishedGraniteDoubleSlab:                return Self.DefaultColor.granite.argb
            case .polishedDioriteDoubleSlab:                return Self.DefaultColor.diorite.argb
            case .polishedAndesiteDoubleSlab:               return Self.DefaultColor.andesite.argb
            case .endStoneBrickDoubleSlab:                  return Self.DefaultColor.endBricks.argb

            case .stoneSlab:                                return Self.DefaultColor.normalStone.argb
            case .mossyStoneBrickSlab:                      return Self.DefaultColor.mossyStone.argb
            case .cutSandstoneSlab:                         return Self.DefaultColor.sand.argb
            case .cutRedSandstoneSlab:                      return Self.DefaultColor.redSand.argb
            case .smoothQuartzSlab:                         return Self.DefaultColor.quartz.argb
            case .stoneDoubleSlab:                          return Self.DefaultColor.normalStone.argb
            case .mossyStoneBrickDoubleSlab:                return Self.DefaultColor.mossyStone.argb
            case .cutSandstoneDoubleSlab:                   return Self.DefaultColor.sand.argb
            case .cutRedSandstoneDoubleSlab:                return Self.DefaultColor.redSand.argb
            case .smoothQuartzDoubleSlab:                   return Self.DefaultColor.quartz.argb

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

            case .mudBrickSlab:                             return Self.DefaultColor.mudBricks.argb
            case .mudBrickDoubleSlab:                       return Self.DefaultColor.mudBricks.argb

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
            case .oakStandingSign:                          return Self.DefaultColor.oakPlanks.argb
            case .spruceStandingSign:                       return Self.DefaultColor.sprucePlanks.argb
            case .birchStandingSign:                        return Self.DefaultColor.birchPlanks.argb
            case .acaciaStandingSign:                       return Self.DefaultColor.acaciaPlanks.argb
            case .jungleStandingSign:                       return Self.DefaultColor.junglePlanks.argb
            case .darkoakStandingSign:                      return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveStandingSign:                     return Self.DefaultColor.mangrovePlanks.argb
            case .cherryStandingSign:                       return Self.DefaultColor.cherryPlanks.argb
            case .bambooStandingSign:                       return Self.DefaultColor.bambooPlanks.argb
            case .crimsonStandingSign:                      return Self.DefaultColor.crimsonPlanks.argb
            case .warpedStandingSign:                       return Self.DefaultColor.warpedPlanks.argb

            case .oakHangingSign:                           return Self.DefaultColor.oakPlanks.argb
            case .spruceHangingSign:                        return Self.DefaultColor.sprucePlanks.argb
            case .birchHangingSign:                         return Self.DefaultColor.birchPlanks.argb
            case .jungleHangingSign:                        return Self.DefaultColor.junglePlanks.argb
            case .acaciaHangingSign:                        return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakHangingSign:                       return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveHangingSign:                      return Self.DefaultColor.mangrovePlanks.argb
            case .cherryHangingSign:                        return Self.DefaultColor.cherryPlanks.argb
            case .bambooHangingSign:                        return Self.DefaultColor.bambooPlanks.argb
            case .crimsonHangingSign:                       return Self.DefaultColor.crimsonPlanks.argb
            case .warpedHangingSign:                        return Self.DefaultColor.warpedPlanks.argb

            case .oakWallSign:                              return Self.DefaultColor.oakPlanks.argb
            case .spruceWallSign:                           return Self.DefaultColor.sprucePlanks.argb
            case .birchWallSign:                            return Self.DefaultColor.birchPlanks.argb
            case .jungleWallSign:                           return Self.DefaultColor.junglePlanks.argb
            case .acaciaWallSign:                           return Self.DefaultColor.acaciaPlanks.argb
            case .darkoakWallSign:                          return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveWallSign:                         return Self.DefaultColor.mangrovePlanks.argb
            case .cherryWallSign:                           return Self.DefaultColor.cherryPlanks.argb
            case .bambooWallSign:                           return Self.DefaultColor.bambooPlanks.argb
            case .crimsonWallSign:                          return Self.DefaultColor.crimsonPlanks.argb
            case .warpedWallSign:                           return Self.DefaultColor.warpedPlanks.argb

            /* ---------- ---------- ---------- Doors & Trapdoors ---------- ---------- ---------- */
            case .oakDoor:                                  return Self.DefaultColor.oakPlanks.argb
            case .spruceDoor:                               return Self.DefaultColor.sprucePlanks.argb
            case .birchDoor:                                return Self.DefaultColor.birchPlanks.argb
            case .jungleDoor:                               return Self.DefaultColor.junglePlanks.argb
            case .acaciaDoor:                               return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakDoor:                              return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveDoor:                             return Self.DefaultColor.mangrovePlanks.argb
            case .cherryDoor:                               return Self.DefaultColor.cherryPlanks.argb
            case .bambooDoor:                               return Self.DefaultColor.bambooPlanks.argb
            case .crimsonDoor:                              return Self.DefaultColor.crimsonPlanks.argb
            case .warpedDoor:                               return Self.DefaultColor.warpedPlanks.argb
            case .ironDoor:                                 return 0xFF // 227, 227, 227

            case .oakTrapdoor:                              return Self.DefaultColor.oakPlanks.argb
            case .spruceTrapdoor:                           return Self.DefaultColor.sprucePlanks.argb
            case .birchTrapdoor:                            return Self.DefaultColor.birchPlanks.argb
            case .jungleTrapdoor:                           return Self.DefaultColor.junglePlanks.argb
            case .acaciaTrapdoor:                           return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakTrapdoor:                          return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveTrapdoor:                         return Self.DefaultColor.mangrovePlanks.argb
            case .cherryTrapdoor:                           return Self.DefaultColor.cherryPlanks.argb
            case .bambooTrapdoor:                           return Self.DefaultColor.bambooPlanks.argb
            case .crimsonTrapdoor:                          return Self.DefaultColor.crimsonPlanks.argb
            case .warpedTrapdoor:                           return Self.DefaultColor.warpedPlanks.argb
            case .ironTrapdoor:                             return 0xFF // 227, 227, 227

            /* ---------- ---------- ---------- Village Blocks ---------- ---------- ---------- */
            case .ironBars:                                 return 0xFF // 154, 154, 154
            case .ladder:                                   return 0xFF // 79, 79, 79
            case .scaffolding:                              return 0xFFE1C473    // (225, 196, 115)
            case .honeycombBlock:                           return 0xFFE58A08    // (229, 138, 008)
            case .lodestone:                                return 0xFFA0A2AA    // (160, 162, 170)
            case .hayBlock:                                 return 0xFFCBB007    // (203, 176, 007)

            case .torch:                                    return 0xFF // 79, 79, 79
            case .soulTorch:                                return 0xFF // 123, 239, 242
            case .lantern:                                  return 0xFF484F64    // (072, 079, 100)
            case .soulLantern:                              return 0xFF // 123, 239, 242
            case .campfire:                                 return 0xFF // 199, 107, 3
            case .soulCampfire:                             return 0xFF // 123, 239, 242

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
            case .brewingStand:                             return 0xFF // 47, 47, 47
            case .anvil:                                    return Self.DefaultColor.anvil.argb
            case .grindstone:                               return 0xFF8D8D8D    // (141, 141, 141)
            case .enchantingTable:                          return 0xFF49EACF    // (073, 234, 207)
            case .bookshelf:                                return 0xFFC09B61    // (192, 155, 097)
            case .chiseledBookshelf:                        return Self.DefaultColor.bookshelf.argb
            case .lectern:                                  return 0xFFA48049    // (164, 128, 073)
            case .composter:                                return 0xFF8B5B31    // (139, 091, 049)

            case .emptyCauldron:                            return 0xFF353434    // (053, 052, 052)
            case .waterCauldron:                            return 0xFF //  // (53, 52, 52)
            case .lavaCauldron:                             return 0xFF //  // (53, 52, 52)
            case .powerSnowCauldron:                        return 0xFF //  // (53, 52, 52)

            case .chest:                                    return Self.DefaultColor.chest.argb
            case .trappedChest:                             return Self.DefaultColor.chest.argb
            case .enderChest:                               return 0xFF273638    // (039, 054, 056)
            case .barrel:                                   return 0xFF89663C    // (137, 102, 060)

            case .noteblock:                                return 0xFF925C40    // (146, 092, 064)
            case .jukebox:                                  return 0xFF7A4F38    // (122, 079, 056)
            case .frame:                                    return nil
            case .glowFrame:                                return nil
            case .flowerPot:                                return Self.DefaultColor.potter.argb
            case .beacon:                                   return 0xFF48D2CA    // (072, 210, 202)
            case .bell:                                     return 0xFFFAD338    // (250, 211, 056)
            case .stonecutterBlock:                         return Self.DefaultColor.furnace.argb
            case .loom:                                     return 0xFFC8A470    // (200, 164, 112)
            case .decoratedPot:                             return Self.DefaultColor.potter.argb
            case .chain:                                    return 0xFF // 60, 65, 80
            case .endRod:                                   return 0xFF // 79, 79, 79
            case .lightningRod:                             return 0xFF // 186, 109, 44

            case .skull:                                    return 0xFF // 
            case .rail:                                     return Self.DefaultColor.rail.argb
            case .goldenRail:                               return Self.DefaultColor.rail.argb
            case .detectorRail:                             return Self.DefaultColor.rail.argb
            case .activatorRail:                            return Self.DefaultColor.rail.argb

            /* ---------- ---------- ---------- Tech Blocks ---------- ---------- ---------- */
            case .commandBlock:                             return 0xFFC47D4E    // (196, 125, 078)
            case .repeatingCommandBlock:                    return 0xFF694EC5    // (105, 078, 197)
            case .chainCommandBlock:                        return 0xFF9FC1B2    // (159, 193, 178)
            case .structureBlock:                           return 0xFF937894    // (147, 120, 148)
            case .structureVoid:                            return 0xFF // 
            case .movingBlock:                              return 0xFF // 
            case .lightBlock:                               return 0xFF // 
            case .barrier:                                  return 0xFF // 
            case .jigsaw:                                   return 0xFF // 147, 120, 148

            case .woodenButton:                             return Self.DefaultColor.oakPlanks.argb
            case .spruceButton:                             return Self.DefaultColor.sprucePlanks.argb
            case .birchButton:                              return Self.DefaultColor.birchPlanks.argb
            case .jungleButton:                             return Self.DefaultColor.junglePlanks.argb
            case .acaciaButton:                             return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakButton:                            return Self.DefaultColor.darkOakPlanks.argb
            case .mangroveButton:                           return Self.DefaultColor.mangrovePlanks.argb
            case .cherryButton:                             return Self.DefaultColor.cherryPlanks.argb
            case .bambooButton:                             return Self.DefaultColor.bambooPlanks.argb
            case .crimsonButton:                            return Self.DefaultColor.crimsonPlanks.argb
            case .warpedButton:                             return Self.DefaultColor.warpedPlanks.argb
            case .stoneButton:                              return Self.DefaultColor.normalStone.argb
            case .polishedBlackstoneButton:                 return Self.DefaultColor.polishedBlackStone.argb

            case .woodenPressurePlate:                      return Self.DefaultColor.oakPlanks.argb
            case .sprucePressurePlate:                      return Self.DefaultColor.sprucePlanks.argb
            case .birchPressurePlate:                       return Self.DefaultColor.birchPlanks.argb
            case .junglePressurePlate:                      return Self.DefaultColor.junglePlanks.argb
            case .acaciaPressurePlate:                      return Self.DefaultColor.acaciaPlanks.argb
            case .darkOakPressurePlate:                     return Self.DefaultColor.darkOakPlanks.argb
            case .mangrovePressurePlate:                    return Self.DefaultColor.mangrovePlanks.argb
            case .cherryPressurePlate:                      return Self.DefaultColor.cherryPlanks.argb
            case .bambooPressurePlate:                      return Self.DefaultColor.bambooPlanks.argb
            case .crimsonPressurePlate:                     return Self.DefaultColor.crimsonPlanks.argb
            case .warpedPressurePlate:                      return Self.DefaultColor.warpedPlanks.argb
            case .stonePressurePlate:                       return Self.DefaultColor.normalStone.argb
            case .lightWeightedPressurePlate:               return 0xFF // 202, 171, 50
            case .heavyWeightedPressurePlate:               return 0xFF // 182, 182, 182
            case .polishedBlackstonePressurePlate:          return Self.DefaultColor.polishedBlackStone.argb

            case .redstoneWire:                             return 0xFF // 75, 1, 0
            case .redstoneTorch:                            return 0xFF // 
            case .unlitRedstoneTorch:                       return 0xFF // 
            case .lever:                                    return 0xFF // 134, 133, 134
            case .tripwireHook:                             return 0xFF // 135, 135, 135
            case .tripWire:                                 return 0xFF // 
            case .redstoneLamp:                             return 0xFFAD683A    // (173, 104, 058)
            case .litRedstoneLamp:                          return 0xFFF8D773    // (248, 215, 115)
            case .observer:                                 return 0xFF646464    // (100, 100, 100)
            case .daylightDetector:                         return 0xFFBCA88C    // (188, 168, 140)
            case .daylightDetectorInverted:                 return 0xFFBCA88C    // (188, 168, 140)
            case .poweredRepeater:                          return 0xFF // 185, 185, 185
            case .unpoweredRepeater:                        return 0xFF // 185, 185, 185
            case .poweredComparator:                        return 0xFF // 185, 185, 185
            case .unpoweredComparator:                      return 0xFF // 185, 185, 185
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
            case .bed:                                      return 0xFF // 247, 247, 247
            case .standingBanner:                           return 0xFF // 
            case .wallBanner:                               return 0xFF // 

            case .tintedGlass:                              return 0xFF // 
            case .glass:                                    return 0x11FFFFFF

            case .glassPane:                                return 0xFF // 
            case .whiteStainedGlass:                        return 0xFF // 
            case .lightGrayStainedGlass:                    return 0xFF // 
            case .grayStainedGlass:                         return 0xFF // 
            case .blackStainedGlass:                        return 0xFF // 21, 21, 21
            case .brownStainedGlass:                        return 0xFF // 
            case .redStainedGlass:                          return 0xFF // 
            case .orangeStainedGlass:                       return 0xFF // 
            case .yellowStainedGlass:                       return 0xFF // 
            case .limeStainedGlass:                         return 0xFF // 
            case .greenStainedGlass:                        return 0xFF // 
            case .cyanStainedGlass:                         return 0xFF // 
            case .lightBlueStainedGlass:                    return 0xFF // 
            case .blueStainedGlass:                         return 0xFF // 
            case .purpleStainedGlass:                       return 0xFF // 
            case .magentaStainedGlass:                      return 0xFF // 
            case .pinkStainedGlass:                         return 0xFF // 

            case .whiteStainedGlassPane:                    return 0xFF // 
            case .lightGrayStainedGlassPane:                return 0xFF // 
            case .grayStainedGlassPane:                     return 0xFF // 
            case .blackStainedGlassPane:                    return 0xFF // 
            case .brownStainedGlassPane:                    return 0xFF // 
            case .redStainedGlassPane:                      return 0xFF // 
            case .orangeStainedGlassPane:                   return 0xFF // 
            case .yellowStainedGlassPane:                   return 0xFF // 
            case .limeStainedGlassPane:                     return 0xFF // 
            case .greenStainedGlassPane:                    return 0xFF // 
            case .cyanStainedGlassPane:                     return 0xFF // 
            case .lightBlueStainedGlassPane:                return 0xFF // 
            case .blueStainedGlassPane:                     return 0xFF // 
            case .purpleStainedGlassPane:                   return 0xFF // 
            case .magentaStainedGlassPane:                  return 0xFF // 
            case .pinkStainedGlassPane:                     return 0xFF // 

            case .undyedShulkerBox:                         return 0xFF956595    // (149, 101, 149)
            case .whiteShulkerBox:                          return 0xFF // 225, 230, 230
            case .lightGrayShulkerBox:                      return 0xFF // 135, 135, 126
            case .grayShulkerBox:                           return 0xFF // 59, 63, 67
            case .blackShulkerBox:                          return 0xFF // 31, 31, 34
            case .brownShulkerBox:                          return 0xFF // 111, 69, 39
            case .redShulkerBox:                            return 0xFF // 152, 35, 33
            case .orangeShulkerBox:                         return 0xFF // 225, 230, 230
            case .yellowShulkerBox:                         return 0xFF // 249, 194, 34
            case .limeShulkerBox:                           return 0xFF // 108, 183, 24
            case .greenShulkerBox:                          return 0xFF // 83, 107, 29
            case .cyanShulkerBox:                           return 0xFF // 22, 133, 144
            case .lightBlueShulkerBox:                      return 0xFF // 57, 177, 215
            case .blueShulkerBox:                           return 0xFF // 49, 52, 152
            case .purpleShulkerBox:                         return 0xFF // 115, 38, 167
            case .magentaShulkerBox:                        return 0xFF // 183, 61, 172
            case .pinkShulkerBox:                           return 0xFF // 239, 135, 166

            // case .wool:                                  return 0xFF // 
            case .whiteWool:                                return 0xFF // 247, 247, 247
            case .lightGrayWool:                            return 0xFF // 151, 151, 145
            case .grayWool:                                 return 0xFF // 70, 78, 81
            case .blackWool:                                return 0xFF // 28, 28, 32
            case .brownWool:                                return 0xFF // 125, 79, 46
            case .redWool:                                  return 0xFF // 170, 42, 36
            case .orangeWool:                               return 0xFF // 244, 122, 25
            case .yellowWool:                               return 0xFF // 249, 206, 47
            case .limeWool:                                 return 0xFF // 123, 193, 27
            case .greenWool:                                return 0xFF // 91, 119, 22
            case .cyanWool:                                 return 0xFF // 22, 153, 154
            case .lightBlueWool:                            return 0xFF // 65, 186, 220
            case .blueWool:                                 return 0xFF // 57, 63, 164
            case .purpleWool:                               return 0xFF // 132, 47, 179
            case .magentaWool:                              return 0xFF // 193, 73, 183
            case .pinkWool:                                 return 0xFF // 241, 160, 186

            // case .carpet:                                return 0xFF // 
            case .whiteCarpet:                              return 0xFF // 247, 247, 247
            case .lightGrayCarpet:                          return 0xFF // 151, 151, 145
            case .grayCarpet:                               return 0xFF // 70, 78, 81
            case .blackCarpet:                              return 0xFF // 28, 28, 32
            case .brownCarpet:                              return 0xFF // 125, 79, 46
            case .redCarpet:                                return 0xFF // 170, 42, 36
            case .orangeCarpet:                             return 0xFF // 244, 122, 25
            case .yellowCarpet:                             return 0xFF // 249, 206, 47
            case .limeCarpet:                               return 0xFF // 123, 193, 27
            case .greenCarpet:                              return 0xFF // 91, 119, 22
            case .cyanCarpet:                               return 0xFF // 22, 153, 154
            case .lightBlueCarpet:                          return 0xFF // 65, 186, 220
            case .blueCarpet:                               return 0xFF // 57, 63, 164
            case .purpleCarpet:                             return 0xFF // 132, 47, 179
            case .magentaCarpet:                            return 0xFF // 193, 73, 183
            case .pinkCarpet:                               return 0xFF // 241, 160, 186

            case .candle:                                   return 0xFF // 
            case .whiteCandle:                              return 0xFF // 
            case .lightGrayCandle:                          return 0xFF // 
            case .grayCandle:                               return 0xFF // 
            case .blackCandle:                              return 0xFF // 
            case .brownCandle:                              return 0xFF // 
            case .redCandle:                                return 0xFF // 
            case .orangeCandle:                             return 0xFF // 
            case .yellowCandle:                             return 0xFF // 
            case .limeCandle:                               return 0xFF // 
            case .greenCandle:                              return 0xFF // 
            case .cyanCandle:                               return 0xFF // 
            case .lightBlueCandle:                          return 0xFF // 
            case .blueCandle:                               return 0xFF // 
            case .purpleCandle:                             return 0xFF // 
            case .magentaCandle:                            return 0xFF // 
            case .pinkCandle:                               return 0xFF // 

            case .cake:                                     return 0xFF // 238, 229, 203
            case .candleCake:                               return 0xFF // 238, 229, 203
            case .whiteCandleCake:                          return 0xFF // 238, 229, 203
            case .lightGrayCandleCake:                      return 0xFF // 238, 229, 203
            case .grayCandleCake:                           return 0xFF // 238, 229, 203
            case .blackCandleCake:                          return 0xFF // 238, 229, 203
            case .brownCandleCake:                          return 0xFF // 238, 229, 203
            case .redCandleCake:                            return 0xFF // 238, 229, 203
            case .orangeCandleCake:                         return 0xFF // 238, 229, 203
            case .yellowCandleCake:                         return 0xFF // 238, 229, 203
            case .limeCandleCake:                           return 0xFF // 238, 229, 203
            case .greenCandleCake:                          return 0xFF // 238, 229, 203
            case .cyanCandleCake:                           return 0xFF // 238, 229, 203
            case .lightBlueCandleCake:                      return 0xFF // 238, 229, 203
            case .blueCandleCake:                           return 0xFF // 238, 229, 203
            case .purpleCandleCake:                         return 0xFF // 238, 229, 203
            case .magentaCandleCake:                        return 0xFF // 238, 229, 203
            case .pinkCandleCake:                           return 0xFF // 238, 229, 203

            case .whiteConcretePowder:                      return 0xFF // 222, 223, 224
            case .lightGrayConcretePowder:                  return 0xFF // 154, 154, 148
            case .grayConcretePowder:                       return 0xFF // 75, 79, 82
            case .blackConcretePowder:                      return 0xFF // 22, 24, 29
            case .brownConcretePowder:                      return 0xFF // 120, 81, 50
            case .redConcretePowder:                        return 0xFF // 180, 58, 55
            case .orangeConcretePowder:                     return 0xFF // 230, 128, 20
            case .yellowConcretePowder:                     return 0xFF // 235, 209, 64
            case .limeConcretePowder:                       return 0xFF // 138, 197, 45
            case .greenConcretePowder:                      return 0xFF // 103, 126, 37
            case .cyanConcretePowder:                       return 0xFF // 37, 154, 160
            case .lightBlueConcretePowder:                  return 0xFF // 91, 194, 216
            case .blueConcretePowder:                       return 0xFF // 72, 75, 175
            case .purpleConcretePowder:                     return 0xFF // 138, 58, 186
            case .magentaConcretePowder:                    return 0xFF // 200, 93, 193
            case .pinkConcretePowder:                       return 0xFF // 236, 172, 195

            case .concrete:                                 return 0xFF // 
            case .whiteConcrete:                            return 0xFF // 204, 209, 210
            case .lightGrayConcrete:                        return 0xFF // 125, 125, 115
            case .grayConcrete:                             return 0xFF // 53, 57, 61
            case .blackConcrete:                            return 0xFF // 8, 10, 15
            case .brownConcrete:                            return 0xFF // 95, 58, 31
            case .redConcrete:                              return 0xFF // 138, 32, 32
            case .orangeConcrete:                           return 0xFF // 222, 97, 0
            case .yellowConcrete:                           return 0xFF // 239, 175, 22
            case .limeConcrete:                             return 0xFF // 93, 167, 24
            case .greenConcrete:                            return 0xFF // 72, 90, 35
            case .cyanConcrete:                             return 0xFF // 21, 118, 134
            case .lightBlueConcrete:                        return 0xFF // 37, 136, 198
            case .blueConcrete:                             return 0xFF // 44, 46, 142
            case .purpleConcrete:                           return 0xFF // 99, 32, 154
            case .magentaConcrete:                          return 0xFF // 168, 49, 158
            case .pinkConcrete:                             return 0xFF // 210, 100, 141

            case .clay:                                     return 0xFFA2A6B6    // (162, 166, 182)
            case .hardenedClay:                             return 0xFFA2A6B6    // (162, 166, 182)
            case .whiteStainedHardenedClay:                 return 0xFF // 
            case .lightGrayStainedHardenedClay:             return 0xFF // 
            case .grayStainedHardenedClay:                  return 0xFF // 
            case .blackStainedHardenedClay:                 return 0xFF // 
            case .brownStainedHardenedClay:                 return 0xFF // 
            case .redStainedHardenedClay:                   return 0xFF // 
            case .orangeStainedHardenedClay:                return 0xFF // 
            case .yellowStainedHardenedClay:                return 0xFF // 
            case .limeStainedHardenedClay:                  return 0xFF // 
            case .greenStainedHardenedClay:                 return 0xFF // 
            case .cyanStainedHardenedClay:                  return 0xFF // 
            case .lightBlueStainedHardenedClay:             return 0xFF // 
            case .blueStainedHardenedClay:                  return 0xFF // 
            case .purpleStainedHardenedClay:                return 0xFF // 
            case .magentaStainedHardenedClay:               return 0xFF // 
            case .pinkStainedHardenedClay:                  return 0xFF // 

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

            case .tubeCoralBlock:                           return 0xFF // 48, 78, 218
            case .brainCoralBlock:                          return 0xFF // 225, 125, 183
            case .bubbleCoralBlock:                         return 0xFF // 198, 25, 184
            case .fireCoralBlock:                           return 0xFF // 196, 42, 54
            case .hornCoralBlock:                           return 0xFF // 234, 233, 76
            case .deadTubeCoralBlock:                       return Self.DefaultColor.deadCoral.argb
            case .deadBrainCoralBlock:                      return Self.DefaultColor.deadCoral.argb
            case .deadBubbleCoralBlock:                     return Self.DefaultColor.deadCoral.argb
            case .deadFireCoralBlock:                       return Self.DefaultColor.deadCoral.argb
            case .deadHornCoralBlock:                       return Self.DefaultColor.deadCoral.argb

            case .fireCoral:                                return 0xFF // 48, 78, 218
            case .brainCoral:                               return 0xFF // 225, 125, 183
            case .bubbleCoral:                              return 0xFF // 198, 25, 184
            case .tubeCoral:                                return 0xFF // 196, 42, 54
            case .hornCoral:                                return 0xFF // 234, 233, 76
            case .deadFireCoral:                            return Self.DefaultColor.deadCoral.argb
            case .deadBrainCoral:                           return Self.DefaultColor.deadCoral.argb
            case .deadBubbleCoral:                          return Self.DefaultColor.deadCoral.argb
            case .deadTubeCoral:                            return Self.DefaultColor.deadCoral.argb
            case .deadHornCoral:                            return Self.DefaultColor.deadCoral.argb

            case .tubeCoralFan:                             return 0xFF // 48, 78, 218
            case .brainCoralFan:                            return 0xFF // 225, 125, 183
            case .bubbleCoralFan:                           return 0xFF // 198, 25, 184
            case .fireCoralFan:                             return 0xFF // 196, 42, 54
            case .hornCoralFan:                             return 0xFF // 234, 233, 76

            case .deadTubeCoralFan:                         return Self.DefaultColor.deadCoral.argb
            case .deadBrainCoralFan:                        return Self.DefaultColor.deadCoral.argb
            case .deadBubbleCoralFan:                       return Self.DefaultColor.deadCoral.argb
            case .deadFireCoralFan:                         return Self.DefaultColor.deadCoral.argb
            case .deadHornCoralFan:                         return Self.DefaultColor.deadCoral.argb

            case .tubeCoralHang:                            return 0xFF // 48, 78, 218
            case .brainCoralHang:                           return 0xFF // 225, 125, 183
            case .deadTubeCoralHang:                        return Self.DefaultColor.deadCoral.argb
            case .deadBrainCoralHang:                       return Self.DefaultColor.deadCoral.argb
            case .bubbleCoralHang:                          return 0xFF // 198, 25, 184
            case .fireCoralHang:                            return 0xFF // 196, 42, 54
            case .deadBubbleCoralHang:                      return Self.DefaultColor.deadCoral.argb
            case .deadFireCoralHang:                        return Self.DefaultColor.deadCoral.argb
            case .hornCoralHang:                            return 0xFF // 234, 233, 76
            case .deadHornCoralHang:                        return Self.DefaultColor.deadCoral.argb

            /* ---------- ---------- ---------- Other ---------- ---------- ---------- */
            case .clientRequestPlaceholderBlock:            return 0xFF // 
            case .invisibleBedrock:                         return 0xFF // 
            case .reserved6:                                return 0xFF // 
            case .netherreactor:                            return 0xFF211114    // (033, 017, 020)
            case .glowingobsidian:                          return 0xFF // 
            case .stonecutter:                              return Self.DefaultColor.furnace.argb
            case .infoUpdate:                               return 0xFF // 
            case .infoUpdate2:                              return 0xFF // 
        }
    }
}
