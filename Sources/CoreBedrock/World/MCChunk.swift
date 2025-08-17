//
// Created by yechentide on 2025/08/11
//

public class MCChunk {
    public static let sideLength = 16
    public static var viewSize: Int { Self.sideLength * Self.sideLength }
    public static func calcRange(chunkIndex: Int32) -> ClosedRange<Int> {
        return Int(chunkIndex)*Self.sideLength ... Int(chunkIndex+1)*Self.sideLength-1
    }
}
