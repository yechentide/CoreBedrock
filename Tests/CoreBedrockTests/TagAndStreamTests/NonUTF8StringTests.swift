import XCTest
@testable import CoreBedrock

class NonUTF8StringTests: XCTestCase {
    func testParsingTagContainNonUTF8String() throws {
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
                XCTFail()
                return
            }
            
            if let storageKey = rootTag["internalComponents"]?["EntityStorageKeyComponent"]?["StorageKey"] {
                XCTAssertEqual(expected[i], storageKey.stringValue.data(using: .isoLatin1))
            } else {
                XCTFail()
            }
        }
    }
}
