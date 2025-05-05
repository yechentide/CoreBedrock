//
// Created by yechentide on 2024/06/02
//

import Foundation

extension Date {
    public static let defaultFormatter = {
        let defaultFormatter = DateFormatter()
        defaultFormatter.dateStyle = .medium
        defaultFormatter.timeStyle = .medium
        return defaultFormatter
    }()

    public func format(_ format: String) -> String {
        Self.defaultFormatter.dateFormat = format
        return Self.defaultFormatter.string(from: self)
    }
}
