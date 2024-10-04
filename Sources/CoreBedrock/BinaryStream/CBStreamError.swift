//
// Created by yechentide on 2024/06/02
//

import Foundation

public enum CBStreamError: Error, Equatable {
    case invalidReaderState(_ message: String)
    case invalidFormat(_ message: String)
    case invalidOperation(_ message: String)
    case argumentError(_ message: String)
    case argumentError(_ message: String, _ paramName: String)
    case argumentOutOfRange(_ paramName: String, _ message: String)
    case endOfStream
    case invalidCast
    case invalidData(_ message: String)
    case compressionError
    case stringConversionError
    case seekBeforeBegin
    case bufferNotExpandable
}
