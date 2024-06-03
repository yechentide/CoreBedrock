//
// Created by yechentide on 2024/06/02
//

import Foundation

extension Date {
    private static func makeDefaultFormatter() -> DateFormatter {
        let defaultFormatter = DateFormatter()
        defaultFormatter.dateStyle = .medium
        defaultFormatter.timeStyle = .medium
        return defaultFormatter
    }
    public static let defaultFormatter = makeDefaultFormatter()

    public static func formatDate(_ date: Date) -> String {
        defaultFormatter.dateFormat = "yyyy/MM/dd"
        return defaultFormatter.string(from: date)
    }

    public static func formatDateTime(_ date: Date) -> String {
        defaultFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return defaultFormatter.string(from: date)
    }
}
