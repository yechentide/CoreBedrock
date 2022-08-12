import Foundation

struct MCPlayer: Equatable, Hashable {
    let msaID: String       // player_ad01bd0d-3bae-30f2-89f1-e177a65764a9
    let signedID: String    // player_d3663243-007c-33de-8bf1-384226d03329
    let serverID: String    // player_server_de3a8a4b-a66f-465f-881b-0389e4993834
    
    static func == (lhs: MCPlayer, rhs: MCPlayer) -> Bool {
        return lhs.msaID == rhs.msaID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(msaID)
    }
}
