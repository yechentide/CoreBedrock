//
// Created by yechentide on 2025/08/22
//

import Foundation

internal enum NetEaseNBTTransform {
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
            _ = try reader.readNext()
        } catch {
            let signature = Data([NetEaseConstants.stringTagByte]) + NetEaseConstants.scriptDataSignature
            guard let patched = replacingSignatureByte(
                find: signature, in: data, newValue: NetEaseConstants.byteArrayTagByte
            ) else {
                throw error
            }
            return patched
        }
        return nil
    }

    public static func patchEncodedPlayerData(_ data: Data) throws -> Data? {
        let signature = Data([NetEaseConstants.byteArrayTagByte]) + NetEaseConstants.scriptDataSignature
        guard let patched = replacingSignatureByte(
            find: signature, in: data, newValue: NetEaseConstants.stringTagByte
        ) else {
            return nil
        }
        return patched
    }
}
