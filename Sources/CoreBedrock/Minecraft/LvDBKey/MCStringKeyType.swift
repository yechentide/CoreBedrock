import Foundation

public enum MCStringKeyType: String, CaseIterable {
    case autonomousEntities             = "AutonomousEntities"
    case biomeData                      = "BiomeData"
    case dimension0                     = "dimension0"
    case flatworldlayers                = "game_flatworldlayers"        // not sure
    case levelChunkMetaDataDictionary   = "LevelChunkMetaDataDictionary"
    case mobevents                      = "mobevents"
    case mVillages                      = "mVillages"
    case nether                         = "Nether"
    case theEnd                         = "TheEnd"
    case overworld                      = "Overworld"
    case portals                        = "portals"
    case schedulerWT                    = "schedulerWT"
    case scoreboard                     = "scoreboard"
    case localPlayer                    = "~local_player"
    
    public static func parse(data: Data) -> Self? {
        guard let str = String(data: data, encoding: .utf8), let key = Self(rawValue: str) else { return nil }
        return key
    }
}
