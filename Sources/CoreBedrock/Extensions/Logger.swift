//
// Created by yechentide on 2024/07/21
//

import OSLog

enum CBLogger {
    private static let logger = Logger(
        subsystem: "com.github.yechentide.CoreBedrock",
        category: "library"
    )

    private static func log(
        level: OSLogType,
        _ message: String,
        file: String,
        function: String,
        line: Int
    ) {
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[CoreBedrock] [\(Date().standardTimestamp)] [\(fileName):L\(line) \(function)]"

        // swiftformat:disable consecutiveSpaces spaceAroundOperators
        switch level {
        case .debug:    self.logger.debug("\(prefix) \(message)")
        case .info:     self.logger.info("\(prefix) \(message)")
        case .fault:    self.logger.fault("\(prefix) \(message)")
        case .error:    self.logger.error("\(prefix) \(message)")
        default:        self.logger.log("\(prefix) \(message)")
        }
        // swiftformat:enable consecutiveSpaces spaceAroundOperators
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(level: .debug, message, file: file, function: function, line: line)
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(level: .info, message, file: file, function: function, line: line)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(level: .fault, message, file: file, function: function, line: line)
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(level: .error, message, file: file, function: function, line: line)
    }
}
