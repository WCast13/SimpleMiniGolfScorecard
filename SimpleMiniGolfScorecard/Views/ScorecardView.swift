import SwiftUI
import SwiftData

struct ScorecardView: View {
    @Environment(\.modelContext) private var modelContext
    let game: Game
    @State private var currentHole: Int = 1
    @State private var showingResults = false
    @State private var showingScorecardTable = false

    var body: some View {
        VStack(spacing: 0) {
            if let course = game.course, let players = game.players {
                if !showingScorecardTable {
                    HoleNavigationBar(
                        currentHole: $currentHole,
                        totalHoles: course.numberOfHoles,
                        onComplete: {
                            game.isComplete = true
                            showingResults = true
                        }
                    )

                    ScrollView {
                        VStack(spacing: 20) {
                            HoleInfoCard(
                                holeNumber: currentHole,
                                par: course.parPerHole[currentHole - 1]
                            )

                            VStack(spacing: 12) {
                                ForEach(players) { player in
                                    PlayerScoreCard(
                                        player: player,
                                        game: game,
                                        hole: currentHole,
                                        modelContext: modelContext
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                } else {
                    ScorecardTableView(game: game)
                }
            }
        }
        .navigationTitle(game.course?.name ?? "Scorecard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showingScorecardTable.toggle()
                    }
                } label: {
                    Label(
                        showingScorecardTable ? "Score Entry" : "View Scorecard",
                        systemImage: showingScorecardTable ? "pencil" : "tablecells"
                    )
                }
            }
        }
        .sheet(isPresented: $showingResults) {
            GameResultsView(game: game)
        }
    }
}

struct HoleNavigationBar: View {
    @Binding var currentHole: Int
    let totalHoles: Int
    let onComplete: () -> Void

    var body: some View {
        HStack {
            Button {
                if currentHole > 1 {
                    currentHole -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundStyle(currentHole > 1 ? .blue : .gray)
            }
            .disabled(currentHole == 1)

            Spacer()

            Text("Hole \(currentHole) of \(totalHoles)")
                .font(.headline)

            Spacer()

            if currentHole < totalHoles {
                Button {
                    currentHole += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            } else {
                Button("Finish") {
                    onComplete()
                }
                .foregroundStyle(.green)
                .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
    }
}

struct HoleInfoCard: View {
    let holeNumber: Int
    let par: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Hole \(holeNumber)")
                .font(.title2)
                .fontWeight(.bold)
            Text("Par \(par)")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct PlayerScoreCard: View {
    let player: Player
    let game: Game
    let hole: Int
    let modelContext: ModelContext

    @State private var strokes: Int = 0
    @State private var showingScorePicker = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if let ballColor = player.ballColor {
                        Circle()
                            .fill(ballColor.color)
                            .frame(width: 16, height: 16)
                    }
                    Text(player.name)
                        .font(.headline)
                }
                Text("Total: \(game.totalScore(for: player))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                showingScorePicker = true
            } label: {
                VStack(spacing: 4) {
                    Text("\(strokes)")
                        .font(.system(size: 36, weight: .bold))
                    Text("strokes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 100, height: 80)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4)
        .onAppear {
            loadScore()
        }
        .onChange(of: hole) { _, _ in
            loadScore()
        }
        .sheet(isPresented: $showingScorePicker) {
            ScorePickerView(
                selectedScore: $strokes,
                onSelect: { score in
                    strokes = score
                    updateScore()
                },
                onDismiss: {
                    showingScorePicker = false
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private func loadScore() {
        if let existingScore = game.getScore(for: player, hole: hole) {
            strokes = existingScore.strokes
        } else {
            strokes = 2
        }
    }

    private func updateScore() {
        if let existingScore = game.getScore(for: player, hole: hole) {
            existingScore.strokes = strokes
        } else {
            let newScore = Score(holeNumber: hole, strokes: strokes, game: game, player: player)
            modelContext.insert(newScore)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 18)
    let player1 = Player(name: "Player 1")
    let player2 = Player(name: "Player 2")
    let game = Game(course: course, players: [player1, player2])

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return NavigationStack {
        ScorecardView(game: game)
            .modelContainer(container)
    }
}
