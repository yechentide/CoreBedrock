//
// Created by yechentide on 2024/10/05
//

import CoreGraphics
import LvDBWrapper

public struct MCChunk {
    public static let length = 16
    public static var viewSize: Int { length * length }
    public static func calcRange(chunkIndex: Int32) -> ClosedRange<Int> {
        return Int(chunkIndex)*length ... Int(chunkIndex+1)*length-1
    }
}
