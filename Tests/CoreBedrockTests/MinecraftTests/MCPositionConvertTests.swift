//
// Created by yechentide on 2024/11/05
//

@testable import CoreBedrock
import Testing

struct MCPositionConvertTests {
    @Test
    func convertBlockToChunk() {
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
    func convertBlockToRegion() {
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
    func convertChunkToRegion() {
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

    @Test
    func convertChunkToIndexInRegion() throws {
        let list: [(pos: Int, expected: Int)] = [
            (-33, 31),
            (-32, 0),
            (-1, 31),
            (0, 0),
            (31, 31),
            (32, 0),
            (63, 31),
        ]
        for data in list {
            let actual = convertPos(from: data.pos, .chunkToIndexInRegion)
            #expect(actual == data.expected)
        }
    }
}
