import SwiftData
import SwiftUI

struct PreviewHelper {
    /// Creates an in-memory model container for previews
    /// - Returns: A ModelContainer configured for in-memory storage with common models
    static func createPreviewContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }

    /// Creates a sample game with players and scores for preview purposes
    /// - Parameters:
    ///   - container: The model container to insert data into
    ///   - courseName: Name of the course
    ///   - numberOfHoles: Number of holes in the course
    ///   - playerCount: Number of players to create
    /// - Returns: A tuple containing the game and its players
    static func createSampleGame(
        in container: ModelContainer,
        courseName: String = "Test Course",
        numberOfHoles: Int = 18,
        playerCount: Int = 2
    ) -> (game: Game, players: [Player], course: Course) {
        let course = Course(name: courseName, numberOfHoles: numberOfHoles)

        let playerNames = ["Alice", "Bob", "Charlie", "Diana", "Eve"]
        let ballColors: [BallColor?] = [.red, .blue, .green, .yellow, .orange]

        let players = (0..<min(playerCount, playerNames.count)).map { index in
            Player(name: playerNames[index], preferredBallColor: ballColors[index])
        }

        let game = Game(course: course, players: players)

        container.mainContext.insert(course)
        players.forEach { container.mainContext.insert($0) }
        container.mainContext.insert(game)

        return (game, players, course)
    }

    /// Creates random scores for a game
    /// - Parameters:
    ///   - game: The game to add scores to
    ///   - players: The players in the game
    ///   - numberOfHoles: Number of holes to create scores for
    ///   - container: The model container to insert scores into
    static func createRandomScores(
        for game: Game,
        players: [Player],
        numberOfHoles: Int,
        in container: ModelContainer
    ) {
        for hole in 1...numberOfHoles {
            for player in players {
                let score = Score(
                    holeNumber: hole,
                    strokes: Int.random(in: 2...6),
                    game: game,
                    player: player
                )
                container.mainContext.insert(score)
            }
        }
    }
}
