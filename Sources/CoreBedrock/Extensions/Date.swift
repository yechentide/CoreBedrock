import Foundation

extension Date {
    public static var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyMMdd-HHmmss"
        
        return formatter.string(from: Date())
    }
}
