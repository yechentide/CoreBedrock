public enum MCDimension: Int32, CustomStringConvertible {
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
}
