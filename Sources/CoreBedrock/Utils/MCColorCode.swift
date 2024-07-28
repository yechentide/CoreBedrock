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
            case .black:        return CGColor(red: 000 / 255, green: 000 / 255, blue: 000 / 255, alpha: 1)
            case .darkBlue:     return CGColor(red: 000 / 255, green: 000 / 255, blue: 170 / 255, alpha: 1)
            case .darkGreen:    return CGColor(red: 000 / 255, green: 170 / 255, blue: 000 / 255, alpha: 1)
            case .darkAqua:     return CGColor(red: 000 / 255, green: 170 / 255, blue: 170 / 255, alpha: 1)
            case .darkRed:      return CGColor(red: 170 / 255, green: 000 / 255, blue: 000 / 255, alpha: 1)
            case .darkPurple:   return CGColor(red: 170 / 255, green: 000 / 255, blue: 170 / 255, alpha: 1)
            case .gold:         return CGColor(red: 255 / 255, green: 170 / 255, blue: 000 / 255, alpha: 1)
            case .gray:         return CGColor(red: 170 / 255, green: 170 / 255, blue: 170 / 255, alpha: 1)
            case .darkGray:     return CGColor(red: 085 / 255, green: 085 / 255, blue: 085 / 255, alpha: 1)
            case .blue:         return CGColor(red: 085 / 255, green: 085 / 255, blue: 255 / 255, alpha: 1)
            case .green:        return CGColor(red: 085 / 255, green: 255 / 255, blue: 085 / 255, alpha: 1)
            case .aqua:         return CGColor(red: 085 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            case .red:          return CGColor(red: 255 / 255, green: 085 / 255, blue: 085 / 255, alpha: 1)
            case .lightPurple:  return CGColor(red: 255 / 255, green: 085 / 255, blue: 255 / 255, alpha: 1)
            case .yellow:       return CGColor(red: 255 / 255, green: 255 / 255, blue: 085 / 255, alpha: 1)
            case .white:        return CGColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            case .minecoinGold: return CGColor(red: 221 / 255, green: 214 / 255, blue: 005 / 255, alpha: 1)
        }
    }
}
