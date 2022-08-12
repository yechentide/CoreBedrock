import XCTest
@testable import CoreBedrock

final class MCAreaTests: XCTestCase {
    private struct ChunkArea: MCArea {
        static var length: Int32 = 16
        var xIndex: Int32
        var zIndex: Int32
    }
    
    let testCases: [(testValue: Int32, startPos: Int32, endPos: Int32, chunkIndex: Int32)] = [
        (-33, -48, -33, -3 ),
        (-32, -32, -17, -2 ),
        (-31, -32, -17, -2 ),
        (-17, -32, -17, -2 ),
        (-16, -16,  -1, -1 ),
        (-15, -16,  -1, -1 ),
        (-1 , -16,  -1, -1 ),
        ( 0 ,  0 ,  15,  0 ),
        ( 1 ,  0 ,  15,  0 ),
        ( 15,  0 ,  15,  0 ),
        ( 16,  16,  31,  1 ),
        ( 17,  16,  31,  1 ),
        ( 31,  16,  31,  1 ),
        ( 32,  32,  47,  2 ),
        ( 33,  32,  47,  2 ),
    ]
    
    func testCaclPos() {
        for testCase in testCases {
            let chunk = ChunkArea(xIndex: testCase.chunkIndex, zIndex: testCase.testValue)
            XCTAssertEqual(testCase.startPos, chunk.startXPos)
            XCTAssertEqual(testCase.endPos, chunk.endXPos)
        }
    }
    
    func testCaclIndex() {
        for testCase in testCases {
            XCTAssertEqual(testCase.chunkIndex,
                           ChunkArea.calcIndex(pos: testCase.testValue))
        }
    }
}
