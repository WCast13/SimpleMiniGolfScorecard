import SwiftUI

struct ScoreColorHelper {
    /// Returns the appropriate color for a score based on its comparison to par
    /// - Parameters:
    ///   - score: The actual strokes taken
    ///   - par: The par for the hole
    /// - Returns: Green for under par, red for over par, clear for par
    static func color(score: Int, par: Int) -> Color {
        if score < par {
            return Color.green.opacity(0.2)
        } else if score > par {
            return Color.red.opacity(0.2)
        }
        return Color.clear
    }
}
