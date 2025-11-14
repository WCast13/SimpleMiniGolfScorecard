import Foundation

struct DateFormatterHelper {
    /// Shared date formatter for game dates with medium date and short time
    static let gameDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    /// Format a date for game display
    /// - Parameter date: The date to format
    /// - Returns: Formatted string with medium date and short time
    static func formatGameDate(_ date: Date) -> String {
        gameDateTime.string(from: date)
    }
}
