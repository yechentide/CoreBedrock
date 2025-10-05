//
// Created by yechentide on 2025/05/25
//

@testable import CoreBedrock
import Foundation
import Testing

struct DateTests {
    @Test
    func dateFormatting() {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 1
        dateComponents.day = 20
        dateComponents.hour = 14
        dateComponents.minute = 30
        dateComponents.second = 0

        let date = calendar.date(from: dateComponents)!

        // Test compact timestamp format (yyMMdd-HHmmss)
        let compactTimestamp = date.compactTimestamp
        #expect(compactTimestamp == "240120-143000")

        // Test standard timestamp format (yyyy-MM-dd HH:mm:ss)
        let standardTimestamp = date.standardTimestamp
        #expect(standardTimestamp == "2024-01-20 14:30:00")

        // Test date-only format (yyyy-MM-dd)
        let dateString = date.dateString
        #expect(dateString == "2024-01-20")
    }
}
