import SwiftUI
import SwiftData

struct TeamMatchPlayResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let game: Game

    var teamMatchResult: TeamMatchPlayResult {
        GameModeService.calculateTeamMatchPlayResults(game: game)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let course = game.course {
                        VStack(spacing: 8) {
                            Text(course.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(DateFormatterHelper.formatGameDate(game.date))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if let format = game.teamFormat {
                                Text(format.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()

                        // Match status banner
                        VStack(spacing: 12) {
                            Text(teamMatchResult.finalStatus)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(teamMatchResult.winningTeam != nil ? .green : .primary)

                            if let winningTeam = teamMatchResult.winningTeam {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(.yellow)
                                    Text("Team \(winningTeam) wins!")
                                        .font(.headline)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Team rosters
                        HStack(spacing: 16) {
                            TeamRosterCard(
                                teamName: "Team A",
                                players: teamMatchResult.teamAPlayers,
                                game: game,
                                isWinner: teamMatchResult.winningTeam == "A"
                            )

                            TeamRosterCard(
                                teamName: "Team B",
                                players: teamMatchResult.teamBPlayers,
                                game: game,
                                isWinner: teamMatchResult.winningTeam == "B"
                            )
                        }
                        .padding(.horizontal)

                        // Hole-by-hole results
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hole-by-Hole Results")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(teamMatchResult.holeResults, id: \.holeNumber) { holeResult in
                                TeamHoleResultCard(holeResult: holeResult, course: course, game: game)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Team Match Play Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TeamRosterCard: View {
    let teamName: String
    let players: [Player]
    let game: Game
    let isWinner: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(teamName)
                    .font(.headline)
                if isWinner {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
            }

            ForEach(players) { player in
                VStack(alignment: .leading, spacing: 2) {
                    Text(player.name)
                        .font(.subheadline)
                    Text("\(game.totalScore(for: player)) strokes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isWinner ? Color.yellow.opacity(0.1) : Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct TeamHoleResultCard: View {
    let holeResult: TeamHoleResult
    let course: Course
    let game: Game

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Hole \(holeResult.holeNumber)")
                    .font(.headline)
                Spacer()
                if holeResult.holeNumber <= course.parPerHole.count {
                    Text("Par \(course.parPerHole[holeResult.holeNumber - 1])")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 20) {
                // Team A
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Team A")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(holeResult.teamAScore)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        if holeResult.winningTeam == "A" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if holeResult.winningTeam == nil {
                            Text("T")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Individual player scores
                    ForEach(holeResult.teamAPlayers) { player in
                        if let score = game.getScore(for: player, hole: holeResult.holeNumber) {
                            HStack {
                                Text(player.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(score.strokes)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                Divider()

                // Team B
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Team B")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(holeResult.teamBScore)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        if holeResult.winningTeam == "B" {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if holeResult.winningTeam == nil {
                            Text("T")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Individual player scores
                    ForEach(holeResult.teamBPlayers) { player in
                        if let score = game.getScore(for: player, hole: holeResult.holeNumber) {
                            HStack {
                                Text(player.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(score.strokes)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 9)
    let player1 = Player(name: "Alice", preferredBallColor: .red)
    let player2 = Player(name: "Bob", preferredBallColor: .blue)
    let player3 = Player(name: "Charlie", preferredBallColor: .green)
    let player4 = Player(name: "Dana", preferredBallColor: .yellow)

    let teamAssignments: [UUID: String] = [
        player1.id: "A",
        player2.id: "A",
        player3.id: "B",
        player4.id: "B"
    ]

    let game = Game(
        course: course,
        players: [player1, player2, player3, player4],
        gameMode: .teamMatchPlay,
        teamFormat: .bestBall,
        teamAssignments: teamAssignments
    )

    for hole in 1...9 {
        let score1 = Score(holeNumber: hole, strokes: 3 + (hole % 3), game: game, player: player1)
        let score2 = Score(holeNumber: hole, strokes: 4 + (hole % 2), game: game, player: player2)
        let score3 = Score(holeNumber: hole, strokes: 3 + ((hole + 1) % 3), game: game, player: player3)
        let score4 = Score(holeNumber: hole, strokes: 4 + ((hole + 1) % 2), game: game, player: player4)
        container.mainContext.insert(score1)
        container.mainContext.insert(score2)
        container.mainContext.insert(score3)
        container.mainContext.insert(score4)
    }

    game.isComplete = true

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(player3)
    container.mainContext.insert(player4)
    container.mainContext.insert(game)

    return TeamMatchPlayResultsView(game: game)
        .modelContainer(container)
}
