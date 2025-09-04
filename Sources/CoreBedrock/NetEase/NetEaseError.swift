//
// Created by yechentide on 2025/08/22
//

import Foundation

public enum NetEaseError: Error, Equatable, LocalizedError {
    case dbNotFound(String)
    case currentFileNotFound
    case manifestFileNotFound
    case invalidHeader
    case alreadyDecrypted
    case alreadyEncrypted
    case invalidKeyLength(Int)
    case invalidCurrentFileData
    case invalidManifestFileData
    case keyVerificationFailed
    case fileEnumerationFailed(String)
}
