import SwiftUI
import SwiftData

@Observable
class PlayerFormViewModel {
    var name: String = ""
    var initials: String = ""
    var selectedBallColor: BallColor?

    private let player: Player?
    private let modelContext: ModelContext

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var title: String {
        player == nil ? "New Player" : "Edit Player"
    }

    init(player: Player? = nil, modelContext: ModelContext) {
        self.player = player
        self.modelContext = modelContext

        if let player = player {
            self.name = player.name
            self.initials = player.initials
            self.selectedBallColor = player.ballColor
        }
    }

    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        if let player = player {
            player.name = trimmedName
            player.ballColor = selectedBallColor
            player.initials = initials
        } else {
            let newPlayer = Player(name: trimmedName, initials: initials, preferredBallColor: selectedBallColor)
            modelContext.insert(newPlayer)
        }
    }
}
