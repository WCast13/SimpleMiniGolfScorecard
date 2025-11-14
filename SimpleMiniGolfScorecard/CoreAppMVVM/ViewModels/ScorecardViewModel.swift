import SwiftUI
import SwiftData

@Observable
class ScorecardViewModel {
    var currentHole: Int = 1
    var showingResults = false
    var showingScorecardTable = false

    let game: Game
    private let modelContext: ModelContext

    init(game: Game, modelContext: ModelContext) {
        self.game = game
        self.modelContext = modelContext
    }

    var totalHoles: Int {
        game.course?.numberOfHoles ?? 0
    }

    var courseName: String {
        game.course?.name ?? "Scorecard"
    }

    func parForCurrentHole() -> Int {
        guard let course = game.course,
              currentHole > 0,
              currentHole <= course.parPerHole.count else {
            return 3 // Default fallback
        }
        return course.parPerHole[currentHole - 1]
    }

    func nextHole() {
        guard currentHole < totalHoles else { return }
        currentHole += 1
    }

    func previousHole() {
        guard currentHole > 1 else { return }
        currentHole -= 1
    }

    func completeGame() {
        game.isComplete = true
        showingResults = true
    }

    func toggleView() {
        withAnimation {
            showingScorecardTable.toggle()
        }
    }

    func loadScore(for player: Player, hole: Int) -> Int {
        if let existingScore = game.getScore(for: player, hole: hole) {
            return existingScore.strokes
        }
        return 2 // Default score
    }

    func updateScore(for player: Player, hole: Int, strokes: Int) {
        if let existingScore = game.getScore(for: player, hole: hole) {
            existingScore.strokes = strokes
        } else {
            let newScore = Score(holeNumber: hole, strokes: strokes, game: game, player: player)
            modelContext.insert(newScore)
        }
    }

    func totalScore(for player: Player) -> Int {
        game.totalScore(for: player)
    }
}
