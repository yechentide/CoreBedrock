//
// Created by yechentide on 2025/05/10
//

import Foundation

public struct TexturePixelData {
    public let height: Int
    public let waterDepth: Int
    public let blockType: MCBlockType

    public init() {
        self.height = -1
        self.waterDepth = -1
        self.blockType = .unknown
    }

    public init(height: Int, waterdepth: Int, blockType: MCBlockType) {
        self.height = height
        self.waterDepth = waterdepth
        self.blockType = blockType
    }
}
