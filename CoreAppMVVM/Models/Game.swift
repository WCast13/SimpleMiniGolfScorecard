import Foundation
import SwiftData

@Model
final class Game {
    var id: UUID = UUID()
    var date: Date = Date()
    var isComplete: Bool = false
    var gameModeRaw: String = GameMode.strokePlay.rawValue
    var teamFormatRaw: String?
    var teamAssignmentsData: Data?

    var course: Course?
    var players: [Player]?

    @Relationship(deleteRule: .cascade, inverse: \Score.game)
    var scores: [Score]?

    init(course: Course, players: [Player], gameMode: GameMode = .strokePlay, teamFormat: TeamFormat? = nil, teamAssignments: [UUID: String]? = nil) {
        self.id = UUID()
        self.date = Date()
        self.isComplete = false
        self.course = course
        self.players = players
        self.scores = []
        self.gameModeRaw = gameMode.rawValue
        self.teamFormatRaw = teamFormat?.rawValue

        if let teamAssignments = teamAssignments {
            self.teamAssignmentsData = try? JSONEncoder().encode(teamAssignments)
        }
    }

    var gameMode: GameMode {
        get { GameMode(rawValue: gameModeRaw) ?? .strokePlay }
        set { gameModeRaw = newValue.rawValue }
    }

    var teamFormat: TeamFormat? {
        get {
            guard let raw = teamFormatRaw else { return nil }
            return TeamFormat(rawValue: raw)
        }
        set { teamFormatRaw = newValue?.rawValue }
    }

    var teamAssignments: [UUID: String]? {
        get {
            guard let data = teamAssignmentsData else { return nil }
            return try? JSONDecoder().decode([UUID: String].self, from: data)
        }
        set {
            teamAssignmentsData = try? JSONEncoder().encode(newValue)
        }
    }

    func getScore(for player: Player, hole: Int) -> Score? {
        return scores?.first { $0.player?.id == player.id && $0.holeNumber == hole }
    }

    func totalScore(for player: Player) -> Int {
        return scores?.filter { $0.player?.id == player.id }.reduce(0) { $0 + $1.strokes } ?? 0
    }

    func getTeamPlayers(team: String) -> [Player] {
        guard let players = players, let assignments = teamAssignments else { return [] }
        return players.filter { assignments[$0.id] == team }
    }
}
