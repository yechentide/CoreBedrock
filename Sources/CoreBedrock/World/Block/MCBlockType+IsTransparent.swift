//
// Created by yechentide on 2025/03/20
//

extension MCBlockType {
    public var isTransparent: Bool {
        if self.isPlant { return true }
        return switch self {
            case .unknown,
                 .air,
                 .fire,
                 .soulFire,
                 .bubbleColumn,
                 .movingBlock,
                 .reserved6,
                 .barrier,
                 .borderBlock,
                 .structureVoid,
                 .lightBlock0,
                 .lightBlock1,
                 .lightBlock2,
                 .lightBlock3,
                 .lightBlock4,
                 .lightBlock5,
                 .lightBlock6,
                 .lightBlock7,
                 .lightBlock8,
                 .lightBlock9,
                 .lightBlock10,
                 .lightBlock11,
                 .lightBlock12,
                 .lightBlock13,
                 .lightBlock14,
                 .lightBlock15:
                true
            default:
                false
        }
    }
}
