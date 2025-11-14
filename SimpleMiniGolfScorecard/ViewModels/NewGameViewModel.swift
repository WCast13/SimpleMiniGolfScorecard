import SwiftUI
import SwiftData

@Observable
class NewGameViewModel {
    var selectedCourse: Course?
    var selectedPlayers: Set<Player.ID> = []
    var showingError = false
    var errorMessage = ""

    private let modelContext: ModelContext
    private let courses: [Course]
    private let players: [Player]

    var isValid: Bool {
        selectedCourse != nil && !selectedPlayers.isEmpty
    }

    var hasData: Bool {
        !courses.isEmpty && !players.isEmpty
    }

    init(courses: [Course], players: [Player], modelContext: ModelContext) {
        self.courses = courses
        self.players = players
        self.modelContext = modelContext
    }

    func startGame() -> Game? {
        guard let course = selectedCourse else {
            showError("Please select a course")
            return nil
        }

        let gamePlayers = players.filter { selectedPlayers.contains($0.id) }

        guard !gamePlayers.isEmpty else {
            showError("Please select at least one player")
            return nil
        }

        let newGame = Game(course: course, players: gamePlayers)
        modelContext.insert(newGame)

        return newGame
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }

    func togglePlayer(_ playerId: Player.ID) {
        if selectedPlayers.contains(playerId) {
            selectedPlayers.remove(playerId)
        } else {
            selectedPlayers.insert(playerId)
        }
    }

    func isPlayerSelected(_ playerId: Player.ID) -> Bool {
        selectedPlayers.contains(playerId)
    }
}
