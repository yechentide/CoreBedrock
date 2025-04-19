//
// Created by yechentide on 2024/07/21
//

import CoreGraphics

enum MCColorCode: Character {
    case black          = "0"
    case darkBlue       = "1"
    case darkGreen      = "2"
    case darkAqua       = "3"
    case darkRed        = "4"
    case darkPurple     = "5"
    case gold           = "6"
    case gray           = "7"
    case darkGray       = "8"
    case blue           = "9"
    case green          = "a"
    case aqua           = "b"
    case red            = "c"
    case lightPurple    = "d"
    case yellow         = "e"
    case white          = "f"
    case minecoinGold   = "g"

    var color: CGColor {
        switch self {
            case .black:        return CGColor.from(red:   0, green:   0, blue:   0, alpha: 1)
            case .darkBlue:     return CGColor.from(red:   0, green:   0, blue: 170, alpha: 1)
            case .darkGreen:    return CGColor.from(red:   0, green: 170, blue:   0, alpha: 1)
            case .darkAqua:     return CGColor.from(red:   0, green: 170, blue: 170, alpha: 1)
            case .darkRed:      return CGColor.from(red: 170, green:   0, blue:   0, alpha: 1)
            case .darkPurple:   return CGColor.from(red: 170, green:   0, blue: 170, alpha: 1)
            case .gold:         return CGColor.from(red: 255, green: 170, blue:   0, alpha: 1)
            case .gray:         return CGColor.from(red: 170, green: 170, blue: 170, alpha: 1)
            case .darkGray:     return CGColor.from(red:  85, green:  85, blue:  85, alpha: 1)
            case .blue:         return CGColor.from(red:  85, green:  85, blue: 255, alpha: 1)
            case .green:        return CGColor.from(red:  85, green: 255, blue:  85, alpha: 1)
            case .aqua:         return CGColor.from(red:  85, green: 255, blue: 255, alpha: 1)
            case .red:          return CGColor.from(red: 255, green:  85, blue:  85, alpha: 1)
            case .lightPurple:  return CGColor.from(red: 255, green:  85, blue: 255, alpha: 1)
            case .yellow:       return CGColor.from(red: 255, green: 255, blue:  85, alpha: 1)
            case .white:        return CGColor.from(red: 255, green: 255, blue: 255, alpha: 1)
            case .minecoinGold: return CGColor.from(red: 221, green: 214, blue:   5, alpha: 1)
        }
    }
}
