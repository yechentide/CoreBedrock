import Foundation

public enum CBLvDBError: Error, LocalizedError {
    case invalidWorldDirectory(URL)
    case failedOpenWorld(URL)
    case failedParseLevelData(URL)
    case failedExtractKeys(URL)
    case unhandledLevelDBKey(String)
}
