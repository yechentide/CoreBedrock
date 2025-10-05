//
// Created by yechentide on 2025/09/04
//

import Foundation
import LvDBWrapper

enum NetEasePlayerDataProcessor {
    static func processPlayerData(
        worldDir: String,
        transform: (Data) throws -> Data?
    ) throws {
        let dbDirPath = (worldDir as NSString).appendingPathComponent("db")
        let database = try LvDB(dbPath: dbDirPath)
        defer { database.close() }

        do {
            let localPlayerKey = LvDBStringKeyType.localPlayer.rawValue.data(using: .utf8)!
            let localPlayerData = try database.get(localPlayerKey)
            if let fixedData = try transform(localPlayerData) {
                try database.put(localPlayerKey, fixedData)
            }
        } catch {
            let lvdbError = LvDBError(nsError: error as NSError)
            guard case LvDBError.notFound = lvdbError else {
                throw error
            }
        }

        let iter = try database.makeIterator()
        iter.seek(Data(NetEaseConstants.playerKeyPrefix.utf8))
        while iter.valid() {
            defer { iter.next() }
            // player_server_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            guard
                let key = iter.key(),
                key.count == NetEaseConstants.expectedPlayerKeyLength,
                let prefix = String(data: key[0...3], encoding: .utf8),
                prefix == "play",
                let serverPlayerData = iter.value()
            else {
                break
            }

            if let fixedData = try transform(serverPlayerData) {
                try database.put(key, fixedData)
            }
        }
    }
}
