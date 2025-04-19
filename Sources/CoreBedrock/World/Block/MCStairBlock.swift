//
// Created by yechentide on 2025/04/13
//

public enum HalfBlockType {
    case bottom
    case top
}

public enum BlockFace: UInt32 {
    case north          = 0b00000000000000000000000000000001
    case northNorthEast = 0b00000000000000000000000000000010
    case northEast      = 0b00000000000000000000000000000100
    case eastNorthEast  = 0b00000000000000000000000000001000
    case east           = 0b00000000000000000000000000010000
    case eastSouthEast  = 0b00000000000000000000000000100000
    case southEast      = 0b00000000000000000000000001000000
    case southSouthEast = 0b00000000000000000000000010000000
    case south          = 0b00000000000000000000000100000000
    case southSouthWest = 0b00000000000000000000001000000000
    case southWest      = 0b00000000000000000000010000000000
    case westSouthWest  = 0b00000000000000000000100000000000
    case west           = 0b00000000000000000001000000000000
    case westNotrhWest  = 0b00000000000000000010000000000000
    case northWest      = 0b00000000000000000100000000000000
    case northNorthWest = 0b00000000000000001000000000000000
    case up             = 0b00000000000000010000000000000000
    case `self`         = 0b00000000000000100000000000000000
    case down           = 0b00000000000001000000000000000000
}

public class MCStairBlock: MCBlock {
    public func facing() -> BlockFace {
        if let direction = self.states["weirdo_direction"] as? IntTag {
            switch direction.value {
                case 3:  return .north
                case 1:  return .west
                case 0:  return .east
                case 2:  return .south
                default: return .south
            }
        }
        return .south
    }

    public func half() -> HalfBlockType {
        if let tag = self.states["upside_down_bit"] as? ByteTag {
            return tag.value == 1 ? .top : .bottom
        }
        return .bottom
    }
}
