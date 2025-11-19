import SwiftUI
import SwiftData

struct ScorecardView: View {
    @Environment(\.modelContext) private var modelContext
    let game: Game
    @State private var currentHole: Int = 1
    @State private var showingResults = false
    @State private var showingScorecardTable = true
    
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

                    // Match Play status banner
                    if game.gameMode == .matchPlay || game.gameMode == .teamMatchPlay {
                        MatchStatusBanner(game: game, currentHole: currentHole)
                    }

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
                                
                                switch game.gameMode {
                                case .matchPlay:
                                    MatchPlayScorecardTableView(game: game)
                                case .strokePlay:
                                    ScorecardTableView(game: game)
                                default:
                                    ScorecardTableView(game: game)
                                }
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

struct MatchStatusBanner: View {
    let game: Game
    let currentHole: Int

    var statusText: String {
        if game.gameMode == .matchPlay {
            let holeResults = (1..<currentHole).compactMap { hole -> HoleResult? in
                guard let players = game.players else { return nil }
                let winner = GameModeService.getHoleWinner(game: game, hole: hole, players: players)
                var scores: [Player: Int] = [:]
                for player in players {
                    if let score = game.getScore(for: player, hole: hole) {
                        scores[player] = score.strokes
                    }
                }
                return HoleResult(holeNumber: hole, winner: winner, scores: scores)
            }
            return GameModeService.getMatchStatus(game: game, holeResults: holeResults)
        } else if game.gameMode == .teamMatchPlay {
            let holeResults = (1..<currentHole).compactMap { hole -> TeamHoleResult? in
                guard let teamFormat = game.teamFormat else { return nil }
                let teamAPlayers = game.getTeamPlayers(team: "A")
                let teamBPlayers = game.getTeamPlayers(team: "B")

                let teamAScore = GameModeService.calculateTeamScore(players: teamAPlayers, game: game, hole: hole, format: teamFormat)
                let teamBScore = GameModeService.calculateTeamScore(players: teamBPlayers, game: game, hole: hole, format: teamFormat)

                var winningTeam: String?
                if teamAScore < teamBScore {
                    winningTeam = "A"
                } else if teamBScore < teamAScore {
                    winningTeam = "B"
                }

                return TeamHoleResult(
                    holeNumber: hole,
                    winningTeam: winningTeam,
                    teamAScore: teamAScore,
                    teamBScore: teamBScore,
                    teamAPlayers: teamAPlayers,
                    teamBPlayers: teamBPlayers
                )
            }
            return GameModeService.getTeamMatchStatus(holeResults: holeResults, teamAPlayers: game.getTeamPlayers(team: "A"), teamBPlayers: game.getTeamPlayers(team: "B"))
        }
        return ""
    }

    var body: some View {
        if currentHole > 1 {
            HStack {
                Image(systemName: game.gameMode == .teamMatchPlay ? "person.3.fill" : "person.2.fill")
                    .foregroundStyle(.blue)
                Text(statusText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
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
