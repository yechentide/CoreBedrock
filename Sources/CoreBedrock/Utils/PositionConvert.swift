//
// Created by yechentide on 2024/10/04
//

public enum PositionConvertType {
    case blockToChunk
    case blockToRegion
    case chunkToBlock
    case chunkToRegion
    case regionToBlock
    case regionToChunk

    case chunkToIndexInRegion
}

public func convertPos<T: SignedInteger>(from pos: T, _ type: PositionConvertType) -> T {
    switch type {
    case .blockToChunk:
        pos >> 4
    case .blockToRegion:
        pos >> 9
    case .chunkToBlock:
        pos << 4
    case .chunkToRegion:
        pos >> 5
    case .regionToBlock:
        pos << 9
    case .regionToChunk:
        pos << 5
    case .chunkToIndexInRegion:
        (pos % 32 + 32) % 32
    }
}
