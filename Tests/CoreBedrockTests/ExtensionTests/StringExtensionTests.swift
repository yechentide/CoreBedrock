//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct StringExtensionTests {
    let testCases: [String:Data?] = [
        "0xC"       : nil,
        "0x1F"      : Data([0x1F]),
        "0x25AE"    : Data([0x25, 0xAE]),
        "0x2_5AE"   : Data([0x25, 0xAE]),
        "25_A_E_"   : Data([0x25, 0xAE]),
        "0x1G"      : nil,
    ]

    @Test
    func testHexData() async {
        for (key, value) in testCases {
            #expect(key.hexData ?? nil == value ?? nil)
        }
    }
}
