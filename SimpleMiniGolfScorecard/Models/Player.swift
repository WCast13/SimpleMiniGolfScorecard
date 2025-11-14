import Foundation
import SwiftData
import SwiftUI

enum BallColor: String, Codable, CaseIterable {
    case red = "Red"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
    case orange = "Orange"
    case purple = "Purple"
    case pink = "Pink"
    case white = "White"
    case black = "Black"

    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .white: return .white
        case .black: return .black
        }
    }
}

@Model
final class Player {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    var createdAt: Date = Date()
    var preferredBallColor: String?

    @Relationship(deleteRule: .cascade, inverse: \Game.players)
    var games: [Game]?

    @Relationship(deleteRule: .nullify, inverse: \Score.player)
    var scores: [Score]?

    init(name: String, preferredBallColor: BallColor? = nil) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.preferredBallColor = preferredBallColor?.rawValue
        self.games = []
        self.scores = []
    }

    var ballColor: BallColor? {
        get {
            guard let colorString = preferredBallColor else { return nil }
            return BallColor(rawValue: colorString)
        }
        set {
            preferredBallColor = newValue?.rawValue
        }
    }
}
