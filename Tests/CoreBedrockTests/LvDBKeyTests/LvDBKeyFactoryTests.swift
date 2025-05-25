//
// Created by yechentide on 2025/05/25
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct LvDBKeyFactoryTests {
    @Test
    func testMakeBaseChunkKey() async throws {
        // Test for overworld
        let key1 = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)
        #expect(key1.count == 8)  // Int32 x 2 = 8 bytes

        // Test for the nether (includes dimension)
        let key2 = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .theNether)
        #expect(key2.count == 12)  // Int32 x 3 = 12 bytes
    }

    @Test
    func testMakeChunkKey() async throws {
        let base = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)

        // Test for sub-chunk (with yIndex)
        let key1 = LvDBKeyFactory.makeChunkKey(base: base, type: .subChunkPrefix, yIndex: 0)
        #expect(key1.count == base.count + 2)  // base + type(1) + yIndex(1)

        // Test for other types (without yIndex)
        let key2 = LvDBKeyFactory.makeChunkKey(base: base, type: .finalizedState)
        #expect(key2.count == base.count + 1)  // base + type(1)
    }

    @Test
    func testMakeDigpKey() async throws {
        let base = LvDBKeyFactory.makeBaseChunkKey(x: 0, z: 0, dimension: .overworld)
        let key = LvDBKeyFactory.makeDigpKey(base: base)

        let prefix = "digp".data(using: .utf8)!
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + base.count)

        // Test coordinate-based version
        let key2 = LvDBKeyFactory.makeDigpKey(x: 0, z: 0, dimension: .overworld)
        #expect(key2 == key)
    }

    @Test
    func testMakeActorKey() async throws {
        let testId = Data([0x01, 0x02, 0x03, 0x04])
        let key = LvDBKeyFactory.makeActorKey(id: testId)

        let prefix = "actorprefix".data(using: .utf8)!
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + testId.count)
    }

    @Test
    func testMakeMapKey() async throws {
        let mapId: Int64 = 12345
        let key = LvDBKeyFactory.makeMapKey(id: mapId)

        let prefix = "map_".data(using: .utf8)!
        #expect(key.starts(with: prefix))
        #expect(key.count == prefix.count + 8)  // prefix + Int64(8)
    }
}
