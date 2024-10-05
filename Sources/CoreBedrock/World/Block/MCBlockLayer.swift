//
// Created by yechentide on 2024/10/05
//

import Foundation

public class MCBlockLayer {
    public var palettes: [MCBlock]
    public var map: [UInt16]

    public init() {
        palettes = [MCBlock]()
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }

    public init(palettes: [MCBlock], map: [UInt16]) {
        self.palettes = palettes
        self.map = map
    }

    public init(palette: MCBlock) {
        palettes = [palette]
        map = [UInt16](repeating: 0, count: MCSubChunk.totalBlockCount)
    }
}
