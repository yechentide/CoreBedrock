//
// Created by yechentide on 2024/11/05
//

import Testing
@testable import CoreBedrock

struct MCSubChunkTests {
    @Test
    func testIndex() async {
        let list: [(localX: Int, localY: Int, localZ: Int, expected: Int)] = [
            (0, 0, 0, 0),
            (0, 1, 0, 1),
            (0, 0, 1, 16),
            (1, 0, 0, 256),
            (15, 15, 15, 4095),
        ]
        for data in list {
            let actual = MCSubChunk.offset(data.localX, data.localY, data.localZ)
            #expect(actual == data.expected)
        }
    }
}
