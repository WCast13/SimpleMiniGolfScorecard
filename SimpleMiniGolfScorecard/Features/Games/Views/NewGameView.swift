import SwiftUI
import SwiftData

struct NewGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Course.name) private var courses: [Course]
    @Query(sort: \Player.name) private var players: [Player]

    @State private var selectedCourse: Course?
    @State private var selectedPlayers: Set<Player.ID> = []
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Select Course") {
                    if courses.isEmpty {
                        Text("No courses available")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Course", selection: $selectedCourse) {
                            Text("Select a course").tag(nil as Course?)
                            ForEach(courses) { course in
                                Text(course.name).tag(course as Course?)
                            }
                        }
                    }
                }

                Section("Select Players") {
                    if players.isEmpty {
                        Text("No players available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(players) { player in
                            Toggle(player.name, isOn: Binding(
                                get: { selectedPlayers.contains(player.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedPlayers.insert(player.id)
                                    } else {
                                        selectedPlayers.remove(player.id)
                                    }
                                }
                            ))
                        }
                    }
                }

                if !courses.isEmpty && !players.isEmpty {
                    Section {
                        Button("Start Game") {
                            startGame()
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(selectedCourse == nil || selectedPlayers.isEmpty)
                    }
                }
            }
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func startGame() {
        guard let course = selectedCourse else {
            showError("Please select a course")
            return
        }

        let gamePlayers = players.filter { selectedPlayers.contains($0.id) }

        guard !gamePlayers.isEmpty else {
            showError("Please select at least one player")
            return
        }

        let newGame = Game(course: course, players: gamePlayers)
        modelContext.insert(newGame)

        dismiss()
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Course.self, Player.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 18)
    let player1 = Player(name: "Player 1")
    let player2 = Player(name: "Player 2")

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)

    return NewGameView()
        .modelContainer(container)
}
