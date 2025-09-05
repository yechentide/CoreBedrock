//
// Created by yechentide on 2024/06/02
//

import Foundation

public enum CBStreamError: Error, Equatable, LocalizedError {
    case invalidFormat(_ message: String)
    case argumentError(_ message: String, _ paramName: String? = nil)
    case argumentOutOfRange(_ paramName: String, _ message: String)
    case endOfStream
    case stringConversionError
    case outOfBounds
}
