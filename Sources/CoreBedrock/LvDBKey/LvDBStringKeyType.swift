//
// Created by yechentide on 2024/10/04
//

import Foundation

public enum LvDBStringKeyType: String, CaseIterable, Sendable {
    case autonomousEntities             = "AutonomousEntities"
    case biomeData                      = "BiomeData"
    case dimension0                     = "dimension0"
    case levelChunkMetaDataDictionary   = "LevelChunkMetaDataDictionary"
    case mobevents                      = "mobevents"
    case nether                         = "Nether"
    case theEnd                         = "TheEnd"
    case overworld                      = "Overworld"
    case portals                        = "portals"
    case schedulerWT                    = "schedulerWT"
    case scoreboard                     = "scoreboard"
    case localPlayer                    = "~local_player"

    // legacy key types
    case flatworldlayers                = "game_flatworldlayers"        // Info about the flat world before 1.5, it has been moved to level.dat
    case mVillages                      = "mVillages"                   // Info about old villages before 1.11

    public static func parse(data: Data) -> Self? {
        guard let str = String(data: data, encoding: .utf8), let key = Self(rawValue: str) else { return nil }
        return key
    }
}
