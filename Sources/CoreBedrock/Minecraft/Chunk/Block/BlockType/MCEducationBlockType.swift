import Foundation

public enum MCEducationBlockType {
    case unknown
    case chemistryTable
    case hardGlass
    case hardGlassPane
    case hardStainedGlass
    case hardStainedGlassPane
    case deny
    case allow
    case camera
    case borderBlock
    case chemicalHeat
    case coloredTorchBp
    case coloredTorchRg
    case underwaterTorch
    case chalkboard

    case element0
    case element1
    case element2
    case element3
    case element4
    case element5
    case element6
    case element7
    case element8
    case element9
    case element10
    case element11
    case element12
    case element13
    case element14
    case element15
    case element16
    case element17
    case element18
    case element19
    case element20
    case element21
    case element22
    case element23
    case element24
    case element25
    case element26
    case element27
    case element28
    case element29
    case element30
    case element31
    case element32
    case element33
    case element34
    case element35
    case element36
    case element37
    case element38
    case element39
    case element40
    case element41
    case element42
    case element43
    case element44
    case element45
    case element46
    case element47
    case element48
    case element49
    case element50
    case element51
    case element52
    case element53
    case element54
    case element55
    case element56
    case element57
    case element58
    case element59
    case element60
    case element61
    case element62
    case element63
    case element64
    case element65
    case element66
    case element67
    case element68
    case element69
    case element70
    case element71
    case element72
    case element73
    case element74
    case element75
    case element76
    case element77
    case element78
    case element79
    case element80
    case element81
    case element82
    case element83
    case element84
    case element85
    case element86
    case element87
    case element88
    case element89
    case element90
    case element91
    case element92
    case element93
    case element94
    case element95
    case element96
    case element97
    case element98
    case element99
    case element100
    case element101
    case element102
    case element103
    case element104
    case element105
    case element106
    case element107
    case element108
    case element109
    case element110
    case element111
    case element112
    case element113
    case element114
    case element115
    case element116
    case element117
    case element118
}

extension MCEducationBlockType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
            case "minecraft:chemistry_table":                        self = .chemistryTable
            case "minecraft:hard_glass":                             self = .hardGlass
            case "minecraft:hard_glass_pane":                        self = .hardGlassPane
            case "minecraft:hard_stained_glass":                     self = .hardStainedGlass
            case "minecraft:hard_stained_glass_pane":                self = .hardStainedGlassPane
            case "minecraft:deny":                                   self = .deny
            case "minecraft:allow":                                  self = .allow
            case "minecraft:camera":                                 self = .camera
            case "minecraft:border_block":                           self = .borderBlock
            case "minecraft:chemical_heat":                          self = .chemicalHeat
            case "minecraft:colored_torch_bp":                       self = .coloredTorchBp
            case "minecraft:colored_torch_rg":                       self = .coloredTorchRg
            case "minecraft:underwater_torch":                       self = .underwaterTorch
            case "minecraft:chalkboard":                             self = .chalkboard

            case "minecraft:element_0":                              self = .element0
            case "minecraft:element_1":                              self = .element1
            case "minecraft:element_2":                              self = .element2
            case "minecraft:element_3":                              self = .element3
            case "minecraft:element_4":                              self = .element4
            case "minecraft:element_5":                              self = .element5
            case "minecraft:element_6":                              self = .element6
            case "minecraft:element_7":                              self = .element7
            case "minecraft:element_8":                              self = .element8
            case "minecraft:element_9":                              self = .element9
            case "minecraft:element_10":                             self = .element10
            case "minecraft:element_11":                             self = .element11
            case "minecraft:element_12":                             self = .element12
            case "minecraft:element_13":                             self = .element13
            case "minecraft:element_14":                             self = .element14
            case "minecraft:element_15":                             self = .element15
            case "minecraft:element_16":                             self = .element16
            case "minecraft:element_17":                             self = .element17
            case "minecraft:element_18":                             self = .element18
            case "minecraft:element_19":                             self = .element19
            case "minecraft:element_20":                             self = .element20
            case "minecraft:element_21":                             self = .element21
            case "minecraft:element_22":                             self = .element22
            case "minecraft:element_23":                             self = .element23
            case "minecraft:element_24":                             self = .element24
            case "minecraft:element_25":                             self = .element25
            case "minecraft:element_26":                             self = .element26
            case "minecraft:element_27":                             self = .element27
            case "minecraft:element_28":                             self = .element28
            case "minecraft:element_29":                             self = .element29
            case "minecraft:element_30":                             self = .element30
            case "minecraft:element_31":                             self = .element31
            case "minecraft:element_32":                             self = .element32
            case "minecraft:element_33":                             self = .element33
            case "minecraft:element_34":                             self = .element34
            case "minecraft:element_35":                             self = .element35
            case "minecraft:element_36":                             self = .element36
            case "minecraft:element_37":                             self = .element37
            case "minecraft:element_38":                             self = .element38
            case "minecraft:element_39":                             self = .element39
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
            case "minecraft:element_50":                             self = .element50
            case "minecraft:element_51":                             self = .element51
            case "minecraft:element_52":                             self = .element52
            case "minecraft:element_53":                             self = .element53
            case "minecraft:element_54":                             self = .element54
            case "minecraft:element_55":                             self = .element55
            case "minecraft:element_56":                             self = .element56
            case "minecraft:element_57":                             self = .element57
            case "minecraft:element_58":                             self = .element58
            case "minecraft:element_59":                             self = .element59
            case "minecraft:element_60":                             self = .element60
            case "minecraft:element_61":                             self = .element61
            case "minecraft:element_62":                             self = .element62
            case "minecraft:element_63":                             self = .element63
            case "minecraft:element_64":                             self = .element64
            case "minecraft:element_65":                             self = .element65
            case "minecraft:element_66":                             self = .element66
            case "minecraft:element_67":                             self = .element67
            case "minecraft:element_68":                             self = .element68
            case "minecraft:element_69":                             self = .element69
            case "minecraft:element_70":                             self = .element70
            case "minecraft:element_71":                             self = .element71
            case "minecraft:element_72":                             self = .element72
            case "minecraft:element_73":                             self = .element73
            case "minecraft:element_74":                             self = .element74
            case "minecraft:element_75":                             self = .element75
            case "minecraft:element_76":                             self = .element76
            case "minecraft:element_77":                             self = .element77
            case "minecraft:element_78":                             self = .element78
            case "minecraft:element_79":                             self = .element79
            case "minecraft:element_80":                             self = .element80
            case "minecraft:element_81":                             self = .element81
            case "minecraft:element_82":                             self = .element82
            case "minecraft:element_83":                             self = .element83
            case "minecraft:element_84":                             self = .element84
            case "minecraft:element_85":                             self = .element85
            case "minecraft:element_86":                             self = .element86
            case "minecraft:element_87":                             self = .element87
            case "minecraft:element_88":                             self = .element88
            case "minecraft:element_89":                             self = .element89
            case "minecraft:element_90":                             self = .element90
            case "minecraft:element_91":                             self = .element91
            case "minecraft:element_92":                             self = .element92
            case "minecraft:element_93":                             self = .element93
            case "minecraft:element_94":                             self = .element94
            case "minecraft:element_95":                             self = .element95
            case "minecraft:element_96":                             self = .element96
            case "minecraft:element_97":                             self = .element97
            case "minecraft:element_98":                             self = .element98
            case "minecraft:element_99":                             self = .element99
            case "minecraft:element_100":                            self = .element100
            case "minecraft:element_101":                            self = .element101
            case "minecraft:element_102":                            self = .element102
            case "minecraft:element_103":                            self = .element103
            case "minecraft:element_104":                            self = .element104
            case "minecraft:element_105":                            self = .element105
            case "minecraft:element_106":                            self = .element106
            case "minecraft:element_107":                            self = .element107
            case "minecraft:element_108":                            self = .element108
            case "minecraft:element_109":                            self = .element109
            case "minecraft:element_110":                            self = .element110
            case "minecraft:element_111":                            self = .element111
            case "minecraft:element_112":                            self = .element112
            case "minecraft:element_113":                            self = .element113
            case "minecraft:element_114":                            self = .element114
            case "minecraft:element_115":                            self = .element115
            case "minecraft:element_116":                            self = .element116
            case "minecraft:element_117":                            self = .element117
            case "minecraft:element_118":                            self = .element118
            default:                                                 self = .unknown
        }
    }
}

