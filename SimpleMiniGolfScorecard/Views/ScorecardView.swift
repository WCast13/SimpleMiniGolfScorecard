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
                    HoleNavigationBar(
                        currentHole: $currentHole,
                        totalHoles: course.numberOfHoles,
                        onComplete: {
                            game.isComplete = true
                            showingResults = true
                        }, par: course.parPerHole[currentHole - 1]
                    )
                    
                    ScrollView {
                        VStack(spacing: 20) {
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
                            
                            if showingScorecardTable == true {
                                ScorecardTableView(game: game)
                            }
                        }
                        .padding(.vertical)
                    }
            }
        }
        .background(Color(.systemBackground))
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
    let par: Int
    
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
            
            VStack(spacing: 8) {
                Text("Hole \(currentHole)")
                    .font(.title2)
                    .bold()
                Text("Par \(par)")
                    .font(.headline)
            }
            
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
                            .overlay(
                                Circle().stroke(Color.black.opacity(0.5), lineWidth: 1)
                            )
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
            
            Button("\(strokes == 0 ? "-" : "\(strokes)")") {
                showingScorePicker = true
            }
            .font(.system(size: 36, weight: .bold))
            .frame(width: 75, height: 60)
            .background(Color(.secondarySystemBackground).cornerRadius(12))
            .buttonStyle(.plain)
        }
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
            strokes = 0
        }
    }
    
    func updateScore() {
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
    var player1 = Player(name: "Player 1", preferredBallColor: .red)
    let player2 = Player(name: "Player 2", preferredBallColor: .white)
    var player3 = Player(name: "Player 1", preferredBallColor: .green)
    let player4 = Player(name: "Player 2", preferredBallColor: .blue)
    let game = Game(course: course, players: [player1, player2, player3, player4])
    
    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)
    
    return NavigationStack {
        ScorecardView(game: game)
            .modelContainer(container)
    }
}
