public enum MCGameMode: Int32, CustomStringConvertible {
    case unknown    = -1
    case survival   = 0
    case creative   = 1
    case adventure  = 2
    case spectator  = 3

    public var description: String {
        switch self {
            case .survival:     return "Survival"
            case .creative:     return "Creative"
            case .adventure:    return "Adventure"
            case .spectator:    return "Spectator"
            case .unknown:      return "Unknown"
        }
    }
}
