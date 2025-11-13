import Foundation
import SwiftData

@Model
final class Score {
    var id: UUID
    var holeNumber: Int
    var strokes: Int

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
