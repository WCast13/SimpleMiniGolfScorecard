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
                            Text(formatDate(game.date))
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

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
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

struct DetailedScorecard: View {
    let game: Game
    let course: Course
    let players: [Player]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("Hole")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 60)
                        .padding(.vertical, 8)

                    ForEach(1...course.numberOfHoles, id: \.self) { hole in
                        VStack(spacing: 4) {
                            Text("\(hole)")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("(\(course.parPerHole[hole - 1]))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 50)
                        .padding(.vertical, 4)
                    }

                    Text("Total")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 60)
                        .padding(.vertical, 8)
                }
                .background(Color(.secondarySystemBackground))

                ForEach(players) { player in
                    HStack(spacing: 0) {
                        Text(player.name)
                            .font(.caption)
                            .lineLimit(1)
                            .frame(width: 60)
                            .padding(.vertical, 8)

                        ForEach(1...course.numberOfHoles, id: \.self) { hole in
                            if let score = game.getScore(for: player, hole: hole) {
                                Text("\(score.strokes)")
                                    .font(.caption)
                                    .frame(width: 50)
                                    .padding(.vertical, 8)
                                    .background(scoreColor(score: score.strokes, par: course.parPerHole[hole - 1]))
                            } else {
                                Text("-")
                                    .font(.caption)
                                    .frame(width: 50)
                                    .padding(.vertical, 8)
                            }
                        }

                        Text("\(game.totalScore(for: player))")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 60)
                            .padding(.vertical, 8)
                    }
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }

    private func scoreColor(score: Int, par: Int) -> Color {
        if score < par {
            return Color.green.opacity(0.2)
        } else if score > par {
            return Color.red.opacity(0.2)
        }
        return Color.clear
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
