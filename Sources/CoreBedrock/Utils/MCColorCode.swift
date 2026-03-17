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
        case .black:        CGColor(red:   0/255, green:   0/255, blue:   0/255, alpha: 1.0)
        case .darkBlue:     CGColor(red:   0/255, green:   0/255, blue: 170/255, alpha: 1.0)
        case .darkGreen:    CGColor(red:   0/255, green: 170/255, blue:   0/255, alpha: 1.0)
        case .darkAqua:     CGColor(red:   0/255, green: 170/255, blue: 170/255, alpha: 1.0)
        case .darkRed:      CGColor(red: 170/255, green:   0/255, blue:   0/255, alpha: 1.0)
        case .darkPurple:   CGColor(red: 170/255, green:   0/255, blue: 170/255, alpha: 1.0)
        case .gold:         CGColor(red: 255/255, green: 170/255, blue:   0/255, alpha: 1.0)
        case .gray:         CGColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
        case .darkGray:     CGColor(red:  85/255, green:  85/255, blue:  85/255, alpha: 1.0)
        case .blue:         CGColor(red:  85/255, green:  85/255, blue: 255/255, alpha: 1.0)
        case .green:        CGColor(red:  85/255, green: 255/255, blue:  85/255, alpha: 1.0)
        case .aqua:         CGColor(red:  85/255, green: 255/255, blue: 255/255, alpha: 1.0)
        case .red:          CGColor(red: 255/255, green:  85/255, blue:  85/255, alpha: 1.0)
        case .lightPurple:  CGColor(red: 255/255, green:  85/255, blue: 255/255, alpha: 1.0)
        case .yellow:       CGColor(red: 255/255, green: 255/255, blue:  85/255, alpha: 1.0)
        case .white:        CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        case .minecoinGold: CGColor(red: 221/255, green: 214/255, blue:   5/255, alpha: 1.0)
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
// swiftlint:enable colon
