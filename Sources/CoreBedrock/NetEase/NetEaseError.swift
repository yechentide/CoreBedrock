//
// Created by yechentide on 2025/08/22
//

import Foundation

public enum NetEaseError: Error, LocalizedError {
    case dbNotFound(String)
    case invalidHeader
    case manifestNotFound
    case readCurrentFailed
    case invalidManifestLength(Int)
    case invalidCurrentLength(Int)
    case keyVerificationFailed
}
