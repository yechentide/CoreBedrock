//
// Created by yechentide on 2024/07/14
//

import CoreGraphics
import SwiftUI

public enum MCDimension: Int32, Sendable, CustomStringConvertible {
    case overworld = 0
    case theNether = 1
    case theEnd    = 2

    public var description: String {
        switch self {
            case .overworld:
                return "overworld"
            case .theNether:
                return "theNether"
            case .theEnd:
                return "theEnd"
        }
    }

    public var cgColor: CGColor {
        switch self {
            case .overworld:
                return .init(red: 52/255, green: 199/255, blue: 90/255, alpha: 1)
            case .theNether:
                return .init(red: 189/255, green: 48/255, blue: 48/255, alpha: 1)
            case .theEnd:
                return .init(red: 235/255, green: 237/255, blue: 150/255, alpha: 1)
        }
    }

    public var color: Color {
        switch self {
            case .overworld:
                return .init(red: 52/255, green: 199/255, blue: 90/255, opacity: 1)
            case .theNether:
                return .init(red: 189/255, green: 48/255, blue: 48/255, opacity: 1)
            case .theEnd:
                return .init(red: 235/255, green: 237/255, blue: 150/255, opacity: 1)
        }
    }

    public var blockYRange: ClosedRange<Int> {
        switch self {
            case .overworld:
                return -64...319
            case .theNether:
                return 0...127
            case .theEnd:
                return 0...255
        }
    }

    public var chunkYRange: ClosedRange<Int8> {
        switch self {
            case .overworld:
                return -4...19
            case .theNether:
                return 0...7
            case .theEnd:
                return 0...15
        }
    }
}
