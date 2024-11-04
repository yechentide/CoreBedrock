//
// Created by yechentide on 2024/11/05
//

import Testing
@testable import CoreBedrock

struct MCPositionConvertTests {
    @Test
    func testConvertBlockToChunk() async {
        let list: [(pos: Int, expected: Int)] = [
            (-33, -3),
            (-32, -2),
            (-17, -2),
            (-16, -1),
            (-15, -1),
            (-1, -1),
            (0, 0),
            (1, 0),
            (15, 0),
            (16, 1),
            (31, 1),
            (32, 2),
        ]
        for data in list {
            let actual = convertPos(from: data.pos, .blockToChunk)
            #expect(actual == data.expected)
        }
    }

    @Test
    func testConvertBlockToRegion() async {
        let list: [(pos: Int, expected: Int)] = [
            (-513, -2),
            (-512, -1),
            (-1, -1),
            (0, 0),
            (511, 0),
            (512, 1),
        ]
        for data in list {
            let actual = convertPos(from: data.pos, .blockToRegion)
            #expect(actual == data.expected)
        }
    }

    @Test
    func testConvertChunkToRegion() async {
        let list: [(pos: Int, expected: Int)] = [
            (-33, -2),
            (-32, -1),
            (-1, -1),
            (0, 0),
            (31, 0),
            (32, 1),
        ]
        for data in list {
            let actual = convertPos(from: data.pos, .chunkToRegion)
            #expect(actual == data.expected)
        }
    }
}
