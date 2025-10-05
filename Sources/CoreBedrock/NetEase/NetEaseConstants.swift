//
// Created by yechentide on 2025/09/04
//

import Foundation

enum NetEaseConstants {
    // File and Header Constants
    static let headerSize = 4
    static let manifestPrefix = "MANIFEST-"

    // Key Derivation Constants
    static let expectedKeyLength = 16
    static let expectedManifestLength = 16

    // Player Data Constants
    static let playerKeyPrefix = "player_"
    static let expectedPlayerKeyLength = 50

    // NBT Transform Constants
    static let scriptDataSignature = Data([
        0x0A, 0x00,
        0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x44, 0x61, 0x74, 0x61,
    ])

    // Signature bytes
    static let stringTagByte: UInt8 = 0x08
    static let byteArrayTagByte: UInt8 = 0x07
}
