import SwiftUI
import SwiftData

struct MatchPlayResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let game: Game

    var matchPlayResult: MatchPlayResult {
        GameModeService.calculateMatchPlayResults(game: game)
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

                        // Match status banner
                        VStack(spacing: 12) {
                            Text(matchPlayResult.finalStatus)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(matchPlayResult.winner != nil ? .green : .primary)

                            if let winner = matchPlayResult.winner {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(.yellow)
                                    Text("\(winner.name) wins!")
                                        .font(.headline)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Hole-by-hole results
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hole-by-Hole Results")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(matchPlayResult.holeResults, id: \.holeNumber) { holeResult in
                                HoleResultCard(holeResult: holeResult, course: course)
                            }
                        }
                        .padding(.top)

                        // Stroke play totals
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Stroke Play Totals")
                                .font(.headline)
                                .padding(.horizontal)

                            if let players = game.players {
                                ForEach(players) { player in
                                    HStack {
                                        Text(player.name)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(game.totalScore(for: player))")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Match Play Results")
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

struct HoleResultCard: View {
    let holeResult: HoleResult
    let course: Course

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

            ForEach(Array(holeResult.scores.keys.sorted(by: { p1, p2 in
                holeResult.scores[p1] ?? 999 < holeResult.scores[p2] ?? 999
            })), id: \.id) { player in
                HStack {
                    Text(player.name)
                        .font(.subheadline)
                    Spacer()

                    HStack(spacing: 12) {
                        Text("\(holeResult.scores[player] ?? 0)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 30)

                        // Winner indicator
                        if holeResult.winner?.id == player.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if holeResult.winner == nil {
                            Text("T")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.red)
                                .opacity(0.5)
                        }
                    }
                }
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
    let game = Game(course: course, players: [player1, player2], gameMode: .matchPlay)

    for hole in 1...9 {
        let score1 = Score(holeNumber: hole, strokes: 3 + (hole % 2), game: game, player: player1)
        let score2 = Score(holeNumber: hole, strokes: 3 + ((hole + 1) % 2), game: game, player: player2)
        container.mainContext.insert(score1)
        container.mainContext.insert(score2)
    }

    game.isComplete = true

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return MatchPlayResultsView(game: game)
        .modelContainer(container)
}
