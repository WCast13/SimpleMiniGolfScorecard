import SwiftUI
import SwiftData

struct ScorecardTableView: View {
    let game: Game
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var isLandscape: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    var body: some View {
        Group {
            if isLandscape {
                HorizontalScorecardTable(game: game)
            } else {
                VerticalScorecardTable(game: game)
            }
        }
    }
}

struct VerticalScorecardTable: View {
    let game: Game

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let course = game.course, let players = game.players {
                    // Header
                    HStack(spacing: 0) {
                        Text("Hole")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 50)
                            .padding(.vertical, 8)

                        Text("Par")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 40)
                            .padding(.vertical, 8)

                        ForEach(players) { player in
                            VStack(spacing: 2) {
                                Text(player.name)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                if let ballColor = player.ballColor {
                                    Circle()
                                        .fill(ballColor.color)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                        }
                    }
                    .background(Color(.secondarySystemBackground))

                    // Holes
                    ForEach(1...course.numberOfHoles, id: \.self) { hole in
                        HStack(spacing: 0) {
                            Text("\(hole)")
                                .font(.caption)
                                .frame(width: 50)
                                .padding(.vertical, 8)

                            Text("\(course.parPerHole[hole - 1])")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 40)
                                .padding(.vertical, 8)

                            ForEach(players) { player in
                                if let score = game.getScore(for: player, hole: hole) {
                                    Text("\(score.strokes)")
                                        .font(.caption)
                                        .fontWeight(score.strokes == course.parPerHole[hole - 1] ? .regular : .semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(ScoreColorHelper.color(score: score.strokes, par: course.parPerHole[hole - 1]))
                                } else {
                                    Text("-")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                        if hole < course.numberOfHoles {
                            Divider()
                        }
                    }

                    // Total row
                    HStack(spacing: 0) {
                        Text("Total")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 50)
                            .padding(.vertical, 8)

                        Text("\(course.parPerHole.reduce(0, +))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 40)
                            .padding(.vertical, 8)

                        ForEach(players) { player in
                            Text("\(game.totalScore(for: player))")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .padding()
        }
    }
}

struct HorizontalScorecardTable: View {
    let game: Game

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 0) {
                if let course = game.course, let players = game.players {
                    // Header row with holes
                    HStack(spacing: 0) {
                        Text("Player")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 100, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)

                        ForEach(1...course.numberOfHoles, id: \.self) { hole in
                            VStack(spacing: 2) {
                                Text("\(hole)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Text("(\(course.parPerHole[hole - 1]))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 45)
                            .padding(.vertical, 4)
                        }

                        Text("Tot")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 45)
                            .padding(.vertical, 8)
                    }
                    .background(Color(.secondarySystemBackground))

                    // Player rows
                    ForEach(players) { player in
                        HStack(spacing: 0) {
                            HStack(spacing: 4) {
                                if let ballColor = player.ballColor {
                                    Circle()
                                        .fill(ballColor.color)
                                        .frame(width: 12, height: 12)
                                }
                                Text(player.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(width: 100, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)

                            ForEach(1...course.numberOfHoles, id: \.self) { hole in
                                if let score = game.getScore(for: player, hole: hole) {
                                    Text("\(score.strokes)")
                                        .font(.caption)
                                        .fontWeight(score.strokes == course.parPerHole[hole - 1] ? .regular : .semibold)
                                        .frame(width: 45)
                                        .padding(.vertical, 8)
                                        .background(ScoreColorHelper.color(score: score.strokes, par: course.parPerHole[hole - 1]))
                                } else {
                                    Text("-")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 45)
                                        .padding(.vertical, 8)
                                }
                            }

                            Text("\(game.totalScore(for: player))")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(width: 45)
                                .padding(.vertical, 8)
                        }
                        if player.id != players.last?.id {
                            Divider()
                        }
                    }

                    // Par row
                    HStack(spacing: 0) {
                        Text("Par")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 100, alignment: .leading)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)

                        ForEach(1...course.numberOfHoles, id: \.self) { hole in
                            Text("\(course.parPerHole[hole - 1])")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(width: 45)
                                .padding(.vertical, 8)
                        }

                        Text("\(course.parPerHole.reduce(0, +))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 45)
                            .padding(.vertical, 8)
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .padding()
        }
    }
}

#Preview("Vertical") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 9)
    let player1 = Player(name: "Alice", preferredBallColor: .red)
    let player2 = Player(name: "Bob", preferredBallColor: .blue)
    let game = Game(course: course, players: [player1, player2])

    for hole in 1...9 {
        let score1 = Score(holeNumber: hole, strokes: 2 + (hole % 3), game: game, player: player1)
        let score2 = Score(holeNumber: hole, strokes: 3 + (hole % 2), game: game, player: player2)
        container.mainContext.insert(score1)
        container.mainContext.insert(score2)
    }

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return VerticalScorecardTable(game: game)
        .modelContainer(container)
}

#Preview("Horizontal") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 18)
    let player1 = Player(name: "Alice", preferredBallColor: .red)
    let player2 = Player(name: "Bob", preferredBallColor: .blue)
    let game = Game(course: course, players: [player1, player2])

    for hole in 1...18 {
        let score1 = Score(holeNumber: hole, strokes: 2 + (hole % 3), game: game, player: player1)
        let score2 = Score(holeNumber: hole, strokes: 3 + (hole % 2), game: game, player: player2)
        container.mainContext.insert(score1)
        container.mainContext.insert(score2)
    }

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return HorizontalScorecardTable(game: game)
        .modelContainer(container)
}
