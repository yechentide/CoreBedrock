/**
 Minecraft blocks

 [Data source](https://github.com/PrismarineJS/minecraft-data/blob/master/data/bedrock/1.19.1/blocks.json)
 */
public enum MCBlockType: UInt32 {
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
}

extension MCBlockType: CustomStringConvertible {
    public var description: String {
        switch self {
            case .air:                               return "minecraft:air"
            case .stone:                             return "minecraft:stone"
            case .grass:                             return "minecraft:grass"
            case .dirt:                              return "minecraft:dirt"
            case .podzol:                            return "minecraft:podzol"
            case .cobblestone:                       return "minecraft:cobblestone"
            case .planks:                            return "minecraft:planks"
            case .mangrovePlanks:                    return "minecraft:mangrove_planks"
            case .sapling:                           return "minecraft:sapling"
            case .mangrovePropagule:                 return "minecraft:mangrove_propagule"
            case .bedrock:                           return "minecraft:bedrock"
            case .flowingWater:                      return "minecraft:flowing_water"
            case .water:                             return "minecraft:water"
            case .lava:                              return "minecraft:lava"
            case .flowingLava:                       return "minecraft:flowing_lava"
            case .sand:                              return "minecraft:sand"
            case .gravel:                            return "minecraft:gravel"
            case .goldOre:                           return "minecraft:gold_ore"
            case .deepslateGoldOre:                  return "minecraft:deepslate_gold_ore"
            case .ironOre:                           return "minecraft:iron_ore"
            case .deepslateIronOre:                  return "minecraft:deepslate_iron_ore"
            case .coalOre:                           return "minecraft:coal_ore"
            case .deepslateCoalOre:                  return "minecraft:deepslate_coal_ore"
            case .netherGoldOre:                     return "minecraft:nether_gold_ore"
            case .log:                               return "minecraft:log"
            case .log2:                              return "minecraft:log2"
            case .mangroveLog:                       return "minecraft:mangrove_log"
            case .mangroveRoots:                     return "minecraft:mangrove_roots"
            case .muddyMangroveRoots:                return "minecraft:muddy_mangrove_roots"
            case .strippedSpruceLog:                 return "minecraft:stripped_spruce_log"
            case .strippedBirchLog:                  return "minecraft:stripped_birch_log"
            case .strippedJungleLog:                 return "minecraft:stripped_jungle_log"
            case .strippedAcaciaLog:                 return "minecraft:stripped_acacia_log"
            case .strippedDarkOakLog:                return "minecraft:stripped_dark_oak_log"
            case .strippedOakLog:                    return "minecraft:stripped_oak_log"
            case .strippedMangroveLog:               return "minecraft:stripped_mangrove_log"
            case .wood:                              return "minecraft:wood"
            case .mangroveWood:                      return "minecraft:mangrove_wood"
            case .strippedMangroveWood:              return "minecraft:stripped_mangrove_wood"
            case .leaves:                            return "minecraft:leaves"
            case .leaves2:                           return "minecraft:leaves2"
            case .mangroveLeaves:                    return "minecraft:mangrove_leaves"
            case .azaleaLeaves:                      return "minecraft:azalea_leaves"
            case .azaleaLeavesFlowered:              return "minecraft:azalea_leaves_flowered"
            case .sponge:                            return "minecraft:sponge"
            case .glass:                             return "minecraft:glass"
            case .lapisOre:                          return "minecraft:lapis_ore"
            case .deepslateLapisOre:                 return "minecraft:deepslate_lapis_ore"
            case .lapisBlock:                        return "minecraft:lapis_block"
            case .dispenser:                         return "minecraft:dispenser"
            case .sandstone:                         return "minecraft:sandstone"
            case .noteblock:                         return "minecraft:noteblock"
            case .bed:                               return "minecraft:bed"
            case .goldenRail:                        return "minecraft:golden_rail"
            case .detectorRail:                      return "minecraft:detector_rail"
            case .stickyPiston:                      return "minecraft:sticky_piston"
            case .web:                               return "minecraft:web"
            case .tallgrass:                         return "minecraft:tallgrass"
            case .deadbush:                          return "minecraft:deadbush"
            case .seagrass:                          return "minecraft:seagrass"
            case .piston:                            return "minecraft:piston"
            case .pistonArmCollision:                return "minecraft:piston_arm_collision"
            case .stickyPistonArmCollision:          return "minecraft:sticky_piston_arm_collision"
            case .wool:                              return "minecraft:wool"
            case .movingBlock:                       return "minecraft:moving_block"
            case .yellowFlower:                      return "minecraft:yellow_flower"
            case .redFlower:                         return "minecraft:red_flower"
            case .witherRose:                        return "minecraft:wither_rose"
            case .brownMushroom:                     return "minecraft:brown_mushroom"
            case .redMushroom:                       return "minecraft:red_mushroom"
            case .goldBlock:                         return "minecraft:gold_block"
            case .ironBlock:                         return "minecraft:iron_block"
            case .brickBlock:                        return "minecraft:brick_block"
            case .tnt:                               return "minecraft:tnt"
            case .bookshelf:                         return "minecraft:bookshelf"
            case .mossyCobblestone:                  return "minecraft:mossy_cobblestone"
            case .obsidian:                          return "minecraft:obsidian"
            case .torch:                             return "minecraft:torch"
            case .fire:                              return "minecraft:fire"
            case .soulFire:                          return "minecraft:soul_fire"
            case .mobSpawner:                        return "minecraft:mob_spawner"
            case .oakStairs:                         return "minecraft:oak_stairs"
            case .chest:                             return "minecraft:chest"
            case .redstoneWire:                      return "minecraft:redstone_wire"
            case .diamondOre:                        return "minecraft:diamond_ore"
            case .deepslateDiamondOre:               return "minecraft:deepslate_diamond_ore"
            case .diamondBlock:                      return "minecraft:diamond_block"
            case .craftingTable:                     return "minecraft:crafting_table"
            case .wheat:                             return "minecraft:wheat"
            case .farmland:                          return "minecraft:farmland"
            case .litFurnace:                        return "minecraft:lit_furnace"
            case .furnace:                           return "minecraft:furnace"
            case .standingSign:                      return "minecraft:standing_sign"
            case .spruceStandingSign:                return "minecraft:spruce_standing_sign"
            case .birchStandingSign:                 return "minecraft:birch_standing_sign"
            case .acaciaStandingSign:                return "minecraft:acacia_standing_sign"
            case .jungleStandingSign:                return "minecraft:jungle_standing_sign"
            case .darkoakStandingSign:               return "minecraft:darkoak_standing_sign"
            case .mangroveStandingSign:              return "minecraft:mangrove_standing_sign"
            case .woodenDoor:                        return "minecraft:wooden_door"
            case .ladder:                            return "minecraft:ladder"
            case .rail:                              return "minecraft:rail"
            case .stoneStairs:                       return "minecraft:stone_stairs"
            case .wallSign:                          return "minecraft:wall_sign"
            case .spruceWallSign:                    return "minecraft:spruce_wall_sign"
            case .birchWallSign:                     return "minecraft:birch_wall_sign"
            case .acaciaWallSign:                    return "minecraft:acacia_wall_sign"
            case .jungleWallSign:                    return "minecraft:jungle_wall_sign"
            case .darkoakWallSign:                   return "minecraft:darkoak_wall_sign"
            case .mangroveWallSign:                  return "minecraft:mangrove_wall_sign"
            case .lever:                             return "minecraft:lever"
            case .stonePressurePlate:                return "minecraft:stone_pressure_plate"
            case .ironDoor:                          return "minecraft:iron_door"
            case .woodenPressurePlate:               return "minecraft:wooden_pressure_plate"
            case .sprucePressurePlate:               return "minecraft:spruce_pressure_plate"
            case .birchPressurePlate:                return "minecraft:birch_pressure_plate"
            case .junglePressurePlate:               return "minecraft:jungle_pressure_plate"
            case .acaciaPressurePlate:               return "minecraft:acacia_pressure_plate"
            case .darkOakPressurePlate:              return "minecraft:dark_oak_pressure_plate"
            case .mangrovePressurePlate:             return "minecraft:mangrove_pressure_plate"
            case .redstoneOre:                       return "minecraft:redstone_ore"
            case .litRedstoneOre:                    return "minecraft:lit_redstone_ore"
            case .deepslateRedstoneOre:              return "minecraft:deepslate_redstone_ore"
            case .litDeepslateRedstoneOre:           return "minecraft:lit_deepslate_redstone_ore"
            case .redstoneTorch:                     return "minecraft:redstone_torch"
            case .unlitRedstoneTorch:                return "minecraft:unlit_redstone_torch"
            case .stoneButton:                       return "minecraft:stone_button"
            case .snowLayer:                         return "minecraft:snow_layer"
            case .ice:                               return "minecraft:ice"
            case .snow:                              return "minecraft:snow"
            case .cactus:                            return "minecraft:cactus"
            case .clay:                              return "minecraft:clay"
            case .reeds:                             return "minecraft:reeds"
            case .jukebox:                           return "minecraft:jukebox"
            case .fence:                             return "minecraft:fence"
            case .pumpkin:                           return "minecraft:pumpkin"
            case .netherrack:                        return "minecraft:netherrack"
            case .soulSand:                          return "minecraft:soul_sand"
            case .soulSoil:                          return "minecraft:soul_soil"
            case .basalt:                            return "minecraft:basalt"
            case .polishedBasalt:                    return "minecraft:polished_basalt"
            case .soulTorch:                         return "minecraft:soul_torch"
            case .glowstone:                         return "minecraft:glowstone"
            case .portal:                            return "minecraft:portal"
            case .carvedPumpkin:                     return "minecraft:carved_pumpkin"
            case .litPumpkin:                        return "minecraft:lit_pumpkin"
            case .cake:                              return "minecraft:cake"
            case .poweredRepeater:                   return "minecraft:powered_repeater"
            case .unpoweredRepeater:                 return "minecraft:unpowered_repeater"
            case .stainedGlass:                      return "minecraft:stained_glass"
            case .trapdoor:                          return "minecraft:trapdoor"
            case .spruceTrapdoor:                    return "minecraft:spruce_trapdoor"
            case .birchTrapdoor:                     return "minecraft:birch_trapdoor"
            case .jungleTrapdoor:                    return "minecraft:jungle_trapdoor"
            case .acaciaTrapdoor:                    return "minecraft:acacia_trapdoor"
            case .darkOakTrapdoor:                   return "minecraft:dark_oak_trapdoor"
            case .mangroveTrapdoor:                  return "minecraft:mangrove_trapdoor"
            case .stonebrick:                        return "minecraft:stonebrick"
            case .packedMud:                         return "minecraft:packed_mud"
            case .mudBricks:                         return "minecraft:mud_bricks"
            case .monsterEgg:                        return "minecraft:monster_egg"
            case .brownMushroomBlock:                return "minecraft:brown_mushroom_block"
            case .redMushroomBlock:                  return "minecraft:red_mushroom_block"
            case .ironBars:                          return "minecraft:iron_bars"
            case .chain:                             return "minecraft:chain"
            case .glassPane:                         return "minecraft:glass_pane"
            case .melonBlock:                        return "minecraft:melon_block"
            case .pumpkinStem:                       return "minecraft:pumpkin_stem"
            case .melonStem:                         return "minecraft:melon_stem"
            case .vine:                              return "minecraft:vine"
            case .glowLichen:                        return "minecraft:glow_lichen"
            case .fenceGate:                         return "minecraft:fence_gate"
            case .brickStairs:                       return "minecraft:brick_stairs"
            case .stoneBrickStairs:                  return "minecraft:stone_brick_stairs"
            case .mudBrickStairs:                    return "minecraft:mud_brick_stairs"
            case .mycelium:                          return "minecraft:mycelium"
            case .waterlily:                         return "minecraft:waterlily"
            case .netherBrick:                       return "minecraft:nether_brick"
            case .netherBrickFence:                  return "minecraft:nether_brick_fence"
            case .netherBrickStairs:                 return "minecraft:nether_brick_stairs"
            case .netherWart:                        return "minecraft:nether_wart"
            case .enchantingTable:                   return "minecraft:enchanting_table"
            case .brewingStand:                      return "minecraft:brewing_stand"
            case .cauldron:                          return "minecraft:cauldron"
            case .endPortal:                         return "minecraft:end_portal"
            case .endPortalFrame:                    return "minecraft:end_portal_frame"
            case .endStone:                          return "minecraft:end_stone"
            case .dragonEgg:                         return "minecraft:dragon_egg"
            case .redstoneLamp:                      return "minecraft:redstone_lamp"
            case .litRedstoneLamp:                   return "minecraft:lit_redstone_lamp"
            case .cocoa:                             return "minecraft:cocoa"
            case .sandstoneStairs:                   return "minecraft:sandstone_stairs"
            case .emeraldOre:                        return "minecraft:emerald_ore"
            case .deepslateEmeraldOre:               return "minecraft:deepslate_emerald_ore"
            case .enderChest:                        return "minecraft:ender_chest"
            case .tripwireHook:                      return "minecraft:tripwire_hook"
            case .tripWire:                          return "minecraft:trip_wire"
            case .emeraldBlock:                      return "minecraft:emerald_block"
            case .spruceStairs:                      return "minecraft:spruce_stairs"
            case .birchStairs:                       return "minecraft:birch_stairs"
            case .jungleStairs:                      return "minecraft:jungle_stairs"
            case .commandBlock:                      return "minecraft:command_block"
            case .beacon:                            return "minecraft:beacon"
            case .cobblestoneWall:                   return "minecraft:cobblestone_wall"
            case .carrots:                           return "minecraft:carrots"
            case .potatoes:                          return "minecraft:potatoes"
            case .woodenButton:                      return "minecraft:wooden_button"
            case .spruceButton:                      return "minecraft:spruce_button"
            case .birchButton:                       return "minecraft:birch_button"
            case .jungleButton:                      return "minecraft:jungle_button"
            case .acaciaButton:                      return "minecraft:acacia_button"
            case .darkOakButton:                     return "minecraft:dark_oak_button"
            case .mangroveButton:                    return "minecraft:mangrove_button"
            case .skull:                             return "minecraft:skull"
            case .anvil:                             return "minecraft:anvil"
            case .trappedChest:                      return "minecraft:trapped_chest"
            case .lightWeightedPressurePlate:        return "minecraft:light_weighted_pressure_plate"
            case .heavyWeightedPressurePlate:        return "minecraft:heavy_weighted_pressure_plate"
            case .poweredComparator:                 return "minecraft:powered_comparator"
            case .unpoweredComparator:               return "minecraft:unpowered_comparator"
            case .daylightDetector:                  return "minecraft:daylight_detector"
            case .daylightDetectorInverted:          return "minecraft:daylight_detector_inverted"
            case .redstoneBlock:                     return "minecraft:redstone_block"
            case .quartzOre:                         return "minecraft:quartz_ore"
            case .hopper:                            return "minecraft:hopper"
            case .quartzBlock:                       return "minecraft:quartz_block"
            case .quartzStairs:                      return "minecraft:quartz_stairs"
            case .activatorRail:                     return "minecraft:activator_rail"
            case .dropper:                           return "minecraft:dropper"
            case .stainedHardenedClay:               return "minecraft:stained_hardened_clay"
            case .stainedGlassPane:                  return "minecraft:stained_glass_pane"
            case .acaciaStairs:                      return "minecraft:acacia_stairs"
            case .darkOakStairs:                     return "minecraft:dark_oak_stairs"
            case .mangroveStairs:                    return "minecraft:mangrove_stairs"
            case .slime:                             return "minecraft:slime"
            case .barrier:                           return "minecraft:barrier"
            case .lightBlock:                        return "minecraft:light_block"
            case .ironTrapdoor:                      return "minecraft:iron_trapdoor"
            case .prismarine:                        return "minecraft:prismarine"
            case .prismarineStairs:                  return "minecraft:prismarine_stairs"
            case .prismarineBricksStairs:            return "minecraft:prismarine_bricks_stairs"
            case .darkPrismarineStairs:              return "minecraft:dark_prismarine_stairs"
            case .stoneBlockSlab2:                   return "minecraft:stone_block_slab2"
            case .doubleStoneBlockSlab2:             return "minecraft:double_stone_block_slab2"
            case .seaLantern:                        return "minecraft:sea_lantern"
            case .hayBlock:                          return "minecraft:hay_block"
            case .carpet:                            return "minecraft:carpet"
            case .hardenedClay:                      return "minecraft:hardened_clay"
            case .coalBlock:                         return "minecraft:coal_block"
            case .packedIce:                         return "minecraft:packed_ice"
            case .doublePlant:                       return "minecraft:double_plant"
            case .standingBanner:                    return "minecraft:standing_banner"
            case .wallBanner:                        return "minecraft:wall_banner"
            case .redSandstone:                      return "minecraft:red_sandstone"
            case .redSandstoneStairs:                return "minecraft:red_sandstone_stairs"
            case .woodenSlab:                        return "minecraft:wooden_slab"
            case .doubleWoodenSlab:                  return "minecraft:double_wooden_slab"
            case .mangroveDoubleSlab:                return "minecraft:mangrove_double_slab"
            case .mangroveSlab:                      return "minecraft:mangrove_slab"
            case .stoneBlockSlab4:                   return "minecraft:stone_block_slab4"
            case .doubleStoneBlockSlab4:             return "minecraft:double_stone_block_slab4"
            case .stoneBlockSlab:                    return "minecraft:stone_block_slab"
            case .doubleStoneBlockSlab:              return "minecraft:double_stone_block_slab"
            case .mudBrickDoubleSlab:                return "minecraft:mud_brick_double_slab"
            case .mudBrickSlab:                      return "minecraft:mud_brick_slab"
            case .smoothStone:                       return "minecraft:smooth_stone"
            case .spruceFenceGate:                   return "minecraft:spruce_fence_gate"
            case .birchFenceGate:                    return "minecraft:birch_fence_gate"
            case .jungleFenceGate:                   return "minecraft:jungle_fence_gate"
            case .acaciaFenceGate:                   return "minecraft:acacia_fence_gate"
            case .darkOakFenceGate:                  return "minecraft:dark_oak_fence_gate"
            case .mangroveFenceGate:                 return "minecraft:mangrove_fence_gate"
            case .mangroveFence:                     return "minecraft:mangrove_fence"
            case .spruceDoor:                        return "minecraft:spruce_door"
            case .birchDoor:                         return "minecraft:birch_door"
            case .jungleDoor:                        return "minecraft:jungle_door"
            case .acaciaDoor:                        return "minecraft:acacia_door"
            case .darkOakDoor:                       return "minecraft:dark_oak_door"
            case .mangroveDoor:                      return "minecraft:mangrove_door"
            case .endRod:                            return "minecraft:end_rod"
            case .chorusPlant:                       return "minecraft:chorus_plant"
            case .chorusFlower:                      return "minecraft:chorus_flower"
            case .purpurBlock:                       return "minecraft:purpur_block"
            case .purpurStairs:                      return "minecraft:purpur_stairs"
            case .endBricks:                         return "minecraft:end_bricks"
            case .beetroot:                          return "minecraft:beetroot"
            case .grassPath:                         return "minecraft:grass_path"
            case .endGateway:                        return "minecraft:end_gateway"
            case .repeatingCommandBlock:             return "minecraft:repeating_command_block"
            case .chainCommandBlock:                 return "minecraft:chain_command_block"
            case .frostedIce:                        return "minecraft:frosted_ice"
            case .magma:                             return "minecraft:magma"
            case .netherWartBlock:                   return "minecraft:nether_wart_block"
            case .redNetherBrick:                    return "minecraft:red_nether_brick"
            case .boneBlock:                         return "minecraft:bone_block"
            case .structureVoid:                     return "minecraft:structure_void"
            case .observer:                          return "minecraft:observer"
            case .undyedShulkerBox:                  return "minecraft:undyed_shulker_box"
            case .shulkerBox:                        return "minecraft:shulker_box"
            case .whiteGlazedTerracotta:             return "minecraft:white_glazed_terracotta"
            case .orangeGlazedTerracotta:            return "minecraft:orange_glazed_terracotta"
            case .magentaGlazedTerracotta:           return "minecraft:magenta_glazed_terracotta"
            case .lightBlueGlazedTerracotta:         return "minecraft:light_blue_glazed_terracotta"
            case .yellowGlazedTerracotta:            return "minecraft:yellow_glazed_terracotta"
            case .limeGlazedTerracotta:              return "minecraft:lime_glazed_terracotta"
            case .pinkGlazedTerracotta:              return "minecraft:pink_glazed_terracotta"
            case .grayGlazedTerracotta:              return "minecraft:gray_glazed_terracotta"
            case .silverGlazedTerracotta:            return "minecraft:silver_glazed_terracotta"
            case .cyanGlazedTerracotta:              return "minecraft:cyan_glazed_terracotta"
            case .purpleGlazedTerracotta:            return "minecraft:purple_glazed_terracotta"
            case .blueGlazedTerracotta:              return "minecraft:blue_glazed_terracotta"
            case .brownGlazedTerracotta:             return "minecraft:brown_glazed_terracotta"
            case .greenGlazedTerracotta:             return "minecraft:green_glazed_terracotta"
            case .redGlazedTerracotta:               return "minecraft:red_glazed_terracotta"
            case .blackGlazedTerracotta:             return "minecraft:black_glazed_terracotta"
            case .concrete:                          return "minecraft:concrete"
            case .concretePowder:                    return "minecraft:concrete_powder"
            case .kelp:                              return "minecraft:kelp"
            case .driedKelpBlock:                    return "minecraft:dried_kelp_block"
            case .turtleEgg:                         return "minecraft:turtle_egg"
            case .coralBlock:                        return "minecraft:coral_block"
            case .coral:                             return "minecraft:coral"
            case .coralFanDead:                      return "minecraft:coral_fan_dead"
            case .coralFan:                          return "minecraft:coral_fan"
            case .coralFanHang:                      return "minecraft:coral_fan_hang"
            case .coralFanHang2:                     return "minecraft:coral_fan_hang2"
            case .coralFanHang3:                     return "minecraft:coral_fan_hang3"
            case .seaPickle:                         return "minecraft:sea_pickle"
            case .blueIce:                           return "minecraft:blue_ice"
            case .conduit:                           return "minecraft:conduit"
            case .bambooSapling:                     return "minecraft:bamboo_sapling"
            case .bamboo:                            return "minecraft:bamboo"
            case .bubbleColumn:                      return "minecraft:bubble_column"
            case .polishedGraniteStairs:             return "minecraft:polished_granite_stairs"
            case .smoothRedSandstoneStairs:          return "minecraft:smooth_red_sandstone_stairs"
            case .mossyStoneBrickStairs:             return "minecraft:mossy_stone_brick_stairs"
            case .polishedDioriteStairs:             return "minecraft:polished_diorite_stairs"
            case .mossyCobblestoneStairs:            return "minecraft:mossy_cobblestone_stairs"
            case .endBrickStairs:                    return "minecraft:end_brick_stairs"
            case .normalStoneStairs:                 return "minecraft:normal_stone_stairs"
            case .smoothSandstoneStairs:             return "minecraft:smooth_sandstone_stairs"
            case .smoothQuartzStairs:                return "minecraft:smooth_quartz_stairs"
            case .graniteStairs:                     return "minecraft:granite_stairs"
            case .andesiteStairs:                    return "minecraft:andesite_stairs"
            case .redNetherBrickStairs:              return "minecraft:red_nether_brick_stairs"
            case .polishedAndesiteStairs:            return "minecraft:polished_andesite_stairs"
            case .dioriteStairs:                     return "minecraft:diorite_stairs"
            case .stoneBlockSlab3:                   return "minecraft:stone_block_slab3"
            case .doubleStoneBlockSlab3:             return "minecraft:double_stone_block_slab3"
            case .mudBrickWall:                      return "minecraft:mud_brick_wall"
            case .scaffolding:                       return "minecraft:scaffolding"
            case .loom:                              return "minecraft:loom"
            case .barrel:                            return "minecraft:barrel"
            case .smoker:                            return "minecraft:smoker"
            case .litSmoker:                         return "minecraft:lit_smoker"
            case .litBlastFurnace:                   return "minecraft:lit_blast_furnace"
            case .blastFurnace:                      return "minecraft:blast_furnace"
            case .cartographyTable:                  return "minecraft:cartography_table"
            case .fletchingTable:                    return "minecraft:fletching_table"
            case .grindstone:                        return "minecraft:grindstone"
            case .lectern:                           return "minecraft:lectern"
            case .smithingTable:                     return "minecraft:smithing_table"
            case .stonecutterBlock:                  return "minecraft:stonecutter_block"
            case .bell:                              return "minecraft:bell"
            case .lantern:                           return "minecraft:lantern"
            case .soulLantern:                       return "minecraft:soul_lantern"
            case .campfire:                          return "minecraft:campfire"
            case .soulCampfire:                      return "minecraft:soul_campfire"
            case .sweetBerryBush:                    return "minecraft:sweet_berry_bush"
            case .warpedStem:                        return "minecraft:warped_stem"
            case .strippedWarpedStem:                return "minecraft:stripped_warped_stem"
            case .warpedHyphae:                      return "minecraft:warped_hyphae"
            case .strippedWarpedHyphae:              return "minecraft:stripped_warped_hyphae"
            case .warpedNylium:                      return "minecraft:warped_nylium"
            case .warpedFungus:                      return "minecraft:warped_fungus"
            case .warpedWartBlock:                   return "minecraft:warped_wart_block"
            case .warpedRoots:                       return "minecraft:warped_roots"
            case .netherSprouts:                     return "minecraft:nether_sprouts"
            case .crimsonStem:                       return "minecraft:crimson_stem"
            case .strippedCrimsonStem:               return "minecraft:stripped_crimson_stem"
            case .crimsonHyphae:                     return "minecraft:crimson_hyphae"
            case .strippedCrimsonHyphae:             return "minecraft:stripped_crimson_hyphae"
            case .crimsonNylium:                     return "minecraft:crimson_nylium"
            case .crimsonFungus:                     return "minecraft:crimson_fungus"
            case .shroomlight:                       return "minecraft:shroomlight"
            case .weepingVines:                      return "minecraft:weeping_vines"
            case .twistingVines:                     return "minecraft:twisting_vines"
            case .crimsonRoots:                      return "minecraft:crimson_roots"
            case .crimsonPlanks:                     return "minecraft:crimson_planks"
            case .warpedPlanks:                      return "minecraft:warped_planks"
            case .crimsonDoubleSlab:                 return "minecraft:crimson_double_slab"
            case .crimsonSlab:                       return "minecraft:crimson_slab"
            case .warpedDoubleSlab:                  return "minecraft:warped_double_slab"
            case .warpedSlab:                        return "minecraft:warped_slab"
            case .crimsonPressurePlate:              return "minecraft:crimson_pressure_plate"
            case .warpedPressurePlate:               return "minecraft:warped_pressure_plate"
            case .crimsonFence:                      return "minecraft:crimson_fence"
            case .warpedFence:                       return "minecraft:warped_fence"
            case .crimsonTrapdoor:                   return "minecraft:crimson_trapdoor"
            case .warpedTrapdoor:                    return "minecraft:warped_trapdoor"
            case .crimsonFenceGate:                  return "minecraft:crimson_fence_gate"
            case .warpedFenceGate:                   return "minecraft:warped_fence_gate"
            case .crimsonStairs:                     return "minecraft:crimson_stairs"
            case .warpedStairs:                      return "minecraft:warped_stairs"
            case .crimsonButton:                     return "minecraft:crimson_button"
            case .warpedButton:                      return "minecraft:warped_button"
            case .crimsonDoor:                       return "minecraft:crimson_door"
            case .warpedDoor:                        return "minecraft:warped_door"
            case .crimsonStandingSign:               return "minecraft:crimson_standing_sign"
            case .warpedStandingSign:                return "minecraft:warped_standing_sign"
            case .crimsonWallSign:                   return "minecraft:crimson_wall_sign"
            case .warpedWallSign:                    return "minecraft:warped_wall_sign"
            case .structureBlock:                    return "minecraft:structure_block"
            case .jigsaw:                            return "minecraft:jigsaw"
            case .composter:                         return "minecraft:composter"
            case .target:                            return "minecraft:target"
            case .beeNest:                           return "minecraft:bee_nest"
            case .beehive:                           return "minecraft:beehive"
            case .honeyBlock:                        return "minecraft:honey_block"
            case .honeycombBlock:                    return "minecraft:honeycomb_block"
            case .netheriteBlock:                    return "minecraft:netherite_block"
            case .ancientDebris:                     return "minecraft:ancient_debris"
            case .cryingObsidian:                    return "minecraft:crying_obsidian"
            case .respawnAnchor:                     return "minecraft:respawn_anchor"
            case .lodestone:                         return "minecraft:lodestone"
            case .blackstone:                        return "minecraft:blackstone"
            case .blackstoneStairs:                  return "minecraft:blackstone_stairs"
            case .blackstoneWall:                    return "minecraft:blackstone_wall"
            case .blackstoneDoubleSlab:              return "minecraft:blackstone_double_slab"
            case .blackstoneSlab:                    return "minecraft:blackstone_slab"
            case .polishedBlackstone:                return "minecraft:polished_blackstone"
            case .polishedBlackstoneBricks:          return "minecraft:polished_blackstone_bricks"
            case .crackedPolishedBlackstoneBricks:   return "minecraft:cracked_polished_blackstone_bricks"
            case .chiseledPolishedBlackstone:        return "minecraft:chiseled_polished_blackstone"
            case .polishedBlackstoneBrickDoubleSlab: return "minecraft:polished_blackstone_brick_double_slab"
            case .polishedBlackstoneBrickSlab:       return "minecraft:polished_blackstone_brick_slab"
            case .polishedBlackstoneBrickStairs:     return "minecraft:polished_blackstone_brick_stairs"
            case .polishedBlackstoneBrickWall:       return "minecraft:polished_blackstone_brick_wall"
            case .gildedBlackstone:                  return "minecraft:gilded_blackstone"
            case .polishedBlackstoneStairs:          return "minecraft:polished_blackstone_stairs"
            case .polishedBlackstoneDoubleSlab:      return "minecraft:polished_blackstone_double_slab"
            case .polishedBlackstoneSlab:            return "minecraft:polished_blackstone_slab"
            case .polishedBlackstonePressurePlate:   return "minecraft:polished_blackstone_pressure_plate"
            case .polishedBlackstoneButton:          return "minecraft:polished_blackstone_button"
            case .polishedBlackstoneWall:            return "minecraft:polished_blackstone_wall"
            case .chiseledNetherBricks:              return "minecraft:chiseled_nether_bricks"
            case .crackedNetherBricks:               return "minecraft:cracked_nether_bricks"
            case .quartzBricks:                      return "minecraft:quartz_bricks"
            case .candle:                            return "minecraft:candle"
            case .whiteCandle:                       return "minecraft:white_candle"
            case .orangeCandle:                      return "minecraft:orange_candle"
            case .magentaCandle:                     return "minecraft:magenta_candle"
            case .lightBlueCandle:                   return "minecraft:light_blue_candle"
            case .yellowCandle:                      return "minecraft:yellow_candle"
            case .limeCandle:                        return "minecraft:lime_candle"
            case .pinkCandle:                        return "minecraft:pink_candle"
            case .grayCandle:                        return "minecraft:gray_candle"
            case .lightGrayCandle:                   return "minecraft:light_gray_candle"
            case .cyanCandle:                        return "minecraft:cyan_candle"
            case .purpleCandle:                      return "minecraft:purple_candle"
            case .blueCandle:                        return "minecraft:blue_candle"
            case .brownCandle:                       return "minecraft:brown_candle"
            case .greenCandle:                       return "minecraft:green_candle"
            case .redCandle:                         return "minecraft:red_candle"
            case .blackCandle:                       return "minecraft:black_candle"
            case .candleCake:                        return "minecraft:candle_cake"
            case .whiteCandleCake:                   return "minecraft:white_candle_cake"
            case .orangeCandleCake:                  return "minecraft:orange_candle_cake"
            case .magentaCandleCake:                 return "minecraft:magenta_candle_cake"
            case .lightBlueCandleCake:               return "minecraft:light_blue_candle_cake"
            case .yellowCandleCake:                  return "minecraft:yellow_candle_cake"
            case .limeCandleCake:                    return "minecraft:lime_candle_cake"
            case .pinkCandleCake:                    return "minecraft:pink_candle_cake"
            case .grayCandleCake:                    return "minecraft:gray_candle_cake"
            case .lightGrayCandleCake:               return "minecraft:light_gray_candle_cake"
            case .cyanCandleCake:                    return "minecraft:cyan_candle_cake"
            case .purpleCandleCake:                  return "minecraft:purple_candle_cake"
            case .blueCandleCake:                    return "minecraft:blue_candle_cake"
            case .brownCandleCake:                   return "minecraft:brown_candle_cake"
            case .greenCandleCake:                   return "minecraft:green_candle_cake"
            case .redCandleCake:                     return "minecraft:red_candle_cake"
            case .blackCandleCake:                   return "minecraft:black_candle_cake"
            case .amethystBlock:                     return "minecraft:amethyst_block"
            case .buddingAmethyst:                   return "minecraft:budding_amethyst"
            case .amethystCluster:                   return "minecraft:amethyst_cluster"
            case .largeAmethystBud:                  return "minecraft:large_amethyst_bud"
            case .mediumAmethystBud:                 return "minecraft:medium_amethyst_bud"
            case .smallAmethystBud:                  return "minecraft:small_amethyst_bud"
            case .tuff:                              return "minecraft:tuff"
            case .calcite:                           return "minecraft:calcite"
            case .tintedGlass:                       return "minecraft:tinted_glass"
            case .powderSnow:                        return "minecraft:powder_snow"
            case .sculkSensor:                       return "minecraft:sculk_sensor"
            case .sculk:                             return "minecraft:sculk"
            case .sculkVein:                         return "minecraft:sculk_vein"
            case .sculkCatalyst:                     return "minecraft:sculk_catalyst"
            case .sculkShrieker:                     return "minecraft:sculk_shrieker"
            case .oxidizedCopper:                    return "minecraft:oxidized_copper"
            case .weatheredCopper:                   return "minecraft:weathered_copper"
            case .exposedCopper:                     return "minecraft:exposed_copper"
            case .copperBlock:                       return "minecraft:copper_block"
            case .copperOre:                         return "minecraft:copper_ore"
            case .deepslateCopperOre:                return "minecraft:deepslate_copper_ore"
            case .oxidizedCutCopper:                 return "minecraft:oxidized_cut_copper"
            case .weatheredCutCopper:                return "minecraft:weathered_cut_copper"
            case .exposedCutCopper:                  return "minecraft:exposed_cut_copper"
            case .cutCopper:                         return "minecraft:cut_copper"
            case .oxidizedCutCopperStairs:           return "minecraft:oxidized_cut_copper_stairs"
            case .weatheredCutCopperStairs:          return "minecraft:weathered_cut_copper_stairs"
            case .exposedCutCopperStairs:            return "minecraft:exposed_cut_copper_stairs"
            case .cutCopperStairs:                   return "minecraft:cut_copper_stairs"
            case .oxidizedDoubleCutCopperSlab:       return "minecraft:oxidized_double_cut_copper_slab"
            case .oxidizedCutCopperSlab:             return "minecraft:oxidized_cut_copper_slab"
            case .weatheredCutCopperSlab:            return "minecraft:weathered_cut_copper_slab"
            case .weatheredDoubleCutCopperSlab:      return "minecraft:weathered_double_cut_copper_slab"
            case .exposedDoubleCutCopperSlab:        return "minecraft:exposed_double_cut_copper_slab"
            case .exposedCutCopperSlab:              return "minecraft:exposed_cut_copper_slab"
            case .doubleCutCopperSlab:               return "minecraft:double_cut_copper_slab"
            case .cutCopperSlab:                     return "minecraft:cut_copper_slab"
            case .waxedCopper:                       return "minecraft:waxed_copper"
            case .waxedWeatheredCopper:              return "minecraft:waxed_weathered_copper"
            case .waxedExposedCopper:                return "minecraft:waxed_exposed_copper"
            case .waxedOxidizedCopper:               return "minecraft:waxed_oxidized_copper"
            case .waxedOxidizedCutCopper:            return "minecraft:waxed_oxidized_cut_copper"
            case .waxedWeatheredCutCopper:           return "minecraft:waxed_weathered_cut_copper"
            case .waxedExposedCutCopper:             return "minecraft:waxed_exposed_cut_copper"
            case .waxedCutCopper:                    return "minecraft:waxed_cut_copper"
            case .waxedOxidizedCutCopperStairs:      return "minecraft:waxed_oxidized_cut_copper_stairs"
            case .waxedWeatheredCutCopperStairs:     return "minecraft:waxed_weathered_cut_copper_stairs"
            case .waxedExposedCutCopperStairs:       return "minecraft:waxed_exposed_cut_copper_stairs"
            case .waxedCutCopperStairs:              return "minecraft:waxed_cut_copper_stairs"
            case .waxedOxidizedCutCopperSlab:        return "minecraft:waxed_oxidized_cut_copper_slab"
            case .waxedOxidizedDoubleCutCopperSlab:  return "minecraft:waxed_oxidized_double_cut_copper_slab"
            case .waxedWeatheredDoubleCutCopperSlab: return "minecraft:waxed_weathered_double_cut_copper_slab"
            case .waxedWeatheredCutCopperSlab:       return "minecraft:waxed_weathered_cut_copper_slab"
            case .waxedExposedCutCopperSlab:         return "minecraft:waxed_exposed_cut_copper_slab"
            case .waxedExposedDoubleCutCopperSlab:   return "minecraft:waxed_exposed_double_cut_copper_slab"
            case .waxedDoubleCutCopperSlab:          return "minecraft:waxed_double_cut_copper_slab"
            case .waxedCutCopperSlab:                return "minecraft:waxed_cut_copper_slab"
            case .lightningRod:                      return "minecraft:lightning_rod"
            case .pointedDripstone:                  return "minecraft:pointed_dripstone"
            case .dripstoneBlock:                    return "minecraft:dripstone_block"
            case .caveVinesHeadWithBerries:          return "minecraft:cave_vines_head_with_berries"
            case .caveVines:                         return "minecraft:cave_vines"
            case .caveVinesBodyWithBerries:          return "minecraft:cave_vines_body_with_berries"
            case .sporeBlossom:                      return "minecraft:spore_blossom"
            case .azalea:                            return "minecraft:azalea"
            case .floweringAzalea:                   return "minecraft:flowering_azalea"
            case .mossCarpet:                        return "minecraft:moss_carpet"
            case .mossBlock:                         return "minecraft:moss_block"
            case .bigDripleaf:                       return "minecraft:big_dripleaf"
            case .smallDripleafBlock:                return "minecraft:small_dripleaf_block"
            case .hangingRoots:                      return "minecraft:hanging_roots"
            case .dirtWithRoots:                     return "minecraft:dirt_with_roots"
            case .mud:                               return "minecraft:mud"
            case .deepslate:                         return "minecraft:deepslate"
            case .cobbledDeepslate:                  return "minecraft:cobbled_deepslate"
            case .cobbledDeepslateStairs:            return "minecraft:cobbled_deepslate_stairs"
            case .cobbledDeepslateDoubleSlab:        return "minecraft:cobbled_deepslate_double_slab"
            case .cobbledDeepslateSlab:              return "minecraft:cobbled_deepslate_slab"
            case .cobbledDeepslateWall:              return "minecraft:cobbled_deepslate_wall"
            case .polishedDeepslate:                 return "minecraft:polished_deepslate"
            case .polishedDeepslateStairs:           return "minecraft:polished_deepslate_stairs"
            case .polishedDeepslateSlab:             return "minecraft:polished_deepslate_slab"
            case .polishedDeepslateDoubleSlab:       return "minecraft:polished_deepslate_double_slab"
            case .polishedDeepslateWall:             return "minecraft:polished_deepslate_wall"
            case .deepslateTiles:                    return "minecraft:deepslate_tiles"
            case .deepslateTileStairs:               return "minecraft:deepslate_tile_stairs"
            case .deepslateTileDoubleSlab:           return "minecraft:deepslate_tile_double_slab"
            case .deepslateTileSlab:                 return "minecraft:deepslate_tile_slab"
            case .deepslateTileWall:                 return "minecraft:deepslate_tile_wall"
            case .deepslateBricks:                   return "minecraft:deepslate_bricks"
            case .deepslateBrickStairs:              return "minecraft:deepslate_brick_stairs"
            case .deepslateBrickDoubleSlab:          return "minecraft:deepslate_brick_double_slab"
            case .deepslateBrickSlab:                return "minecraft:deepslate_brick_slab"
            case .deepslateBrickWall:                return "minecraft:deepslate_brick_wall"
            case .chiseledDeepslate:                 return "minecraft:chiseled_deepslate"
            case .crackedDeepslateBricks:            return "minecraft:cracked_deepslate_bricks"
            case .crackedDeepslateTiles:             return "minecraft:cracked_deepslate_tiles"
            case .infestedDeepslate:                 return "minecraft:infested_deepslate"
            case .smoothBasalt:                      return "minecraft:smooth_basalt"
            case .rawIronBlock:                      return "minecraft:raw_iron_block"
            case .rawCopperBlock:                    return "minecraft:raw_copper_block"
            case .rawGoldBlock:                      return "minecraft:raw_gold_block"
            case .flowerPot:                         return "minecraft:flower_pot"
            case .ochreFroglight:                    return "minecraft:ochre_froglight"
            case .verdantFroglight:                  return "minecraft:verdant_froglight"
            case .pearlescentFroglight:              return "minecraft:pearlescent_froglight"
            case .frogSpawn:                         return "minecraft:frog_spawn"
            case .reinforcedDeepslate:               return "minecraft:reinforced_deepslate"
            case .hardStainedGlassPane:              return "minecraft:hard_stained_glass_pane"
            case .infoUpdate2:                       return "minecraft:info_update2"
            case .element84:                         return "minecraft:element_84"
            case .element85:                         return "minecraft:element_85"
            case .element86:                         return "minecraft:element_86"
            case .element87:                         return "minecraft:element_87"
            case .element80:                         return "minecraft:element_80"
            case .element81:                         return "minecraft:element_81"
            case .element82:                         return "minecraft:element_82"
            case .element83:                         return "minecraft:element_83"
            case .element88:                         return "minecraft:element_88"
            case .element89:                         return "minecraft:element_89"
            case .element97:                         return "minecraft:element_97"
            case .element96:                         return "minecraft:element_96"
            case .element95:                         return "minecraft:element_95"
            case .element94:                         return "minecraft:element_94"
            case .element93:                         return "minecraft:element_93"
            case .element92:                         return "minecraft:element_92"
            case .element91:                         return "minecraft:element_91"
            case .element90:                         return "minecraft:element_90"
            case .element99:                         return "minecraft:element_99"
            case .element98:                         return "minecraft:element_98"
            case .element68:                         return "minecraft:element_68"
            case .element69:                         return "minecraft:element_69"
            case .element62:                         return "minecraft:element_62"
            case .element63:                         return "minecraft:element_63"
            case .element60:                         return "minecraft:element_60"
            case .element61:                         return "minecraft:element_61"
            case .element66:                         return "minecraft:element_66"
            case .element67:                         return "minecraft:element_67"
            case .element64:                         return "minecraft:element_64"
            case .element65:                         return "minecraft:element_65"
            case .element79:                         return "minecraft:element_79"
            case .element78:                         return "minecraft:element_78"
            case .element75:                         return "minecraft:element_75"
            case .element74:                         return "minecraft:element_74"
            case .element77:                         return "minecraft:element_77"
            case .element76:                         return "minecraft:element_76"
            case .element71:                         return "minecraft:element_71"
            case .element70:                         return "minecraft:element_70"
            case .element73:                         return "minecraft:element_73"
            case .element72:                         return "minecraft:element_72"
            case .element40:                         return "minecraft:element_40"
            case .element41:                         return "minecraft:element_41"
            case .element42:                         return "minecraft:element_42"
            case .element43:                         return "minecraft:element_43"
            case .element44:                         return "minecraft:element_44"
            case .element45:                         return "minecraft:element_45"
            case .element46:                         return "minecraft:element_46"
            case .element47:                         return "minecraft:element_47"
            case .element48:                         return "minecraft:element_48"
            case .element49:                         return "minecraft:element_49"
            case .element53:                         return "minecraft:element_53"
            case .element52:                         return "minecraft:element_52"
            case .element51:                         return "minecraft:element_51"
            case .element50:                         return "minecraft:element_50"
            case .element57:                         return "minecraft:element_57"
            case .element56:                         return "minecraft:element_56"
            case .element55:                         return "minecraft:element_55"
            case .element54:                         return "minecraft:element_54"
            case .element59:                         return "minecraft:element_59"
            case .element58:                         return "minecraft:element_58"
            case .element26:                         return "minecraft:element_26"
            case .element27:                         return "minecraft:element_27"
            case .element24:                         return "minecraft:element_24"
            case .element25:                         return "minecraft:element_25"
            case .element22:                         return "minecraft:element_22"
            case .element23:                         return "minecraft:element_23"
            case .element20:                         return "minecraft:element_20"
            case .element21:                         return "minecraft:element_21"
            case .element28:                         return "minecraft:element_28"
            case .element29:                         return "minecraft:element_29"
            case .element39:                         return "minecraft:element_39"
            case .element38:                         return "minecraft:element_38"
            case .element31:                         return "minecraft:element_31"
            case .element30:                         return "minecraft:element_30"
            case .element33:                         return "minecraft:element_33"
            case .element32:                         return "minecraft:element_32"
            case .element35:                         return "minecraft:element_35"
            case .element34:                         return "minecraft:element_34"
            case .element37:                         return "minecraft:element_37"
            case .element36:                         return "minecraft:element_36"
            case .element19:                         return "minecraft:element_19"
            case .element18:                         return "minecraft:element_18"
            case .element17:                         return "minecraft:element_17"
            case .element16:                         return "minecraft:element_16"
            case .element15:                         return "minecraft:element_15"
            case .element14:                         return "minecraft:element_14"
            case .element13:                         return "minecraft:element_13"
            case .element12:                         return "minecraft:element_12"
            case .element11:                         return "minecraft:element_11"
            case .element10:                         return "minecraft:element_10"
            case .coloredTorchRg:                    return "minecraft:colored_torch_rg"
            case .coloredTorchBp:                    return "minecraft:colored_torch_bp"
            case .chemicalHeat:                      return "minecraft:chemical_heat"
            case .netherreactor:                     return "minecraft:netherreactor"
            case .chemistryTable:                    return "minecraft:chemistry_table"
            case .camera:                            return "minecraft:camera"
            case .element8:                          return "minecraft:element_8"
            case .element9:                          return "minecraft:element_9"
            case .element6:                          return "minecraft:element_6"
            case .element7:                          return "minecraft:element_7"
            case .element4:                          return "minecraft:element_4"
            case .element5:                          return "minecraft:element_5"
            case .element2:                          return "minecraft:element_2"
            case .element3:                          return "minecraft:element_3"
            case .element0:                          return "minecraft:element_0"
            case .element1:                          return "minecraft:element_1"
            case .allow:                             return "minecraft:allow"
            case .hardStainedGlass:                  return "minecraft:hard_stained_glass"
            case .deny:                              return "minecraft:deny"
            case .element118:                        return "minecraft:element_118"
            case .element114:                        return "minecraft:element_114"
            case .element115:                        return "minecraft:element_115"
            case .element116:                        return "minecraft:element_116"
            case .element117:                        return "minecraft:element_117"
            case .element110:                        return "minecraft:element_110"
            case .element111:                        return "minecraft:element_111"
            case .element112:                        return "minecraft:element_112"
            case .element113:                        return "minecraft:element_113"
            case .element109:                        return "minecraft:element_109"
            case .element108:                        return "minecraft:element_108"
            case .element107:                        return "minecraft:element_107"
            case .element106:                        return "minecraft:element_106"
            case .element105:                        return "minecraft:element_105"
            case .element104:                        return "minecraft:element_104"
            case .element103:                        return "minecraft:element_103"
            case .element102:                        return "minecraft:element_102"
            case .element101:                        return "minecraft:element_101"
            case .element100:                        return "minecraft:element_100"
            case .borderBlock:                       return "minecraft:border_block"
            case .hardGlass:                         return "minecraft:hard_glass"
            case .unknown:                           return "minecraft:unknown"
            case .reserved6:                         return "minecraft:reserved6"
            case .clientRequestPlaceholderBlock:     return "minecraft:client_request_placeholder_block"
            case .frame:                             return "minecraft:frame"
            case .glowingobsidian:                   return "minecraft:glowingobsidian"
            case .underwaterTorch:                   return "minecraft:underwater_torch"
            case .invisibleBedrock:                  return "minecraft:invisible_bedrock"
            case .stonecutter:                       return "minecraft:stonecutter"
            case .hardGlassPane:                     return "minecraft:hard_glass_pane"
            case .lavaCauldron:                      return "minecraft:lava_cauldron"
            case .infoUpdate:                        return "minecraft:info_update"
            case .glowFrame:                         return "minecraft:glow_frame"
        }
    }
}

extension MCBlockType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
            case "minecraft:air":                                    self = .air
            case "minecraft:stone":                                  self = .stone
            case "minecraft:grass":                                  self = .grass
            case "minecraft:dirt":                                   self = .dirt
            case "minecraft:podzol":                                 self = .podzol
            case "minecraft:cobblestone":                            self = .cobblestone
            case "minecraft:planks":                                 self = .planks
            case "minecraft:mangrove_planks":                        self = .mangrovePlanks
            case "minecraft:sapling":                                self = .sapling
            case "minecraft:mangrove_propagule":                     self = .mangrovePropagule
            case "minecraft:bedrock":                                self = .bedrock
            case "minecraft:flowing_water":                          self = .flowingWater
            case "minecraft:water":                                  self = .water
            case "minecraft:lava":                                   self = .lava
            case "minecraft:flowing_lava":                           self = .flowingLava
            case "minecraft:sand":                                   self = .sand
            case "minecraft:gravel":                                 self = .gravel
            case "minecraft:gold_ore":                               self = .goldOre
            case "minecraft:deepslate_gold_ore":                     self = .deepslateGoldOre
            case "minecraft:iron_ore":                               self = .ironOre
            case "minecraft:deepslate_iron_ore":                     self = .deepslateIronOre
            case "minecraft:coal_ore":                               self = .coalOre
            case "minecraft:deepslate_coal_ore":                     self = .deepslateCoalOre
            case "minecraft:nether_gold_ore":                        self = .netherGoldOre
            case "minecraft:log":                                    self = .log
            case "minecraft:log2":                                   self = .log2
            case "minecraft:mangrove_log":                           self = .mangroveLog
            case "minecraft:mangrove_roots":                         self = .mangroveRoots
            case "minecraft:muddy_mangrove_roots":                   self = .muddyMangroveRoots
            case "minecraft:stripped_spruce_log":                    self = .strippedSpruceLog
            case "minecraft:stripped_birch_log":                     self = .strippedBirchLog
            case "minecraft:stripped_jungle_log":                    self = .strippedJungleLog
            case "minecraft:stripped_acacia_log":                    self = .strippedAcaciaLog
            case "minecraft:stripped_dark_oak_log":                  self = .strippedDarkOakLog
            case "minecraft:stripped_oak_log":                       self = .strippedOakLog
            case "minecraft:stripped_mangrove_log":                  self = .strippedMangroveLog
            case "minecraft:wood":                                   self = .wood
            case "minecraft:mangrove_wood":                          self = .mangroveWood
            case "minecraft:stripped_mangrove_wood":                 self = .strippedMangroveWood
            case "minecraft:leaves":                                 self = .leaves
            case "minecraft:leaves2":                                self = .leaves2
            case "minecraft:mangrove_leaves":                        self = .mangroveLeaves
            case "minecraft:azalea_leaves":                          self = .azaleaLeaves
            case "minecraft:azalea_leaves_flowered":                 self = .azaleaLeavesFlowered
            case "minecraft:sponge":                                 self = .sponge
            case "minecraft:glass":                                  self = .glass
            case "minecraft:lapis_ore":                              self = .lapisOre
            case "minecraft:deepslate_lapis_ore":                    self = .deepslateLapisOre
            case "minecraft:lapis_block":                            self = .lapisBlock
            case "minecraft:dispenser":                              self = .dispenser
            case "minecraft:sandstone":                              self = .sandstone
            case "minecraft:noteblock":                              self = .noteblock
            case "minecraft:bed":                                    self = .bed
            case "minecraft:golden_rail":                            self = .goldenRail
            case "minecraft:detector_rail":                          self = .detectorRail
            case "minecraft:sticky_piston":                          self = .stickyPiston
            case "minecraft:web":                                    self = .web
            case "minecraft:tallgrass":                              self = .tallgrass
            case "minecraft:deadbush":                               self = .deadbush
            case "minecraft:seagrass":                               self = .seagrass
            case "minecraft:piston":                                 self = .piston
            case "minecraft:piston_arm_collision":                   self = .pistonArmCollision
            case "minecraft:sticky_piston_arm_collision":            self = .stickyPistonArmCollision
            case "minecraft:wool":                                   self = .wool
            case "minecraft:moving_block":                           self = .movingBlock
            case "minecraft:yellow_flower":                          self = .yellowFlower
            case "minecraft:red_flower":                             self = .redFlower
            case "minecraft:wither_rose":                            self = .witherRose
            case "minecraft:brown_mushroom":                         self = .brownMushroom
            case "minecraft:red_mushroom":                           self = .redMushroom
            case "minecraft:gold_block":                             self = .goldBlock
            case "minecraft:iron_block":                             self = .ironBlock
            case "minecraft:brick_block":                            self = .brickBlock
            case "minecraft:tnt":                                    self = .tnt
            case "minecraft:bookshelf":                              self = .bookshelf
            case "minecraft:mossy_cobblestone":                      self = .mossyCobblestone
            case "minecraft:obsidian":                               self = .obsidian
            case "minecraft:torch":                                  self = .torch
            case "minecraft:fire":                                   self = .fire
            case "minecraft:soul_fire":                              self = .soulFire
            case "minecraft:mob_spawner":                            self = .mobSpawner
            case "minecraft:oak_stairs":                             self = .oakStairs
            case "minecraft:chest":                                  self = .chest
            case "minecraft:redstone_wire":                          self = .redstoneWire
            case "minecraft:diamond_ore":                            self = .diamondOre
            case "minecraft:deepslate_diamond_ore":                  self = .deepslateDiamondOre
            case "minecraft:diamond_block":                          self = .diamondBlock
            case "minecraft:crafting_table":                         self = .craftingTable
            case "minecraft:wheat":                                  self = .wheat
            case "minecraft:farmland":                               self = .farmland
            case "minecraft:lit_furnace":                            self = .litFurnace
            case "minecraft:furnace":                                self = .furnace
            case "minecraft:standing_sign":                          self = .standingSign
            case "minecraft:spruce_standing_sign":                   self = .spruceStandingSign
            case "minecraft:birch_standing_sign":                    self = .birchStandingSign
            case "minecraft:acacia_standing_sign":                   self = .acaciaStandingSign
            case "minecraft:jungle_standing_sign":                   self = .jungleStandingSign
            case "minecraft:darkoak_standing_sign":                  self = .darkoakStandingSign
            case "minecraft:mangrove_standing_sign":                 self = .mangroveStandingSign
            case "minecraft:wooden_door":                            self = .woodenDoor
            case "minecraft:ladder":                                 self = .ladder
            case "minecraft:rail":                                   self = .rail
            case "minecraft:stone_stairs":                           self = .stoneStairs
            case "minecraft:wall_sign":                              self = .wallSign
            case "minecraft:spruce_wall_sign":                       self = .spruceWallSign
            case "minecraft:birch_wall_sign":                        self = .birchWallSign
            case "minecraft:acacia_wall_sign":                       self = .acaciaWallSign
            case "minecraft:jungle_wall_sign":                       self = .jungleWallSign
            case "minecraft:darkoak_wall_sign":                      self = .darkoakWallSign
            case "minecraft:mangrove_wall_sign":                     self = .mangroveWallSign
            case "minecraft:lever":                                  self = .lever
            case "minecraft:stone_pressure_plate":                   self = .stonePressurePlate
            case "minecraft:iron_door":                              self = .ironDoor
            case "minecraft:wooden_pressure_plate":                  self = .woodenPressurePlate
            case "minecraft:spruce_pressure_plate":                  self = .sprucePressurePlate
            case "minecraft:birch_pressure_plate":                   self = .birchPressurePlate
            case "minecraft:jungle_pressure_plate":                  self = .junglePressurePlate
            case "minecraft:acacia_pressure_plate":                  self = .acaciaPressurePlate
            case "minecraft:dark_oak_pressure_plate":                self = .darkOakPressurePlate
            case "minecraft:mangrove_pressure_plate":                self = .mangrovePressurePlate
            case "minecraft:redstone_ore":                           self = .redstoneOre
            case "minecraft:lit_redstone_ore":                       self = .litRedstoneOre
            case "minecraft:deepslate_redstone_ore":                 self = .deepslateRedstoneOre
            case "minecraft:lit_deepslate_redstone_ore":             self = .litDeepslateRedstoneOre
            case "minecraft:redstone_torch":                         self = .redstoneTorch
            case "minecraft:unlit_redstone_torch":                   self = .unlitRedstoneTorch
            case "minecraft:stone_button":                           self = .stoneButton
            case "minecraft:snow_layer":                             self = .snowLayer
            case "minecraft:ice":                                    self = .ice
            case "minecraft:snow":                                   self = .snow
            case "minecraft:cactus":                                 self = .cactus
            case "minecraft:clay":                                   self = .clay
            case "minecraft:reeds":                                  self = .reeds
            case "minecraft:jukebox":                                self = .jukebox
            case "minecraft:fence":                                  self = .fence
            case "minecraft:pumpkin":                                self = .pumpkin
            case "minecraft:netherrack":                             self = .netherrack
            case "minecraft:soul_sand":                              self = .soulSand
            case "minecraft:soul_soil":                              self = .soulSoil
            case "minecraft:basalt":                                 self = .basalt
            case "minecraft:polished_basalt":                        self = .polishedBasalt
            case "minecraft:soul_torch":                             self = .soulTorch
            case "minecraft:glowstone":                              self = .glowstone
            case "minecraft:portal":                                 self = .portal
            case "minecraft:carved_pumpkin":                         self = .carvedPumpkin
            case "minecraft:lit_pumpkin":                            self = .litPumpkin
            case "minecraft:cake":                                   self = .cake
            case "minecraft:powered_repeater":                       self = .poweredRepeater
            case "minecraft:unpowered_repeater":                     self = .unpoweredRepeater
            case "minecraft:stained_glass":                          self = .stainedGlass
            case "minecraft:trapdoor":                               self = .trapdoor
            case "minecraft:spruce_trapdoor":                        self = .spruceTrapdoor
            case "minecraft:birch_trapdoor":                         self = .birchTrapdoor
            case "minecraft:jungle_trapdoor":                        self = .jungleTrapdoor
            case "minecraft:acacia_trapdoor":                        self = .acaciaTrapdoor
            case "minecraft:dark_oak_trapdoor":                      self = .darkOakTrapdoor
            case "minecraft:mangrove_trapdoor":                      self = .mangroveTrapdoor
            case "minecraft:stonebrick":                             self = .stonebrick
            case "minecraft:packed_mud":                             self = .packedMud
            case "minecraft:mud_bricks":                             self = .mudBricks
            case "minecraft:monster_egg":                            self = .monsterEgg
            case "minecraft:brown_mushroom_block":                   self = .brownMushroomBlock
            case "minecraft:red_mushroom_block":                     self = .redMushroomBlock
            case "minecraft:iron_bars":                              self = .ironBars
            case "minecraft:chain":                                  self = .chain
            case "minecraft:glass_pane":                             self = .glassPane
            case "minecraft:melon_block":                            self = .melonBlock
            case "minecraft:pumpkin_stem":                           self = .pumpkinStem
            case "minecraft:melon_stem":                             self = .melonStem
            case "minecraft:vine":                                   self = .vine
            case "minecraft:glow_lichen":                            self = .glowLichen
            case "minecraft:fence_gate":                             self = .fenceGate
            case "minecraft:brick_stairs":                           self = .brickStairs
            case "minecraft:stone_brick_stairs":                     self = .stoneBrickStairs
            case "minecraft:mud_brick_stairs":                       self = .mudBrickStairs
            case "minecraft:mycelium":                               self = .mycelium
            case "minecraft:waterlily":                              self = .waterlily
            case "minecraft:nether_brick":                           self = .netherBrick
            case "minecraft:nether_brick_fence":                     self = .netherBrickFence
            case "minecraft:nether_brick_stairs":                    self = .netherBrickStairs
            case "minecraft:nether_wart":                            self = .netherWart
            case "minecraft:enchanting_table":                       self = .enchantingTable
            case "minecraft:brewing_stand":                          self = .brewingStand
            case "minecraft:cauldron":                               self = .cauldron
            case "minecraft:end_portal":                             self = .endPortal
            case "minecraft:end_portal_frame":                       self = .endPortalFrame
            case "minecraft:end_stone":                              self = .endStone
            case "minecraft:dragon_egg":                             self = .dragonEgg
            case "minecraft:redstone_lamp":                          self = .redstoneLamp
            case "minecraft:lit_redstone_lamp":                      self = .litRedstoneLamp
            case "minecraft:cocoa":                                  self = .cocoa
            case "minecraft:sandstone_stairs":                       self = .sandstoneStairs
            case "minecraft:emerald_ore":                            self = .emeraldOre
            case "minecraft:deepslate_emerald_ore":                  self = .deepslateEmeraldOre
            case "minecraft:ender_chest":                            self = .enderChest
            case "minecraft:tripwire_hook":                          self = .tripwireHook
            case "minecraft:trip_wire":                              self = .tripWire
            case "minecraft:emerald_block":                          self = .emeraldBlock
            case "minecraft:spruce_stairs":                          self = .spruceStairs
            case "minecraft:birch_stairs":                           self = .birchStairs
            case "minecraft:jungle_stairs":                          self = .jungleStairs
            case "minecraft:command_block":                          self = .commandBlock
            case "minecraft:beacon":                                 self = .beacon
            case "minecraft:cobblestone_wall":                       self = .cobblestoneWall
            case "minecraft:carrots":                                self = .carrots
            case "minecraft:potatoes":                               self = .potatoes
            case "minecraft:wooden_button":                          self = .woodenButton
            case "minecraft:spruce_button":                          self = .spruceButton
            case "minecraft:birch_button":                           self = .birchButton
            case "minecraft:jungle_button":                          self = .jungleButton
            case "minecraft:acacia_button":                          self = .acaciaButton
            case "minecraft:dark_oak_button":                        self = .darkOakButton
            case "minecraft:mangrove_button":                        self = .mangroveButton
            case "minecraft:skull":                                  self = .skull
            case "minecraft:anvil":                                  self = .anvil
            case "minecraft:trapped_chest":                          self = .trappedChest
            case "minecraft:light_weighted_pressure_plate":          self = .lightWeightedPressurePlate
            case "minecraft:heavy_weighted_pressure_plate":          self = .heavyWeightedPressurePlate
            case "minecraft:powered_comparator":                     self = .poweredComparator
            case "minecraft:unpowered_comparator":                   self = .unpoweredComparator
            case "minecraft:daylight_detector":                      self = .daylightDetector
            case "minecraft:daylight_detector_inverted":             self = .daylightDetectorInverted
            case "minecraft:redstone_block":                         self = .redstoneBlock
            case "minecraft:quartz_ore":                             self = .quartzOre
            case "minecraft:hopper":                                 self = .hopper
            case "minecraft:quartz_block":                           self = .quartzBlock
            case "minecraft:quartz_stairs":                          self = .quartzStairs
            case "minecraft:activator_rail":                         self = .activatorRail
            case "minecraft:dropper":                                self = .dropper
            case "minecraft:stained_hardened_clay":                  self = .stainedHardenedClay
            case "minecraft:stained_glass_pane":                     self = .stainedGlassPane
            case "minecraft:acacia_stairs":                          self = .acaciaStairs
            case "minecraft:dark_oak_stairs":                        self = .darkOakStairs
            case "minecraft:mangrove_stairs":                        self = .mangroveStairs
            case "minecraft:slime":                                  self = .slime
            case "minecraft:barrier":                                self = .barrier
            case "minecraft:light_block":                            self = .lightBlock
            case "minecraft:iron_trapdoor":                          self = .ironTrapdoor
            case "minecraft:prismarine":                             self = .prismarine
            case "minecraft:prismarine_stairs":                      self = .prismarineStairs
            case "minecraft:prismarine_bricks_stairs":               self = .prismarineBricksStairs
            case "minecraft:dark_prismarine_stairs":                 self = .darkPrismarineStairs
            case "minecraft:stone_block_slab2":                      self = .stoneBlockSlab2
            case "minecraft:double_stone_block_slab2":               self = .doubleStoneBlockSlab2
            case "minecraft:sea_lantern":                            self = .seaLantern
            case "minecraft:hay_block":                              self = .hayBlock
            case "minecraft:carpet":                                 self = .carpet
            case "minecraft:hardened_clay":                          self = .hardenedClay
            case "minecraft:coal_block":                             self = .coalBlock
            case "minecraft:packed_ice":                             self = .packedIce
            case "minecraft:double_plant":                           self = .doublePlant
            case "minecraft:standing_banner":                        self = .standingBanner
            case "minecraft:wall_banner":                            self = .wallBanner
            case "minecraft:red_sandstone":                          self = .redSandstone
            case "minecraft:red_sandstone_stairs":                   self = .redSandstoneStairs
            case "minecraft:wooden_slab":                            self = .woodenSlab
            case "minecraft:double_wooden_slab":                     self = .doubleWoodenSlab
            case "minecraft:mangrove_double_slab":                   self = .mangroveDoubleSlab
            case "minecraft:mangrove_slab":                          self = .mangroveSlab
            case "minecraft:stone_block_slab4":                      self = .stoneBlockSlab4
            case "minecraft:double_stone_block_slab4":               self = .doubleStoneBlockSlab4
            case "minecraft:stone_block_slab":                       self = .stoneBlockSlab
            case "minecraft:double_stone_block_slab":                self = .doubleStoneBlockSlab
            case "minecraft:mud_brick_double_slab":                  self = .mudBrickDoubleSlab
            case "minecraft:mud_brick_slab":                         self = .mudBrickSlab
            case "minecraft:smooth_stone":                           self = .smoothStone
            case "minecraft:spruce_fence_gate":                      self = .spruceFenceGate
            case "minecraft:birch_fence_gate":                       self = .birchFenceGate
            case "minecraft:jungle_fence_gate":                      self = .jungleFenceGate
            case "minecraft:acacia_fence_gate":                      self = .acaciaFenceGate
            case "minecraft:dark_oak_fence_gate":                    self = .darkOakFenceGate
            case "minecraft:mangrove_fence_gate":                    self = .mangroveFenceGate
            case "minecraft:mangrove_fence":                         self = .mangroveFence
            case "minecraft:spruce_door":                            self = .spruceDoor
            case "minecraft:birch_door":                             self = .birchDoor
            case "minecraft:jungle_door":                            self = .jungleDoor
            case "minecraft:acacia_door":                            self = .acaciaDoor
            case "minecraft:dark_oak_door":                          self = .darkOakDoor
            case "minecraft:mangrove_door":                          self = .mangroveDoor
            case "minecraft:end_rod":                                self = .endRod
            case "minecraft:chorus_plant":                           self = .chorusPlant
            case "minecraft:chorus_flower":                          self = .chorusFlower
            case "minecraft:purpur_block":                           self = .purpurBlock
            case "minecraft:purpur_stairs":                          self = .purpurStairs
            case "minecraft:end_bricks":                             self = .endBricks
            case "minecraft:beetroot":                               self = .beetroot
            case "minecraft:grass_path":                             self = .grassPath
            case "minecraft:end_gateway":                            self = .endGateway
            case "minecraft:repeating_command_block":                self = .repeatingCommandBlock
            case "minecraft:chain_command_block":                    self = .chainCommandBlock
            case "minecraft:frosted_ice":                            self = .frostedIce
            case "minecraft:magma":                                  self = .magma
            case "minecraft:nether_wart_block":                      self = .netherWartBlock
            case "minecraft:red_nether_brick":                       self = .redNetherBrick
            case "minecraft:bone_block":                             self = .boneBlock
            case "minecraft:structure_void":                         self = .structureVoid
            case "minecraft:observer":                               self = .observer
            case "minecraft:undyed_shulker_box":                     self = .undyedShulkerBox
            case "minecraft:shulker_box":                            self = .shulkerBox
            case "minecraft:white_glazed_terracotta":                self = .whiteGlazedTerracotta
            case "minecraft:orange_glazed_terracotta":               self = .orangeGlazedTerracotta
            case "minecraft:magenta_glazed_terracotta":              self = .magentaGlazedTerracotta
            case "minecraft:light_blue_glazed_terracotta":           self = .lightBlueGlazedTerracotta
            case "minecraft:yellow_glazed_terracotta":               self = .yellowGlazedTerracotta
            case "minecraft:lime_glazed_terracotta":                 self = .limeGlazedTerracotta
            case "minecraft:pink_glazed_terracotta":                 self = .pinkGlazedTerracotta
            case "minecraft:gray_glazed_terracotta":                 self = .grayGlazedTerracotta
            case "minecraft:silver_glazed_terracotta":               self = .silverGlazedTerracotta
            case "minecraft:cyan_glazed_terracotta":                 self = .cyanGlazedTerracotta
            case "minecraft:purple_glazed_terracotta":               self = .purpleGlazedTerracotta
            case "minecraft:blue_glazed_terracotta":                 self = .blueGlazedTerracotta
            case "minecraft:brown_glazed_terracotta":                self = .brownGlazedTerracotta
            case "minecraft:green_glazed_terracotta":                self = .greenGlazedTerracotta
            case "minecraft:red_glazed_terracotta":                  self = .redGlazedTerracotta
            case "minecraft:black_glazed_terracotta":                self = .blackGlazedTerracotta
            case "minecraft:concrete":                               self = .concrete
            case "minecraft:concrete_powder":                        self = .concretePowder
            case "minecraft:kelp":                                   self = .kelp
            case "minecraft:dried_kelp_block":                       self = .driedKelpBlock
            case "minecraft:turtle_egg":                             self = .turtleEgg
            case "minecraft:coral_block":                            self = .coralBlock
            case "minecraft:coral":                                  self = .coral
            case "minecraft:coral_fan_dead":                         self = .coralFanDead
            case "minecraft:coral_fan":                              self = .coralFan
            case "minecraft:coral_fan_hang":                         self = .coralFanHang
            case "minecraft:coral_fan_hang2":                        self = .coralFanHang2
            case "minecraft:coral_fan_hang3":                        self = .coralFanHang3
            case "minecraft:sea_pickle":                             self = .seaPickle
            case "minecraft:blue_ice":                               self = .blueIce
            case "minecraft:conduit":                                self = .conduit
            case "minecraft:bamboo_sapling":                         self = .bambooSapling
            case "minecraft:bamboo":                                 self = .bamboo
            case "minecraft:bubble_column":                          self = .bubbleColumn
            case "minecraft:polished_granite_stairs":                self = .polishedGraniteStairs
            case "minecraft:smooth_red_sandstone_stairs":            self = .smoothRedSandstoneStairs
            case "minecraft:mossy_stone_brick_stairs":               self = .mossyStoneBrickStairs
            case "minecraft:polished_diorite_stairs":                self = .polishedDioriteStairs
            case "minecraft:mossy_cobblestone_stairs":               self = .mossyCobblestoneStairs
            case "minecraft:end_brick_stairs":                       self = .endBrickStairs
            case "minecraft:normal_stone_stairs":                    self = .normalStoneStairs
            case "minecraft:smooth_sandstone_stairs":                self = .smoothSandstoneStairs
            case "minecraft:smooth_quartz_stairs":                   self = .smoothQuartzStairs
            case "minecraft:granite_stairs":                         self = .graniteStairs
            case "minecraft:andesite_stairs":                        self = .andesiteStairs
            case "minecraft:red_nether_brick_stairs":                self = .redNetherBrickStairs
            case "minecraft:polished_andesite_stairs":               self = .polishedAndesiteStairs
            case "minecraft:diorite_stairs":                         self = .dioriteStairs
            case "minecraft:stone_block_slab3":                      self = .stoneBlockSlab3
            case "minecraft:double_stone_block_slab3":               self = .doubleStoneBlockSlab3
            case "minecraft:mud_brick_wall":                         self = .mudBrickWall
            case "minecraft:scaffolding":                            self = .scaffolding
            case "minecraft:loom":                                   self = .loom
            case "minecraft:barrel":                                 self = .barrel
            case "minecraft:smoker":                                 self = .smoker
            case "minecraft:lit_smoker":                             self = .litSmoker
            case "minecraft:lit_blast_furnace":                      self = .litBlastFurnace
            case "minecraft:blast_furnace":                          self = .blastFurnace
            case "minecraft:cartography_table":                      self = .cartographyTable
            case "minecraft:fletching_table":                        self = .fletchingTable
            case "minecraft:grindstone":                             self = .grindstone
            case "minecraft:lectern":                                self = .lectern
            case "minecraft:smithing_table":                         self = .smithingTable
            case "minecraft:stonecutter_block":                      self = .stonecutterBlock
            case "minecraft:bell":                                   self = .bell
            case "minecraft:lantern":                                self = .lantern
            case "minecraft:soul_lantern":                           self = .soulLantern
            case "minecraft:campfire":                               self = .campfire
            case "minecraft:soul_campfire":                          self = .soulCampfire
            case "minecraft:sweet_berry_bush":                       self = .sweetBerryBush
            case "minecraft:warped_stem":                            self = .warpedStem
            case "minecraft:stripped_warped_stem":                   self = .strippedWarpedStem
            case "minecraft:warped_hyphae":                          self = .warpedHyphae
            case "minecraft:stripped_warped_hyphae":                 self = .strippedWarpedHyphae
            case "minecraft:warped_nylium":                          self = .warpedNylium
            case "minecraft:warped_fungus":                          self = .warpedFungus
            case "minecraft:warped_wart_block":                      self = .warpedWartBlock
            case "minecraft:warped_roots":                           self = .warpedRoots
            case "minecraft:nether_sprouts":                         self = .netherSprouts
            case "minecraft:crimson_stem":                           self = .crimsonStem
            case "minecraft:stripped_crimson_stem":                  self = .strippedCrimsonStem
            case "minecraft:crimson_hyphae":                         self = .crimsonHyphae
            case "minecraft:stripped_crimson_hyphae":                self = .strippedCrimsonHyphae
            case "minecraft:crimson_nylium":                         self = .crimsonNylium
            case "minecraft:crimson_fungus":                         self = .crimsonFungus
            case "minecraft:shroomlight":                            self = .shroomlight
            case "minecraft:weeping_vines":                          self = .weepingVines
            case "minecraft:twisting_vines":                         self = .twistingVines
            case "minecraft:crimson_roots":                          self = .crimsonRoots
            case "minecraft:crimson_planks":                         self = .crimsonPlanks
            case "minecraft:warped_planks":                          self = .warpedPlanks
            case "minecraft:crimson_double_slab":                    self = .crimsonDoubleSlab
            case "minecraft:crimson_slab":                           self = .crimsonSlab
            case "minecraft:warped_double_slab":                     self = .warpedDoubleSlab
            case "minecraft:warped_slab":                            self = .warpedSlab
            case "minecraft:crimson_pressure_plate":                 self = .crimsonPressurePlate
            case "minecraft:warped_pressure_plate":                  self = .warpedPressurePlate
            case "minecraft:crimson_fence":                          self = .crimsonFence
            case "minecraft:warped_fence":                           self = .warpedFence
            case "minecraft:crimson_trapdoor":                       self = .crimsonTrapdoor
            case "minecraft:warped_trapdoor":                        self = .warpedTrapdoor
            case "minecraft:crimson_fence_gate":                     self = .crimsonFenceGate
            case "minecraft:warped_fence_gate":                      self = .warpedFenceGate
            case "minecraft:crimson_stairs":                         self = .crimsonStairs
            case "minecraft:warped_stairs":                          self = .warpedStairs
            case "minecraft:crimson_button":                         self = .crimsonButton
            case "minecraft:warped_button":                          self = .warpedButton
            case "minecraft:crimson_door":                           self = .crimsonDoor
            case "minecraft:warped_door":                            self = .warpedDoor
            case "minecraft:crimson_standing_sign":                  self = .crimsonStandingSign
            case "minecraft:warped_standing_sign":                   self = .warpedStandingSign
            case "minecraft:crimson_wall_sign":                      self = .crimsonWallSign
            case "minecraft:warped_wall_sign":                       self = .warpedWallSign
            case "minecraft:structure_block":                        self = .structureBlock
            case "minecraft:jigsaw":                                 self = .jigsaw
            case "minecraft:composter":                              self = .composter
            case "minecraft:target":                                 self = .target
            case "minecraft:bee_nest":                               self = .beeNest
            case "minecraft:beehive":                                self = .beehive
            case "minecraft:honey_block":                            self = .honeyBlock
            case "minecraft:honeycomb_block":                        self = .honeycombBlock
            case "minecraft:netherite_block":                        self = .netheriteBlock
            case "minecraft:ancient_debris":                         self = .ancientDebris
            case "minecraft:crying_obsidian":                        self = .cryingObsidian
            case "minecraft:respawn_anchor":                         self = .respawnAnchor
            case "minecraft:lodestone":                              self = .lodestone
            case "minecraft:blackstone":                             self = .blackstone
            case "minecraft:blackstone_stairs":                      self = .blackstoneStairs
            case "minecraft:blackstone_wall":                        self = .blackstoneWall
            case "minecraft:blackstone_double_slab":                 self = .blackstoneDoubleSlab
            case "minecraft:blackstone_slab":                        self = .blackstoneSlab
            case "minecraft:polished_blackstone":                    self = .polishedBlackstone
            case "minecraft:polished_blackstone_bricks":             self = .polishedBlackstoneBricks
            case "minecraft:cracked_polished_blackstone_bricks":     self = .crackedPolishedBlackstoneBricks
            case "minecraft:chiseled_polished_blackstone":           self = .chiseledPolishedBlackstone
            case "minecraft:polished_blackstone_brick_double_slab":  self = .polishedBlackstoneBrickDoubleSlab
            case "minecraft:polished_blackstone_brick_slab":         self = .polishedBlackstoneBrickSlab
            case "minecraft:polished_blackstone_brick_stairs":       self = .polishedBlackstoneBrickStairs
            case "minecraft:polished_blackstone_brick_wall":         self = .polishedBlackstoneBrickWall
            case "minecraft:gilded_blackstone":                      self = .gildedBlackstone
            case "minecraft:polished_blackstone_stairs":             self = .polishedBlackstoneStairs
            case "minecraft:polished_blackstone_double_slab":        self = .polishedBlackstoneDoubleSlab
            case "minecraft:polished_blackstone_slab":               self = .polishedBlackstoneSlab
            case "minecraft:polished_blackstone_pressure_plate":     self = .polishedBlackstonePressurePlate
            case "minecraft:polished_blackstone_button":             self = .polishedBlackstoneButton
            case "minecraft:polished_blackstone_wall":               self = .polishedBlackstoneWall
            case "minecraft:chiseled_nether_bricks":                 self = .chiseledNetherBricks
            case "minecraft:cracked_nether_bricks":                  self = .crackedNetherBricks
            case "minecraft:quartz_bricks":                          self = .quartzBricks
            case "minecraft:candle":                                 self = .candle
            case "minecraft:white_candle":                           self = .whiteCandle
            case "minecraft:orange_candle":                          self = .orangeCandle
            case "minecraft:magenta_candle":                         self = .magentaCandle
            case "minecraft:light_blue_candle":                      self = .lightBlueCandle
            case "minecraft:yellow_candle":                          self = .yellowCandle
            case "minecraft:lime_candle":                            self = .limeCandle
            case "minecraft:pink_candle":                            self = .pinkCandle
            case "minecraft:gray_candle":                            self = .grayCandle
            case "minecraft:light_gray_candle":                      self = .lightGrayCandle
            case "minecraft:cyan_candle":                            self = .cyanCandle
            case "minecraft:purple_candle":                          self = .purpleCandle
            case "minecraft:blue_candle":                            self = .blueCandle
            case "minecraft:brown_candle":                           self = .brownCandle
            case "minecraft:green_candle":                           self = .greenCandle
            case "minecraft:red_candle":                             self = .redCandle
            case "minecraft:black_candle":                           self = .blackCandle
            case "minecraft:candle_cake":                            self = .candleCake
            case "minecraft:white_candle_cake":                      self = .whiteCandleCake
            case "minecraft:orange_candle_cake":                     self = .orangeCandleCake
            case "minecraft:magenta_candle_cake":                    self = .magentaCandleCake
            case "minecraft:light_blue_candle_cake":                 self = .lightBlueCandleCake
            case "minecraft:yellow_candle_cake":                     self = .yellowCandleCake
            case "minecraft:lime_candle_cake":                       self = .limeCandleCake
            case "minecraft:pink_candle_cake":                       self = .pinkCandleCake
            case "minecraft:gray_candle_cake":                       self = .grayCandleCake
            case "minecraft:light_gray_candle_cake":                 self = .lightGrayCandleCake
            case "minecraft:cyan_candle_cake":                       self = .cyanCandleCake
            case "minecraft:purple_candle_cake":                     self = .purpleCandleCake
            case "minecraft:blue_candle_cake":                       self = .blueCandleCake
            case "minecraft:brown_candle_cake":                      self = .brownCandleCake
            case "minecraft:green_candle_cake":                      self = .greenCandleCake
            case "minecraft:red_candle_cake":                        self = .redCandleCake
            case "minecraft:black_candle_cake":                      self = .blackCandleCake
            case "minecraft:amethyst_block":                         self = .amethystBlock
            case "minecraft:budding_amethyst":                       self = .buddingAmethyst
            case "minecraft:amethyst_cluster":                       self = .amethystCluster
            case "minecraft:large_amethyst_bud":                     self = .largeAmethystBud
            case "minecraft:medium_amethyst_bud":                    self = .mediumAmethystBud
            case "minecraft:small_amethyst_bud":                     self = .smallAmethystBud
            case "minecraft:tuff":                                   self = .tuff
            case "minecraft:calcite":                                self = .calcite
            case "minecraft:tinted_glass":                           self = .tintedGlass
            case "minecraft:powder_snow":                            self = .powderSnow
            case "minecraft:sculk_sensor":                           self = .sculkSensor
            case "minecraft:sculk":                                  self = .sculk
            case "minecraft:sculk_vein":                             self = .sculkVein
            case "minecraft:sculk_catalyst":                         self = .sculkCatalyst
            case "minecraft:sculk_shrieker":                         self = .sculkShrieker
            case "minecraft:oxidized_copper":                        self = .oxidizedCopper
            case "minecraft:weathered_copper":                       self = .weatheredCopper
            case "minecraft:exposed_copper":                         self = .exposedCopper
            case "minecraft:copper_block":                           self = .copperBlock
            case "minecraft:copper_ore":                             self = .copperOre
            case "minecraft:deepslate_copper_ore":                   self = .deepslateCopperOre
            case "minecraft:oxidized_cut_copper":                    self = .oxidizedCutCopper
            case "minecraft:weathered_cut_copper":                   self = .weatheredCutCopper
            case "minecraft:exposed_cut_copper":                     self = .exposedCutCopper
            case "minecraft:cut_copper":                             self = .cutCopper
            case "minecraft:oxidized_cut_copper_stairs":             self = .oxidizedCutCopperStairs
            case "minecraft:weathered_cut_copper_stairs":            self = .weatheredCutCopperStairs
            case "minecraft:exposed_cut_copper_stairs":              self = .exposedCutCopperStairs
            case "minecraft:cut_copper_stairs":                      self = .cutCopperStairs
            case "minecraft:oxidized_double_cut_copper_slab":        self = .oxidizedDoubleCutCopperSlab
            case "minecraft:oxidized_cut_copper_slab":               self = .oxidizedCutCopperSlab
            case "minecraft:weathered_cut_copper_slab":              self = .weatheredCutCopperSlab
            case "minecraft:weathered_double_cut_copper_slab":       self = .weatheredDoubleCutCopperSlab
            case "minecraft:exposed_double_cut_copper_slab":         self = .exposedDoubleCutCopperSlab
            case "minecraft:exposed_cut_copper_slab":                self = .exposedCutCopperSlab
            case "minecraft:double_cut_copper_slab":                 self = .doubleCutCopperSlab
            case "minecraft:cut_copper_slab":                        self = .cutCopperSlab
            case "minecraft:waxed_copper":                           self = .waxedCopper
            case "minecraft:waxed_weathered_copper":                 self = .waxedWeatheredCopper
            case "minecraft:waxed_exposed_copper":                   self = .waxedExposedCopper
            case "minecraft:waxed_oxidized_copper":                  self = .waxedOxidizedCopper
            case "minecraft:waxed_oxidized_cut_copper":              self = .waxedOxidizedCutCopper
            case "minecraft:waxed_weathered_cut_copper":             self = .waxedWeatheredCutCopper
            case "minecraft:waxed_exposed_cut_copper":               self = .waxedExposedCutCopper
            case "minecraft:waxed_cut_copper":                       self = .waxedCutCopper
            case "minecraft:waxed_oxidized_cut_copper_stairs":       self = .waxedOxidizedCutCopperStairs
            case "minecraft:waxed_weathered_cut_copper_stairs":      self = .waxedWeatheredCutCopperStairs
            case "minecraft:waxed_exposed_cut_copper_stairs":        self = .waxedExposedCutCopperStairs
            case "minecraft:waxed_cut_copper_stairs":                self = .waxedCutCopperStairs
            case "minecraft:waxed_oxidized_cut_copper_slab":         self = .waxedOxidizedCutCopperSlab
            case "minecraft:waxed_oxidized_double_cut_copper_slab":  self = .waxedOxidizedDoubleCutCopperSlab
            case "minecraft:waxed_weathered_double_cut_copper_slab": self = .waxedWeatheredDoubleCutCopperSlab
            case "minecraft:waxed_weathered_cut_copper_slab":        self = .waxedWeatheredCutCopperSlab
            case "minecraft:waxed_exposed_cut_copper_slab":          self = .waxedExposedCutCopperSlab
            case "minecraft:waxed_exposed_double_cut_copper_slab":   self = .waxedExposedDoubleCutCopperSlab
            case "minecraft:waxed_double_cut_copper_slab":           self = .waxedDoubleCutCopperSlab
            case "minecraft:waxed_cut_copper_slab":                  self = .waxedCutCopperSlab
            case "minecraft:lightning_rod":                          self = .lightningRod
            case "minecraft:pointed_dripstone":                      self = .pointedDripstone
            case "minecraft:dripstone_block":                        self = .dripstoneBlock
            case "minecraft:cave_vines_head_with_berries":           self = .caveVinesHeadWithBerries
            case "minecraft:cave_vines":                             self = .caveVines
            case "minecraft:cave_vines_body_with_berries":           self = .caveVinesBodyWithBerries
            case "minecraft:spore_blossom":                          self = .sporeBlossom
            case "minecraft:azalea":                                 self = .azalea
            case "minecraft:flowering_azalea":                       self = .floweringAzalea
            case "minecraft:moss_carpet":                            self = .mossCarpet
            case "minecraft:moss_block":                             self = .mossBlock
            case "minecraft:big_dripleaf":                           self = .bigDripleaf
            case "minecraft:small_dripleaf_block":                   self = .smallDripleafBlock
            case "minecraft:hanging_roots":                          self = .hangingRoots
            case "minecraft:dirt_with_roots":                        self = .dirtWithRoots
            case "minecraft:mud":                                    self = .mud
            case "minecraft:deepslate":                              self = .deepslate
            case "minecraft:cobbled_deepslate":                      self = .cobbledDeepslate
            case "minecraft:cobbled_deepslate_stairs":               self = .cobbledDeepslateStairs
            case "minecraft:cobbled_deepslate_double_slab":          self = .cobbledDeepslateDoubleSlab
            case "minecraft:cobbled_deepslate_slab":                 self = .cobbledDeepslateSlab
            case "minecraft:cobbled_deepslate_wall":                 self = .cobbledDeepslateWall
            case "minecraft:polished_deepslate":                     self = .polishedDeepslate
            case "minecraft:polished_deepslate_stairs":              self = .polishedDeepslateStairs
            case "minecraft:polished_deepslate_slab":                self = .polishedDeepslateSlab
            case "minecraft:polished_deepslate_double_slab":         self = .polishedDeepslateDoubleSlab
            case "minecraft:polished_deepslate_wall":                self = .polishedDeepslateWall
            case "minecraft:deepslate_tiles":                        self = .deepslateTiles
            case "minecraft:deepslate_tile_stairs":                  self = .deepslateTileStairs
            case "minecraft:deepslate_tile_double_slab":             self = .deepslateTileDoubleSlab
            case "minecraft:deepslate_tile_slab":                    self = .deepslateTileSlab
            case "minecraft:deepslate_tile_wall":                    self = .deepslateTileWall
            case "minecraft:deepslate_bricks":                       self = .deepslateBricks
            case "minecraft:deepslate_brick_stairs":                 self = .deepslateBrickStairs
            case "minecraft:deepslate_brick_double_slab":            self = .deepslateBrickDoubleSlab
            case "minecraft:deepslate_brick_slab":                   self = .deepslateBrickSlab
            case "minecraft:deepslate_brick_wall":                   self = .deepslateBrickWall
            case "minecraft:chiseled_deepslate":                     self = .chiseledDeepslate
            case "minecraft:cracked_deepslate_bricks":               self = .crackedDeepslateBricks
            case "minecraft:cracked_deepslate_tiles":                self = .crackedDeepslateTiles
            case "minecraft:infested_deepslate":                     self = .infestedDeepslate
            case "minecraft:smooth_basalt":                          self = .smoothBasalt
            case "minecraft:raw_iron_block":                         self = .rawIronBlock
            case "minecraft:raw_copper_block":                       self = .rawCopperBlock
            case "minecraft:raw_gold_block":                         self = .rawGoldBlock
            case "minecraft:flower_pot":                             self = .flowerPot
            case "minecraft:ochre_froglight":                        self = .ochreFroglight
            case "minecraft:verdant_froglight":                      self = .verdantFroglight
            case "minecraft:pearlescent_froglight":                  self = .pearlescentFroglight
            case "minecraft:frog_spawn":                             self = .frogSpawn
            case "minecraft:reinforced_deepslate":                   self = .reinforcedDeepslate
            case "minecraft:hard_stained_glass_pane":                self = .hardStainedGlassPane
            case "minecraft:info_update2":                           self = .infoUpdate2
            case "minecraft:element_84":                             self = .element84
            case "minecraft:element_85":                             self = .element85
            case "minecraft:element_86":                             self = .element86
            case "minecraft:element_87":                             self = .element87
            case "minecraft:element_80":                             self = .element80
            case "minecraft:element_81":                             self = .element81
            case "minecraft:element_82":                             self = .element82
            case "minecraft:element_83":                             self = .element83
            case "minecraft:element_88":                             self = .element88
            case "minecraft:element_89":                             self = .element89
            case "minecraft:element_97":                             self = .element97
            case "minecraft:element_96":                             self = .element96
            case "minecraft:element_95":                             self = .element95
            case "minecraft:element_94":                             self = .element94
            case "minecraft:element_93":                             self = .element93
            case "minecraft:element_92":                             self = .element92
            case "minecraft:element_91":                             self = .element91
            case "minecraft:element_90":                             self = .element90
            case "minecraft:element_99":                             self = .element99
            case "minecraft:element_98":                             self = .element98
            case "minecraft:element_68":                             self = .element68
            case "minecraft:element_69":                             self = .element69
            case "minecraft:element_62":                             self = .element62
            case "minecraft:element_63":                             self = .element63
            case "minecraft:element_60":                             self = .element60
            case "minecraft:element_61":                             self = .element61
            case "minecraft:element_66":                             self = .element66
            case "minecraft:element_67":                             self = .element67
            case "minecraft:element_64":                             self = .element64
            case "minecraft:element_65":                             self = .element65
            case "minecraft:element_79":                             self = .element79
            case "minecraft:element_78":                             self = .element78
            case "minecraft:element_75":                             self = .element75
            case "minecraft:element_74":                             self = .element74
            case "minecraft:element_77":                             self = .element77
            case "minecraft:element_76":                             self = .element76
            case "minecraft:element_71":                             self = .element71
            case "minecraft:element_70":                             self = .element70
            case "minecraft:element_73":                             self = .element73
            case "minecraft:element_72":                             self = .element72
            case "minecraft:element_40":                             self = .element40
            case "minecraft:element_41":                             self = .element41
            case "minecraft:element_42":                             self = .element42
            case "minecraft:element_43":                             self = .element43
            case "minecraft:element_44":                             self = .element44
            case "minecraft:element_45":                             self = .element45
            case "minecraft:element_46":                             self = .element46
            case "minecraft:element_47":                             self = .element47
            case "minecraft:element_48":                             self = .element48
            case "minecraft:element_49":                             self = .element49
            case "minecraft:element_53":                             self = .element53
            case "minecraft:element_52":                             self = .element52
            case "minecraft:element_51":                             self = .element51
            case "minecraft:element_50":                             self = .element50
            case "minecraft:element_57":                             self = .element57
            case "minecraft:element_56":                             self = .element56
            case "minecraft:element_55":                             self = .element55
            case "minecraft:element_54":                             self = .element54
            case "minecraft:element_59":                             self = .element59
            case "minecraft:element_58":                             self = .element58
            case "minecraft:element_26":                             self = .element26
            case "minecraft:element_27":                             self = .element27
            case "minecraft:element_24":                             self = .element24
            case "minecraft:element_25":                             self = .element25
            case "minecraft:element_22":                             self = .element22
            case "minecraft:element_23":                             self = .element23
            case "minecraft:element_20":                             self = .element20
            case "minecraft:element_21":                             self = .element21
            case "minecraft:element_28":                             self = .element28
            case "minecraft:element_29":                             self = .element29
            case "minecraft:element_39":                             self = .element39
            case "minecraft:element_38":                             self = .element38
            case "minecraft:element_31":                             self = .element31
            case "minecraft:element_30":                             self = .element30
            case "minecraft:element_33":                             self = .element33
            case "minecraft:element_32":                             self = .element32
            case "minecraft:element_35":                             self = .element35
            case "minecraft:element_34":                             self = .element34
            case "minecraft:element_37":                             self = .element37
            case "minecraft:element_36":                             self = .element36
            case "minecraft:element_19":                             self = .element19
            case "minecraft:element_18":                             self = .element18
            case "minecraft:element_17":                             self = .element17
            case "minecraft:element_16":                             self = .element16
            case "minecraft:element_15":                             self = .element15
            case "minecraft:element_14":                             self = .element14
            case "minecraft:element_13":                             self = .element13
            case "minecraft:element_12":                             self = .element12
            case "minecraft:element_11":                             self = .element11
            case "minecraft:element_10":                             self = .element10
            case "minecraft:colored_torch_rg":                       self = .coloredTorchRg
            case "minecraft:colored_torch_bp":                       self = .coloredTorchBp
            case "minecraft:chemical_heat":                          self = .chemicalHeat
            case "minecraft:netherreactor":                          self = .netherreactor
            case "minecraft:chemistry_table":                        self = .chemistryTable
            case "minecraft:camera":                                 self = .camera
            case "minecraft:element_8":                              self = .element8
            case "minecraft:element_9":                              self = .element9
            case "minecraft:element_6":                              self = .element6
            case "minecraft:element_7":                              self = .element7
            case "minecraft:element_4":                              self = .element4
            case "minecraft:element_5":                              self = .element5
            case "minecraft:element_2":                              self = .element2
            case "minecraft:element_3":                              self = .element3
            case "minecraft:element_0":                              self = .element0
            case "minecraft:element_1":                              self = .element1
            case "minecraft:allow":                                  self = .allow
            case "minecraft:hard_stained_glass":                     self = .hardStainedGlass
            case "minecraft:deny":                                   self = .deny
            case "minecraft:element_118":                            self = .element118
            case "minecraft:element_114":                            self = .element114
            case "minecraft:element_115":                            self = .element115
            case "minecraft:element_116":                            self = .element116
            case "minecraft:element_117":                            self = .element117
            case "minecraft:element_110":                            self = .element110
            case "minecraft:element_111":                            self = .element111
            case "minecraft:element_112":                            self = .element112
            case "minecraft:element_113":                            self = .element113
            case "minecraft:element_109":                            self = .element109
            case "minecraft:element_108":                            self = .element108
            case "minecraft:element_107":                            self = .element107
            case "minecraft:element_106":                            self = .element106
            case "minecraft:element_105":                            self = .element105
            case "minecraft:element_104":                            self = .element104
            case "minecraft:element_103":                            self = .element103
            case "minecraft:element_102":                            self = .element102
            case "minecraft:element_101":                            self = .element101
            case "minecraft:element_100":                            self = .element100
            case "minecraft:border_block":                           self = .borderBlock
            case "minecraft:hard_glass":                             self = .hardGlass
            case "minecraft:unknown":                                self = .unknown
            case "minecraft:reserved6":                              self = .reserved6
            case "minecraft:client_request_placeholder_block":       self = .clientRequestPlaceholderBlock
            case "minecraft:frame":                                  self = .frame
            case "minecraft:glowingobsidian":                        self = .glowingobsidian
            case "minecraft:underwater_torch":                       self = .underwaterTorch
            case "minecraft:invisible_bedrock":                      self = .invisibleBedrock
            case "minecraft:stonecutter":                            self = .stonecutter
            case "minecraft:hard_glass_pane":                        self = .hardGlassPane
            case "minecraft:lava_cauldron":                          self = .lavaCauldron
            case "minecraft:info_update":                            self = .infoUpdate
            case "minecraft:glow_frame":                             self = .glowFrame
            default: self = .unknown
        }
    }
}

extension MCBlockType {
    public var isOpaque: Bool {
        switch self {
            case .stone:                             return true
            case .grass:                             return true
            case .dirt:                              return true
            case .podzol:                            return true
            case .cobblestone:                       return true
            case .planks:                            return true
            case .mangrovePlanks:                    return true
            case .bedrock:                           return true
            case .sand:                              return true
            case .gravel:                            return true
            case .goldOre:                           return true
            case .deepslateGoldOre:                  return true
            case .ironOre:                           return true
            case .deepslateIronOre:                  return true
            case .coalOre:                           return true
            case .deepslateCoalOre:                  return true
            case .netherGoldOre:                     return true
            case .log:                               return true
            case .log2:                              return true
            case .mangroveLog:                       return true
            case .muddyMangroveRoots:                return true
            case .strippedSpruceLog:                 return true
            case .strippedBirchLog:                  return true
            case .strippedJungleLog:                 return true
            case .strippedAcaciaLog:                 return true
            case .strippedDarkOakLog:                return true
            case .strippedOakLog:                    return true
            case .strippedMangroveLog:               return true
            case .wood:                              return true
            case .mangroveWood:                      return true
            case .strippedMangroveWood:              return true
            case .sponge:                            return true
            case .lapisOre:                          return true
            case .deepslateLapisOre:                 return true
            case .lapisBlock:                        return true
            case .dispenser:                         return true
            case .sandstone:                         return true
            case .noteblock:                         return true
            case .stickyPiston:                      return true
            case .piston:                            return true
            case .pistonArmCollision:                return true
            case .stickyPistonArmCollision:          return true
            case .wool:                              return true
            case .goldBlock:                         return true
            case .ironBlock:                         return true
            case .brickBlock:                        return true
            case .tnt:                               return true
            case .bookshelf:                         return true
            case .mossyCobblestone:                  return true
            case .obsidian:                          return true
            case .oakStairs:                         return true
            case .chest:                             return true
            case .diamondOre:                        return true
            case .deepslateDiamondOre:               return true
            case .diamondBlock:                      return true
            case .craftingTable:                     return true
            case .farmland:                          return true
            case .litFurnace:                        return true
            case .furnace:                           return true
            case .stoneStairs:                       return true
            case .redstoneOre:                       return true
            case .litRedstoneOre:                    return true
            case .deepslateRedstoneOre:              return true
            case .litDeepslateRedstoneOre:           return true
            case .snowLayer:                         return true
            case .snow:                              return true
            case .cactus:                            return true
            case .clay:                              return true
            case .jukebox:                           return true
            case .fence:                             return true
            case .pumpkin:                           return true
            case .netherrack:                        return true
            case .soulSand:                          return true
            case .soulSoil:                          return true
            case .basalt:                            return true
            case .polishedBasalt:                    return true
            case .glowstone:                         return true
            case .carvedPumpkin:                     return true
            case .litPumpkin:                        return true
            case .cake:                              return true
            case .poweredRepeater:                   return true
            case .unpoweredRepeater:                 return true
            case .stonebrick:                        return true
            case .packedMud:                         return true
            case .mudBricks:                         return true
            case .monsterEgg:                        return true
            case .brownMushroomBlock:                return true
            case .redMushroomBlock:                  return true
            case .melonBlock:                        return true
            case .fenceGate:                         return true
            case .brickStairs:                       return true
            case .stoneBrickStairs:                  return true
            case .mudBrickStairs:                    return true
            case .mycelium:                          return true
            case .netherBrick:                       return true
            case .netherBrickFence:                  return true
            case .netherBrickStairs:                 return true
            case .enchantingTable:                   return true
            case .endPortalFrame:                    return true
            case .endStone:                          return true
            case .redstoneLamp:                      return true
            case .litRedstoneLamp:                   return true
            case .sandstoneStairs:                   return true
            case .emeraldOre:                        return true
            case .deepslateEmeraldOre:               return true
            case .enderChest:                        return true
            case .emeraldBlock:                      return true
            case .spruceStairs:                      return true
            case .birchStairs:                       return true
            case .jungleStairs:                      return true
            case .commandBlock:                      return true
            case .cobblestoneWall:                   return true
            case .skull:                             return true
            case .anvil:                             return true
            case .trappedChest:                      return true
            case .poweredComparator:                 return true
            case .unpoweredComparator:               return true
            case .daylightDetector:                  return true
            case .daylightDetectorInverted:          return true
            case .redstoneBlock:                     return true
            case .quartzOre:                         return true
            case .quartzBlock:                       return true
            case .quartzStairs:                      return true
            case .dropper:                           return true
            case .stainedHardenedClay:               return true
            case .acaciaStairs:                      return true
            case .darkOakStairs:                     return true
            case .mangroveStairs:                    return true
            case .prismarine:                        return true
            case .prismarineStairs:                  return true
            case .prismarineBricksStairs:            return true
            case .darkPrismarineStairs:              return true
            case .stoneBlockSlab2:                   return true
            case .doubleStoneBlockSlab2:             return true
            case .seaLantern:                        return true
            case .hayBlock:                          return true
            case .carpet:                            return true
            case .hardenedClay:                      return true
            case .coalBlock:                         return true
            case .packedIce:                         return true
            case .redSandstone:                      return true
            case .redSandstoneStairs:                return true
            case .woodenSlab:                        return true
            case .doubleWoodenSlab:                  return true
            case .mangroveDoubleSlab:                return true
            case .mangroveSlab:                      return true
            case .stoneBlockSlab4:                   return true
            case .doubleStoneBlockSlab4:             return true
            case .stoneBlockSlab:                    return true
            case .doubleStoneBlockSlab:              return true
            case .mudBrickDoubleSlab:                return true
            case .mudBrickSlab:                      return true
            case .smoothStone:                       return true
            case .spruceFenceGate:                   return true
            case .birchFenceGate:                    return true
            case .jungleFenceGate:                   return true
            case .acaciaFenceGate:                   return true
            case .darkOakFenceGate:                  return true
            case .mangroveFenceGate:                 return true
            case .mangroveFence:                     return true
            case .purpurBlock:                       return true
            case .purpurStairs:                      return true
            case .endBricks:                         return true
            case .grassPath:                         return true
            case .repeatingCommandBlock:             return true
            case .chainCommandBlock:                 return true
            case .magma:                             return true
            case .netherWartBlock:                   return true
            case .redNetherBrick:                    return true
            case .boneBlock:                         return true
            case .observer:                          return true
            case .whiteGlazedTerracotta:             return true
            case .orangeGlazedTerracotta:            return true
            case .magentaGlazedTerracotta:           return true
            case .lightBlueGlazedTerracotta:         return true
            case .yellowGlazedTerracotta:            return true
            case .limeGlazedTerracotta:              return true
            case .pinkGlazedTerracotta:              return true
            case .grayGlazedTerracotta:              return true
            case .silverGlazedTerracotta:            return true
            case .cyanGlazedTerracotta:              return true
            case .purpleGlazedTerracotta:            return true
            case .blueGlazedTerracotta:              return true
            case .brownGlazedTerracotta:             return true
            case .greenGlazedTerracotta:             return true
            case .redGlazedTerracotta:               return true
            case .blackGlazedTerracotta:             return true
            case .concrete:                          return true
            case .concretePowder:                    return true
            case .driedKelpBlock:                    return true
            case .coralBlock:                        return true
            case .blueIce:                           return true
            case .polishedGraniteStairs:             return true
            case .smoothRedSandstoneStairs:          return true
            case .mossyStoneBrickStairs:             return true
            case .polishedDioriteStairs:             return true
            case .mossyCobblestoneStairs:            return true
            case .endBrickStairs:                    return true
            case .normalStoneStairs:                 return true
            case .smoothSandstoneStairs:             return true
            case .smoothQuartzStairs:                return true
            case .graniteStairs:                     return true
            case .andesiteStairs:                    return true
            case .redNetherBrickStairs:              return true
            case .polishedAndesiteStairs:            return true
            case .dioriteStairs:                     return true
            case .stoneBlockSlab3:                   return true
            case .doubleStoneBlockSlab3:             return true
            case .mudBrickWall:                      return true
            case .loom:                              return true
            case .barrel:                            return true
            case .smoker:                            return true
            case .litSmoker:                         return true
            case .litBlastFurnace:                   return true
            case .blastFurnace:                      return true
            case .cartographyTable:                  return true
            case .fletchingTable:                    return true
            case .grindstone:                        return true
            case .lectern:                           return true
            case .smithingTable:                     return true
            case .stonecutterBlock:                  return true
            case .bell:                              return true
            case .warpedStem:                        return true
            case .strippedWarpedStem:                return true
            case .warpedHyphae:                      return true
            case .strippedWarpedHyphae:              return true
            case .warpedNylium:                      return true
            case .warpedWartBlock:                   return true
            case .crimsonStem:                       return true
            case .strippedCrimsonStem:               return true
            case .crimsonHyphae:                     return true
            case .strippedCrimsonHyphae:             return true
            case .crimsonNylium:                     return true
            case .shroomlight:                       return true
            case .crimsonPlanks:                     return true
            case .warpedPlanks:                      return true
            case .crimsonDoubleSlab:                 return true
            case .crimsonSlab:                       return true
            case .warpedDoubleSlab:                  return true
            case .warpedSlab:                        return true
            case .crimsonFence:                      return true
            case .warpedFence:                       return true
            case .crimsonFenceGate:                  return true
            case .warpedFenceGate:                   return true
            case .crimsonStairs:                     return true
            case .warpedStairs:                      return true
            case .structureBlock:                    return true
            case .jigsaw:                            return true
            case .composter:                         return true
            case .target:                            return true
            case .beeNest:                           return true
            case .beehive:                           return true
            case .honeycombBlock:                    return true
            case .netheriteBlock:                    return true
            case .ancientDebris:                     return true
            case .cryingObsidian:                    return true
            case .respawnAnchor:                     return true
            case .lodestone:                         return true
            case .blackstone:                        return true
            case .blackstoneStairs:                  return true
            case .blackstoneWall:                    return true
            case .blackstoneDoubleSlab:              return true
            case .blackstoneSlab:                    return true
            case .polishedBlackstone:                return true
            case .polishedBlackstoneBricks:          return true
            case .crackedPolishedBlackstoneBricks:   return true
            case .chiseledPolishedBlackstone:        return true
            case .polishedBlackstoneBrickDoubleSlab: return true
            case .polishedBlackstoneBrickSlab:       return true
            case .polishedBlackstoneBrickStairs:     return true
            case .polishedBlackstoneBrickWall:       return true
            case .gildedBlackstone:                  return true
            case .polishedBlackstoneStairs:          return true
            case .polishedBlackstoneDoubleSlab:      return true
            case .polishedBlackstoneSlab:            return true
            case .polishedBlackstoneWall:            return true
            case .chiseledNetherBricks:              return true
            case .crackedNetherBricks:               return true
            case .quartzBricks:                      return true
            case .candleCake:                        return true
            case .whiteCandleCake:                   return true
            case .orangeCandleCake:                  return true
            case .magentaCandleCake:                 return true
            case .lightBlueCandleCake:               return true
            case .yellowCandleCake:                  return true
            case .limeCandleCake:                    return true
            case .pinkCandleCake:                    return true
            case .grayCandleCake:                    return true
            case .lightGrayCandleCake:               return true
            case .cyanCandleCake:                    return true
            case .purpleCandleCake:                  return true
            case .blueCandleCake:                    return true
            case .brownCandleCake:                   return true
            case .greenCandleCake:                   return true
            case .redCandleCake:                     return true
            case .blackCandleCake:                   return true
            case .amethystBlock:                     return true
            case .buddingAmethyst:                   return true
            case .tuff:                              return true
            case .calcite:                           return true
            case .powderSnow:                        return true
            case .sculkSensor:                       return true
            case .sculk:                             return true
            case .sculkCatalyst:                     return true
            case .sculkShrieker:                     return true
            case .oxidizedCopper:                    return true
            case .weatheredCopper:                   return true
            case .exposedCopper:                     return true
            case .copperBlock:                       return true
            case .copperOre:                         return true
            case .deepslateCopperOre:                return true
            case .oxidizedCutCopper:                 return true
            case .weatheredCutCopper:                return true
            case .exposedCutCopper:                  return true
            case .cutCopper:                         return true
            case .oxidizedCutCopperStairs:           return true
            case .weatheredCutCopperStairs:          return true
            case .exposedCutCopperStairs:            return true
            case .cutCopperStairs:                   return true
            case .oxidizedDoubleCutCopperSlab:       return true
            case .oxidizedCutCopperSlab:             return true
            case .weatheredCutCopperSlab:            return true
            case .weatheredDoubleCutCopperSlab:      return true
            case .exposedDoubleCutCopperSlab:        return true
            case .exposedCutCopperSlab:              return true
            case .doubleCutCopperSlab:               return true
            case .cutCopperSlab:                     return true
            case .waxedCopper:                       return true
            case .waxedWeatheredCopper:              return true
            case .waxedExposedCopper:                return true
            case .waxedOxidizedCopper:               return true
            case .waxedOxidizedCutCopper:            return true
            case .waxedWeatheredCutCopper:           return true
            case .waxedExposedCutCopper:             return true
            case .waxedCutCopper:                    return true
            case .waxedOxidizedCutCopperStairs:      return true
            case .waxedWeatheredCutCopperStairs:     return true
            case .waxedExposedCutCopperStairs:       return true
            case .waxedCutCopperStairs:              return true
            case .waxedOxidizedCutCopperSlab:        return true
            case .waxedOxidizedDoubleCutCopperSlab:  return true
            case .waxedWeatheredDoubleCutCopperSlab: return true
            case .waxedWeatheredCutCopperSlab:       return true
            case .waxedExposedCutCopperSlab:         return true
            case .waxedExposedDoubleCutCopperSlab:   return true
            case .waxedDoubleCutCopperSlab:          return true
            case .waxedCutCopperSlab:                return true
            case .dripstoneBlock:                    return true
            case .mossCarpet:                        return true
            case .mossBlock:                         return true
            case .bigDripleaf:                       return true
            case .dirtWithRoots:                     return true
            case .mud:                               return true
            case .deepslate:                         return true
            case .cobbledDeepslate:                  return true
            case .cobbledDeepslateStairs:            return true
            case .cobbledDeepslateDoubleSlab:        return true
            case .cobbledDeepslateSlab:              return true
            case .cobbledDeepslateWall:              return true
            case .polishedDeepslate:                 return true
            case .polishedDeepslateStairs:           return true
            case .polishedDeepslateSlab:             return true
            case .polishedDeepslateDoubleSlab:       return true
            case .polishedDeepslateWall:             return true
            case .deepslateTiles:                    return true
            case .deepslateTileStairs:               return true
            case .deepslateTileDoubleSlab:           return true
            case .deepslateTileSlab:                 return true
            case .deepslateTileWall:                 return true
            case .deepslateBricks:                   return true
            case .deepslateBrickStairs:              return true
            case .deepslateBrickDoubleSlab:          return true
            case .deepslateBrickSlab:                return true
            case .deepslateBrickWall:                return true
            case .chiseledDeepslate:                 return true
            case .crackedDeepslateBricks:            return true
            case .crackedDeepslateTiles:             return true
            case .infestedDeepslate:                 return true
            case .smoothBasalt:                      return true
            case .rawIronBlock:                      return true
            case .rawCopperBlock:                    return true
            case .rawGoldBlock:                      return true
            case .ochreFroglight:                    return true
            case .verdantFroglight:                  return true
            case .pearlescentFroglight:              return true
            case .reinforcedDeepslate:               return true
            case .hardStainedGlassPane:              return true
            case .infoUpdate2:                       return true
            case .element84:                         return true
            case .element85:                         return true
            case .element86:                         return true
            case .element87:                         return true
            case .element80:                         return true
            case .element81:                         return true
            case .element82:                         return true
            case .element83:                         return true
            case .element88:                         return true
            case .element89:                         return true
            case .element97:                         return true
            case .element96:                         return true
            case .element95:                         return true
            case .element94:                         return true
            case .element93:                         return true
            case .element92:                         return true
            case .element91:                         return true
            case .element90:                         return true
            case .element99:                         return true
            case .element98:                         return true
            case .element68:                         return true
            case .element69:                         return true
            case .element62:                         return true
            case .element63:                         return true
            case .element60:                         return true
            case .element61:                         return true
            case .element66:                         return true
            case .element67:                         return true
            case .element64:                         return true
            case .element65:                         return true
            case .element79:                         return true
            case .element78:                         return true
            case .element75:                         return true
            case .element74:                         return true
            case .element77:                         return true
            case .element76:                         return true
            case .element71:                         return true
            case .element70:                         return true
            case .element73:                         return true
            case .element72:                         return true
            case .element40:                         return true
            case .element41:                         return true
            case .element42:                         return true
            case .element43:                         return true
            case .element44:                         return true
            case .element45:                         return true
            case .element46:                         return true
            case .element47:                         return true
            case .element48:                         return true
            case .element49:                         return true
            case .element53:                         return true
            case .element52:                         return true
            case .element51:                         return true
            case .element50:                         return true
            case .element57:                         return true
            case .element56:                         return true
            case .element55:                         return true
            case .element54:                         return true
            case .element59:                         return true
            case .element58:                         return true
            case .element26:                         return true
            case .element27:                         return true
            case .element24:                         return true
            case .element25:                         return true
            case .element22:                         return true
            case .element23:                         return true
            case .element20:                         return true
            case .element21:                         return true
            case .element28:                         return true
            case .element29:                         return true
            case .element39:                         return true
            case .element38:                         return true
            case .element31:                         return true
            case .element30:                         return true
            case .element33:                         return true
            case .element32:                         return true
            case .element35:                         return true
            case .element34:                         return true
            case .element37:                         return true
            case .element36:                         return true
            case .element19:                         return true
            case .element18:                         return true
            case .element17:                         return true
            case .element16:                         return true
            case .element15:                         return true
            case .element14:                         return true
            case .element13:                         return true
            case .element12:                         return true
            case .element11:                         return true
            case .element10:                         return true
            case .coloredTorchRg:                    return true
            case .coloredTorchBp:                    return true
            case .chemicalHeat:                      return true
            case .netherreactor:                     return true
            case .chemistryTable:                    return true
            case .camera:                            return true
            case .element8:                          return true
            case .element9:                          return true
            case .element6:                          return true
            case .element7:                          return true
            case .element4:                          return true
            case .element5:                          return true
            case .element2:                          return true
            case .element3:                          return true
            case .element0:                          return true
            case .element1:                          return true
            case .allow:                             return true
            case .hardStainedGlass:                  return true
            case .deny:                              return true
            case .element118:                        return true
            case .element114:                        return true
            case .element115:                        return true
            case .element116:                        return true
            case .element117:                        return true
            case .element110:                        return true
            case .element111:                        return true
            case .element112:                        return true
            case .element113:                        return true
            case .element109:                        return true
            case .element108:                        return true
            case .element107:                        return true
            case .element106:                        return true
            case .element105:                        return true
            case .element104:                        return true
            case .element103:                        return true
            case .element102:                        return true
            case .element101:                        return true
            case .element100:                        return true
            case .borderBlock:                       return true
            case .hardGlass:                         return true
            case .unknown:                           return true
            case .reserved6:                         return true
            case .clientRequestPlaceholderBlock:     return true
            case .frame:                             return true
            case .glowingobsidian:                   return true
            case .underwaterTorch:                   return true
            case .invisibleBedrock:                  return true
            case .stonecutter:                       return true
            case .hardGlassPane:                     return true
            case .lavaCauldron:                      return true
            case .infoUpdate:                        return true
            case .glowFrame:                         return true
            default:                                 return false
        }
    }
}

extension MCBlockType {
    public var color: UInt32 {
        switch self {
            case .air:                               return 0xF0000F
            case .stone:                             return 0xF0000F
            case .grass:                             return 0xF0000F
            case .dirt:                              return 0xF0000F
            case .podzol:                            return 0xF0000F
            case .cobblestone:                       return 0xF0000F
            case .planks:                            return 0xF0000F
            case .mangrovePlanks:                    return 0xF0000F
            case .sapling:                           return 0xF0000F
            case .mangrovePropagule:                 return 0xF0000F
            case .bedrock:                           return 0xF0000F
            case .flowingWater:                      return 0xF0000F
            case .water:                             return 0xF0000F
            case .lava:                              return 0xF0000F
            case .flowingLava:                       return 0xF0000F
            case .sand:                              return 0xF0000F
            case .gravel:                            return 0xF0000F
            case .goldOre:                           return 0xF0000F
            case .deepslateGoldOre:                  return 0xF0000F
            case .ironOre:                           return 0xF0000F
            case .deepslateIronOre:                  return 0xF0000F
            case .coalOre:                           return 0xF0000F
            case .deepslateCoalOre:                  return 0xF0000F
            case .netherGoldOre:                     return 0xF0000F
            case .log:                               return 0xF0000F
            case .log2:                              return 0xF0000F
            case .mangroveLog:                       return 0xF0000F
            case .mangroveRoots:                     return 0xF0000F
            case .muddyMangroveRoots:                return 0xF0000F
            case .strippedSpruceLog:                 return 0xF0000F
            case .strippedBirchLog:                  return 0xF0000F
            case .strippedJungleLog:                 return 0xF0000F
            case .strippedAcaciaLog:                 return 0xF0000F
            case .strippedDarkOakLog:                return 0xF0000F
            case .strippedOakLog:                    return 0xF0000F
            case .strippedMangroveLog:               return 0xF0000F
            case .wood:                              return 0xF0000F
            case .mangroveWood:                      return 0xF0000F
            case .strippedMangroveWood:              return 0xF0000F
            case .leaves:                            return 0xF0000F
            case .leaves2:                           return 0xF0000F
            case .mangroveLeaves:                    return 0xF0000F
            case .azaleaLeaves:                      return 0xF0000F
            case .azaleaLeavesFlowered:              return 0xF0000F
            case .sponge:                            return 0xF0000F
            case .glass:                             return 0xF0000F
            case .lapisOre:                          return 0xF0000F
            case .deepslateLapisOre:                 return 0xF0000F
            case .lapisBlock:                        return 0xF0000F
            case .dispenser:                         return 0xF0000F
            case .sandstone:                         return 0xF0000F
            case .noteblock:                         return 0xF0000F
            case .bed:                               return 0xF0000F
            case .goldenRail:                        return 0xF0000F
            case .detectorRail:                      return 0xF0000F
            case .stickyPiston:                      return 0xF0000F
            case .web:                               return 0xF0000F
            case .tallgrass:                         return 0xF0000F
            case .deadbush:                          return 0xF0000F
            case .seagrass:                          return 0xF0000F
            case .piston:                            return 0xF0000F
            case .pistonArmCollision:                return 0xF0000F
            case .stickyPistonArmCollision:          return 0xF0000F
            case .wool:                              return 0xF0000F
            case .movingBlock:                       return 0xF0000F
            case .yellowFlower:                      return 0xF0000F
            case .redFlower:                         return 0xF0000F
            case .witherRose:                        return 0xF0000F
            case .brownMushroom:                     return 0xF0000F
            case .redMushroom:                       return 0xF0000F
            case .goldBlock:                         return 0xF0000F
            case .ironBlock:                         return 0xF0000F
            case .brickBlock:                        return 0xF0000F
            case .tnt:                               return 0xF0000F
            case .bookshelf:                         return 0xF0000F
            case .mossyCobblestone:                  return 0xF0000F
            case .obsidian:                          return 0xF0000F
            case .torch:                             return 0xF0000F
            case .fire:                              return 0xF0000F
            case .soulFire:                          return 0xF0000F
            case .mobSpawner:                        return 0xF0000F
            case .oakStairs:                         return 0xF0000F
            case .chest:                             return 0xF0000F
            case .redstoneWire:                      return 0xF0000F
            case .diamondOre:                        return 0xF0000F
            case .deepslateDiamondOre:               return 0xF0000F
            case .diamondBlock:                      return 0xF0000F
            case .craftingTable:                     return 0xF0000F
            case .wheat:                             return 0xF0000F
            case .farmland:                          return 0xF0000F
            case .litFurnace:                        return 0xF0000F
            case .furnace:                           return 0xF0000F
            case .standingSign:                      return 0xF0000F
            case .spruceStandingSign:                return 0xF0000F
            case .birchStandingSign:                 return 0xF0000F
            case .acaciaStandingSign:                return 0xF0000F
            case .jungleStandingSign:                return 0xF0000F
            case .darkoakStandingSign:               return 0xF0000F
            case .mangroveStandingSign:              return 0xF0000F
            case .woodenDoor:                        return 0xF0000F
            case .ladder:                            return 0xF0000F
            case .rail:                              return 0xF0000F
            case .stoneStairs:                       return 0xF0000F
            case .wallSign:                          return 0xF0000F
            case .spruceWallSign:                    return 0xF0000F
            case .birchWallSign:                     return 0xF0000F
            case .acaciaWallSign:                    return 0xF0000F
            case .jungleWallSign:                    return 0xF0000F
            case .darkoakWallSign:                   return 0xF0000F
            case .mangroveWallSign:                  return 0xF0000F
            case .lever:                             return 0xF0000F
            case .stonePressurePlate:                return 0xF0000F
            case .ironDoor:                          return 0xF0000F
            case .woodenPressurePlate:               return 0xF0000F
            case .sprucePressurePlate:               return 0xF0000F
            case .birchPressurePlate:                return 0xF0000F
            case .junglePressurePlate:               return 0xF0000F
            case .acaciaPressurePlate:               return 0xF0000F
            case .darkOakPressurePlate:              return 0xF0000F
            case .mangrovePressurePlate:             return 0xF0000F
            case .redstoneOre:                       return 0xF0000F
            case .litRedstoneOre:                    return 0xF0000F
            case .deepslateRedstoneOre:              return 0xF0000F
            case .litDeepslateRedstoneOre:           return 0xF0000F
            case .redstoneTorch:                     return 0xF0000F
            case .unlitRedstoneTorch:                return 0xF0000F
            case .stoneButton:                       return 0xF0000F
            case .snowLayer:                         return 0xF0000F
            case .ice:                               return 0xF0000F
            case .snow:                              return 0xF0000F
            case .cactus:                            return 0xF0000F
            case .clay:                              return 0xF0000F
            case .reeds:                             return 0xF0000F
            case .jukebox:                           return 0xF0000F
            case .fence:                             return 0xF0000F
            case .pumpkin:                           return 0xF0000F
            case .netherrack:                        return 0xF0000F
            case .soulSand:                          return 0xF0000F
            case .soulSoil:                          return 0xF0000F
            case .basalt:                            return 0xF0000F
            case .polishedBasalt:                    return 0xF0000F
            case .soulTorch:                         return 0xF0000F
            case .glowstone:                         return 0xF0000F
            case .portal:                            return 0xF0000F
            case .carvedPumpkin:                     return 0xF0000F
            case .litPumpkin:                        return 0xF0000F
            case .cake:                              return 0xF0000F
            case .poweredRepeater:                   return 0xF0000F
            case .unpoweredRepeater:                 return 0xF0000F
            case .stainedGlass:                      return 0xF0000F
            case .trapdoor:                          return 0xF0000F
            case .spruceTrapdoor:                    return 0xF0000F
            case .birchTrapdoor:                     return 0xF0000F
            case .jungleTrapdoor:                    return 0xF0000F
            case .acaciaTrapdoor:                    return 0xF0000F
            case .darkOakTrapdoor:                   return 0xF0000F
            case .mangroveTrapdoor:                  return 0xF0000F
            case .stonebrick:                        return 0xF0000F
            case .packedMud:                         return 0xF0000F
            case .mudBricks:                         return 0xF0000F
            case .monsterEgg:                        return 0xF0000F
            case .brownMushroomBlock:                return 0xF0000F
            case .redMushroomBlock:                  return 0xF0000F
            case .ironBars:                          return 0xF0000F
            case .chain:                             return 0xF0000F
            case .glassPane:                         return 0xF0000F
            case .melonBlock:                        return 0xF0000F
            case .pumpkinStem:                       return 0xF0000F
            case .melonStem:                         return 0xF0000F
            case .vine:                              return 0xF0000F
            case .glowLichen:                        return 0xF0000F
            case .fenceGate:                         return 0xF0000F
            case .brickStairs:                       return 0xF0000F
            case .stoneBrickStairs:                  return 0xF0000F
            case .mudBrickStairs:                    return 0xF0000F
            case .mycelium:                          return 0xF0000F
            case .waterlily:                         return 0xF0000F
            case .netherBrick:                       return 0xF0000F
            case .netherBrickFence:                  return 0xF0000F
            case .netherBrickStairs:                 return 0xF0000F
            case .netherWart:                        return 0xF0000F
            case .enchantingTable:                   return 0xF0000F
            case .brewingStand:                      return 0xF0000F
            case .cauldron:                          return 0xF0000F
            case .endPortal:                         return 0xF0000F
            case .endPortalFrame:                    return 0xF0000F
            case .endStone:                          return 0xF0000F
            case .dragonEgg:                         return 0xF0000F
            case .redstoneLamp:                      return 0xF0000F
            case .litRedstoneLamp:                   return 0xF0000F
            case .cocoa:                             return 0xF0000F
            case .sandstoneStairs:                   return 0xF0000F
            case .emeraldOre:                        return 0xF0000F
            case .deepslateEmeraldOre:               return 0xF0000F
            case .enderChest:                        return 0xF0000F
            case .tripwireHook:                      return 0xF0000F
            case .tripWire:                          return 0xF0000F
            case .emeraldBlock:                      return 0xF0000F
            case .spruceStairs:                      return 0xF0000F
            case .birchStairs:                       return 0xF0000F
            case .jungleStairs:                      return 0xF0000F
            case .commandBlock:                      return 0xF0000F
            case .beacon:                            return 0xF0000F
            case .cobblestoneWall:                   return 0xF0000F
            case .carrots:                           return 0xF0000F
            case .potatoes:                          return 0xF0000F
            case .woodenButton:                      return 0xF0000F
            case .spruceButton:                      return 0xF0000F
            case .birchButton:                       return 0xF0000F
            case .jungleButton:                      return 0xF0000F
            case .acaciaButton:                      return 0xF0000F
            case .darkOakButton:                     return 0xF0000F
            case .mangroveButton:                    return 0xF0000F
            case .skull:                             return 0xF0000F
            case .anvil:                             return 0xF0000F
            case .trappedChest:                      return 0xF0000F
            case .lightWeightedPressurePlate:        return 0xF0000F
            case .heavyWeightedPressurePlate:        return 0xF0000F
            case .poweredComparator:                 return 0xF0000F
            case .unpoweredComparator:               return 0xF0000F
            case .daylightDetector:                  return 0xF0000F
            case .daylightDetectorInverted:          return 0xF0000F
            case .redstoneBlock:                     return 0xF0000F
            case .quartzOre:                         return 0xF0000F
            case .hopper:                            return 0xF0000F
            case .quartzBlock:                       return 0xF0000F
            case .quartzStairs:                      return 0xF0000F
            case .activatorRail:                     return 0xF0000F
            case .dropper:                           return 0xF0000F
            case .stainedHardenedClay:               return 0xF0000F
            case .stainedGlassPane:                  return 0xF0000F
            case .acaciaStairs:                      return 0xF0000F
            case .darkOakStairs:                     return 0xF0000F
            case .mangroveStairs:                    return 0xF0000F
            case .slime:                             return 0xF0000F
            case .barrier:                           return 0xF0000F
            case .lightBlock:                        return 0xF0000F
            case .ironTrapdoor:                      return 0xF0000F
            case .prismarine:                        return 0xF0000F
            case .prismarineStairs:                  return 0xF0000F
            case .prismarineBricksStairs:            return 0xF0000F
            case .darkPrismarineStairs:              return 0xF0000F
            case .stoneBlockSlab2:                   return 0xF0000F
            case .doubleStoneBlockSlab2:             return 0xF0000F
            case .seaLantern:                        return 0xF0000F
            case .hayBlock:                          return 0xF0000F
            case .carpet:                            return 0xF0000F
            case .hardenedClay:                      return 0xF0000F
            case .coalBlock:                         return 0xF0000F
            case .packedIce:                         return 0xF0000F
            case .doublePlant:                       return 0xF0000F
            case .standingBanner:                    return 0xF0000F
            case .wallBanner:                        return 0xF0000F
            case .redSandstone:                      return 0xF0000F
            case .redSandstoneStairs:                return 0xF0000F
            case .woodenSlab:                        return 0xF0000F
            case .doubleWoodenSlab:                  return 0xF0000F
            case .mangroveDoubleSlab:                return 0xF0000F
            case .mangroveSlab:                      return 0xF0000F
            case .stoneBlockSlab4:                   return 0xF0000F
            case .doubleStoneBlockSlab4:             return 0xF0000F
            case .stoneBlockSlab:                    return 0xF0000F
            case .doubleStoneBlockSlab:              return 0xF0000F
            case .mudBrickDoubleSlab:                return 0xF0000F
            case .mudBrickSlab:                      return 0xF0000F
            case .smoothStone:                       return 0xF0000F
            case .spruceFenceGate:                   return 0xF0000F
            case .birchFenceGate:                    return 0xF0000F
            case .jungleFenceGate:                   return 0xF0000F
            case .acaciaFenceGate:                   return 0xF0000F
            case .darkOakFenceGate:                  return 0xF0000F
            case .mangroveFenceGate:                 return 0xF0000F
            case .mangroveFence:                     return 0xF0000F
            case .spruceDoor:                        return 0xF0000F
            case .birchDoor:                         return 0xF0000F
            case .jungleDoor:                        return 0xF0000F
            case .acaciaDoor:                        return 0xF0000F
            case .darkOakDoor:                       return 0xF0000F
            case .mangroveDoor:                      return 0xF0000F
            case .endRod:                            return 0xF0000F
            case .chorusPlant:                       return 0xF0000F
            case .chorusFlower:                      return 0xF0000F
            case .purpurBlock:                       return 0xF0000F
            case .purpurStairs:                      return 0xF0000F
            case .endBricks:                         return 0xF0000F
            case .beetroot:                          return 0xF0000F
            case .grassPath:                         return 0xF0000F
            case .endGateway:                        return 0xF0000F
            case .repeatingCommandBlock:             return 0xF0000F
            case .chainCommandBlock:                 return 0xF0000F
            case .frostedIce:                        return 0xF0000F
            case .magma:                             return 0xF0000F
            case .netherWartBlock:                   return 0xF0000F
            case .redNetherBrick:                    return 0xF0000F
            case .boneBlock:                         return 0xF0000F
            case .structureVoid:                     return 0xF0000F
            case .observer:                          return 0xF0000F
            case .undyedShulkerBox:                  return 0xF0000F
            case .shulkerBox:                        return 0xF0000F
            case .whiteGlazedTerracotta:             return 0xF0000F
            case .orangeGlazedTerracotta:            return 0xF0000F
            case .magentaGlazedTerracotta:           return 0xF0000F
            case .lightBlueGlazedTerracotta:         return 0xF0000F
            case .yellowGlazedTerracotta:            return 0xF0000F
            case .limeGlazedTerracotta:              return 0xF0000F
            case .pinkGlazedTerracotta:              return 0xF0000F
            case .grayGlazedTerracotta:              return 0xF0000F
            case .silverGlazedTerracotta:            return 0xF0000F
            case .cyanGlazedTerracotta:              return 0xF0000F
            case .purpleGlazedTerracotta:            return 0xF0000F
            case .blueGlazedTerracotta:              return 0xF0000F
            case .brownGlazedTerracotta:             return 0xF0000F
            case .greenGlazedTerracotta:             return 0xF0000F
            case .redGlazedTerracotta:               return 0xF0000F
            case .blackGlazedTerracotta:             return 0xF0000F
            case .concrete:                          return 0xF0000F
            case .concretePowder:                    return 0xF0000F
            case .kelp:                              return 0xF0000F
            case .driedKelpBlock:                    return 0xF0000F
            case .turtleEgg:                         return 0xF0000F
            case .coralBlock:                        return 0xF0000F
            case .coral:                             return 0xF0000F
            case .coralFanDead:                      return 0xF0000F
            case .coralFan:                          return 0xF0000F
            case .coralFanHang:                      return 0xF0000F
            case .coralFanHang2:                     return 0xF0000F
            case .coralFanHang3:                     return 0xF0000F
            case .seaPickle:                         return 0xF0000F
            case .blueIce:                           return 0xF0000F
            case .conduit:                           return 0xF0000F
            case .bambooSapling:                     return 0xF0000F
            case .bamboo:                            return 0xF0000F
            case .bubbleColumn:                      return 0xF0000F
            case .polishedGraniteStairs:             return 0xF0000F
            case .smoothRedSandstoneStairs:          return 0xF0000F
            case .mossyStoneBrickStairs:             return 0xF0000F
            case .polishedDioriteStairs:             return 0xF0000F
            case .mossyCobblestoneStairs:            return 0xF0000F
            case .endBrickStairs:                    return 0xF0000F
            case .normalStoneStairs:                 return 0xF0000F
            case .smoothSandstoneStairs:             return 0xF0000F
            case .smoothQuartzStairs:                return 0xF0000F
            case .graniteStairs:                     return 0xF0000F
            case .andesiteStairs:                    return 0xF0000F
            case .redNetherBrickStairs:              return 0xF0000F
            case .polishedAndesiteStairs:            return 0xF0000F
            case .dioriteStairs:                     return 0xF0000F
            case .stoneBlockSlab3:                   return 0xF0000F
            case .doubleStoneBlockSlab3:             return 0xF0000F
            case .mudBrickWall:                      return 0xF0000F
            case .scaffolding:                       return 0xF0000F
            case .loom:                              return 0xF0000F
            case .barrel:                            return 0xF0000F
            case .smoker:                            return 0xF0000F
            case .litSmoker:                         return 0xF0000F
            case .litBlastFurnace:                   return 0xF0000F
            case .blastFurnace:                      return 0xF0000F
            case .cartographyTable:                  return 0xF0000F
            case .fletchingTable:                    return 0xF0000F
            case .grindstone:                        return 0xF0000F
            case .lectern:                           return 0xF0000F
            case .smithingTable:                     return 0xF0000F
            case .stonecutterBlock:                  return 0xF0000F
            case .bell:                              return 0xF0000F
            case .lantern:                           return 0xF0000F
            case .soulLantern:                       return 0xF0000F
            case .campfire:                          return 0xF0000F
            case .soulCampfire:                      return 0xF0000F
            case .sweetBerryBush:                    return 0xF0000F
            case .warpedStem:                        return 0xF0000F
            case .strippedWarpedStem:                return 0xF0000F
            case .warpedHyphae:                      return 0xF0000F
            case .strippedWarpedHyphae:              return 0xF0000F
            case .warpedNylium:                      return 0xF0000F
            case .warpedFungus:                      return 0xF0000F
            case .warpedWartBlock:                   return 0xF0000F
            case .warpedRoots:                       return 0xF0000F
            case .netherSprouts:                     return 0xF0000F
            case .crimsonStem:                       return 0xF0000F
            case .strippedCrimsonStem:               return 0xF0000F
            case .crimsonHyphae:                     return 0xF0000F
            case .strippedCrimsonHyphae:             return 0xF0000F
            case .crimsonNylium:                     return 0xF0000F
            case .crimsonFungus:                     return 0xF0000F
            case .shroomlight:                       return 0xF0000F
            case .weepingVines:                      return 0xF0000F
            case .twistingVines:                     return 0xF0000F
            case .crimsonRoots:                      return 0xF0000F
            case .crimsonPlanks:                     return 0xF0000F
            case .warpedPlanks:                      return 0xF0000F
            case .crimsonDoubleSlab:                 return 0xF0000F
            case .crimsonSlab:                       return 0xF0000F
            case .warpedDoubleSlab:                  return 0xF0000F
            case .warpedSlab:                        return 0xF0000F
            case .crimsonPressurePlate:              return 0xF0000F
            case .warpedPressurePlate:               return 0xF0000F
            case .crimsonFence:                      return 0xF0000F
            case .warpedFence:                       return 0xF0000F
            case .crimsonTrapdoor:                   return 0xF0000F
            case .warpedTrapdoor:                    return 0xF0000F
            case .crimsonFenceGate:                  return 0xF0000F
            case .warpedFenceGate:                   return 0xF0000F
            case .crimsonStairs:                     return 0xF0000F
            case .warpedStairs:                      return 0xF0000F
            case .crimsonButton:                     return 0xF0000F
            case .warpedButton:                      return 0xF0000F
            case .crimsonDoor:                       return 0xF0000F
            case .warpedDoor:                        return 0xF0000F
            case .crimsonStandingSign:               return 0xF0000F
            case .warpedStandingSign:                return 0xF0000F
            case .crimsonWallSign:                   return 0xF0000F
            case .warpedWallSign:                    return 0xF0000F
            case .structureBlock:                    return 0xF0000F
            case .jigsaw:                            return 0xF0000F
            case .composter:                         return 0xF0000F
            case .target:                            return 0xF0000F
            case .beeNest:                           return 0xF0000F
            case .beehive:                           return 0xF0000F
            case .honeyBlock:                        return 0xF0000F
            case .honeycombBlock:                    return 0xF0000F
            case .netheriteBlock:                    return 0xF0000F
            case .ancientDebris:                     return 0xF0000F
            case .cryingObsidian:                    return 0xF0000F
            case .respawnAnchor:                     return 0xF0000F
            case .lodestone:                         return 0xF0000F
            case .blackstone:                        return 0xF0000F
            case .blackstoneStairs:                  return 0xF0000F
            case .blackstoneWall:                    return 0xF0000F
            case .blackstoneDoubleSlab:              return 0xF0000F
            case .blackstoneSlab:                    return 0xF0000F
            case .polishedBlackstone:                return 0xF0000F
            case .polishedBlackstoneBricks:          return 0xF0000F
            case .crackedPolishedBlackstoneBricks:   return 0xF0000F
            case .chiseledPolishedBlackstone:        return 0xF0000F
            case .polishedBlackstoneBrickDoubleSlab: return 0xF0000F
            case .polishedBlackstoneBrickSlab:       return 0xF0000F
            case .polishedBlackstoneBrickStairs:     return 0xF0000F
            case .polishedBlackstoneBrickWall:       return 0xF0000F
            case .gildedBlackstone:                  return 0xF0000F
            case .polishedBlackstoneStairs:          return 0xF0000F
            case .polishedBlackstoneDoubleSlab:      return 0xF0000F
            case .polishedBlackstoneSlab:            return 0xF0000F
            case .polishedBlackstonePressurePlate:   return 0xF0000F
            case .polishedBlackstoneButton:          return 0xF0000F
            case .polishedBlackstoneWall:            return 0xF0000F
            case .chiseledNetherBricks:              return 0xF0000F
            case .crackedNetherBricks:               return 0xF0000F
            case .quartzBricks:                      return 0xF0000F
            case .candle:                            return 0xF0000F
            case .whiteCandle:                       return 0xF0000F
            case .orangeCandle:                      return 0xF0000F
            case .magentaCandle:                     return 0xF0000F
            case .lightBlueCandle:                   return 0xF0000F
            case .yellowCandle:                      return 0xF0000F
            case .limeCandle:                        return 0xF0000F
            case .pinkCandle:                        return 0xF0000F
            case .grayCandle:                        return 0xF0000F
            case .lightGrayCandle:                   return 0xF0000F
            case .cyanCandle:                        return 0xF0000F
            case .purpleCandle:                      return 0xF0000F
            case .blueCandle:                        return 0xF0000F
            case .brownCandle:                       return 0xF0000F
            case .greenCandle:                       return 0xF0000F
            case .redCandle:                         return 0xF0000F
            case .blackCandle:                       return 0xF0000F
            case .candleCake:                        return 0xF0000F
            case .whiteCandleCake:                   return 0xF0000F
            case .orangeCandleCake:                  return 0xF0000F
            case .magentaCandleCake:                 return 0xF0000F
            case .lightBlueCandleCake:               return 0xF0000F
            case .yellowCandleCake:                  return 0xF0000F
            case .limeCandleCake:                    return 0xF0000F
            case .pinkCandleCake:                    return 0xF0000F
            case .grayCandleCake:                    return 0xF0000F
            case .lightGrayCandleCake:               return 0xF0000F
            case .cyanCandleCake:                    return 0xF0000F
            case .purpleCandleCake:                  return 0xF0000F
            case .blueCandleCake:                    return 0xF0000F
            case .brownCandleCake:                   return 0xF0000F
            case .greenCandleCake:                   return 0xF0000F
            case .redCandleCake:                     return 0xF0000F
            case .blackCandleCake:                   return 0xF0000F
            case .amethystBlock:                     return 0xF0000F
            case .buddingAmethyst:                   return 0xF0000F
            case .amethystCluster:                   return 0xF0000F
            case .largeAmethystBud:                  return 0xF0000F
            case .mediumAmethystBud:                 return 0xF0000F
            case .smallAmethystBud:                  return 0xF0000F
            case .tuff:                              return 0xF0000F
            case .calcite:                           return 0xF0000F
            case .tintedGlass:                       return 0xF0000F
            case .powderSnow:                        return 0xF0000F
            case .sculkSensor:                       return 0xF0000F
            case .sculk:                             return 0xF0000F
            case .sculkVein:                         return 0xF0000F
            case .sculkCatalyst:                     return 0xF0000F
            case .sculkShrieker:                     return 0xF0000F
            case .oxidizedCopper:                    return 0xF0000F
            case .weatheredCopper:                   return 0xF0000F
            case .exposedCopper:                     return 0xF0000F
            case .copperBlock:                       return 0xF0000F
            case .copperOre:                         return 0xF0000F
            case .deepslateCopperOre:                return 0xF0000F
            case .oxidizedCutCopper:                 return 0xF0000F
            case .weatheredCutCopper:                return 0xF0000F
            case .exposedCutCopper:                  return 0xF0000F
            case .cutCopper:                         return 0xF0000F
            case .oxidizedCutCopperStairs:           return 0xF0000F
            case .weatheredCutCopperStairs:          return 0xF0000F
            case .exposedCutCopperStairs:            return 0xF0000F
            case .cutCopperStairs:                   return 0xF0000F
            case .oxidizedDoubleCutCopperSlab:       return 0xF0000F
            case .oxidizedCutCopperSlab:             return 0xF0000F
            case .weatheredCutCopperSlab:            return 0xF0000F
            case .weatheredDoubleCutCopperSlab:      return 0xF0000F
            case .exposedDoubleCutCopperSlab:        return 0xF0000F
            case .exposedCutCopperSlab:              return 0xF0000F
            case .doubleCutCopperSlab:               return 0xF0000F
            case .cutCopperSlab:                     return 0xF0000F
            case .waxedCopper:                       return 0xF0000F
            case .waxedWeatheredCopper:              return 0xF0000F
            case .waxedExposedCopper:                return 0xF0000F
            case .waxedOxidizedCopper:               return 0xF0000F
            case .waxedOxidizedCutCopper:            return 0xF0000F
            case .waxedWeatheredCutCopper:           return 0xF0000F
            case .waxedExposedCutCopper:             return 0xF0000F
            case .waxedCutCopper:                    return 0xF0000F
            case .waxedOxidizedCutCopperStairs:      return 0xF0000F
            case .waxedWeatheredCutCopperStairs:     return 0xF0000F
            case .waxedExposedCutCopperStairs:       return 0xF0000F
            case .waxedCutCopperStairs:              return 0xF0000F
            case .waxedOxidizedCutCopperSlab:        return 0xF0000F
            case .waxedOxidizedDoubleCutCopperSlab:  return 0xF0000F
            case .waxedWeatheredDoubleCutCopperSlab: return 0xF0000F
            case .waxedWeatheredCutCopperSlab:       return 0xF0000F
            case .waxedExposedCutCopperSlab:         return 0xF0000F
            case .waxedExposedDoubleCutCopperSlab:   return 0xF0000F
            case .waxedDoubleCutCopperSlab:          return 0xF0000F
            case .waxedCutCopperSlab:                return 0xF0000F
            case .lightningRod:                      return 0xF0000F
            case .pointedDripstone:                  return 0xF0000F
            case .dripstoneBlock:                    return 0xF0000F
            case .caveVinesHeadWithBerries:          return 0xF0000F
            case .caveVines:                         return 0xF0000F
            case .caveVinesBodyWithBerries:          return 0xF0000F
            case .sporeBlossom:                      return 0xF0000F
            case .azalea:                            return 0xF0000F
            case .floweringAzalea:                   return 0xF0000F
            case .mossCarpet:                        return 0xF0000F
            case .mossBlock:                         return 0xF0000F
            case .bigDripleaf:                       return 0xF0000F
            case .smallDripleafBlock:                return 0xF0000F
            case .hangingRoots:                      return 0xF0000F
            case .dirtWithRoots:                     return 0xF0000F
            case .mud:                               return 0xF0000F
            case .deepslate:                         return 0xF0000F
            case .cobbledDeepslate:                  return 0xF0000F
            case .cobbledDeepslateStairs:            return 0xF0000F
            case .cobbledDeepslateDoubleSlab:        return 0xF0000F
            case .cobbledDeepslateSlab:              return 0xF0000F
            case .cobbledDeepslateWall:              return 0xF0000F
            case .polishedDeepslate:                 return 0xF0000F
            case .polishedDeepslateStairs:           return 0xF0000F
            case .polishedDeepslateSlab:             return 0xF0000F
            case .polishedDeepslateDoubleSlab:       return 0xF0000F
            case .polishedDeepslateWall:             return 0xF0000F
            case .deepslateTiles:                    return 0xF0000F
            case .deepslateTileStairs:               return 0xF0000F
            case .deepslateTileDoubleSlab:           return 0xF0000F
            case .deepslateTileSlab:                 return 0xF0000F
            case .deepslateTileWall:                 return 0xF0000F
            case .deepslateBricks:                   return 0xF0000F
            case .deepslateBrickStairs:              return 0xF0000F
            case .deepslateBrickDoubleSlab:          return 0xF0000F
            case .deepslateBrickSlab:                return 0xF0000F
            case .deepslateBrickWall:                return 0xF0000F
            case .chiseledDeepslate:                 return 0xF0000F
            case .crackedDeepslateBricks:            return 0xF0000F
            case .crackedDeepslateTiles:             return 0xF0000F
            case .infestedDeepslate:                 return 0xF0000F
            case .smoothBasalt:                      return 0xF0000F
            case .rawIronBlock:                      return 0xF0000F
            case .rawCopperBlock:                    return 0xF0000F
            case .rawGoldBlock:                      return 0xF0000F
            case .flowerPot:                         return 0xF0000F
            case .ochreFroglight:                    return 0xF0000F
            case .verdantFroglight:                  return 0xF0000F
            case .pearlescentFroglight:              return 0xF0000F
            case .frogSpawn:                         return 0xF0000F
            case .reinforcedDeepslate:               return 0xF0000F
            case .hardStainedGlassPane:              return 0xF0000F
            case .infoUpdate2:                       return 0xF0000F
            case .element84:                         return 0xF0000F
            case .element85:                         return 0xF0000F
            case .element86:                         return 0xF0000F
            case .element87:                         return 0xF0000F
            case .element80:                         return 0xF0000F
            case .element81:                         return 0xF0000F
            case .element82:                         return 0xF0000F
            case .element83:                         return 0xF0000F
            case .element88:                         return 0xF0000F
            case .element89:                         return 0xF0000F
            case .element97:                         return 0xF0000F
            case .element96:                         return 0xF0000F
            case .element95:                         return 0xF0000F
            case .element94:                         return 0xF0000F
            case .element93:                         return 0xF0000F
            case .element92:                         return 0xF0000F
            case .element91:                         return 0xF0000F
            case .element90:                         return 0xF0000F
            case .element99:                         return 0xF0000F
            case .element98:                         return 0xF0000F
            case .element68:                         return 0xF0000F
            case .element69:                         return 0xF0000F
            case .element62:                         return 0xF0000F
            case .element63:                         return 0xF0000F
            case .element60:                         return 0xF0000F
            case .element61:                         return 0xF0000F
            case .element66:                         return 0xF0000F
            case .element67:                         return 0xF0000F
            case .element64:                         return 0xF0000F
            case .element65:                         return 0xF0000F
            case .element79:                         return 0xF0000F
            case .element78:                         return 0xF0000F
            case .element75:                         return 0xF0000F
            case .element74:                         return 0xF0000F
            case .element77:                         return 0xF0000F
            case .element76:                         return 0xF0000F
            case .element71:                         return 0xF0000F
            case .element70:                         return 0xF0000F
            case .element73:                         return 0xF0000F
            case .element72:                         return 0xF0000F
            case .element40:                         return 0xF0000F
            case .element41:                         return 0xF0000F
            case .element42:                         return 0xF0000F
            case .element43:                         return 0xF0000F
            case .element44:                         return 0xF0000F
            case .element45:                         return 0xF0000F
            case .element46:                         return 0xF0000F
            case .element47:                         return 0xF0000F
            case .element48:                         return 0xF0000F
            case .element49:                         return 0xF0000F
            case .element53:                         return 0xF0000F
            case .element52:                         return 0xF0000F
            case .element51:                         return 0xF0000F
            case .element50:                         return 0xF0000F
            case .element57:                         return 0xF0000F
            case .element56:                         return 0xF0000F
            case .element55:                         return 0xF0000F
            case .element54:                         return 0xF0000F
            case .element59:                         return 0xF0000F
            case .element58:                         return 0xF0000F
            case .element26:                         return 0xF0000F
            case .element27:                         return 0xF0000F
            case .element24:                         return 0xF0000F
            case .element25:                         return 0xF0000F
            case .element22:                         return 0xF0000F
            case .element23:                         return 0xF0000F
            case .element20:                         return 0xF0000F
            case .element21:                         return 0xF0000F
            case .element28:                         return 0xF0000F
            case .element29:                         return 0xF0000F
            case .element39:                         return 0xF0000F
            case .element38:                         return 0xF0000F
            case .element31:                         return 0xF0000F
            case .element30:                         return 0xF0000F
            case .element33:                         return 0xF0000F
            case .element32:                         return 0xF0000F
            case .element35:                         return 0xF0000F
            case .element34:                         return 0xF0000F
            case .element37:                         return 0xF0000F
            case .element36:                         return 0xF0000F
            case .element19:                         return 0xF0000F
            case .element18:                         return 0xF0000F
            case .element17:                         return 0xF0000F
            case .element16:                         return 0xF0000F
            case .element15:                         return 0xF0000F
            case .element14:                         return 0xF0000F
            case .element13:                         return 0xF0000F
            case .element12:                         return 0xF0000F
            case .element11:                         return 0xF0000F
            case .element10:                         return 0xF0000F
            case .coloredTorchRg:                    return 0xF0000F
            case .coloredTorchBp:                    return 0xF0000F
            case .chemicalHeat:                      return 0xF0000F
            case .netherreactor:                     return 0xF0000F
            case .chemistryTable:                    return 0xF0000F
            case .camera:                            return 0xF0000F
            case .element8:                          return 0xF0000F
            case .element9:                          return 0xF0000F
            case .element6:                          return 0xF0000F
            case .element7:                          return 0xF0000F
            case .element4:                          return 0xF0000F
            case .element5:                          return 0xF0000F
            case .element2:                          return 0xF0000F
            case .element3:                          return 0xF0000F
            case .element0:                          return 0xF0000F
            case .element1:                          return 0xF0000F
            case .allow:                             return 0xF0000F
            case .hardStainedGlass:                  return 0xF0000F
            case .deny:                              return 0xF0000F
            case .element118:                        return 0xF0000F
            case .element114:                        return 0xF0000F
            case .element115:                        return 0xF0000F
            case .element116:                        return 0xF0000F
            case .element117:                        return 0xF0000F
            case .element110:                        return 0xF0000F
            case .element111:                        return 0xF0000F
            case .element112:                        return 0xF0000F
            case .element113:                        return 0xF0000F
            case .element109:                        return 0xF0000F
            case .element108:                        return 0xF0000F
            case .element107:                        return 0xF0000F
            case .element106:                        return 0xF0000F
            case .element105:                        return 0xF0000F
            case .element104:                        return 0xF0000F
            case .element103:                        return 0xF0000F
            case .element102:                        return 0xF0000F
            case .element101:                        return 0xF0000F
            case .element100:                        return 0xF0000F
            case .borderBlock:                       return 0xF0000F
            case .hardGlass:                         return 0xF0000F
            case .unknown:                           return 0xF0000F
            case .reserved6:                         return 0xF0000F
            case .clientRequestPlaceholderBlock:     return 0xF0000F
            case .frame:                             return 0xF0000F
            case .glowingobsidian:                   return 0xF0000F
            case .underwaterTorch:                   return 0xF0000F
            case .invisibleBedrock:                  return 0xF0000F
            case .stonecutter:                       return 0xF0000F
            case .hardGlassPane:                     return 0xF0000F
            case .lavaCauldron:                      return 0xF0000F
            case .infoUpdate:                        return 0xF0000F
            case .glowFrame:                         return 0xF0000F
//            default:                                 return 0
        }
    }
}
