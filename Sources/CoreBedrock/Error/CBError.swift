//
// Created by yechentide on 2024/07/14
//

public import Foundation

public enum CBError: Error, LocalizedError, Sendable, Hashable {
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
