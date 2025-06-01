//
// Created by yechentide on 2025/04/13
//

extension MCBlockType {
    public var isWater: Bool {
        switch self {
            case .water,
                 .bubbleColumn,
                 .kelp,
                 .seagrass:
                return true
            default:
                return false
        }
    }
}
