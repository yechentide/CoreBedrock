import Foundation

public enum MCEnchantmentType: UInt8 {
    // Sword & Axe
    case sharpness              = 9
    case smite                  = 10
    case baneOfArthropods       = 11
    case knockback              = 12
    case fireAspect             = 13
    case looting                = 14
    // Bow
    case power                  = 19
    case punch                  = 20
    case flame                  = 21
    case infinity               = 22
    // Trident
    case impaling               = 29
    case riptide                = 30
    case loyalty                = 31
    case channeling             = 32
    // Crossbow
    case multishot              = 33
    case piercing               = 34
    case quickCharge            = 35
    // Armor
    case protection             = 0
    case fireProtection         = 1
    case featherFalling         = 2
    case blastProtection        = 3
    case projectileProtection   = 4
    case thorns                 = 5
    case respiration            = 6
    case depthStrider           = 7
    case aquaAffinity           = 8
    case frostWalker            = 25
    case soulSpeed              = 36
    case swiftSneak             = 37
    // Tools
    case efficiency             = 15
    case silkTouch              = 16
    case unbreaking             = 17
    case fortune                = 18
    case mending                = 26
    // Fishing Rod
    case luckOfTheSea           = 23
    case lure                   = 24
    // Other
    case binding                = 27
    case vanishing              = 28

    public var maxLevel: UInt8 {
        switch self {
            case .sharpness:            return 5
            case .smite:                return 5
            case .baneOfArthropods:     return 5
            case .knockback:            return 2
            case .fireAspect:           return 2
            case .looting:              return 3
            case .power:                return 5
            case .punch:                return 2
            case .flame:                return 1
            case .infinity:             return 1
            case .impaling:             return 3
            case .riptide:              return 3
            case .loyalty:              return 3
            case .channeling:           return 1
            case .multishot:            return 1
            case .piercing:             return 4
            case .quickCharge:          return 3
            case .protection:           return 4
            case .fireProtection:       return 4
            case .featherFalling:       return 4
            case .blastProtection:      return 4
            case .projectileProtection: return 4
            case .thorns:               return 3
            case .respiration:          return 3
            case .depthStrider:         return 3
            case .aquaAffinity:         return 1
            case .frostWalker:          return 2
            case .soulSpeed:            return 3
            case .swiftSneak:           return 3
            case .efficiency:           return 5
            case .silkTouch:            return 1
            case .unbreaking:           return 3
            case .fortune:              return 3
            case .mending:              return 1
            case .luckOfTheSea:         return 3
            case .lure:                 return 3
            case .binding:              return 1
            case .vanishing:            return 1
        }
    }
}

extension MCEnchantmentType: CustomStringConvertible {
    public var description: String {
        switch self {
            case .sharpness:            return "minecraft:sharpness"
            case .smite:                return "minecraft:smite"
            case .baneOfArthropods:     return "minecraft:bane_of_arthropods"
            case .knockback:            return "minecraft:knockback"
            case .fireAspect:           return "minecraft:fire_aspect"
            case .looting:              return "minecraft:looting"
            case .power:                return "minecraft:power"
            case .punch:                return "minecraft:punch"
            case .flame:                return "minecraft:flame"
            case .infinity:             return "minecraft:infinity"
            case .impaling:             return "minecraft:impaling"
            case .riptide:              return "minecraft:riptide"
            case .loyalty:              return "minecraft:loyalty"
            case .channeling:           return "minecraft:channeling"
            case .multishot:            return "minecraft:multishot"
            case .piercing:             return "minecraft:piercing"
            case .quickCharge:          return "minecraft:quick_charge"
            case .protection:           return "minecraft:protection"
            case .fireProtection:       return "minecraft:fire_protection"
            case .featherFalling:       return "minecraft:feather_falling"
            case .blastProtection:      return "minecraft:blast_protection"
            case .projectileProtection: return "minecraft:projectile_protection"
            case .thorns:               return "minecraft:thorns"
            case .respiration:          return "minecraft:respiration"
            case .depthStrider:         return "minecraft:depth_strider"
            case .aquaAffinity:         return "minecraft:aqua_affinity"
            case .frostWalker:          return "minecraft:frost_walker"
            case .soulSpeed:            return "minecraft:soul_speed"
            case .swiftSneak:           return "minecraft:swift_sneak"
            case .efficiency:           return "minecraft:efficiency"
            case .silkTouch:            return "minecraft:silk_touch"
            case .unbreaking:           return "minecraft:unbreaking"
            case .fortune:              return "minecraft:fortune"
            case .mending:              return "minecraft:mending"
            case .luckOfTheSea:         return "minecraft:luck_of_the_sea"
            case .lure:                 return "minecraft:lure"
            case .binding:              return "minecraft:binding"
            case .vanishing:            return "minecraft:vanishing"
        }
    }
}

extension MCEnchantmentType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        switch value {
            case "minecraft:sharpness":             self = .sharpness
            case "minecraft:smite":                 self = .smite
            case "minecraft:bane_of_arthropods":    self = .baneOfArthropods
            case "minecraft:knockback":             self = .knockback
            case "minecraft:fire_aspect":           self = .fireAspect
            case "minecraft:looting":               self = .looting
            case "minecraft:power":                 self = .power
            case "minecraft:punch":                 self = .punch
            case "minecraft:flame":                 self = .flame
            case "minecraft:infinity":              self = .infinity
            case "minecraft:impaling":              self = .impaling
            case "minecraft:riptide":               self = .riptide
            case "minecraft:loyalty":               self = .loyalty
            case "minecraft:channeling":            self = .channeling
            case "minecraft:multishot":             self = .multishot
            case "minecraft:piercing":              self = .piercing
            case "minecraft:quick_charge":          self = .quickCharge
            case "minecraft:protection":            self = .protection
            case "minecraft:fire_protection":       self = .fireProtection
            case "minecraft:feather_falling":       self = .featherFalling
            case "minecraft:blast_protection":      self = .blastProtection
            case "minecraft:projectile_protection": self = .projectileProtection
            case "minecraft:thorns":                self = .thorns
            case "minecraft:respiration":           self = .respiration
            case "minecraft:depth_strider":         self = .depthStrider
            case "minecraft:aqua_affinity":         self = .aquaAffinity
            case "minecraft:frost_walker":          self = .frostWalker
            case "minecraft:soul_speed":            self = .soulSpeed
            case "minecraft:swift_sneak":           self = .swiftSneak
            case "minecraft:efficiency":            self = .efficiency
            case "minecraft:silk_touch":            self = .silkTouch
            case "minecraft:unbreaking":            self = .unbreaking
            case "minecraft:fortune":               self = .fortune
            case "minecraft:mending":               self = .mending
            case "minecraft:luck_of_the_sea":       self = .luckOfTheSea
            case "minecraft:lure":                  self = .lure
            case "minecraft:binding":               self = .binding
            case "minecraft:vanishing":             self = .vanishing
            default:                                fatalError("Wrong enchantment type: \(value)")
        }
    }
}
