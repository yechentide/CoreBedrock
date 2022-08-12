import XCTest
@testable import CoreBedrock

final class StringExtensionTests: XCTestCase {
    let testCases: [String:Data?] = [
        "0xC"       : nil,
        "0x1F"      : Data([0x1F]),
        "0x25AE"    : Data([0x25, 0xAE]),
        "0x2_5AE"   : Data([0x25, 0xAE]),
        "25_A_E_"   : Data([0x25, 0xAE]),
        "0x1G"      : nil,
    ]

    func testHexData() {
        for (key, value) in testCases {
            XCTAssertEqual(key.hexData ?? nil, value ?? nil)
        }
    }
}
