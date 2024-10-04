//
// Created by yechentide on 2024/10/04
//

public enum PositionConvertType {
    case blockToChunk
    case blockToRegion
    case chunkToRegion
}

public func convertPos<T: SignedInteger>(from pos: T, _ type: PositionConvertType) -> T {
    switch type {
        case .blockToChunk:
            return pos >> 4
        case .blockToRegion:
            return pos >> 9
        case .chunkToRegion:
            return pos >> 5
    }
}
