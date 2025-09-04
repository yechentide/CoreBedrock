//
// Created by yechentide on 2025/09/04
//

import Foundation

internal enum NetEaseCrypto {
    static func applyXOR(to data: Data, with key: Data) -> Data {
        guard !key.isEmpty else { return data }
        var result = Data(capacity: data.count)
        for (index, byte) in data.enumerated() {
            result.append(byte ^ key[index % key.count])
        }
        return result
    }

    static func decryptFile(data: Data, key: Data) throws -> Data {
        let body = data.dropFirst(NetEaseConstants.headerSize)
        return applyXOR(to: body, with: key)
    }

    static func encryptFile(data: Data, key: Data) throws -> Data {
        let encryptedBody = applyXOR(to: data, with: key)
        return NetEaseHeader.neteaseEncrypted.data + encryptedBody
    }
}
