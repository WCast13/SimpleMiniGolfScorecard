import Foundation
import SwiftData

@Model
final class Score {
    @Attribute(.unique) var id: UUID = UUID()
    var holeNumber: Int = 1
    var strokes: Int = 0

    var game: Game?
    var player: Player?

    init(holeNumber: Int, strokes: Int, game: Game, player: Player) {
        self.id = UUID()
        self.holeNumber = holeNumber
        self.strokes = strokes
        self.game = game
        self.player = player
    }
}
