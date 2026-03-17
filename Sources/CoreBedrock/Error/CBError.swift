//
// Created by yechentide on 2024/07/14
//

import Foundation

public enum CBError: Error, Equatable, LocalizedError {
    // World
    case invalidWorldDirectory(URL)
    case failedOpenWorld(URL)
    case failedParseLevelData(URL?)

    // LevelDB
    case failedExtractKeys(URL)
    case unhandledLevelDBKey(String)

    // Parser
    case invalidDataLength(Int)
    case failedParseSubchunk

    // Map Art
    case failedCreateImageContext
    case failedToAllocateMapIDs
    case failedToSaveMapDataTag
}
