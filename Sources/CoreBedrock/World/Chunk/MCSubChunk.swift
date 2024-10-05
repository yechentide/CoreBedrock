//
// Created by yechentide on 2024/10/05
//

import Foundation

public class MCSubChunk {
    public static let totalBlockCount = 4096 // 16 * 16 * 16
    public static let localPosRange = 0 ..< MCChunk.length
    public static func offset(_ localX: Int, _ localY: Int, _ localZ: Int) -> Int? {
        guard localPosRange ~= localX, localPosRange ~= localY, localPosRange ~= localZ else {
            return nil
        }
        return (localX * MCChunk.length + localZ) * MCChunk.length + localY
    }
}
