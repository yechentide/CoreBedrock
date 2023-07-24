import XCTest
@testable import CoreBedrock

final class MCSubChunkTests: XCTestCase {
//    func testIndex() {
//        let list: [(localX: Int, localY: Int, localZ: Int, expected: Int)] = [
//            (0, 0, 0, 0),
//            (0, 1, 0, 1),
//            (0, 0, 1, 16),
//            (1, 0, 0, 256),
//            (15, 15, 15, 4095),
//        ]
//        for data in list {
//            let actual = MCSubChunk.offset(data.localX, data.localY, data.localZ)
//            XCTAssertNotNil(actual)
//            XCTAssertEqual(data.expected, actual!)
//        }
//    }

    func testDecoder() throws {
        print("\n\n")
        defer { print("\n\n") }

        guard let url = Bundle.module.url(forResource: "subchunkData", withExtension: nil),
              let data = try? Data(contentsOf: url)
        else {
            XCTFail()
            return
        }

        print("Data count: \(data.count)")

        let version = data[0]
        let layerCount = data[1]
        let y = data[2]
        print("[\(version), \(layerCount), \(y)]")

        let decoder = BlockDecoder()
        guard let layers = try decoder.decode(data: data, offset: 3, layerCount: 1) else {
            XCTFail()
            return
        }
        print("Layer count = \(layers.count)")

        for palette in layers[0].palettes {
            print(palette.type.description + ":\n" + palette.states.description + "\n")
        }
    }
}
