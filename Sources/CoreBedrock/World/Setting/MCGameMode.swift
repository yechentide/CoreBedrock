//
// Created by yechentide on 2024/07/14
//

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public enum MCGameMode: Int32, Sendable, CustomStringConvertible {
    case unknown    = -1
    case survival   = 0
    case creative   = 1
    case adventure  = 2
    case spectator  = 3

    public var description: String {
        switch self {
        case .survival:     "Survival"
        case .creative:     "Creative"
        case .adventure:    "Adventure"
        case .spectator:    "Spectator"
        case .unknown:      "Unknown"
        }
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
