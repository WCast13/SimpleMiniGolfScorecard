import Foundation
import SwiftData

@Model
final class Game {
    var id: UUID = UUID()
    var date: Date = Date()
    var isComplete: Bool = false

    var course: Course?
    var players: [Player]?

    @Relationship(deleteRule: .cascade, inverse: \Score.game)
    var scores: [Score]?

    init(course: Course, players: [Player]) {
        self.id = UUID()
        self.date = Date()
        self.isComplete = false
        self.course = course
        self.players = players
        self.scores = []
    }

    func getScore(for player: Player, hole: Int) -> Score? {
        return scores?.first { $0.player?.id == player.id && $0.holeNumber == hole }
    }

    func totalScore(for player: Player) -> Int {
        return scores?.filter { $0.player?.id == player.id }.reduce(0) { $0 + $1.strokes } ?? 0
    }
}
