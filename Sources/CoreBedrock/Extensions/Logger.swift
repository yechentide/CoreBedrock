//
// Created by yechentide on 2024/07/21
//

import OSLog

internal enum CBLogger {
    private static let logger = Logger(
        subsystem: "com.github.yechentide.CoreBedrock",
        category: "library"
    )

    private static var currentTime: String {
        return Date().format("yyyy-MM-dd HH:mm:ss")
    }

    private static func log(
        level: OSLogType,
        _ message: String,
        file: String,
        function: String,
        line: Int
    ) {
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[CoreBedrock] [\(currentTime)] [\(fileName):L\(line) \(function)]"

        switch level {
            case .debug:    logger.debug("\(prefix) \(message)")
            case .info:     logger.info("\(prefix) \(message)")
            case .fault:    logger.fault("\(prefix) \(message)")
            case .error:    logger.error("\(prefix) \(message)")
            default:        logger.log("\(prefix) \(message)")
        }
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message, file: file, function: function, line: line)
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message, file: file, function: function, line: line)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .fault, message, file: file, function: function, line: line) // `fault` は重めの警告として代用
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message, file: file, function: function, line: line)
    }
}
