import SwiftUI
import SwiftData

struct GameResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let game: Game

    var sortedPlayers: [(Player, Int)] {
        guard let players = game.players else { return [] }
        return players.map { player in
            (player, game.totalScore(for: player))
        }.sorted { $0.1 < $1.1 }
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
                        }
                        .padding()

                        VStack(spacing: 12) {
                            ForEach(Array(sortedPlayers.enumerated()), id: \.element.0.id) { index, playerScore in
                                PlayerResultCard(
                                    rank: index + 1,
                                    player: playerScore.0,
                                    totalScore: playerScore.1,
                                    course: course,
                                    isWinner: index == 0
                                )
                            }
                        }
                        .padding(.horizontal)

                        if let players = game.players, !players.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Detailed Scores")
                                    .font(.headline)
                                    .padding(.horizontal)

                                DetailedScorecard(game: game, course: course, players: players)
                            }
                            .padding(.top)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Results")
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

struct PlayerResultCard: View {
    let rank: Int
    let player: Player
    let totalScore: Int
    let course: Course
    let isWinner: Bool

    var totalPar: Int {
        course.parPerHole.reduce(0, +)
    }

    var scoreDifference: Int {
        totalScore - totalPar
    }

    var scoreText: String {
        if scoreDifference == 0 {
            return "Even"
        } else if scoreDifference > 0 {
            return "+\(scoreDifference)"
        } else {
            return "\(scoreDifference)"
        }
    }

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(isWinner ? .yellow : .secondary)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(player.name)
                        .font(.headline)
                    if isWinner {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                Text("\(totalScore) (\(scoreText))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(isWinner ? Color.yellow.opacity(0.1) : Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 9)
    let player1 = Player(name: "Alice")
    let player2 = Player(name: "Bob")
    let game = Game(course: course, players: [player1, player2])

    for hole in 1...9 {
        let score1 = Score(holeNumber: hole, strokes: 3 + (hole % 3), game: game, player: player1)
        let score2 = Score(holeNumber: hole, strokes: 4 + (hole % 2), game: game, player: player2)
        container.mainContext.insert(score1)
        container.mainContext.insert(score2)
    }

    game.isComplete = true

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return GameResultsView(game: game)
        .modelContainer(container)
}

#Preview("Detailed Scorecard") {
    let container = PreviewHelper.createPreviewContainer()
    let (game, players, course) = PreviewHelper.createSampleGame(
        in: container,
        courseName: "Popstroke Mini Golf",
        numberOfHoles: 18,
        playerCount: 3
    )

    PreviewHelper.createRandomScores(for: game, players: players, numberOfHoles: 18, in: container)
    game.isComplete = true

    return DetailedScorecard(game: game, course: course, players: players)
        .modelContainer(container)
}
