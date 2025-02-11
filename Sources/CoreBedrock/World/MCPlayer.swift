//
// Created by yechentide on 2024/10/04
//

public struct MCPlayer: Equatable, Hashable, Sendable {
    public let msaID: String       // player_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    public let signedID: String    // player_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    public let serverID: String    // player_server_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

    public static func == (lhs: MCPlayer, rhs: MCPlayer) -> Bool {
        return lhs.msaID == rhs.msaID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(msaID)
    }
}
