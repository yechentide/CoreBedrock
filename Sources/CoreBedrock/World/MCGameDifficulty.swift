//
// Created by yechentide on 2024/07/14
//

public enum MCGameDifficulty: Int32, CustomStringConvertible {
    case unknown    = -1
    case peaceful   = 0
    case easy       = 1
    case normal     = 2
    case hard       = 3

    public var description: String {
        switch self {
            case .peaceful: return "Peaceful"
            case .easy:     return "Easy"
            case .normal:   return "Normal"
            case .hard:     return "Hard"
            case .unknown:  return "Unknown"
        }
    }
}
