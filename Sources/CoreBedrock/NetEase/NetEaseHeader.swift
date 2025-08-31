//
// Created by yechentide on 2025/08/22
//

import Foundation

internal enum NetEaseHeader {
    case current
    case legacy
    case vanilla
    case unknown

    var data: Data {
        switch self {
            case .current:
                Data([0x80, 0x1D, 0x30, 0x01])
            case .legacy:
                Data([0x90, 0x1D, 0x30, 0x01])
            case .vanilla:
                Data([0x4D, 0x41, 0x4E, 0x49]) // "MANI"
            case .unknown:
                Data()
        }
    }

    static func identifyHeader(in data: Data) -> Self {
        guard data.count >= 4 else {
            return .unknown
        }
        let headerBytes = data[0..<4]
        if headerBytes == Self.current.data {
            return .current
        }
        if headerBytes == Self.legacy.data {
            return .legacy
        }
        if headerBytes == Self.vanilla.data {
            return .vanilla
        }
        return .unknown
    }

    static func validateDecryptableFile(data: Data) throws {
        let headerType = Self.identifyHeader(in: data)
        switch headerType {
            case .current:
                return
            default:
                throw NetEaseError.invalidHeader
        }
    }
}
