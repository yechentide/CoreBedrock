//
// Created by yechentide on 2024/06/02
//

import Foundation

extension Date {
    private static let compactFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd-HHmmss"
        return formatter
    }()

    private static let standardFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    public var compactTimestamp: String {
        Self.compactFormatter.string(from: self)
    }

    public var standardTimestamp: String {
        Self.standardFormatter.string(from: self)
    }

    public var dateString: String {
        Self.dateOnlyFormatter.string(from: self)
    }
}
