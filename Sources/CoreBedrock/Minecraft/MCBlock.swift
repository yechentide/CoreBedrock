/**
 Minecraft blocks

 [Data source](https://github.com/PrismarineJS/minecraft-data/blob/master/data/bedrock/1.19.1/blocks.json)
 */
public enum MCBlock: UInt32, ExpressibleByStringLiteral, CustomStringConvertible {
    case air                               = 0
    case stone                             = 1
    case grass                             = 8
    case dirt                              = 9
    case podzol                            = 11
    case cobblestone                       = 12
    case planks                            = 13
    case mangrovePlanks                    = 19
    case sapling                           = 20
    case mangrovePropagule                 = 26
    case bedrock                           = 27
    case flowingWater                      = 28
    case water                             = 8000
    case lava                              = 29
    case flowingLava                       = 8001
    case sand                              = 30
    case gravel                            = 32
    case goldOre                           = 33
    case deepslateGoldOre                  = 34
    case ironOre                           = 35
    case deepslateIronOre                  = 36
    case coalOre                           = 37
    case deepslateCoalOre                  = 38
    case netherGoldOre                     = 39
    case log                               = 40
    case log2                              = 44
    case mangroveLog                       = 46
    case mangroveRoots                     = 47
    case muddyMangroveRoots                = 48
    case strippedSpruceLog                 = 49
    case strippedBirchLog                  = 50
    case strippedJungleLog                 = 51
    case strippedAcaciaLog                 = 52
    case strippedDarkOakLog                = 53
    case strippedOakLog                    = 54
    case strippedMangroveLog               = 55
    case wood                              = 56
    case mangroveWood                      = 62
    case strippedMangroveWood              = 69
    case leaves                            = 70
    case leaves2                           = 74
    case mangroveLeaves                    = 76
    case azaleaLeaves                      = 77
    case azaleaLeavesFlowered              = 78
    case sponge                            = 79
    case glass                             = 81
    case lapisOre                          = 82
    case deepslateLapisOre                 = 83
    case lapisBlock                        = 84
    case dispenser                         = 85
    case sandstone                         = 86
    case noteblock                         = 89
    case bed                               = 105
    case goldenRail                        = 106
    case detectorRail                      = 107
    case stickyPiston                      = 108
    case web                               = 109
    case tallgrass                         = 110
    case deadbush                          = 112
    case seagrass                          = 113
    case piston                            = 115
    case pistonArmCollision                = 116
    case stickyPistonArmCollision          = 8002
    case wool                              = 117
    case movingBlock                       = 133
    case yellowFlower                      = 134
    case redFlower                         = 135
    case witherRose                        = 145
    case brownMushroom                     = 147
    case redMushroom                       = 148
    case goldBlock                         = 149
    case ironBlock                         = 150
    case brickBlock                        = 151
    case tnt                               = 152
    case bookshelf                         = 153
    case mossyCobblestone                  = 154
    case obsidian                          = 155
    case torch                             = 156
    case fire                              = 158
    case soulFire                          = 159
    case mobSpawner                        = 160
    case oakStairs                         = 161
    case chest                             = 162
    case redstoneWire                      = 163
    case diamondOre                        = 164
    case deepslateDiamondOre               = 165
    case diamondBlock                      = 166
    case craftingTable                     = 167
    case wheat                             = 168
    case farmland                          = 169
    case litFurnace                        = 170
    case furnace                           = 8003
    case standingSign                      = 171
    case spruceStandingSign                = 172
    case birchStandingSign                 = 173
    case acaciaStandingSign                = 174
    case jungleStandingSign                = 175
    case darkoakStandingSign               = 176
    case mangroveStandingSign              = 177
    case woodenDoor                        = 178
    case ladder                            = 179
    case rail                              = 180
    case stoneStairs                       = 181
    case wallSign                          = 182
    case spruceWallSign                    = 183
    case birchWallSign                     = 184
    case acaciaWallSign                    = 185
    case jungleWallSign                    = 186
    case darkoakWallSign                   = 187
    case mangroveWallSign                  = 188
    case lever                             = 189
    case stonePressurePlate                = 190
    case ironDoor                          = 191
    case woodenPressurePlate               = 192
    case sprucePressurePlate               = 193
    case birchPressurePlate                = 194
    case junglePressurePlate               = 195
    case acaciaPressurePlate               = 196
    case darkOakPressurePlate              = 197
    case mangrovePressurePlate             = 198
    case redstoneOre                       = 199
    case litRedstoneOre                    = 8004
    case deepslateRedstoneOre              = 200
    case litDeepslateRedstoneOre           = 8005
    case redstoneTorch                     = 201
    case unlitRedstoneTorch                = 8006
    case stoneButton                       = 203
    case snowLayer                         = 204
    case ice                               = 205
    case snow                              = 206
    case cactus                            = 207
    case clay                              = 208
    case reeds                             = 209
    case jukebox                           = 210
    case fence                             = 211
    case pumpkin                           = 212
    case netherrack                        = 213
    case soulSand                          = 214
    case soulSoil                          = 215
    case basalt                            = 216
    case polishedBasalt                    = 217
    case soulTorch                         = 218
    case glowstone                         = 220
    case portal                            = 221
    case carvedPumpkin                     = 222
    case litPumpkin                        = 223
    case cake                              = 224
    case poweredRepeater                   = 225
    case unpoweredRepeater                 = 8007
    case stainedGlass                      = 226
    case trapdoor                          = 242
    case spruceTrapdoor                    = 243
    case birchTrapdoor                     = 244
    case jungleTrapdoor                    = 245
    case acaciaTrapdoor                    = 246
    case darkOakTrapdoor                   = 247
    case mangroveTrapdoor                  = 248
    case stonebrick                        = 249
    case packedMud                         = 253
    case mudBricks                         = 254
    case monsterEgg                        = 255
    case brownMushroomBlock                = 261
    case redMushroomBlock                  = 262
    case ironBars                          = 264
    case chain                             = 265
    case glassPane                         = 266
    case melonBlock                        = 267
    case pumpkinStem                       = 268
    case melonStem                         = 269
    case vine                              = 272
    case glowLichen                        = 273
    case fenceGate                         = 274
    case brickStairs                       = 275
    case stoneBrickStairs                  = 276
    case mudBrickStairs                    = 277
    case mycelium                          = 278
    case waterlily                         = 279
    case netherBrick                       = 280
    case netherBrickFence                  = 281
    case netherBrickStairs                 = 282
    case netherWart                        = 283
    case enchantingTable                   = 284
    case brewingStand                      = 285
    case cauldron                          = 286
    case endPortal                         = 290
    case endPortalFrame                    = 291
    case endStone                          = 292
    case dragonEgg                         = 293
    case redstoneLamp                      = 294
    case litRedstoneLamp                   = 8008
    case cocoa                             = 295
    case sandstoneStairs                   = 296
    case emeraldOre                        = 297
    case deepslateEmeraldOre               = 298
    case enderChest                        = 299
    case tripwireHook                      = 300
    case tripWire                          = 301
    case emeraldBlock                      = 302
    case spruceStairs                      = 303
    case birchStairs                       = 304
    case jungleStairs                      = 305
    case commandBlock                      = 306
    case beacon                            = 307
    case cobblestoneWall                   = 308
    case carrots                           = 336
    case potatoes                          = 337
    case woodenButton                      = 338
    case spruceButton                      = 339
    case birchButton                       = 340
    case jungleButton                      = 341
    case acaciaButton                      = 342
    case darkOakButton                     = 343
    case mangroveButton                    = 344
    case skull                             = 355
    case anvil                             = 357
    case trappedChest                      = 360
    case lightWeightedPressurePlate        = 361
    case heavyWeightedPressurePlate        = 362
    case poweredComparator                 = 363
    case unpoweredComparator               = 8009
    case daylightDetector                  = 364
    case daylightDetectorInverted          = 8010
    case redstoneBlock                     = 365
    case quartzOre                         = 366
    case hopper                            = 367
    case quartzBlock                       = 368
    case quartzStairs                      = 371
    case activatorRail                     = 372
    case dropper                           = 373
    case stainedHardenedClay               = 374
    case stainedGlassPane                  = 390
    case acaciaStairs                      = 406
    case darkOakStairs                     = 407
    case mangroveStairs                    = 408
    case slime                             = 409
    case barrier                           = 410
    case lightBlock                        = 411
    case ironTrapdoor                      = 412
    case prismarine                        = 413
    case prismarineStairs                  = 416
    case prismarineBricksStairs            = 417
    case darkPrismarineStairs              = 418
    case stoneBlockSlab2                   = 419
    case doubleStoneBlockSlab2             = 8011
    case seaLantern                        = 422
    case hayBlock                          = 423
    case carpet                            = 424
    case hardenedClay                      = 440
    case coalBlock                         = 441
    case packedIce                         = 442
    case doublePlant                       = 443
    case standingBanner                    = 464
    case wallBanner                        = 480
    case redSandstone                      = 481
    case redSandstoneStairs                = 484
    case woodenSlab                        = 485
    case doubleWoodenSlab                  = 8012
    case mangroveDoubleSlab                = 491
    case mangroveSlab                      = 8013
    case stoneBlockSlab4                   = 492
    case doubleStoneBlockSlab4             = 8014
    case stoneBlockSlab                    = 493
    case doubleStoneBlockSlab              = 8015
    case mudBrickDoubleSlab                = 500
    case mudBrickSlab                      = 8016
    case smoothStone                       = 506
    case spruceFenceGate                   = 510
    case birchFenceGate                    = 511
    case jungleFenceGate                   = 512
    case acaciaFenceGate                   = 513
    case darkOakFenceGate                  = 514
    case mangroveFenceGate                 = 515
    case mangroveFence                     = 521
    case spruceDoor                        = 522
    case birchDoor                         = 523
    case jungleDoor                        = 524
    case acaciaDoor                        = 525
    case darkOakDoor                       = 526
    case mangroveDoor                      = 527
    case endRod                            = 528
    case chorusPlant                       = 529
    case chorusFlower                      = 530
    case purpurBlock                       = 531
    case purpurStairs                      = 533
    case endBricks                         = 534
    case beetroot                          = 535
    case grassPath                         = 536
    case endGateway                        = 537
    case repeatingCommandBlock             = 538
    case chainCommandBlock                 = 539
    case frostedIce                        = 540
    case magma                             = 541
    case netherWartBlock                   = 542
    case redNetherBrick                    = 543
    case boneBlock                         = 544
    case structureVoid                     = 545
    case observer                          = 546
    case undyedShulkerBox                  = 547
    case shulkerBox                        = 548
    case whiteGlazedTerracotta             = 564
    case orangeGlazedTerracotta            = 565
    case magentaGlazedTerracotta           = 566
    case lightBlueGlazedTerracotta         = 567
    case yellowGlazedTerracotta            = 568
    case limeGlazedTerracotta              = 569
    case pinkGlazedTerracotta              = 570
    case grayGlazedTerracotta              = 571
    case silverGlazedTerracotta            = 572
    case cyanGlazedTerracotta              = 573
    case purpleGlazedTerracotta            = 574
    case blueGlazedTerracotta              = 575
    case brownGlazedTerracotta             = 576
    case greenGlazedTerracotta             = 577
    case redGlazedTerracotta               = 578
    case blackGlazedTerracotta             = 579
    case concrete                          = 580
    case concretePowder                    = 596
    case kelp                              = 613
    case driedKelpBlock                    = 614
    case turtleEgg                         = 615
    case coralBlock                        = 616
    case coral                             = 626
    case coralFanDead                      = 636
    case coralFan                          = 641
    case coralFanHang                      = 646
    case coralFanHang2                     = 648
    case coralFanHang3                     = 650
    case seaPickle                         = 656
    case blueIce                           = 657
    case conduit                           = 658
    case bambooSapling                     = 659
    case bamboo                            = 660
    case bubbleColumn                      = 664
    case polishedGraniteStairs             = 665
    case smoothRedSandstoneStairs          = 666
    case mossyStoneBrickStairs             = 667
    case polishedDioriteStairs             = 668
    case mossyCobblestoneStairs            = 669
    case endBrickStairs                    = 670
    case normalStoneStairs                 = 671
    case smoothSandstoneStairs             = 672
    case smoothQuartzStairs                = 673
    case graniteStairs                     = 674
    case andesiteStairs                    = 675
    case redNetherBrickStairs              = 676
    case polishedAndesiteStairs            = 677
    case dioriteStairs                     = 678
    case stoneBlockSlab3                   = 679
    case doubleStoneBlockSlab3             = 8017
    case mudBrickWall                      = 698
    case scaffolding                       = 705
    case loom                              = 706
    case barrel                            = 707
    case smoker                            = 708
    case litSmoker                         = 8018
    case litBlastFurnace                   = 709
    case blastFurnace                      = 8019
    case cartographyTable                  = 710
    case fletchingTable                    = 711
    case grindstone                        = 712
    case lectern                           = 713
    case smithingTable                     = 714
    case stonecutterBlock                  = 715
    case bell                              = 716
    case lantern                           = 717
    case soulLantern                       = 718
    case campfire                          = 719
    case soulCampfire                      = 720
    case sweetBerryBush                    = 721
    case warpedStem                        = 722
    case strippedWarpedStem                = 723
    case warpedHyphae                      = 724
    case strippedWarpedHyphae              = 725
    case warpedNylium                      = 726
    case warpedFungus                      = 727
    case warpedWartBlock                   = 728
    case warpedRoots                       = 729
    case netherSprouts                     = 730
    case crimsonStem                       = 731
    case strippedCrimsonStem               = 732
    case crimsonHyphae                     = 733
    case strippedCrimsonHyphae             = 734
    case crimsonNylium                     = 735
    case crimsonFungus                     = 736
    case shroomlight                       = 737
    case weepingVines                      = 739
    case twistingVines                     = 741
    case crimsonRoots                      = 742
    case crimsonPlanks                     = 743
    case warpedPlanks                      = 744
    case crimsonDoubleSlab                 = 745
    case crimsonSlab                       = 8020
    case warpedDoubleSlab                  = 746
    case warpedSlab                        = 8021
    case crimsonPressurePlate              = 747
    case warpedPressurePlate               = 748
    case crimsonFence                      = 749
    case warpedFence                       = 750
    case crimsonTrapdoor                   = 751
    case warpedTrapdoor                    = 752
    case crimsonFenceGate                  = 753
    case warpedFenceGate                   = 754
    case crimsonStairs                     = 755
    case warpedStairs                      = 756
    case crimsonButton                     = 757
    case warpedButton                      = 758
    case crimsonDoor                       = 759
    case warpedDoor                        = 760
    case crimsonStandingSign               = 761
    case warpedStandingSign                = 762
    case crimsonWallSign                   = 763
    case warpedWallSign                    = 764
    case structureBlock                    = 765
    case jigsaw                            = 766
    case composter                         = 767
    case target                            = 768
    case beeNest                           = 769
    case beehive                           = 770
    case honeyBlock                        = 771
    case honeycombBlock                    = 772
    case netheriteBlock                    = 773
    case ancientDebris                     = 774
    case cryingObsidian                    = 775
    case respawnAnchor                     = 776
    case lodestone                         = 781
    case blackstone                        = 782
    case blackstoneStairs                  = 783
    case blackstoneWall                    = 784
    case blackstoneDoubleSlab              = 785
    case blackstoneSlab                    = 8022
    case polishedBlackstone                = 786
    case polishedBlackstoneBricks          = 787
    case crackedPolishedBlackstoneBricks   = 788
    case chiseledPolishedBlackstone        = 789
    case polishedBlackstoneBrickDoubleSlab = 790
    case polishedBlackstoneBrickSlab       = 8023
    case polishedBlackstoneBrickStairs     = 791
    case polishedBlackstoneBrickWall       = 792
    case gildedBlackstone                  = 793
    case polishedBlackstoneStairs          = 794
    case polishedBlackstoneDoubleSlab      = 795
    case polishedBlackstoneSlab            = 8024
    case polishedBlackstonePressurePlate   = 796
    case polishedBlackstoneButton          = 797
    case polishedBlackstoneWall            = 798
    case chiseledNetherBricks              = 799
    case crackedNetherBricks               = 800
    case quartzBricks                      = 801
    case candle                            = 802
    case whiteCandle                       = 803
    case orangeCandle                      = 804
    case magentaCandle                     = 805
    case lightBlueCandle                   = 806
    case yellowCandle                      = 807
    case limeCandle                        = 808
    case pinkCandle                        = 809
    case grayCandle                        = 810
    case lightGrayCandle                   = 811
    case cyanCandle                        = 812
    case purpleCandle                      = 813
    case blueCandle                        = 814
    case brownCandle                       = 815
    case greenCandle                       = 816
    case redCandle                         = 817
    case blackCandle                       = 818
    case candleCake                        = 819
    case whiteCandleCake                   = 820
    case orangeCandleCake                  = 821
    case magentaCandleCake                 = 822
    case lightBlueCandleCake               = 823
    case yellowCandleCake                  = 824
    case limeCandleCake                    = 825
    case pinkCandleCake                    = 826
    case grayCandleCake                    = 827
    case lightGrayCandleCake               = 828
    case cyanCandleCake                    = 829
    case purpleCandleCake                  = 830
    case blueCandleCake                    = 831
    case brownCandleCake                   = 832
    case greenCandleCake                   = 833
    case redCandleCake                     = 834
    case blackCandleCake                   = 835
    case amethystBlock                     = 836
    case buddingAmethyst                   = 837
    case amethystCluster                   = 838
    case largeAmethystBud                  = 839
    case mediumAmethystBud                 = 840
    case smallAmethystBud                  = 841
    case tuff                              = 842
    case calcite                           = 843
    case tintedGlass                       = 844
    case powderSnow                        = 845
    case sculkSensor                       = 846
    case sculk                             = 847
    case sculkVein                         = 848
    case sculkCatalyst                     = 849
    case sculkShrieker                     = 850
    case oxidizedCopper                    = 851
    case weatheredCopper                   = 852
    case exposedCopper                     = 853
    case copperBlock                       = 854
    case copperOre                         = 855
    case deepslateCopperOre                = 856
    case oxidizedCutCopper                 = 857
    case weatheredCutCopper                = 858
    case exposedCutCopper                  = 859
    case cutCopper                         = 860
    case oxidizedCutCopperStairs           = 861
    case weatheredCutCopperStairs          = 862
    case exposedCutCopperStairs            = 863
    case cutCopperStairs                   = 864
    case oxidizedDoubleCutCopperSlab       = 865
    case oxidizedCutCopperSlab             = 8025
    case weatheredCutCopperSlab            = 866
    case weatheredDoubleCutCopperSlab      = 8026
    case exposedDoubleCutCopperSlab        = 867
    case exposedCutCopperSlab              = 8027
    case doubleCutCopperSlab               = 868
    case cutCopperSlab                     = 8028
    case waxedCopper                       = 869
    case waxedWeatheredCopper              = 870
    case waxedExposedCopper                = 871
    case waxedOxidizedCopper               = 872
    case waxedOxidizedCutCopper            = 873
    case waxedWeatheredCutCopper           = 874
    case waxedExposedCutCopper             = 875
    case waxedCutCopper                    = 876
    case waxedOxidizedCutCopperStairs      = 877
    case waxedWeatheredCutCopperStairs     = 878
    case waxedExposedCutCopperStairs       = 879
    case waxedCutCopperStairs              = 880
    case waxedOxidizedCutCopperSlab        = 881
    case waxedOxidizedDoubleCutCopperSlab  = 8029
    case waxedWeatheredDoubleCutCopperSlab = 882
    case waxedWeatheredCutCopperSlab       = 8030
    case waxedExposedCutCopperSlab         = 883
    case waxedExposedDoubleCutCopperSlab   = 8031
    case waxedDoubleCutCopperSlab          = 884
    case waxedCutCopperSlab                = 8032
    case lightningRod                      = 885
    case pointedDripstone                  = 886
    case dripstoneBlock                    = 887
    case caveVinesHeadWithBerries          = 888
    case caveVines                         = 889
    case caveVinesBodyWithBerries          = 8033
    case sporeBlossom                      = 890
    case azalea                            = 891
    case floweringAzalea                   = 892
    case mossCarpet                        = 893
    case mossBlock                         = 894
    case bigDripleaf                       = 895
    case smallDripleafBlock                = 897
    case hangingRoots                      = 898
    case dirtWithRoots                     = 899
    case mud                               = 900
    case deepslate                         = 901
    case cobbledDeepslate                  = 902
    case cobbledDeepslateStairs            = 903
    case cobbledDeepslateDoubleSlab        = 904
    case cobbledDeepslateSlab              = 8034
    case cobbledDeepslateWall              = 905
    case polishedDeepslate                 = 906
    case polishedDeepslateStairs           = 907
    case polishedDeepslateSlab             = 908
    case polishedDeepslateDoubleSlab       = 8035
    case polishedDeepslateWall             = 909
    case deepslateTiles                    = 910
    case deepslateTileStairs               = 911
    case deepslateTileDoubleSlab           = 912
    case deepslateTileSlab                 = 8036
    case deepslateTileWall                 = 913
    case deepslateBricks                   = 914
    case deepslateBrickStairs              = 915
    case deepslateBrickDoubleSlab          = 916
    case deepslateBrickSlab                = 8037
    case deepslateBrickWall                = 917
    case chiseledDeepslate                 = 918
    case crackedDeepslateBricks            = 919
    case crackedDeepslateTiles             = 920
    case infestedDeepslate                 = 921
    case smoothBasalt                      = 922
    case rawIronBlock                      = 923
    case rawCopperBlock                    = 924
    case rawGoldBlock                      = 925
    case flowerPot                         = 927
    case ochreFroglight                    = 928
    case verdantFroglight                  = 929
    case pearlescentFroglight              = 930
    case frogSpawn                         = 931
    case reinforcedDeepslate               = 932
    case hardStainedGlassPane              = 8038
    case infoUpdate2                       = 7808
    case element84                         = 7692
    case element85                         = 7691
    case element86                         = 7690
    case element87                         = 7689
    case element80                         = 7688
    case element81                         = 7687
    case element82                         = 7686
    case element83                         = 7685
    case element88                         = 7684
    case element89                         = 7683
    case element97                         = 7682
    case element96                         = 7681
    case element95                         = 7680
    case element94                         = 7679
    case element93                         = 7678
    case element92                         = 7677
    case element91                         = 7676
    case element90                         = 7675
    case element99                         = 7674
    case element98                         = 7673
    case element68                         = 7672
    case element69                         = 7671
    case element62                         = 7670
    case element63                         = 7669
    case element60                         = 7668
    case element61                         = 7667
    case element66                         = 7666
    case element67                         = 7665
    case element64                         = 7664
    case element65                         = 7663
    case element79                         = 7662
    case element78                         = 7661
    case element75                         = 7660
    case element74                         = 7659
    case element77                         = 7658
    case element76                         = 7657
    case element71                         = 7656
    case element70                         = 7655
    case element73                         = 7654
    case element72                         = 7653
    case element40                         = 7652
    case element41                         = 7651
    case element42                         = 7650
    case element43                         = 7649
    case element44                         = 7648
    case element45                         = 7647
    case element46                         = 7646
    case element47                         = 7645
    case element48                         = 7644
    case element49                         = 7643
    case element53                         = 7642
    case element52                         = 7641
    case element51                         = 7640
    case element50                         = 7639
    case element57                         = 7638
    case element56                         = 7637
    case element55                         = 7636
    case element54                         = 7635
    case element59                         = 7634
    case element58                         = 7633
    case element26                         = 7632
    case element27                         = 7631
    case element24                         = 7630
    case element25                         = 7629
    case element22                         = 7628
    case element23                         = 7627
    case element20                         = 7626
    case element21                         = 7625
    case element28                         = 7624
    case element29                         = 7623
    case element39                         = 7622
    case element38                         = 7621
    case element31                         = 7620
    case element30                         = 7619
    case element33                         = 7618
    case element32                         = 7617
    case element35                         = 7616
    case element34                         = 7615
    case element37                         = 7614
    case element36                         = 7613
    case element19                         = 7612
    case element18                         = 7611
    case element17                         = 7610
    case element16                         = 7609
    case element15                         = 7608
    case element14                         = 7607
    case element13                         = 7606
    case element12                         = 7605
    case element11                         = 7604
    case element10                         = 7603
    case coloredTorchRg                    = 7530
    case coloredTorchBp                    = 7518
    case chemicalHeat                      = 7438
    case netherreactor                     = 7421
    case chemistryTable                    = 7294
    case camera                            = 7284
    case element8                          = 7283
    case element9                          = 7282
    case element6                          = 7281
    case element7                          = 7280
    case element4                          = 7279
    case element5                          = 7278
    case element2                          = 7277
    case element3                          = 7276
    case element0                          = 7275
    case element1                          = 7274
    case allow                             = 7082
    case hardStainedGlass                  = 6208
    case deny                              = 5753
    case element118                        = 5572
    case element114                        = 5571
    case element115                        = 5570
    case element116                        = 5569
    case element117                        = 5568
    case element110                        = 5567
    case element111                        = 5566
    case element112                        = 5565
    case element113                        = 5564
    case element109                        = 5563
    case element108                        = 5562
    case element107                        = 5561
    case element106                        = 5560
    case element105                        = 5559
    case element104                        = 5558
    case element103                        = 5557
    case element102                        = 5556
    case element101                        = 5555
    case element100                        = 5554
    case borderBlock                       = 4899
    case hardGlass                         = 4766
    case unknown                           = 4612
    case reserved6                         = 4603
    case clientRequestPlaceholderBlock     = 4288
    case frame                             = 4246
    case glowingobsidian                   = 3545
    case underwaterTorch                   = 3450
    case invisibleBedrock                  = 948
    case stonecutter                       = 8039
    case hardGlassPane                     = 8040
    case lavaCauldron                      = 608
    case infoUpdate                        = 8041
    case glowFrame                         = 8042

    public var description: String {
        switch self {
            case .air:                               return "air"
            case .stone:                             return "stone"
            case .grass:                             return "grass"
            case .dirt:                              return "dirt"
            case .podzol:                            return "podzol"
            case .cobblestone:                       return "cobblestone"
            case .planks:                            return "planks"
            case .mangrovePlanks:                    return "mangrove_planks"
            case .sapling:                           return "sapling"
            case .mangrovePropagule:                 return "mangrove_propagule"
            case .bedrock:                           return "bedrock"
            case .flowingWater:                      return "flowing_water"
            case .water:                             return "water"
            case .lava:                              return "lava"
            case .flowingLava:                       return "flowing_lava"
            case .sand:                              return "sand"
            case .gravel:                            return "gravel"
            case .goldOre:                           return "gold_ore"
            case .deepslateGoldOre:                  return "deepslate_gold_ore"
            case .ironOre:                           return "iron_ore"
            case .deepslateIronOre:                  return "deepslate_iron_ore"
            case .coalOre:                           return "coal_ore"
            case .deepslateCoalOre:                  return "deepslate_coal_ore"
            case .netherGoldOre:                     return "nether_gold_ore"
            case .log:                               return "log"
            case .log2:                              return "log2"
            case .mangroveLog:                       return "mangrove_log"
            case .mangroveRoots:                     return "mangrove_roots"
            case .muddyMangroveRoots:                return "muddy_mangrove_roots"
            case .strippedSpruceLog:                 return "stripped_spruce_log"
            case .strippedBirchLog:                  return "stripped_birch_log"
            case .strippedJungleLog:                 return "stripped_jungle_log"
            case .strippedAcaciaLog:                 return "stripped_acacia_log"
            case .strippedDarkOakLog:                return "stripped_dark_oak_log"
            case .strippedOakLog:                    return "stripped_oak_log"
            case .strippedMangroveLog:               return "stripped_mangrove_log"
            case .wood:                              return "wood"
            case .mangroveWood:                      return "mangrove_wood"
            case .strippedMangroveWood:              return "stripped_mangrove_wood"
            case .leaves:                            return "leaves"
            case .leaves2:                           return "leaves2"
            case .mangroveLeaves:                    return "mangrove_leaves"
            case .azaleaLeaves:                      return "azalea_leaves"
            case .azaleaLeavesFlowered:              return "azalea_leaves_flowered"
            case .sponge:                            return "sponge"
            case .glass:                             return "glass"
            case .lapisOre:                          return "lapis_ore"
            case .deepslateLapisOre:                 return "deepslate_lapis_ore"
            case .lapisBlock:                        return "lapis_block"
            case .dispenser:                         return "dispenser"
            case .sandstone:                         return "sandstone"
            case .noteblock:                         return "noteblock"
            case .bed:                               return "bed"
            case .goldenRail:                        return "golden_rail"
            case .detectorRail:                      return "detector_rail"
            case .stickyPiston:                      return "sticky_piston"
            case .web:                               return "web"
            case .tallgrass:                         return "tallgrass"
            case .deadbush:                          return "deadbush"
            case .seagrass:                          return "seagrass"
            case .piston:                            return "piston"
            case .pistonArmCollision:                return "piston_arm_collision"
            case .stickyPistonArmCollision:          return "sticky_piston_arm_collision"
            case .wool:                              return "wool"
            case .movingBlock:                       return "moving_block"
            case .yellowFlower:                      return "yellow_flower"
            case .redFlower:                         return "red_flower"
            case .witherRose:                        return "wither_rose"
            case .brownMushroom:                     return "brown_mushroom"
            case .redMushroom:                       return "red_mushroom"
            case .goldBlock:                         return "gold_block"
            case .ironBlock:                         return "iron_block"
            case .brickBlock:                        return "brick_block"
            case .tnt:                               return "tnt"
            case .bookshelf:                         return "bookshelf"
            case .mossyCobblestone:                  return "mossy_cobblestone"
            case .obsidian:                          return "obsidian"
            case .torch:                             return "torch"
            case .fire:                              return "fire"
            case .soulFire:                          return "soul_fire"
            case .mobSpawner:                        return "mob_spawner"
            case .oakStairs:                         return "oak_stairs"
            case .chest:                             return "chest"
            case .redstoneWire:                      return "redstone_wire"
            case .diamondOre:                        return "diamond_ore"
            case .deepslateDiamondOre:               return "deepslate_diamond_ore"
            case .diamondBlock:                      return "diamond_block"
            case .craftingTable:                     return "crafting_table"
            case .wheat:                             return "wheat"
            case .farmland:                          return "farmland"
            case .litFurnace:                        return "lit_furnace"
            case .furnace:                           return "furnace"
            case .standingSign:                      return "standing_sign"
            case .spruceStandingSign:                return "spruce_standing_sign"
            case .birchStandingSign:                 return "birch_standing_sign"
            case .acaciaStandingSign:                return "acacia_standing_sign"
            case .jungleStandingSign:                return "jungle_standing_sign"
            case .darkoakStandingSign:               return "darkoak_standing_sign"
            case .mangroveStandingSign:              return "mangrove_standing_sign"
            case .woodenDoor:                        return "wooden_door"
            case .ladder:                            return "ladder"
            case .rail:                              return "rail"
            case .stoneStairs:                       return "stone_stairs"
            case .wallSign:                          return "wall_sign"
            case .spruceWallSign:                    return "spruce_wall_sign"
            case .birchWallSign:                     return "birch_wall_sign"
            case .acaciaWallSign:                    return "acacia_wall_sign"
            case .jungleWallSign:                    return "jungle_wall_sign"
            case .darkoakWallSign:                   return "darkoak_wall_sign"
            case .mangroveWallSign:                  return "mangrove_wall_sign"
            case .lever:                             return "lever"
            case .stonePressurePlate:                return "stone_pressure_plate"
            case .ironDoor:                          return "iron_door"
            case .woodenPressurePlate:               return "wooden_pressure_plate"
            case .sprucePressurePlate:               return "spruce_pressure_plate"
            case .birchPressurePlate:                return "birch_pressure_plate"
            case .junglePressurePlate:               return "jungle_pressure_plate"
            case .acaciaPressurePlate:               return "acacia_pressure_plate"
            case .darkOakPressurePlate:              return "dark_oak_pressure_plate"
            case .mangrovePressurePlate:             return "mangrove_pressure_plate"
            case .redstoneOre:                       return "redstone_ore"
            case .litRedstoneOre:                    return "lit_redstone_ore"
            case .deepslateRedstoneOre:              return "deepslate_redstone_ore"
            case .litDeepslateRedstoneOre:           return "lit_deepslate_redstone_ore"
            case .redstoneTorch:                     return "redstone_torch"
            case .unlitRedstoneTorch:                return "unlit_redstone_torch"
            case .stoneButton:                       return "stone_button"
            case .snowLayer:                         return "snow_layer"
            case .ice:                               return "ice"
            case .snow:                              return "snow"
            case .cactus:                            return "cactus"
            case .clay:                              return "clay"
            case .reeds:                             return "reeds"
            case .jukebox:                           return "jukebox"
            case .fence:                             return "fence"
            case .pumpkin:                           return "pumpkin"
            case .netherrack:                        return "netherrack"
            case .soulSand:                          return "soul_sand"
            case .soulSoil:                          return "soul_soil"
            case .basalt:                            return "basalt"
            case .polishedBasalt:                    return "polished_basalt"
            case .soulTorch:                         return "soul_torch"
            case .glowstone:                         return "glowstone"
            case .portal:                            return "portal"
            case .carvedPumpkin:                     return "carved_pumpkin"
            case .litPumpkin:                        return "lit_pumpkin"
            case .cake:                              return "cake"
            case .poweredRepeater:                   return "powered_repeater"
            case .unpoweredRepeater:                 return "unpowered_repeater"
            case .stainedGlass:                      return "stained_glass"
            case .trapdoor:                          return "trapdoor"
            case .spruceTrapdoor:                    return "spruce_trapdoor"
            case .birchTrapdoor:                     return "birch_trapdoor"
            case .jungleTrapdoor:                    return "jungle_trapdoor"
            case .acaciaTrapdoor:                    return "acacia_trapdoor"
            case .darkOakTrapdoor:                   return "dark_oak_trapdoor"
            case .mangroveTrapdoor:                  return "mangrove_trapdoor"
            case .stonebrick:                        return "stonebrick"
            case .packedMud:                         return "packed_mud"
            case .mudBricks:                         return "mud_bricks"
            case .monsterEgg:                        return "monster_egg"
            case .brownMushroomBlock:                return "brown_mushroom_block"
            case .redMushroomBlock:                  return "red_mushroom_block"
            case .ironBars:                          return "iron_bars"
            case .chain:                             return "chain"
            case .glassPane:                         return "glass_pane"
            case .melonBlock:                        return "melon_block"
            case .pumpkinStem:                       return "pumpkin_stem"
            case .melonStem:                         return "melon_stem"
            case .vine:                              return "vine"
            case .glowLichen:                        return "glow_lichen"
            case .fenceGate:                         return "fence_gate"
            case .brickStairs:                       return "brick_stairs"
            case .stoneBrickStairs:                  return "stone_brick_stairs"
            case .mudBrickStairs:                    return "mud_brick_stairs"
            case .mycelium:                          return "mycelium"
            case .waterlily:                         return "waterlily"
            case .netherBrick:                       return "nether_brick"
            case .netherBrickFence:                  return "nether_brick_fence"
            case .netherBrickStairs:                 return "nether_brick_stairs"
            case .netherWart:                        return "nether_wart"
            case .enchantingTable:                   return "enchanting_table"
            case .brewingStand:                      return "brewing_stand"
            case .cauldron:                          return "cauldron"
            case .endPortal:                         return "end_portal"
            case .endPortalFrame:                    return "end_portal_frame"
            case .endStone:                          return "end_stone"
            case .dragonEgg:                         return "dragon_egg"
            case .redstoneLamp:                      return "redstone_lamp"
            case .litRedstoneLamp:                   return "lit_redstone_lamp"
            case .cocoa:                             return "cocoa"
            case .sandstoneStairs:                   return "sandstone_stairs"
            case .emeraldOre:                        return "emerald_ore"
            case .deepslateEmeraldOre:               return "deepslate_emerald_ore"
            case .enderChest:                        return "ender_chest"
            case .tripwireHook:                      return "tripwire_hook"
            case .tripWire:                          return "trip_wire"
            case .emeraldBlock:                      return "emerald_block"
            case .spruceStairs:                      return "spruce_stairs"
            case .birchStairs:                       return "birch_stairs"
            case .jungleStairs:                      return "jungle_stairs"
            case .commandBlock:                      return "command_block"
            case .beacon:                            return "beacon"
            case .cobblestoneWall:                   return "cobblestone_wall"
            case .carrots:                           return "carrots"
            case .potatoes:                          return "potatoes"
            case .woodenButton:                      return "wooden_button"
            case .spruceButton:                      return "spruce_button"
            case .birchButton:                       return "birch_button"
            case .jungleButton:                      return "jungle_button"
            case .acaciaButton:                      return "acacia_button"
            case .darkOakButton:                     return "dark_oak_button"
            case .mangroveButton:                    return "mangrove_button"
            case .skull:                             return "skull"
            case .anvil:                             return "anvil"
            case .trappedChest:                      return "trapped_chest"
            case .lightWeightedPressurePlate:        return "light_weighted_pressure_plate"
            case .heavyWeightedPressurePlate:        return "heavy_weighted_pressure_plate"
            case .poweredComparator:                 return "powered_comparator"
            case .unpoweredComparator:               return "unpowered_comparator"
            case .daylightDetector:                  return "daylight_detector"
            case .daylightDetectorInverted:          return "daylight_detector_inverted"
            case .redstoneBlock:                     return "redstone_block"
            case .quartzOre:                         return "quartz_ore"
            case .hopper:                            return "hopper"
            case .quartzBlock:                       return "quartz_block"
            case .quartzStairs:                      return "quartz_stairs"
            case .activatorRail:                     return "activator_rail"
            case .dropper:                           return "dropper"
            case .stainedHardenedClay:               return "stained_hardened_clay"
            case .stainedGlassPane:                  return "stained_glass_pane"
            case .acaciaStairs:                      return "acacia_stairs"
            case .darkOakStairs:                     return "dark_oak_stairs"
            case .mangroveStairs:                    return "mangrove_stairs"
            case .slime:                             return "slime"
            case .barrier:                           return "barrier"
            case .lightBlock:                        return "light_block"
            case .ironTrapdoor:                      return "iron_trapdoor"
            case .prismarine:                        return "prismarine"
            case .prismarineStairs:                  return "prismarine_stairs"
            case .prismarineBricksStairs:            return "prismarine_bricks_stairs"
            case .darkPrismarineStairs:              return "dark_prismarine_stairs"
            case .stoneBlockSlab2:                   return "stone_block_slab2"
            case .doubleStoneBlockSlab2:             return "double_stone_block_slab2"
            case .seaLantern:                        return "sea_lantern"
            case .hayBlock:                          return "hay_block"
            case .carpet:                            return "carpet"
            case .hardenedClay:                      return "hardened_clay"
            case .coalBlock:                         return "coal_block"
            case .packedIce:                         return "packed_ice"
            case .doublePlant:                       return "double_plant"
            case .standingBanner:                    return "standing_banner"
            case .wallBanner:                        return "wall_banner"
            case .redSandstone:                      return "red_sandstone"
            case .redSandstoneStairs:                return "red_sandstone_stairs"
            case .woodenSlab:                        return "wooden_slab"
            case .doubleWoodenSlab:                  return "double_wooden_slab"
            case .mangroveDoubleSlab:                return "mangrove_double_slab"
            case .mangroveSlab:                      return "mangrove_slab"
            case .stoneBlockSlab4:                   return "stone_block_slab4"
            case .doubleStoneBlockSlab4:             return "double_stone_block_slab4"
            case .stoneBlockSlab:                    return "stone_block_slab"
            case .doubleStoneBlockSlab:              return "double_stone_block_slab"
            case .mudBrickDoubleSlab:                return "mud_brick_double_slab"
            case .mudBrickSlab:                      return "mud_brick_slab"
            case .smoothStone:                       return "smooth_stone"
            case .spruceFenceGate:                   return "spruce_fence_gate"
            case .birchFenceGate:                    return "birch_fence_gate"
            case .jungleFenceGate:                   return "jungle_fence_gate"
            case .acaciaFenceGate:                   return "acacia_fence_gate"
            case .darkOakFenceGate:                  return "dark_oak_fence_gate"
            case .mangroveFenceGate:                 return "mangrove_fence_gate"
            case .mangroveFence:                     return "mangrove_fence"
            case .spruceDoor:                        return "spruce_door"
            case .birchDoor:                         return "birch_door"
            case .jungleDoor:                        return "jungle_door"
            case .acaciaDoor:                        return "acacia_door"
            case .darkOakDoor:                       return "dark_oak_door"
            case .mangroveDoor:                      return "mangrove_door"
            case .endRod:                            return "end_rod"
            case .chorusPlant:                       return "chorus_plant"
            case .chorusFlower:                      return "chorus_flower"
            case .purpurBlock:                       return "purpur_block"
            case .purpurStairs:                      return "purpur_stairs"
            case .endBricks:                         return "end_bricks"
            case .beetroot:                          return "beetroot"
            case .grassPath:                         return "grass_path"
            case .endGateway:                        return "end_gateway"
            case .repeatingCommandBlock:             return "repeating_command_block"
            case .chainCommandBlock:                 return "chain_command_block"
            case .frostedIce:                        return "frosted_ice"
            case .magma:                             return "magma"
            case .netherWartBlock:                   return "nether_wart_block"
            case .redNetherBrick:                    return "red_nether_brick"
            case .boneBlock:                         return "bone_block"
            case .structureVoid:                     return "structure_void"
            case .observer:                          return "observer"
            case .undyedShulkerBox:                  return "undyed_shulker_box"
            case .shulkerBox:                        return "shulker_box"
            case .whiteGlazedTerracotta:             return "white_glazed_terracotta"
            case .orangeGlazedTerracotta:            return "orange_glazed_terracotta"
            case .magentaGlazedTerracotta:           return "magenta_glazed_terracotta"
            case .lightBlueGlazedTerracotta:         return "light_blue_glazed_terracotta"
            case .yellowGlazedTerracotta:            return "yellow_glazed_terracotta"
            case .limeGlazedTerracotta:              return "lime_glazed_terracotta"
            case .pinkGlazedTerracotta:              return "pink_glazed_terracotta"
            case .grayGlazedTerracotta:              return "gray_glazed_terracotta"
            case .silverGlazedTerracotta:            return "silver_glazed_terracotta"
            case .cyanGlazedTerracotta:              return "cyan_glazed_terracotta"
            case .purpleGlazedTerracotta:            return "purple_glazed_terracotta"
            case .blueGlazedTerracotta:              return "blue_glazed_terracotta"
            case .brownGlazedTerracotta:             return "brown_glazed_terracotta"
            case .greenGlazedTerracotta:             return "green_glazed_terracotta"
            case .redGlazedTerracotta:               return "red_glazed_terracotta"
            case .blackGlazedTerracotta:             return "black_glazed_terracotta"
            case .concrete:                          return "concrete"
            case .concretePowder:                    return "concrete_powder"
            case .kelp:                              return "kelp"
            case .driedKelpBlock:                    return "dried_kelp_block"
            case .turtleEgg:                         return "turtle_egg"
            case .coralBlock:                        return "coral_block"
            case .coral:                             return "coral"
            case .coralFanDead:                      return "coral_fan_dead"
            case .coralFan:                          return "coral_fan"
            case .coralFanHang:                      return "coral_fan_hang"
            case .coralFanHang2:                     return "coral_fan_hang2"
            case .coralFanHang3:                     return "coral_fan_hang3"
            case .seaPickle:                         return "sea_pickle"
            case .blueIce:                           return "blue_ice"
            case .conduit:                           return "conduit"
            case .bambooSapling:                     return "bamboo_sapling"
            case .bamboo:                            return "bamboo"
            case .bubbleColumn:                      return "bubble_column"
            case .polishedGraniteStairs:             return "polished_granite_stairs"
            case .smoothRedSandstoneStairs:          return "smooth_red_sandstone_stairs"
            case .mossyStoneBrickStairs:             return "mossy_stone_brick_stairs"
            case .polishedDioriteStairs:             return "polished_diorite_stairs"
            case .mossyCobblestoneStairs:            return "mossy_cobblestone_stairs"
            case .endBrickStairs:                    return "end_brick_stairs"
            case .normalStoneStairs:                 return "normal_stone_stairs"
            case .smoothSandstoneStairs:             return "smooth_sandstone_stairs"
            case .smoothQuartzStairs:                return "smooth_quartz_stairs"
            case .graniteStairs:                     return "granite_stairs"
            case .andesiteStairs:                    return "andesite_stairs"
            case .redNetherBrickStairs:              return "red_nether_brick_stairs"
            case .polishedAndesiteStairs:            return "polished_andesite_stairs"
            case .dioriteStairs:                     return "diorite_stairs"
            case .stoneBlockSlab3:                   return "stone_block_slab3"
            case .doubleStoneBlockSlab3:             return "double_stone_block_slab3"
            case .mudBrickWall:                      return "mud_brick_wall"
            case .scaffolding:                       return "scaffolding"
            case .loom:                              return "loom"
            case .barrel:                            return "barrel"
            case .smoker:                            return "smoker"
            case .litSmoker:                         return "lit_smoker"
            case .litBlastFurnace:                   return "lit_blast_furnace"
            case .blastFurnace:                      return "blast_furnace"
            case .cartographyTable:                  return "cartography_table"
            case .fletchingTable:                    return "fletching_table"
            case .grindstone:                        return "grindstone"
            case .lectern:                           return "lectern"
            case .smithingTable:                     return "smithing_table"
            case .stonecutterBlock:                  return "stonecutter_block"
            case .bell:                              return "bell"
            case .lantern:                           return "lantern"
            case .soulLantern:                       return "soul_lantern"
            case .campfire:                          return "campfire"
            case .soulCampfire:                      return "soul_campfire"
            case .sweetBerryBush:                    return "sweet_berry_bush"
            case .warpedStem:                        return "warped_stem"
            case .strippedWarpedStem:                return "stripped_warped_stem"
            case .warpedHyphae:                      return "warped_hyphae"
            case .strippedWarpedHyphae:              return "stripped_warped_hyphae"
            case .warpedNylium:                      return "warped_nylium"
            case .warpedFungus:                      return "warped_fungus"
            case .warpedWartBlock:                   return "warped_wart_block"
            case .warpedRoots:                       return "warped_roots"
            case .netherSprouts:                     return "nether_sprouts"
            case .crimsonStem:                       return "crimson_stem"
            case .strippedCrimsonStem:               return "stripped_crimson_stem"
            case .crimsonHyphae:                     return "crimson_hyphae"
            case .strippedCrimsonHyphae:             return "stripped_crimson_hyphae"
            case .crimsonNylium:                     return "crimson_nylium"
            case .crimsonFungus:                     return "crimson_fungus"
            case .shroomlight:                       return "shroomlight"
            case .weepingVines:                      return "weeping_vines"
            case .twistingVines:                     return "twisting_vines"
            case .crimsonRoots:                      return "crimson_roots"
            case .crimsonPlanks:                     return "crimson_planks"
            case .warpedPlanks:                      return "warped_planks"
            case .crimsonDoubleSlab:                 return "crimson_double_slab"
            case .crimsonSlab:                       return "crimson_slab"
            case .warpedDoubleSlab:                  return "warped_double_slab"
            case .warpedSlab:                        return "warped_slab"
            case .crimsonPressurePlate:              return "crimson_pressure_plate"
            case .warpedPressurePlate:               return "warped_pressure_plate"
            case .crimsonFence:                      return "crimson_fence"
            case .warpedFence:                       return "warped_fence"
            case .crimsonTrapdoor:                   return "crimson_trapdoor"
            case .warpedTrapdoor:                    return "warped_trapdoor"
            case .crimsonFenceGate:                  return "crimson_fence_gate"
            case .warpedFenceGate:                   return "warped_fence_gate"
            case .crimsonStairs:                     return "crimson_stairs"
            case .warpedStairs:                      return "warped_stairs"
            case .crimsonButton:                     return "crimson_button"
            case .warpedButton:                      return "warped_button"
            case .crimsonDoor:                       return "crimson_door"
            case .warpedDoor:                        return "warped_door"
            case .crimsonStandingSign:               return "crimson_standing_sign"
            case .warpedStandingSign:                return "warped_standing_sign"
            case .crimsonWallSign:                   return "crimson_wall_sign"
            case .warpedWallSign:                    return "warped_wall_sign"
            case .structureBlock:                    return "structure_block"
            case .jigsaw:                            return "jigsaw"
            case .composter:                         return "composter"
            case .target:                            return "target"
            case .beeNest:                           return "bee_nest"
            case .beehive:                           return "beehive"
            case .honeyBlock:                        return "honey_block"
            case .honeycombBlock:                    return "honeycomb_block"
            case .netheriteBlock:                    return "netherite_block"
            case .ancientDebris:                     return "ancient_debris"
            case .cryingObsidian:                    return "crying_obsidian"
            case .respawnAnchor:                     return "respawn_anchor"
            case .lodestone:                         return "lodestone"
            case .blackstone:                        return "blackstone"
            case .blackstoneStairs:                  return "blackstone_stairs"
            case .blackstoneWall:                    return "blackstone_wall"
            case .blackstoneDoubleSlab:              return "blackstone_double_slab"
            case .blackstoneSlab:                    return "blackstone_slab"
            case .polishedBlackstone:                return "polished_blackstone"
            case .polishedBlackstoneBricks:          return "polished_blackstone_bricks"
            case .crackedPolishedBlackstoneBricks:   return "cracked_polished_blackstone_bricks"
            case .chiseledPolishedBlackstone:        return "chiseled_polished_blackstone"
            case .polishedBlackstoneBrickDoubleSlab: return "polished_blackstone_brick_double_slab"
            case .polishedBlackstoneBrickSlab:       return "polished_blackstone_brick_slab"
            case .polishedBlackstoneBrickStairs:     return "polished_blackstone_brick_stairs"
            case .polishedBlackstoneBrickWall:       return "polished_blackstone_brick_wall"
            case .gildedBlackstone:                  return "gilded_blackstone"
            case .polishedBlackstoneStairs:          return "polished_blackstone_stairs"
            case .polishedBlackstoneDoubleSlab:      return "polished_blackstone_double_slab"
            case .polishedBlackstoneSlab:            return "polished_blackstone_slab"
            case .polishedBlackstonePressurePlate:   return "polished_blackstone_pressure_plate"
            case .polishedBlackstoneButton:          return "polished_blackstone_button"
            case .polishedBlackstoneWall:            return "polished_blackstone_wall"
            case .chiseledNetherBricks:              return "chiseled_nether_bricks"
            case .crackedNetherBricks:               return "cracked_nether_bricks"
            case .quartzBricks:                      return "quartz_bricks"
            case .candle:                            return "candle"
            case .whiteCandle:                       return "white_candle"
            case .orangeCandle:                      return "orange_candle"
            case .magentaCandle:                     return "magenta_candle"
            case .lightBlueCandle:                   return "light_blue_candle"
            case .yellowCandle:                      return "yellow_candle"
            case .limeCandle:                        return "lime_candle"
            case .pinkCandle:                        return "pink_candle"
            case .grayCandle:                        return "gray_candle"
            case .lightGrayCandle:                   return "light_gray_candle"
            case .cyanCandle:                        return "cyan_candle"
            case .purpleCandle:                      return "purple_candle"
            case .blueCandle:                        return "blue_candle"
            case .brownCandle:                       return "brown_candle"
            case .greenCandle:                       return "green_candle"
            case .redCandle:                         return "red_candle"
            case .blackCandle:                       return "black_candle"
            case .candleCake:                        return "candle_cake"
            case .whiteCandleCake:                   return "white_candle_cake"
            case .orangeCandleCake:                  return "orange_candle_cake"
            case .magentaCandleCake:                 return "magenta_candle_cake"
            case .lightBlueCandleCake:               return "light_blue_candle_cake"
            case .yellowCandleCake:                  return "yellow_candle_cake"
            case .limeCandleCake:                    return "lime_candle_cake"
            case .pinkCandleCake:                    return "pink_candle_cake"
            case .grayCandleCake:                    return "gray_candle_cake"
            case .lightGrayCandleCake:               return "light_gray_candle_cake"
            case .cyanCandleCake:                    return "cyan_candle_cake"
            case .purpleCandleCake:                  return "purple_candle_cake"
            case .blueCandleCake:                    return "blue_candle_cake"
            case .brownCandleCake:                   return "brown_candle_cake"
            case .greenCandleCake:                   return "green_candle_cake"
            case .redCandleCake:                     return "red_candle_cake"
            case .blackCandleCake:                   return "black_candle_cake"
            case .amethystBlock:                     return "amethyst_block"
            case .buddingAmethyst:                   return "budding_amethyst"
            case .amethystCluster:                   return "amethyst_cluster"
            case .largeAmethystBud:                  return "large_amethyst_bud"
            case .mediumAmethystBud:                 return "medium_amethyst_bud"
            case .smallAmethystBud:                  return "small_amethyst_bud"
            case .tuff:                              return "tuff"
            case .calcite:                           return "calcite"
            case .tintedGlass:                       return "tinted_glass"
            case .powderSnow:                        return "powder_snow"
            case .sculkSensor:                       return "sculk_sensor"
            case .sculk:                             return "sculk"
            case .sculkVein:                         return "sculk_vein"
            case .sculkCatalyst:                     return "sculk_catalyst"
            case .sculkShrieker:                     return "sculk_shrieker"
            case .oxidizedCopper:                    return "oxidized_copper"
            case .weatheredCopper:                   return "weathered_copper"
            case .exposedCopper:                     return "exposed_copper"
            case .copperBlock:                       return "copper_block"
            case .copperOre:                         return "copper_ore"
            case .deepslateCopperOre:                return "deepslate_copper_ore"
            case .oxidizedCutCopper:                 return "oxidized_cut_copper"
            case .weatheredCutCopper:                return "weathered_cut_copper"
            case .exposedCutCopper:                  return "exposed_cut_copper"
            case .cutCopper:                         return "cut_copper"
            case .oxidizedCutCopperStairs:           return "oxidized_cut_copper_stairs"
            case .weatheredCutCopperStairs:          return "weathered_cut_copper_stairs"
            case .exposedCutCopperStairs:            return "exposed_cut_copper_stairs"
            case .cutCopperStairs:                   return "cut_copper_stairs"
            case .oxidizedDoubleCutCopperSlab:       return "oxidized_double_cut_copper_slab"
            case .oxidizedCutCopperSlab:             return "oxidized_cut_copper_slab"
            case .weatheredCutCopperSlab:            return "weathered_cut_copper_slab"
            case .weatheredDoubleCutCopperSlab:      return "weathered_double_cut_copper_slab"
            case .exposedDoubleCutCopperSlab:        return "exposed_double_cut_copper_slab"
            case .exposedCutCopperSlab:              return "exposed_cut_copper_slab"
            case .doubleCutCopperSlab:               return "double_cut_copper_slab"
            case .cutCopperSlab:                     return "cut_copper_slab"
            case .waxedCopper:                       return "waxed_copper"
            case .waxedWeatheredCopper:              return "waxed_weathered_copper"
            case .waxedExposedCopper:                return "waxed_exposed_copper"
            case .waxedOxidizedCopper:               return "waxed_oxidized_copper"
            case .waxedOxidizedCutCopper:            return "waxed_oxidized_cut_copper"
            case .waxedWeatheredCutCopper:           return "waxed_weathered_cut_copper"
            case .waxedExposedCutCopper:             return "waxed_exposed_cut_copper"
            case .waxedCutCopper:                    return "waxed_cut_copper"
            case .waxedOxidizedCutCopperStairs:      return "waxed_oxidized_cut_copper_stairs"
            case .waxedWeatheredCutCopperStairs:     return "waxed_weathered_cut_copper_stairs"
            case .waxedExposedCutCopperStairs:       return "waxed_exposed_cut_copper_stairs"
            case .waxedCutCopperStairs:              return "waxed_cut_copper_stairs"
            case .waxedOxidizedCutCopperSlab:        return "waxed_oxidized_cut_copper_slab"
            case .waxedOxidizedDoubleCutCopperSlab:  return "waxed_oxidized_double_cut_copper_slab"
            case .waxedWeatheredDoubleCutCopperSlab: return "waxed_weathered_double_cut_copper_slab"
            case .waxedWeatheredCutCopperSlab:       return "waxed_weathered_cut_copper_slab"
            case .waxedExposedCutCopperSlab:         return "waxed_exposed_cut_copper_slab"
            case .waxedExposedDoubleCutCopperSlab:   return "waxed_exposed_double_cut_copper_slab"
            case .waxedDoubleCutCopperSlab:          return "waxed_double_cut_copper_slab"
            case .waxedCutCopperSlab:                return "waxed_cut_copper_slab"
            case .lightningRod:                      return "lightning_rod"
            case .pointedDripstone:                  return "pointed_dripstone"
            case .dripstoneBlock:                    return "dripstone_block"
            case .caveVinesHeadWithBerries:          return "cave_vines_head_with_berries"
            case .caveVines:                         return "cave_vines"
            case .caveVinesBodyWithBerries:          return "cave_vines_body_with_berries"
            case .sporeBlossom:                      return "spore_blossom"
            case .azalea:                            return "azalea"
            case .floweringAzalea:                   return "flowering_azalea"
            case .mossCarpet:                        return "moss_carpet"
            case .mossBlock:                         return "moss_block"
            case .bigDripleaf:                       return "big_dripleaf"
            case .smallDripleafBlock:                return "small_dripleaf_block"
            case .hangingRoots:                      return "hanging_roots"
            case .dirtWithRoots:                     return "dirt_with_roots"
            case .mud:                               return "mud"
            case .deepslate:                         return "deepslate"
            case .cobbledDeepslate:                  return "cobbled_deepslate"
            case .cobbledDeepslateStairs:            return "cobbled_deepslate_stairs"
            case .cobbledDeepslateDoubleSlab:        return "cobbled_deepslate_double_slab"
            case .cobbledDeepslateSlab:              return "cobbled_deepslate_slab"
            case .cobbledDeepslateWall:              return "cobbled_deepslate_wall"
            case .polishedDeepslate:                 return "polished_deepslate"
            case .polishedDeepslateStairs:           return "polished_deepslate_stairs"
            case .polishedDeepslateSlab:             return "polished_deepslate_slab"
            case .polishedDeepslateDoubleSlab:       return "polished_deepslate_double_slab"
            case .polishedDeepslateWall:             return "polished_deepslate_wall"
            case .deepslateTiles:                    return "deepslate_tiles"
            case .deepslateTileStairs:               return "deepslate_tile_stairs"
            case .deepslateTileDoubleSlab:           return "deepslate_tile_double_slab"
            case .deepslateTileSlab:                 return "deepslate_tile_slab"
            case .deepslateTileWall:                 return "deepslate_tile_wall"
            case .deepslateBricks:                   return "deepslate_bricks"
            case .deepslateBrickStairs:              return "deepslate_brick_stairs"
            case .deepslateBrickDoubleSlab:          return "deepslate_brick_double_slab"
            case .deepslateBrickSlab:                return "deepslate_brick_slab"
            case .deepslateBrickWall:                return "deepslate_brick_wall"
            case .chiseledDeepslate:                 return "chiseled_deepslate"
            case .crackedDeepslateBricks:            return "cracked_deepslate_bricks"
            case .crackedDeepslateTiles:             return "cracked_deepslate_tiles"
            case .infestedDeepslate:                 return "infested_deepslate"
            case .smoothBasalt:                      return "smooth_basalt"
            case .rawIronBlock:                      return "raw_iron_block"
            case .rawCopperBlock:                    return "raw_copper_block"
            case .rawGoldBlock:                      return "raw_gold_block"
            case .flowerPot:                         return "flower_pot"
            case .ochreFroglight:                    return "ochre_froglight"
            case .verdantFroglight:                  return "verdant_froglight"
            case .pearlescentFroglight:              return "pearlescent_froglight"
            case .frogSpawn:                         return "frog_spawn"
            case .reinforcedDeepslate:               return "reinforced_deepslate"
            case .hardStainedGlassPane:              return "hard_stained_glass_pane"
            case .infoUpdate2:                       return "info_update2"
            case .element84:                         return "element_84"
            case .element85:                         return "element_85"
            case .element86:                         return "element_86"
            case .element87:                         return "element_87"
            case .element80:                         return "element_80"
            case .element81:                         return "element_81"
            case .element82:                         return "element_82"
            case .element83:                         return "element_83"
            case .element88:                         return "element_88"
            case .element89:                         return "element_89"
            case .element97:                         return "element_97"
            case .element96:                         return "element_96"
            case .element95:                         return "element_95"
            case .element94:                         return "element_94"
            case .element93:                         return "element_93"
            case .element92:                         return "element_92"
            case .element91:                         return "element_91"
            case .element90:                         return "element_90"
            case .element99:                         return "element_99"
            case .element98:                         return "element_98"
            case .element68:                         return "element_68"
            case .element69:                         return "element_69"
            case .element62:                         return "element_62"
            case .element63:                         return "element_63"
            case .element60:                         return "element_60"
            case .element61:                         return "element_61"
            case .element66:                         return "element_66"
            case .element67:                         return "element_67"
            case .element64:                         return "element_64"
            case .element65:                         return "element_65"
            case .element79:                         return "element_79"
            case .element78:                         return "element_78"
            case .element75:                         return "element_75"
            case .element74:                         return "element_74"
            case .element77:                         return "element_77"
            case .element76:                         return "element_76"
            case .element71:                         return "element_71"
            case .element70:                         return "element_70"
            case .element73:                         return "element_73"
            case .element72:                         return "element_72"
            case .element40:                         return "element_40"
            case .element41:                         return "element_41"
            case .element42:                         return "element_42"
            case .element43:                         return "element_43"
            case .element44:                         return "element_44"
            case .element45:                         return "element_45"
            case .element46:                         return "element_46"
            case .element47:                         return "element_47"
            case .element48:                         return "element_48"
            case .element49:                         return "element_49"
            case .element53:                         return "element_53"
            case .element52:                         return "element_52"
            case .element51:                         return "element_51"
            case .element50:                         return "element_50"
            case .element57:                         return "element_57"
            case .element56:                         return "element_56"
            case .element55:                         return "element_55"
            case .element54:                         return "element_54"
            case .element59:                         return "element_59"
            case .element58:                         return "element_58"
            case .element26:                         return "element_26"
            case .element27:                         return "element_27"
            case .element24:                         return "element_24"
            case .element25:                         return "element_25"
            case .element22:                         return "element_22"
            case .element23:                         return "element_23"
            case .element20:                         return "element_20"
            case .element21:                         return "element_21"
            case .element28:                         return "element_28"
            case .element29:                         return "element_29"
            case .element39:                         return "element_39"
            case .element38:                         return "element_38"
            case .element31:                         return "element_31"
            case .element30:                         return "element_30"
            case .element33:                         return "element_33"
            case .element32:                         return "element_32"
            case .element35:                         return "element_35"
            case .element34:                         return "element_34"
            case .element37:                         return "element_37"
            case .element36:                         return "element_36"
            case .element19:                         return "element_19"
            case .element18:                         return "element_18"
            case .element17:                         return "element_17"
            case .element16:                         return "element_16"
            case .element15:                         return "element_15"
            case .element14:                         return "element_14"
            case .element13:                         return "element_13"
            case .element12:                         return "element_12"
            case .element11:                         return "element_11"
            case .element10:                         return "element_10"
            case .coloredTorchRg:                    return "colored_torch_rg"
            case .coloredTorchBp:                    return "colored_torch_bp"
            case .chemicalHeat:                      return "chemical_heat"
            case .netherreactor:                     return "netherreactor"
            case .chemistryTable:                    return "chemistry_table"
            case .camera:                            return "camera"
            case .element8:                          return "element_8"
            case .element9:                          return "element_9"
            case .element6:                          return "element_6"
            case .element7:                          return "element_7"
            case .element4:                          return "element_4"
            case .element5:                          return "element_5"
            case .element2:                          return "element_2"
            case .element3:                          return "element_3"
            case .element0:                          return "element_0"
            case .element1:                          return "element_1"
            case .allow:                             return "allow"
            case .hardStainedGlass:                  return "hard_stained_glass"
            case .deny:                              return "deny"
            case .element118:                        return "element_118"
            case .element114:                        return "element_114"
            case .element115:                        return "element_115"
            case .element116:                        return "element_116"
            case .element117:                        return "element_117"
            case .element110:                        return "element_110"
            case .element111:                        return "element_111"
            case .element112:                        return "element_112"
            case .element113:                        return "element_113"
            case .element109:                        return "element_109"
            case .element108:                        return "element_108"
            case .element107:                        return "element_107"
            case .element106:                        return "element_106"
            case .element105:                        return "element_105"
            case .element104:                        return "element_104"
            case .element103:                        return "element_103"
            case .element102:                        return "element_102"
            case .element101:                        return "element_101"
            case .element100:                        return "element_100"
            case .borderBlock:                       return "border_block"
            case .hardGlass:                         return "hard_glass"
            case .unknown:                           return "unknown"
            case .reserved6:                         return "reserved6"
            case .clientRequestPlaceholderBlock:     return "client_request_placeholder_block"
            case .frame:                             return "frame"
            case .glowingobsidian:                   return "glowingobsidian"
            case .underwaterTorch:                   return "underwater_torch"
            case .invisibleBedrock:                  return "invisible_bedrock"
            case .stonecutter:                       return "stonecutter"
            case .hardGlassPane:                     return "hard_glass_pane"
            case .lavaCauldron:                      return "lava_cauldron"
            case .infoUpdate:                        return "info_update"
            case .glowFrame:                         return "glow_frame"
        }
    }

    public init(stringLiteral value: String) {
        switch value {
            case "air":                               self = .air
            case "stone":                             self = .stone
            case "grass":                             self = .grass
            case "dirt":                              self = .dirt
            case "podzol":                            self = .podzol
            case "cobblestone":                       self = .cobblestone
            case "planks":                            self = .planks
            case "mangrovePlanks":                    self = .mangrovePlanks
            case "sapling":                           self = .sapling
            case "mangrovePropagule":                 self = .mangrovePropagule
            case "bedrock":                           self = .bedrock
            case "flowingWater":                      self = .flowingWater
            case "water":                             self = .water
            case "lava":                              self = .lava
            case "flowingLava":                       self = .flowingLava
            case "sand":                              self = .sand
            case "gravel":                            self = .gravel
            case "goldOre":                           self = .goldOre
            case "deepslateGoldOre":                  self = .deepslateGoldOre
            case "ironOre":                           self = .ironOre
            case "deepslateIronOre":                  self = .deepslateIronOre
            case "coalOre":                           self = .coalOre
            case "deepslateCoalOre":                  self = .deepslateCoalOre
            case "netherGoldOre":                     self = .netherGoldOre
            case "log":                               self = .log
            case "log2":                              self = .log2
            case "mangroveLog":                       self = .mangroveLog
            case "mangroveRoots":                     self = .mangroveRoots
            case "muddyMangroveRoots":                self = .muddyMangroveRoots
            case "strippedSpruceLog":                 self = .strippedSpruceLog
            case "strippedBirchLog":                  self = .strippedBirchLog
            case "strippedJungleLog":                 self = .strippedJungleLog
            case "strippedAcaciaLog":                 self = .strippedAcaciaLog
            case "strippedDarkOakLog":                self = .strippedDarkOakLog
            case "strippedOakLog":                    self = .strippedOakLog
            case "strippedMangroveLog":               self = .strippedMangroveLog
            case "wood":                              self = .wood
            case "mangroveWood":                      self = .mangroveWood
            case "strippedMangroveWood":              self = .strippedMangroveWood
            case "leaves":                            self = .leaves
            case "leaves2":                           self = .leaves2
            case "mangroveLeaves":                    self = .mangroveLeaves
            case "azaleaLeaves":                      self = .azaleaLeaves
            case "azaleaLeavesFlowered":              self = .azaleaLeavesFlowered
            case "sponge":                            self = .sponge
            case "glass":                             self = .glass
            case "lapisOre":                          self = .lapisOre
            case "deepslateLapisOre":                 self = .deepslateLapisOre
            case "lapisBlock":                        self = .lapisBlock
            case "dispenser":                         self = .dispenser
            case "sandstone":                         self = .sandstone
            case "noteblock":                         self = .noteblock
            case "bed":                               self = .bed
            case "goldenRail":                        self = .goldenRail
            case "detectorRail":                      self = .detectorRail
            case "stickyPiston":                      self = .stickyPiston
            case "web":                               self = .web
            case "tallgrass":                         self = .tallgrass
            case "deadbush":                          self = .deadbush
            case "seagrass":                          self = .seagrass
            case "piston":                            self = .piston
            case "pistonArmCollision":                self = .pistonArmCollision
            case "stickyPistonArmCollision":          self = .stickyPistonArmCollision
            case "wool":                              self = .wool
            case "movingBlock":                       self = .movingBlock
            case "yellowFlower":                      self = .yellowFlower
            case "redFlower":                         self = .redFlower
            case "witherRose":                        self = .witherRose
            case "brownMushroom":                     self = .brownMushroom
            case "redMushroom":                       self = .redMushroom
            case "goldBlock":                         self = .goldBlock
            case "ironBlock":                         self = .ironBlock
            case "brickBlock":                        self = .brickBlock
            case "tnt":                               self = .tnt
            case "bookshelf":                         self = .bookshelf
            case "mossyCobblestone":                  self = .mossyCobblestone
            case "obsidian":                          self = .obsidian
            case "torch":                             self = .torch
            case "fire":                              self = .fire
            case "soulFire":                          self = .soulFire
            case "mobSpawner":                        self = .mobSpawner
            case "oakStairs":                         self = .oakStairs
            case "chest":                             self = .chest
            case "redstoneWire":                      self = .redstoneWire
            case "diamondOre":                        self = .diamondOre
            case "deepslateDiamondOre":               self = .deepslateDiamondOre
            case "diamondBlock":                      self = .diamondBlock
            case "craftingTable":                     self = .craftingTable
            case "wheat":                             self = .wheat
            case "farmland":                          self = .farmland
            case "litFurnace":                        self = .litFurnace
            case "furnace":                           self = .furnace
            case "standingSign":                      self = .standingSign
            case "spruceStandingSign":                self = .spruceStandingSign
            case "birchStandingSign":                 self = .birchStandingSign
            case "acaciaStandingSign":                self = .acaciaStandingSign
            case "jungleStandingSign":                self = .jungleStandingSign
            case "darkoakStandingSign":               self = .darkoakStandingSign
            case "mangroveStandingSign":              self = .mangroveStandingSign
            case "woodenDoor":                        self = .woodenDoor
            case "ladder":                            self = .ladder
            case "rail":                              self = .rail
            case "stoneStairs":                       self = .stoneStairs
            case "wallSign":                          self = .wallSign
            case "spruceWallSign":                    self = .spruceWallSign
            case "birchWallSign":                     self = .birchWallSign
            case "acaciaWallSign":                    self = .acaciaWallSign
            case "jungleWallSign":                    self = .jungleWallSign
            case "darkoakWallSign":                   self = .darkoakWallSign
            case "mangroveWallSign":                  self = .mangroveWallSign
            case "lever":                             self = .lever
            case "stonePressurePlate":                self = .stonePressurePlate
            case "ironDoor":                          self = .ironDoor
            case "woodenPressurePlate":               self = .woodenPressurePlate
            case "sprucePressurePlate":               self = .sprucePressurePlate
            case "birchPressurePlate":                self = .birchPressurePlate
            case "junglePressurePlate":               self = .junglePressurePlate
            case "acaciaPressurePlate":               self = .acaciaPressurePlate
            case "darkOakPressurePlate":              self = .darkOakPressurePlate
            case "mangrovePressurePlate":             self = .mangrovePressurePlate
            case "redstoneOre":                       self = .redstoneOre
            case "litRedstoneOre":                    self = .litRedstoneOre
            case "deepslateRedstoneOre":              self = .deepslateRedstoneOre
            case "litDeepslateRedstoneOre":           self = .litDeepslateRedstoneOre
            case "redstoneTorch":                     self = .redstoneTorch
            case "unlitRedstoneTorch":                self = .unlitRedstoneTorch
            case "stoneButton":                       self = .stoneButton
            case "snowLayer":                         self = .snowLayer
            case "ice":                               self = .ice
            case "snow":                              self = .snow
            case "cactus":                            self = .cactus
            case "clay":                              self = .clay
            case "reeds":                             self = .reeds
            case "jukebox":                           self = .jukebox
            case "fence":                             self = .fence
            case "pumpkin":                           self = .pumpkin
            case "netherrack":                        self = .netherrack
            case "soulSand":                          self = .soulSand
            case "soulSoil":                          self = .soulSoil
            case "basalt":                            self = .basalt
            case "polishedBasalt":                    self = .polishedBasalt
            case "soulTorch":                         self = .soulTorch
            case "glowstone":                         self = .glowstone
            case "portal":                            self = .portal
            case "carvedPumpkin":                     self = .carvedPumpkin
            case "litPumpkin":                        self = .litPumpkin
            case "cake":                              self = .cake
            case "poweredRepeater":                   self = .poweredRepeater
            case "unpoweredRepeater":                 self = .unpoweredRepeater
            case "stainedGlass":                      self = .stainedGlass
            case "trapdoor":                          self = .trapdoor
            case "spruceTrapdoor":                    self = .spruceTrapdoor
            case "birchTrapdoor":                     self = .birchTrapdoor
            case "jungleTrapdoor":                    self = .jungleTrapdoor
            case "acaciaTrapdoor":                    self = .acaciaTrapdoor
            case "darkOakTrapdoor":                   self = .darkOakTrapdoor
            case "mangroveTrapdoor":                  self = .mangroveTrapdoor
            case "stonebrick":                        self = .stonebrick
            case "packedMud":                         self = .packedMud
            case "mudBricks":                         self = .mudBricks
            case "monsterEgg":                        self = .monsterEgg
            case "brownMushroomBlock":                self = .brownMushroomBlock
            case "redMushroomBlock":                  self = .redMushroomBlock
            case "ironBars":                          self = .ironBars
            case "chain":                             self = .chain
            case "glassPane":                         self = .glassPane
            case "melonBlock":                        self = .melonBlock
            case "pumpkinStem":                       self = .pumpkinStem
            case "melonStem":                         self = .melonStem
            case "vine":                              self = .vine
            case "glowLichen":                        self = .glowLichen
            case "fenceGate":                         self = .fenceGate
            case "brickStairs":                       self = .brickStairs
            case "stoneBrickStairs":                  self = .stoneBrickStairs
            case "mudBrickStairs":                    self = .mudBrickStairs
            case "mycelium":                          self = .mycelium
            case "waterlily":                         self = .waterlily
            case "netherBrick":                       self = .netherBrick
            case "netherBrickFence":                  self = .netherBrickFence
            case "netherBrickStairs":                 self = .netherBrickStairs
            case "netherWart":                        self = .netherWart
            case "enchantingTable":                   self = .enchantingTable
            case "brewingStand":                      self = .brewingStand
            case "cauldron":                          self = .cauldron
            case "endPortal":                         self = .endPortal
            case "endPortalFrame":                    self = .endPortalFrame
            case "endStone":                          self = .endStone
            case "dragonEgg":                         self = .dragonEgg
            case "redstoneLamp":                      self = .redstoneLamp
            case "litRedstoneLamp":                   self = .litRedstoneLamp
            case "cocoa":                             self = .cocoa
            case "sandstoneStairs":                   self = .sandstoneStairs
            case "emeraldOre":                        self = .emeraldOre
            case "deepslateEmeraldOre":               self = .deepslateEmeraldOre
            case "enderChest":                        self = .enderChest
            case "tripwireHook":                      self = .tripwireHook
            case "tripWire":                          self = .tripWire
            case "emeraldBlock":                      self = .emeraldBlock
            case "spruceStairs":                      self = .spruceStairs
            case "birchStairs":                       self = .birchStairs
            case "jungleStairs":                      self = .jungleStairs
            case "commandBlock":                      self = .commandBlock
            case "beacon":                            self = .beacon
            case "cobblestoneWall":                   self = .cobblestoneWall
            case "carrots":                           self = .carrots
            case "potatoes":                          self = .potatoes
            case "woodenButton":                      self = .woodenButton
            case "spruceButton":                      self = .spruceButton
            case "birchButton":                       self = .birchButton
            case "jungleButton":                      self = .jungleButton
            case "acaciaButton":                      self = .acaciaButton
            case "darkOakButton":                     self = .darkOakButton
            case "mangroveButton":                    self = .mangroveButton
            case "skull":                             self = .skull
            case "anvil":                             self = .anvil
            case "trappedChest":                      self = .trappedChest
            case "lightWeightedPressurePlate":        self = .lightWeightedPressurePlate
            case "heavyWeightedPressurePlate":        self = .heavyWeightedPressurePlate
            case "poweredComparator":                 self = .poweredComparator
            case "unpoweredComparator":               self = .unpoweredComparator
            case "daylightDetector":                  self = .daylightDetector
            case "daylightDetectorInverted":          self = .daylightDetectorInverted
            case "redstoneBlock":                     self = .redstoneBlock
            case "quartzOre":                         self = .quartzOre
            case "hopper":                            self = .hopper
            case "quartzBlock":                       self = .quartzBlock
            case "quartzStairs":                      self = .quartzStairs
            case "activatorRail":                     self = .activatorRail
            case "dropper":                           self = .dropper
            case "stainedHardenedClay":               self = .stainedHardenedClay
            case "stainedGlassPane":                  self = .stainedGlassPane
            case "acaciaStairs":                      self = .acaciaStairs
            case "darkOakStairs":                     self = .darkOakStairs
            case "mangroveStairs":                    self = .mangroveStairs
            case "slime":                             self = .slime
            case "barrier":                           self = .barrier
            case "lightBlock":                        self = .lightBlock
            case "ironTrapdoor":                      self = .ironTrapdoor
            case "prismarine":                        self = .prismarine
            case "prismarineStairs":                  self = .prismarineStairs
            case "prismarineBricksStairs":            self = .prismarineBricksStairs
            case "darkPrismarineStairs":              self = .darkPrismarineStairs
            case "stoneBlockSlab2":                   self = .stoneBlockSlab2
            case "doubleStoneBlockSlab2":             self = .doubleStoneBlockSlab2
            case "seaLantern":                        self = .seaLantern
            case "hayBlock":                          self = .hayBlock
            case "carpet":                            self = .carpet
            case "hardenedClay":                      self = .hardenedClay
            case "coalBlock":                         self = .coalBlock
            case "packedIce":                         self = .packedIce
            case "doublePlant":                       self = .doublePlant
            case "standingBanner":                    self = .standingBanner
            case "wallBanner":                        self = .wallBanner
            case "redSandstone":                      self = .redSandstone
            case "redSandstoneStairs":                self = .redSandstoneStairs
            case "woodenSlab":                        self = .woodenSlab
            case "doubleWoodenSlab":                  self = .doubleWoodenSlab
            case "mangroveDoubleSlab":                self = .mangroveDoubleSlab
            case "mangroveSlab":                      self = .mangroveSlab
            case "stoneBlockSlab4":                   self = .stoneBlockSlab4
            case "doubleStoneBlockSlab4":             self = .doubleStoneBlockSlab4
            case "stoneBlockSlab":                    self = .stoneBlockSlab
            case "doubleStoneBlockSlab":              self = .doubleStoneBlockSlab
            case "mudBrickDoubleSlab":                self = .mudBrickDoubleSlab
            case "mudBrickSlab":                      self = .mudBrickSlab
            case "smoothStone":                       self = .smoothStone
            case "spruceFenceGate":                   self = .spruceFenceGate
            case "birchFenceGate":                    self = .birchFenceGate
            case "jungleFenceGate":                   self = .jungleFenceGate
            case "acaciaFenceGate":                   self = .acaciaFenceGate
            case "darkOakFenceGate":                  self = .darkOakFenceGate
            case "mangroveFenceGate":                 self = .mangroveFenceGate
            case "mangroveFence":                     self = .mangroveFence
            case "spruceDoor":                        self = .spruceDoor
            case "birchDoor":                         self = .birchDoor
            case "jungleDoor":                        self = .jungleDoor
            case "acaciaDoor":                        self = .acaciaDoor
            case "darkOakDoor":                       self = .darkOakDoor
            case "mangroveDoor":                      self = .mangroveDoor
            case "endRod":                            self = .endRod
            case "chorusPlant":                       self = .chorusPlant
            case "chorusFlower":                      self = .chorusFlower
            case "purpurBlock":                       self = .purpurBlock
            case "purpurStairs":                      self = .purpurStairs
            case "endBricks":                         self = .endBricks
            case "beetroot":                          self = .beetroot
            case "grassPath":                         self = .grassPath
            case "endGateway":                        self = .endGateway
            case "repeatingCommandBlock":             self = .repeatingCommandBlock
            case "chainCommandBlock":                 self = .chainCommandBlock
            case "frostedIce":                        self = .frostedIce
            case "magma":                             self = .magma
            case "netherWartBlock":                   self = .netherWartBlock
            case "redNetherBrick":                    self = .redNetherBrick
            case "boneBlock":                         self = .boneBlock
            case "structureVoid":                     self = .structureVoid
            case "observer":                          self = .observer
            case "undyedShulkerBox":                  self = .undyedShulkerBox
            case "shulkerBox":                        self = .shulkerBox
            case "whiteGlazedTerracotta":             self = .whiteGlazedTerracotta
            case "orangeGlazedTerracotta":            self = .orangeGlazedTerracotta
            case "magentaGlazedTerracotta":           self = .magentaGlazedTerracotta
            case "lightBlueGlazedTerracotta":         self = .lightBlueGlazedTerracotta
            case "yellowGlazedTerracotta":            self = .yellowGlazedTerracotta
            case "limeGlazedTerracotta":              self = .limeGlazedTerracotta
            case "pinkGlazedTerracotta":              self = .pinkGlazedTerracotta
            case "grayGlazedTerracotta":              self = .grayGlazedTerracotta
            case "silverGlazedTerracotta":            self = .silverGlazedTerracotta
            case "cyanGlazedTerracotta":              self = .cyanGlazedTerracotta
            case "purpleGlazedTerracotta":            self = .purpleGlazedTerracotta
            case "blueGlazedTerracotta":              self = .blueGlazedTerracotta
            case "brownGlazedTerracotta":             self = .brownGlazedTerracotta
            case "greenGlazedTerracotta":             self = .greenGlazedTerracotta
            case "redGlazedTerracotta":               self = .redGlazedTerracotta
            case "blackGlazedTerracotta":             self = .blackGlazedTerracotta
            case "concrete":                          self = .concrete
            case "concretePowder":                    self = .concretePowder
            case "kelp":                              self = .kelp
            case "driedKelpBlock":                    self = .driedKelpBlock
            case "turtleEgg":                         self = .turtleEgg
            case "coralBlock":                        self = .coralBlock
            case "coral":                             self = .coral
            case "coralFanDead":                      self = .coralFanDead
            case "coralFan":                          self = .coralFan
            case "coralFanHang":                      self = .coralFanHang
            case "coralFanHang2":                     self = .coralFanHang2
            case "coralFanHang3":                     self = .coralFanHang3
            case "seaPickle":                         self = .seaPickle
            case "blueIce":                           self = .blueIce
            case "conduit":                           self = .conduit
            case "bambooSapling":                     self = .bambooSapling
            case "bamboo":                            self = .bamboo
            case "bubbleColumn":                      self = .bubbleColumn
            case "polishedGraniteStairs":             self = .polishedGraniteStairs
            case "smoothRedSandstoneStairs":          self = .smoothRedSandstoneStairs
            case "mossyStoneBrickStairs":             self = .mossyStoneBrickStairs
            case "polishedDioriteStairs":             self = .polishedDioriteStairs
            case "mossyCobblestoneStairs":            self = .mossyCobblestoneStairs
            case "endBrickStairs":                    self = .endBrickStairs
            case "normalStoneStairs":                 self = .normalStoneStairs
            case "smoothSandstoneStairs":             self = .smoothSandstoneStairs
            case "smoothQuartzStairs":                self = .smoothQuartzStairs
            case "graniteStairs":                     self = .graniteStairs
            case "andesiteStairs":                    self = .andesiteStairs
            case "redNetherBrickStairs":              self = .redNetherBrickStairs
            case "polishedAndesiteStairs":            self = .polishedAndesiteStairs
            case "dioriteStairs":                     self = .dioriteStairs
            case "stoneBlockSlab3":                   self = .stoneBlockSlab3
            case "doubleStoneBlockSlab3":             self = .doubleStoneBlockSlab3
            case "mudBrickWall":                      self = .mudBrickWall
            case "scaffolding":                       self = .scaffolding
            case "loom":                              self = .loom
            case "barrel":                            self = .barrel
            case "smoker":                            self = .smoker
            case "litSmoker":                         self = .litSmoker
            case "litBlastFurnace":                   self = .litBlastFurnace
            case "blastFurnace":                      self = .blastFurnace
            case "cartographyTable":                  self = .cartographyTable
            case "fletchingTable":                    self = .fletchingTable
            case "grindstone":                        self = .grindstone
            case "lectern":                           self = .lectern
            case "smithingTable":                     self = .smithingTable
            case "stonecutterBlock":                  self = .stonecutterBlock
            case "bell":                              self = .bell
            case "lantern":                           self = .lantern
            case "soulLantern":                       self = .soulLantern
            case "campfire":                          self = .campfire
            case "soulCampfire":                      self = .soulCampfire
            case "sweetBerryBush":                    self = .sweetBerryBush
            case "warpedStem":                        self = .warpedStem
            case "strippedWarpedStem":                self = .strippedWarpedStem
            case "warpedHyphae":                      self = .warpedHyphae
            case "strippedWarpedHyphae":              self = .strippedWarpedHyphae
            case "warpedNylium":                      self = .warpedNylium
            case "warpedFungus":                      self = .warpedFungus
            case "warpedWartBlock":                   self = .warpedWartBlock
            case "warpedRoots":                       self = .warpedRoots
            case "netherSprouts":                     self = .netherSprouts
            case "crimsonStem":                       self = .crimsonStem
            case "strippedCrimsonStem":               self = .strippedCrimsonStem
            case "crimsonHyphae":                     self = .crimsonHyphae
            case "strippedCrimsonHyphae":             self = .strippedCrimsonHyphae
            case "crimsonNylium":                     self = .crimsonNylium
            case "crimsonFungus":                     self = .crimsonFungus
            case "shroomlight":                       self = .shroomlight
            case "weepingVines":                      self = .weepingVines
            case "twistingVines":                     self = .twistingVines
            case "crimsonRoots":                      self = .crimsonRoots
            case "crimsonPlanks":                     self = .crimsonPlanks
            case "warpedPlanks":                      self = .warpedPlanks
            case "crimsonDoubleSlab":                 self = .crimsonDoubleSlab
            case "crimsonSlab":                       self = .crimsonSlab
            case "warpedDoubleSlab":                  self = .warpedDoubleSlab
            case "warpedSlab":                        self = .warpedSlab
            case "crimsonPressurePlate":              self = .crimsonPressurePlate
            case "warpedPressurePlate":               self = .warpedPressurePlate
            case "crimsonFence":                      self = .crimsonFence
            case "warpedFence":                       self = .warpedFence
            case "crimsonTrapdoor":                   self = .crimsonTrapdoor
            case "warpedTrapdoor":                    self = .warpedTrapdoor
            case "crimsonFenceGate":                  self = .crimsonFenceGate
            case "warpedFenceGate":                   self = .warpedFenceGate
            case "crimsonStairs":                     self = .crimsonStairs
            case "warpedStairs":                      self = .warpedStairs
            case "crimsonButton":                     self = .crimsonButton
            case "warpedButton":                      self = .warpedButton
            case "crimsonDoor":                       self = .crimsonDoor
            case "warpedDoor":                        self = .warpedDoor
            case "crimsonStandingSign":               self = .crimsonStandingSign
            case "warpedStandingSign":                self = .warpedStandingSign
            case "crimsonWallSign":                   self = .crimsonWallSign
            case "warpedWallSign":                    self = .warpedWallSign
            case "structureBlock":                    self = .structureBlock
            case "jigsaw":                            self = .jigsaw
            case "composter":                         self = .composter
            case "target":                            self = .target
            case "beeNest":                           self = .beeNest
            case "beehive":                           self = .beehive
            case "honeyBlock":                        self = .honeyBlock
            case "honeycombBlock":                    self = .honeycombBlock
            case "netheriteBlock":                    self = .netheriteBlock
            case "ancientDebris":                     self = .ancientDebris
            case "cryingObsidian":                    self = .cryingObsidian
            case "respawnAnchor":                     self = .respawnAnchor
            case "lodestone":                         self = .lodestone
            case "blackstone":                        self = .blackstone
            case "blackstoneStairs":                  self = .blackstoneStairs
            case "blackstoneWall":                    self = .blackstoneWall
            case "blackstoneDoubleSlab":              self = .blackstoneDoubleSlab
            case "blackstoneSlab":                    self = .blackstoneSlab
            case "polishedBlackstone":                self = .polishedBlackstone
            case "polishedBlackstoneBricks":          self = .polishedBlackstoneBricks
            case "crackedPolishedBlackstoneBricks":   self = .crackedPolishedBlackstoneBricks
            case "chiseledPolishedBlackstone":        self = .chiseledPolishedBlackstone
            case "polishedBlackstoneBrickDoubleSlab": self = .polishedBlackstoneBrickDoubleSlab
            case "polishedBlackstoneBrickSlab":       self = .polishedBlackstoneBrickSlab
            case "polishedBlackstoneBrickStairs":     self = .polishedBlackstoneBrickStairs
            case "polishedBlackstoneBrickWall":       self = .polishedBlackstoneBrickWall
            case "gildedBlackstone":                  self = .gildedBlackstone
            case "polishedBlackstoneStairs":          self = .polishedBlackstoneStairs
            case "polishedBlackstoneDoubleSlab":      self = .polishedBlackstoneDoubleSlab
            case "polishedBlackstoneSlab":            self = .polishedBlackstoneSlab
            case "polishedBlackstonePressurePlate":   self = .polishedBlackstonePressurePlate
            case "polishedBlackstoneButton":          self = .polishedBlackstoneButton
            case "polishedBlackstoneWall":            self = .polishedBlackstoneWall
            case "chiseledNetherBricks":              self = .chiseledNetherBricks
            case "crackedNetherBricks":               self = .crackedNetherBricks
            case "quartzBricks":                      self = .quartzBricks
            case "candle":                            self = .candle
            case "whiteCandle":                       self = .whiteCandle
            case "orangeCandle":                      self = .orangeCandle
            case "magentaCandle":                     self = .magentaCandle
            case "lightBlueCandle":                   self = .lightBlueCandle
            case "yellowCandle":                      self = .yellowCandle
            case "limeCandle":                        self = .limeCandle
            case "pinkCandle":                        self = .pinkCandle
            case "grayCandle":                        self = .grayCandle
            case "lightGrayCandle":                   self = .lightGrayCandle
            case "cyanCandle":                        self = .cyanCandle
            case "purpleCandle":                      self = .purpleCandle
            case "blueCandle":                        self = .blueCandle
            case "brownCandle":                       self = .brownCandle
            case "greenCandle":                       self = .greenCandle
            case "redCandle":                         self = .redCandle
            case "blackCandle":                       self = .blackCandle
            case "candleCake":                        self = .candleCake
            case "whiteCandleCake":                   self = .whiteCandleCake
            case "orangeCandleCake":                  self = .orangeCandleCake
            case "magentaCandleCake":                 self = .magentaCandleCake
            case "lightBlueCandleCake":               self = .lightBlueCandleCake
            case "yellowCandleCake":                  self = .yellowCandleCake
            case "limeCandleCake":                    self = .limeCandleCake
            case "pinkCandleCake":                    self = .pinkCandleCake
            case "grayCandleCake":                    self = .grayCandleCake
            case "lightGrayCandleCake":               self = .lightGrayCandleCake
            case "cyanCandleCake":                    self = .cyanCandleCake
            case "purpleCandleCake":                  self = .purpleCandleCake
            case "blueCandleCake":                    self = .blueCandleCake
            case "brownCandleCake":                   self = .brownCandleCake
            case "greenCandleCake":                   self = .greenCandleCake
            case "redCandleCake":                     self = .redCandleCake
            case "blackCandleCake":                   self = .blackCandleCake
            case "amethystBlock":                     self = .amethystBlock
            case "buddingAmethyst":                   self = .buddingAmethyst
            case "amethystCluster":                   self = .amethystCluster
            case "largeAmethystBud":                  self = .largeAmethystBud
            case "mediumAmethystBud":                 self = .mediumAmethystBud
            case "smallAmethystBud":                  self = .smallAmethystBud
            case "tuff":                              self = .tuff
            case "calcite":                           self = .calcite
            case "tintedGlass":                       self = .tintedGlass
            case "powderSnow":                        self = .powderSnow
            case "sculkSensor":                       self = .sculkSensor
            case "sculk":                             self = .sculk
            case "sculkVein":                         self = .sculkVein
            case "sculkCatalyst":                     self = .sculkCatalyst
            case "sculkShrieker":                     self = .sculkShrieker
            case "oxidizedCopper":                    self = .oxidizedCopper
            case "weatheredCopper":                   self = .weatheredCopper
            case "exposedCopper":                     self = .exposedCopper
            case "copperBlock":                       self = .copperBlock
            case "copperOre":                         self = .copperOre
            case "deepslateCopperOre":                self = .deepslateCopperOre
            case "oxidizedCutCopper":                 self = .oxidizedCutCopper
            case "weatheredCutCopper":                self = .weatheredCutCopper
            case "exposedCutCopper":                  self = .exposedCutCopper
            case "cutCopper":                         self = .cutCopper
            case "oxidizedCutCopperStairs":           self = .oxidizedCutCopperStairs
            case "weatheredCutCopperStairs":          self = .weatheredCutCopperStairs
            case "exposedCutCopperStairs":            self = .exposedCutCopperStairs
            case "cutCopperStairs":                   self = .cutCopperStairs
            case "oxidizedDoubleCutCopperSlab":       self = .oxidizedDoubleCutCopperSlab
            case "oxidizedCutCopperSlab":             self = .oxidizedCutCopperSlab
            case "weatheredCutCopperSlab":            self = .weatheredCutCopperSlab
            case "weatheredDoubleCutCopperSlab":      self = .weatheredDoubleCutCopperSlab
            case "exposedDoubleCutCopperSlab":        self = .exposedDoubleCutCopperSlab
            case "exposedCutCopperSlab":              self = .exposedCutCopperSlab
            case "doubleCutCopperSlab":               self = .doubleCutCopperSlab
            case "cutCopperSlab":                     self = .cutCopperSlab
            case "waxedCopper":                       self = .waxedCopper
            case "waxedWeatheredCopper":              self = .waxedWeatheredCopper
            case "waxedExposedCopper":                self = .waxedExposedCopper
            case "waxedOxidizedCopper":               self = .waxedOxidizedCopper
            case "waxedOxidizedCutCopper":            self = .waxedOxidizedCutCopper
            case "waxedWeatheredCutCopper":           self = .waxedWeatheredCutCopper
            case "waxedExposedCutCopper":             self = .waxedExposedCutCopper
            case "waxedCutCopper":                    self = .waxedCutCopper
            case "waxedOxidizedCutCopperStairs":      self = .waxedOxidizedCutCopperStairs
            case "waxedWeatheredCutCopperStairs":     self = .waxedWeatheredCutCopperStairs
            case "waxedExposedCutCopperStairs":       self = .waxedExposedCutCopperStairs
            case "waxedCutCopperStairs":              self = .waxedCutCopperStairs
            case "waxedOxidizedCutCopperSlab":        self = .waxedOxidizedCutCopperSlab
            case "waxedOxidizedDoubleCutCopperSlab":  self = .waxedOxidizedDoubleCutCopperSlab
            case "waxedWeatheredDoubleCutCopperSlab": self = .waxedWeatheredDoubleCutCopperSlab
            case "waxedWeatheredCutCopperSlab":       self = .waxedWeatheredCutCopperSlab
            case "waxedExposedCutCopperSlab":         self = .waxedExposedCutCopperSlab
            case "waxedExposedDoubleCutCopperSlab":   self = .waxedExposedDoubleCutCopperSlab
            case "waxedDoubleCutCopperSlab":          self = .waxedDoubleCutCopperSlab
            case "waxedCutCopperSlab":                self = .waxedCutCopperSlab
            case "lightningRod":                      self = .lightningRod
            case "pointedDripstone":                  self = .pointedDripstone
            case "dripstoneBlock":                    self = .dripstoneBlock
            case "caveVinesHeadWithBerries":          self = .caveVinesHeadWithBerries
            case "caveVines":                         self = .caveVines
            case "caveVinesBodyWithBerries":          self = .caveVinesBodyWithBerries
            case "sporeBlossom":                      self = .sporeBlossom
            case "azalea":                            self = .azalea
            case "floweringAzalea":                   self = .floweringAzalea
            case "mossCarpet":                        self = .mossCarpet
            case "mossBlock":                         self = .mossBlock
            case "bigDripleaf":                       self = .bigDripleaf
            case "smallDripleafBlock":                self = .smallDripleafBlock
            case "hangingRoots":                      self = .hangingRoots
            case "dirtWithRoots":                     self = .dirtWithRoots
            case "mud":                               self = .mud
            case "deepslate":                         self = .deepslate
            case "cobbledDeepslate":                  self = .cobbledDeepslate
            case "cobbledDeepslateStairs":            self = .cobbledDeepslateStairs
            case "cobbledDeepslateDoubleSlab":        self = .cobbledDeepslateDoubleSlab
            case "cobbledDeepslateSlab":              self = .cobbledDeepslateSlab
            case "cobbledDeepslateWall":              self = .cobbledDeepslateWall
            case "polishedDeepslate":                 self = .polishedDeepslate
            case "polishedDeepslateStairs":           self = .polishedDeepslateStairs
            case "polishedDeepslateSlab":             self = .polishedDeepslateSlab
            case "polishedDeepslateDoubleSlab":       self = .polishedDeepslateDoubleSlab
            case "polishedDeepslateWall":             self = .polishedDeepslateWall
            case "deepslateTiles":                    self = .deepslateTiles
            case "deepslateTileStairs":               self = .deepslateTileStairs
            case "deepslateTileDoubleSlab":           self = .deepslateTileDoubleSlab
            case "deepslateTileSlab":                 self = .deepslateTileSlab
            case "deepslateTileWall":                 self = .deepslateTileWall
            case "deepslateBricks":                   self = .deepslateBricks
            case "deepslateBrickStairs":              self = .deepslateBrickStairs
            case "deepslateBrickDoubleSlab":          self = .deepslateBrickDoubleSlab
            case "deepslateBrickSlab":                self = .deepslateBrickSlab
            case "deepslateBrickWall":                self = .deepslateBrickWall
            case "chiseledDeepslate":                 self = .chiseledDeepslate
            case "crackedDeepslateBricks":            self = .crackedDeepslateBricks
            case "crackedDeepslateTiles":             self = .crackedDeepslateTiles
            case "infestedDeepslate":                 self = .infestedDeepslate
            case "smoothBasalt":                      self = .smoothBasalt
            case "rawIronBlock":                      self = .rawIronBlock
            case "rawCopperBlock":                    self = .rawCopperBlock
            case "rawGoldBlock":                      self = .rawGoldBlock
            case "flowerPot":                         self = .flowerPot
            case "ochreFroglight":                    self = .ochreFroglight
            case "verdantFroglight":                  self = .verdantFroglight
            case "pearlescentFroglight":              self = .pearlescentFroglight
            case "frogSpawn":                         self = .frogSpawn
            case "reinforcedDeepslate":               self = .reinforcedDeepslate
            case "hardStainedGlassPane":              self = .hardStainedGlassPane
            case "infoUpdate2":                       self = .infoUpdate2
            case "element84":                         self = .element84
            case "element85":                         self = .element85
            case "element86":                         self = .element86
            case "element87":                         self = .element87
            case "element80":                         self = .element80
            case "element81":                         self = .element81
            case "element82":                         self = .element82
            case "element83":                         self = .element83
            case "element88":                         self = .element88
            case "element89":                         self = .element89
            case "element97":                         self = .element97
            case "element96":                         self = .element96
            case "element95":                         self = .element95
            case "element94":                         self = .element94
            case "element93":                         self = .element93
            case "element92":                         self = .element92
            case "element91":                         self = .element91
            case "element90":                         self = .element90
            case "element99":                         self = .element99
            case "element98":                         self = .element98
            case "element68":                         self = .element68
            case "element69":                         self = .element69
            case "element62":                         self = .element62
            case "element63":                         self = .element63
            case "element60":                         self = .element60
            case "element61":                         self = .element61
            case "element66":                         self = .element66
            case "element67":                         self = .element67
            case "element64":                         self = .element64
            case "element65":                         self = .element65
            case "element79":                         self = .element79
            case "element78":                         self = .element78
            case "element75":                         self = .element75
            case "element74":                         self = .element74
            case "element77":                         self = .element77
            case "element76":                         self = .element76
            case "element71":                         self = .element71
            case "element70":                         self = .element70
            case "element73":                         self = .element73
            case "element72":                         self = .element72
            case "element40":                         self = .element40
            case "element41":                         self = .element41
            case "element42":                         self = .element42
            case "element43":                         self = .element43
            case "element44":                         self = .element44
            case "element45":                         self = .element45
            case "element46":                         self = .element46
            case "element47":                         self = .element47
            case "element48":                         self = .element48
            case "element49":                         self = .element49
            case "element53":                         self = .element53
            case "element52":                         self = .element52
            case "element51":                         self = .element51
            case "element50":                         self = .element50
            case "element57":                         self = .element57
            case "element56":                         self = .element56
            case "element55":                         self = .element55
            case "element54":                         self = .element54
            case "element59":                         self = .element59
            case "element58":                         self = .element58
            case "element26":                         self = .element26
            case "element27":                         self = .element27
            case "element24":                         self = .element24
            case "element25":                         self = .element25
            case "element22":                         self = .element22
            case "element23":                         self = .element23
            case "element20":                         self = .element20
            case "element21":                         self = .element21
            case "element28":                         self = .element28
            case "element29":                         self = .element29
            case "element39":                         self = .element39
            case "element38":                         self = .element38
            case "element31":                         self = .element31
            case "element30":                         self = .element30
            case "element33":                         self = .element33
            case "element32":                         self = .element32
            case "element35":                         self = .element35
            case "element34":                         self = .element34
            case "element37":                         self = .element37
            case "element36":                         self = .element36
            case "element19":                         self = .element19
            case "element18":                         self = .element18
            case "element17":                         self = .element17
            case "element16":                         self = .element16
            case "element15":                         self = .element15
            case "element14":                         self = .element14
            case "element13":                         self = .element13
            case "element12":                         self = .element12
            case "element11":                         self = .element11
            case "element10":                         self = .element10
            case "coloredTorchRg":                    self = .coloredTorchRg
            case "coloredTorchBp":                    self = .coloredTorchBp
            case "chemicalHeat":                      self = .chemicalHeat
            case "netherreactor":                     self = .netherreactor
            case "chemistryTable":                    self = .chemistryTable
            case "camera":                            self = .camera
            case "element8":                          self = .element8
            case "element9":                          self = .element9
            case "element6":                          self = .element6
            case "element7":                          self = .element7
            case "element4":                          self = .element4
            case "element5":                          self = .element5
            case "element2":                          self = .element2
            case "element3":                          self = .element3
            case "element0":                          self = .element0
            case "element1":                          self = .element1
            case "allow":                             self = .allow
            case "hardStainedGlass":                  self = .hardStainedGlass
            case "deny":                              self = .deny
            case "element118":                        self = .element118
            case "element114":                        self = .element114
            case "element115":                        self = .element115
            case "element116":                        self = .element116
            case "element117":                        self = .element117
            case "element110":                        self = .element110
            case "element111":                        self = .element111
            case "element112":                        self = .element112
            case "element113":                        self = .element113
            case "element109":                        self = .element109
            case "element108":                        self = .element108
            case "element107":                        self = .element107
            case "element106":                        self = .element106
            case "element105":                        self = .element105
            case "element104":                        self = .element104
            case "element103":                        self = .element103
            case "element102":                        self = .element102
            case "element101":                        self = .element101
            case "element100":                        self = .element100
            case "borderBlock":                       self = .borderBlock
            case "hardGlass":                         self = .hardGlass
            case "unknown":                           self = .unknown
            case "reserved6":                         self = .reserved6
            case "clientRequestPlaceholderBlock":     self = .clientRequestPlaceholderBlock
            case "frame":                             self = .frame
            case "glowingobsidian":                   self = .glowingobsidian
            case "underwaterTorch":                   self = .underwaterTorch
            case "invisibleBedrock":                  self = .invisibleBedrock
            case "stonecutter":                       self = .stonecutter
            case "hardGlassPane":                     self = .hardGlassPane
            case "lavaCauldron":                      self = .lavaCauldron
            case "infoUpdate":                        self = .infoUpdate
            case "glowFrame":                         self = .glowFrame
            default:                                  self = .unknown
        }
    }

    public var isOpaque: Bool {
        switch self {
            case .air:
                return true
            default:
                return false
        }
    }

    public var color: UInt32 {
        switch self {
            case .air:
                return 0xFF204080
            default:
                return 0x00000000
        }
    }
}




