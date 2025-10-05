//
// Created by yechentide on 2024/10/04
//

// swiftformat:disable consecutiveSpaces spaceAroundOperators

public struct LvDBPlayerKeyGroup: Equatable, Hashable, Sendable {
    public let msaID: String            // player_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    public let selfSignedID: String     // player_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    public let serverID: String         // player_server_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

    public init(msaID: String, selfSignedID: String, serverID: String) {
        self.msaID = msaID
        self.selfSignedID = selfSignedID
        self.serverID = serverID
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.msaID == rhs.msaID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.msaID)
    }
}

// swiftformat:enable consecutiveSpaces spaceAroundOperators
