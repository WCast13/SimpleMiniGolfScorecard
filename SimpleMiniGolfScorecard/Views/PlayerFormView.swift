import SwiftUI
import SwiftData

struct PlayerFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var selectedBallColor: BallColor?

    let player: Player?

    init(player: Player? = nil) {
        self.player = player
        if let player = player {
            _name = State(initialValue: player.name)
            _selectedBallColor = State(initialValue: player.ballColor)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Player Details") {
                    TextField("Player Name", text: $name)
                }

                Section("Preferred Ball Color") {
                    Picker("Ball Color", selection: $selectedBallColor) {
                        Text("None").tag(nil as BallColor?)
                        ForEach(BallColor.allCases, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 20, height: 20)
                                Text(color.rawValue)
                            }
                            .tag(color as BallColor?)
                        }
                    }
                }
            }
            .navigationTitle(player == nil ? "New Player" : "Edit Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePlayer()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func savePlayer() {
        if let player = player {
            player.name = name
            player.ballColor = selectedBallColor
        } else {
            let newPlayer = Player(name: name, preferredBallColor: selectedBallColor)
            modelContext.insert(newPlayer)
        }
    }
}

#Preview {
    PlayerFormView()
        .modelContainer(for: Player.self, inMemory: true)
}
