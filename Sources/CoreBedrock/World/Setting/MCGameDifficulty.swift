//
// Created by yechentide on 2024/07/14
//

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public enum MCGameDifficulty: Int32, Sendable, CustomStringConvertible {
    case unknown    = -1
    case peaceful   = 0
    case easy       = 1
    case normal     = 2
    case hard       = 3

    public var description: String {
        switch self {
        case .peaceful: "Peaceful"
        case .easy:     "Easy"
        case .normal:   "Normal"
        case .hard:     "Hard"
        case .unknown:  "Unknown"
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
