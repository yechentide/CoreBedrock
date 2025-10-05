//
// Created by yechentide on 2025/05/04
//

public struct MCRegion: Hashable {
    public static let sideLength = 512
    public static var viewSize: Int { sideLength * sideLength }
    public static let localChunkRange = 0..<(Self.sideLength / MCChunk.sideLength)

    public let x: Int32
    public let z: Int32

    public init(x: Int32, z: Int32) {
        self.x = x
        self.z = z
    }
}
