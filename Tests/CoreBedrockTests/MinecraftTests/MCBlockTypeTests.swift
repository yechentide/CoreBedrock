//
// Created by yechentide on 2025/03/23
//

import Testing
import Foundation
import LvDBWrapper
@testable import CoreBedrock

struct MCBlockTypeTests {
    @Test
    func testAllWikiBlockIdsAreDefined() async throws {
        let idListFileUrls: [URL] = [
            Bundle.module.url(forResource: "TestData/block-ids/wiki-block-ids-en-20250323.txt", withExtension: nil)!,
            Bundle.module.url(forResource: "TestData/block-ids/wiki-block-ids-zh-20250323.txt", withExtension: nil)!,
            Bundle.module.url(forResource: "TestData/block-ids/wiki-block-ids-ja-20250323.txt", withExtension: nil)!,
        ]
        var unrecordeNameSet: Set<String> = []

        for idListFileUrl in idListFileUrls {
            let fileContent = try String(contentsOf: idListFileUrl, encoding: .utf8)
            fileContent.enumerateLines(invoking: { line, stop in
                if line.isEmpty {
                    return
                }
                let id = "minecraft:\(line)"
                if let _ = MCBlockType(rawValue: id) {
                    return
                }
                if let _ = MCOldBlockType(rawValue: id) {
                    return
                }
                unrecordeNameSet.insert(id)
            })
        }

        if !unrecordeNameSet.isEmpty {
            unrecordeNameSet.forEach { print($0) }
            Issue.record("Unrecored ID count: \(unrecordeNameSet.count)")
        }
    }

    @Test
    func testAllCurrentVersionBlockIdsAreDefined() async throws {
        let dbPath = Bundle.module.path(forResource: "TestData/all-blocks-test-world/db", ofType: nil)!
        guard let db = LvDB(dbPath: dbPath) else {
            return
        }
        defer {
            db.close()
        }

        var subChunkKeys: [LvDBKey] = []
        db.getChunkKeys(x: 0, z: 0, dimension: .overworld).forEach { chunkKeyData in
            if chunkKeyData.count != 10 {
                return
            }
            let lvdbKey = LvDBKey.parse(data: chunkKeyData)
            guard case LvDBKeyType.subChunk(.overworld, .subChunkPrefix) = lvdbKey.type else {
                return
            }
            subChunkKeys.append(lvdbKey)
        }

        var unusedTypesInSwift: Set<String> = []
        var undefinedTypesInMC: Set<String> = []
        for type in MCBlockType.allCases {
            unusedTypesInSwift.insert(type.rawValue)
        }
        unusedTypesInSwift.remove(MCBlockType.unsupported.rawValue)
        unusedTypesInSwift.remove(MCBlockType.unknown.rawValue)

        for subChunkKey in subChunkKeys {
            try parseSubChunkData(db: db, subChunkKey: subChunkKey, unusedTypesInSwift: &unusedTypesInSwift, undefinedTypesInMC: &undefinedTypesInMC)
        }

        if !unusedTypesInSwift.isEmpty {
            unusedTypesInSwift.forEach { print($0) }
            print("========== Unused types: \(unusedTypesInSwift.count)")
        }
        if !undefinedTypesInMC.isEmpty {
            undefinedTypesInMC.forEach { print($0) }
            Issue.record("========== Undefined types: \(undefinedTypesInMC.count)")
        }
    }

    private func parseSubChunkData(db: LvDB, subChunkKey: LvDBKey, unusedTypesInSwift: inout Set<String>, undefinedTypesInMC: inout Set<String>) throws {
        guard let subChunkData = db.get(subChunkKey.data) else {
            Issue.record("Can not find subChunk data for \(subChunkKey.data.hexString)")
            return
        }
        let version = subChunkData[0]
        #expect(version == 9)
        let storageLayerCount = Int(subChunkData[1])
        let yIndex = subChunkData[2].data.int8
        #expect([-4, 0, 1, 2, 3, 4, 5].contains(yIndex))

        let layers = try BlockDecoder.shared.decodeV9(
            data: subChunkData, offset: 3, layerCount: storageLayerCount
        )
        #expect(layers != nil)
        for layer in layers! {
            layer.palettes.forEach { block in
                if let type = MCBlockType(rawValue: block.type) {
                    unusedTypesInSwift.remove(type.rawValue)
                    return
                }
                if let type = MCOldBlockType(rawValue: block.type) {
                    unusedTypesInSwift.remove(type.rawValue)
                    return
                }
                undefinedTypesInMC.insert(block.type)
            }
        }
    }
}
