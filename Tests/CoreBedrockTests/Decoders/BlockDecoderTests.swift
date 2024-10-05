//
// Created by yechentide on 2024/10/05
//

import Testing
import Foundation
import CoreBedrock

struct BlockDecoderTests {
    @Test
    func parseSubChunkWithFormatV9() async throws {
        let url = Bundle.module.url(forResource: "TestData/subChunkData", withExtension: nil)
        precondition(url != nil)
        let subChunkData = try Data(contentsOf: url!)
        precondition(subChunkData.count > 4)

        let version = subChunkData[0]
        let storageLayerCount = Int(subChunkData[1])
        let yIndex = subChunkData[2].data.int8
        #expect(version == 9)
        #expect(storageLayerCount == 1)
        #expect(yIndex == 0)

        let layers = try BlockDecoder.shared.decodeV9(
            data: subChunkData, offset: 3, layerCount: storageLayerCount
        )
        #expect(layers != nil)
        #expect(layers!.count == 1)
        #expect(layers![0].palettes.count == 16)
    }
}
