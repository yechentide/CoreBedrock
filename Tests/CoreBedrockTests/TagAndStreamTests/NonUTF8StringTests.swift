//
// Created by yechentide on 2024/10/04
//

import Testing
import Foundation
@testable import CoreBedrock

struct NonUTF8StringTests {
    @Test
    func testParsingTagContainNonUTF8String() async throws {
        // leveldb key: actorprefix + 0x0000_0001_0000_01AF
        // data of 'StorageKey' tag:  0x0000_0001_0000_01AF
        let expected = [
            Data([0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x01, 0xAF]),
            Data([0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x01, 0x9F])
        ]

        for i in 0...1 {
            let nbtData = try TestData.getFileData(file: .nonUTF8(i), compression: .none)
            let reader = CBTagReader(stream: CBBuffer(nbtData), useLittleEndian: true)
            guard let rootTag = try reader.readAsTag() as? CompoundTag else {
                Issue.record()
                return
            }

            if let storageKey = rootTag["internalComponents"]?["EntityStorageKeyComponent"]?["StorageKey"] {
                #expect(expected[i] == storageKey.stringValue.data(using: .isoLatin1))
            } else {
                Issue.record()
            }
        }
    }
}
