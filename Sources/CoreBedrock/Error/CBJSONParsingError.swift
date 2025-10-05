//
// Created by yechentide on 2025/09/18
//

public enum CBJSONParsingError: Error {
    case invalidVersion(Int)
    case invalidJSONValue(String)
    case invalidHexColor(String)
    case invalidHexRef(String)
    case blockNotDifined(String)
    case wrongEntryCount(Int)
}
