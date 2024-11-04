//
// Created by yechentide on 2024/11/05
//

import Testing
@testable import CoreBedrock

struct MCChunkTests {
    @Test
    func testCalcRange() async {
        let list: [(chunkIndex: Int32, expected: ClosedRange<Int>)] = [
            (-1, (-16)...(-1)),
            (0, 0...15),
            (1, 16...31),
        ]
        for data in list {
            let actual = MCChunk.calcRange(chunkIndex: data.chunkIndex)
            #expect(actual == data.expected)
        }
    }
}
