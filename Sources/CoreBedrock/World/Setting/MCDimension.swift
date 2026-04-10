//
// Created by yechentide on 2024/07/14
//

import CoreGraphics

// swiftlint:disable colon
// swiftformat:disable consecutiveSpaces spaceAroundOperators

public enum MCDimension: Int32, Sendable, Hashable, CustomStringConvertible {
    case overworld = 0
    case theNether = 1
    case theEnd    = 2

    public var description: String {
        switch self {
        case .overworld: "overworld"
        case .theNether: "theNether"
        case .theEnd:    "theEnd"
        }
    }

    public var cgColor: CGColor {
        switch self {
        case .overworld: CGColor(red:  52/255, green: 199/255, blue:  90/255, alpha: 1.0)
        case .theNether: CGColor(red: 189/255, green:  48/255, blue:  48/255, alpha: 1.0)
        case .theEnd:    CGColor(red: 235/255, green: 237/255, blue: 150/255, alpha: 1.0)
        }
    }

    public var blockYRange: ClosedRange<Int> {
        switch self {
        case .overworld: -64...319
        case .theNether: 0...127
        case .theEnd:    0...255
        }
    }

    public var chunkYRange: ClosedRange<Int8> {
        switch self {
        case .overworld: -4...19
        case .theNether: 0...7
        case .theEnd:    0...15
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
// swiftlint:enable colon
