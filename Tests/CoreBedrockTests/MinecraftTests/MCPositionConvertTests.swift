import XCTest
@testable import CoreBedrock

final class MCPositionConvertTests: XCTestCase {
    func testConvertBlockToChunk() {
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
            let actual = convert(from: data.pos, .blockToChunk)
            XCTAssertEqual(data.expected, actual)
        }
    }

    func testConvertBlockToRegion() {
        let list: [(pos: Int, expected: Int)] = [
            (-513, -2),
            (-512, -1),
            (-1, -1),
            (0, 0),
            (511, 0),
            (512, 1),
        ]
        for data in list {
            let actual = convert(from: data.pos, .blockToRegion)
            XCTAssertEqual(data.expected, actual)
        }
    }

    func testConvertChunkToRegion() {
        let list: [(pos: Int, expected: Int)] = [
            (-33, -2),
            (-32, -1),
            (-1, -1),
            (0, 0),
            (31, 0),
            (32, 1),
        ]
        for data in list {
            let actual = convert(from: data.pos, .chunkToRegion)
            XCTAssertEqual(data.expected, actual)
        }
    }
}
