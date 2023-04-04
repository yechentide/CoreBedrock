import Foundation

public enum CBLvDBError: Error, LocalizedError {
    case invalidSecurityScope(URL)
    case invalidWorldDirectory(URL)
    case failedExtractKeys(URL)
    case unhandledLevelDBKey(String)
    case parsingWorldOutsideTheSandbox(URL)
    case failedOpenWorld(URL)
    case failedParseLevelData(URL)
}
