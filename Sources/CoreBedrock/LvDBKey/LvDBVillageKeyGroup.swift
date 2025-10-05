//
// Created by yechentide on 2025/03/18
//

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public struct LvDBVillageKeyGroup: Equatable, Hashable, Sendable {
    public let dwellers: String     // VILLAGE_Overworld_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_DWELLERS
    public let info: String         // VILLAGE_Overworld_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_INFO
    public let players: String      // VILLAGE_Overworld_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_PLAYERS
    public let poi: String          // VILLAGE_Overworld_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx_POI

    public init(dwellers: String, info: String, players: String, poi: String) {
        self.dwellers = dwellers
        self.info = info
        self.players = players
        self.poi = poi
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.info == rhs.info
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.info)
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
