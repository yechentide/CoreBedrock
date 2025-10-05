//
// Created by yechentide on 2025/08/11
//

public class MCSubChunk {
    public static let totalBlockCount = 4096 // 16 * 16 * 16
    public static let localPosRange = 0..<MCChunk.sideLength
    public static func linearIndex(_ localX: Int, _ localY: Int, _ localZ: Int) -> Int? {
        guard self.localPosRange ~= localX, self.localPosRange ~= localY, self.localPosRange ~= localZ else {
            return nil
        }

        return ((localX << 4) | localZ) << 4 | localY
    }
}
