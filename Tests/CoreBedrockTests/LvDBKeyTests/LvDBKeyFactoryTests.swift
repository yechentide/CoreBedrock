//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import LvDBWrapper
import Testing

struct LvDBKeyFactoryTests {
    @Test
    func testMakeBaseChunkKey() throws {
        // Test for overworld
        let key1 = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)
        #expect(key1.count == 8) // Int32 x 2 = 8 bytes

        // Test for the nether (includes dimension)
        let key2 = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .theNether)
        #expect(key2.count == 12) // Int32 x 3 = 12 bytes
    }

    @Test
    func testMakeChunkKey() throws {
        let base = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)

        // Test for sub-chunk (with yIndex)
        let key1 = LvDBKeyFactory.makeChunkKey(base: base, type: .subChunkPrefix, yIndex: 0)
        #expect(key1.count == base.count + 2) // base + type(1) + yIndex(1)

        // Test for other types (without yIndex)
        let key2 = LvDBKeyFactory.makeChunkKey(base: base, type: .finalizedState)
        #expect(key2.count == base.count + 1) // base + type(1)
    }

    @Test
    func testMakeDigpKey() throws {
        let base = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)
        let key = LvDBKeyFactory.makeDigpKey(base: base)

        let prefix = Data("digp".utf8)
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + base.count)

        // Test coordinate-based version
        let key2 = LvDBKeyFactory.makeDigpKey(x: 0, z: 0, dimension: .overworld)
        #expect(key2 == key)
    }

    @Test
    func testMakeActorKey() throws {
        let testId = Data([0x01, 0x02, 0x03, 0x04])
        let key = LvDBKeyFactory.makeActorKey(id: testId)

        let prefix = Data("actorprefix".utf8)
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + testId.count)
    }

    @Test
    func testMakeMapKey() throws {
        let mapId: Int64 = 12345
        let key = LvDBKeyFactory.makeMapKey(id: mapId)

        let prefix = Data("map_".utf8)
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + 8) // prefix + Int64(8)
    }
}
