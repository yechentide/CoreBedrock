//
// Created by yechentide on 2026/08/02
//

@testable import CoreBedrock
import Foundation
import Testing

struct LegacyTerrainTests {
    @Test
    func decodesClassicSubchunkMetadataNibbles() throws {
        var bytes = [UInt8](repeating: 0, count: 1 + 4096 + 2048)
        bytes[0] = 0
        bytes[1] = 7
        bytes[1 + 4096] = 0xA3
        let subchunk = try LegacyTerrainParser.parseSubChunk(Data(bytes))
        #expect(subchunk.block(localX: 0, localY: 0, localZ: 0) == .init(id: 7, data: 3))
        #expect(subchunk.block(localX: 0, localY: 1, localZ: 0) == .init(id: 0, data: 10))
    }

    @Test
    func decodesLegacyData2D() throws {
        var bytes = [UInt8](repeating: 0, count: 256 * 6)
        bytes[0] = 0x34
        bytes[1] = 0x12
        bytes[512] = 42
        bytes[768] = 1
        bytes[769] = 2
        bytes[770] = 3
        let decoded = try LegacyData2DParser.parseLegacyData2D(Data(bytes))
        #expect(decoded.heightmap[0] == 0x1234)
        #expect(decoded.biomeIDs[0] == 42)
        #expect(decoded.biomeColors?[0].red == 1)
        #expect(decoded.biomeColors?[0].green == 2)
        #expect(decoded.biomeColors?[0].blue == 3)
    }
}
