//
// Created by yechentide on 2025/08/22
//

import Foundation

public enum LvDBError: Error, LocalizedError {
    case dbClosed(String)
    case notFound(String)
    case corruption(String)
    case notSupported(String)
    case invalidArgument(String)
    case ioError(String)
    case unknown(String)

    init(nsError: NSError) {
        let message = nsError.localizedDescription
        if message.hasPrefix("DB Closed") {
            self = .dbClosed(message)
        } else if message.hasPrefix("NotFound:") {
            self = .notFound(message)
        } else if message.hasPrefix("Corruption:") {
            self = .corruption(message)
        } else if message.hasPrefix("Not implemented:") {
            self = .notSupported(message)
        } else if message.hasPrefix("Invalid argument:") {
            self = .invalidArgument(message)
        } else if message.hasPrefix("IO error:") {
            self = .ioError(message)
        } else {
            self = .unknown(message)
        }
    }
}
