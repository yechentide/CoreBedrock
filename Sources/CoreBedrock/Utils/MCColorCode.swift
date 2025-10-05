//
// Created by yechentide on 2024/07/21
//

import CoreGraphics

// swiftlint:disable colon
// swiftformat:disable consecutiveSpaces spaceAroundOperators

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
        case .black:        CGColor.from(red:   0, green:   0, blue:   0, alpha: 1)
        case .darkBlue:     CGColor.from(red:   0, green:   0, blue: 170, alpha: 1)
        case .darkGreen:    CGColor.from(red:   0, green: 170, blue:   0, alpha: 1)
        case .darkAqua:     CGColor.from(red:   0, green: 170, blue: 170, alpha: 1)
        case .darkRed:      CGColor.from(red: 170, green:   0, blue:   0, alpha: 1)
        case .darkPurple:   CGColor.from(red: 170, green:   0, blue: 170, alpha: 1)
        case .gold:         CGColor.from(red: 255, green: 170, blue:   0, alpha: 1)
        case .gray:         CGColor.from(red: 170, green: 170, blue: 170, alpha: 1)
        case .darkGray:     CGColor.from(red:  85, green:  85, blue:  85, alpha: 1)
        case .blue:         CGColor.from(red:  85, green:  85, blue: 255, alpha: 1)
        case .green:        CGColor.from(red:  85, green: 255, blue:  85, alpha: 1)
        case .aqua:         CGColor.from(red:  85, green: 255, blue: 255, alpha: 1)
        case .red:          CGColor.from(red: 255, green:  85, blue:  85, alpha: 1)
        case .lightPurple:  CGColor.from(red: 255, green:  85, blue: 255, alpha: 1)
        case .yellow:       CGColor.from(red: 255, green: 255, blue:  85, alpha: 1)
        case .white:        CGColor.from(red: 255, green: 255, blue: 255, alpha: 1)
        case .minecoinGold: CGColor.from(red: 221, green: 214, blue:   5, alpha: 1)
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
// swiftlint:enable colon
