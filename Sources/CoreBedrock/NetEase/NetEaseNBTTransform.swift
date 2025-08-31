//
// Created by yechentide on 2025/08/22
//

import Foundation

internal enum NetEaseNBTTransform {
    private static let scriptDataSignature = Data([
        0x0A, 0x00,
        0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x44, 0x61, 0x74, 0x61
    ])

    private static func replacingSignatureByte(
        find signature: Data,
        in data: Data,
        newValue: UInt8
    ) -> Data? {
        guard let range = data.range(of: signature) else {
            return nil
        }
        var patched = data
        patched[range.lowerBound] = newValue
        return patched
    }

    public static func patchDecodedPlayerData(_ data: Data) throws -> Data? {
        let reader = CBTagReader(data: data)
        do {
            let _ = try reader.readNext()
        } catch {
            let signature = Data([0x08]) + scriptDataSignature
            guard let patched = replacingSignatureByte(find: signature, in: data, newValue: 0x07) else {
                throw error
            }
            return patched
        }
        return nil
    }

    public static func patchEncodedPlayerData(_ data: Data) throws -> Data? {
        let signature = Data([0x07]) + scriptDataSignature
        guard let patched = replacingSignatureByte(find: signature, in: data, newValue: 0x08) else {
            return nil
        }
        return patched
    }
}
