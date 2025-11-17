import SwiftUI
import SwiftData

struct NewGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Course.name) private var courses: [Course]
    @Query(sort: \Player.name) private var players: [Player]

    var onGameCreated: ((Game) -> Void)?

    @State private var selectedCourse: Course?
    @State private var selectedPlayers: Set<Player.ID> = []
    @State private var selectedGameMode: GameMode = .strokePlay
    @State private var selectedTeamFormat: TeamFormat = .bestBall
    @State private var teamAssignmentMethod: TeamAssignment = .manual
    @State private var teamAssignments: [Player.ID: String] = [:]
    @State private var ballColorAssignments: [Player.ID: BallColor] = [:]
    @State private var showingError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Game Mode") {
                    Picker("Mode", selection: $selectedGameMode) {
                        ForEach(GameMode.allCases, id: \.self) { mode in
                            Text(mode.description)
                        }
                    }
                    .onChange(of: selectedGameMode) { _, newMode in
                        if newMode == .teamMatchPlay {
                            initializeTeamAssignments()
                        }
                    }
                }

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
                            VStack(alignment: .leading, spacing: 8) {
                                Toggle(player.name, isOn: Binding(
                                    get: { selectedPlayers.contains(player.id) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedPlayers.insert(player.id)
                                            // Initialize ball color to preferred color
                                            if let preferredColor = player.ballColor {
                                                ballColorAssignments[player.id] = preferredColor
                                            }
                                        } else {
                                            selectedPlayers.remove(player.id)
                                            ballColorAssignments.removeValue(forKey: player.id)
                                        }
                                        if selectedGameMode == .teamMatchPlay {
                                            initializeTeamAssignments()
                                        }
                                    }
                                ))

                                // Show ball color picker if player is selected
                                if selectedPlayers.contains(player.id) {
                                    HStack {
                                        Text("Ball Color")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Picker("", selection: Binding(
                                            get: { ballColorAssignments[player.id] ?? player.ballColor ?? .red },
                                            set: { ballColorAssignments[player.id] = $0 }
                                        )) {
                                            ForEach(BallColor.allCases, id: \.self) { color in
                                                HStack {
                                                    Circle()
                                                        .fill(color.color)
                                                        .frame(width: 16, height: 16)
                                                    Text(color.rawValue)
                                                }
                                                .tag(color)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                    }
                                    .padding(.leading, 20)
                                }
                            }
                        }
                    }
                }

                // Team setup section (only for team match play)
                if selectedGameMode == .teamMatchPlay && !selectedPlayers.isEmpty {
                    Section("Team Setup") {
                        Picker("Assignment", selection: $teamAssignmentMethod) {
                            ForEach(TeamAssignment.allCases, id: \.self) { method in
                                Text(method.description).tag(method)
                            }
                        }
                        .onChange(of: teamAssignmentMethod) { _, _ in
                            initializeTeamAssignments()
                        }

                        if teamAssignmentMethod == .manual {
                            ForEach(getSelectedPlayerObjects()) { player in
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Picker("", selection: Binding(
                                        get: { teamAssignments[player.id] ?? "A" },
                                        set: { teamAssignments[player.id] = $0 }
                                    )) {
                                        Text("Team A").tag("A")
                                        Text("Team B").tag("B")
                                    }
                                    .pickerStyle(.segmented)
                                    .frame(width: 150)
                                }
                            }
                        } else {
                            let teamA = getTeamPlayers(team: "A")
                            let teamB = getTeamPlayers(team: "B")

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Team A")
                                    .font(.headline)
                                ForEach(teamA) { player in
                                    Text("• \(player.name)")
                                        .font(.subheadline)
                                }

                                Text("Team B")
                                    .font(.headline)
                                    .padding(.top, 8)
                                ForEach(teamB) { player in
                                    Text("• \(player.name)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }

                    Section("Team Format") {
                        Picker("Scoring Format", selection: $selectedTeamFormat) {
                            ForEach(TeamFormat.allCases, id: \.self) { format in
                                Text(format.description).tag(format)
                            }
                        }

                        Text(selectedTeamFormat.detailedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
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

        // Validate team setup for team match play
        if selectedGameMode == .teamMatchPlay {
            let teamA = getTeamPlayers(team: "A")
            let teamB = getTeamPlayers(team: "B")

            guard !teamA.isEmpty && !teamB.isEmpty else {
                showError("Both teams must have at least one player")
                return
            }
        }

        // Create game with appropriate game mode settings
        var teamAssignmentsDict: [UUID: String]?
        var teamFormat: TeamFormat?

        if selectedGameMode == .teamMatchPlay {
            teamAssignmentsDict = teamAssignments
            teamFormat = selectedTeamFormat
        }

        let newGame = Game(
            course: course,
            players: gamePlayers,
            gameMode: selectedGameMode,
            teamFormat: teamFormat,
            teamAssignments: teamAssignmentsDict
        )

        modelContext.insert(newGame)
        onGameCreated?(newGame)
    }

    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }

    private func getSelectedPlayerObjects() -> [Player] {
        return players.filter { selectedPlayers.contains($0.id) }
    }

    private func getTeamPlayers(team: String) -> [Player] {
        return players.filter { selectedPlayers.contains($0.id) && teamAssignments[$0.id] == team }
    }

    private func initializeTeamAssignments() {
        let selectedPlayersList = getSelectedPlayerObjects()

        if teamAssignmentMethod == .autoSplit {
            // Auto-split players into two teams
            teamAssignments.removeAll()
            for (index, player) in selectedPlayersList.enumerated() {
                teamAssignments[player.id] = index % 2 == 0 ? "A" : "B"
            }
        } else {
            // Manual assignment - initialize any new players to Team A
            for player in selectedPlayersList {
                if teamAssignments[player.id] == nil {
                    teamAssignments[player.id] = "A"
                }
            }
            // Remove assignments for deselected players
            let selectedIds = Set(selectedPlayersList.map { $0.id })
            teamAssignments = teamAssignments.filter { selectedIds.contains($0.key) }
        }
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
