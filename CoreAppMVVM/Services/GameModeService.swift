import Foundation
import SwiftData

// MARK: - Result Structures

struct HoleResult {
    let holeNumber: Int
    let winner: Player?  // nil for tie
    let scores: [Player: Int]
}

struct MatchPlayResult {
    let holeResults: [HoleResult]
    let finalStatus: String
    let winner: Player?  // nil for tie
}

struct TeamHoleResult {
    let holeNumber: Int
    let winningTeam: String?  // "A", "B", or nil for tie
    let teamAScore: Int
    let teamBScore: Int
    let teamAPlayers: [Player]
    let teamBPlayers: [Player]
}

struct TeamMatchPlayResult {
    let holeResults: [TeamHoleResult]
    let finalStatus: String
    let winningTeam: String?  // "A", "B", or nil for tie
    let teamAPlayers: [Player]
    let teamBPlayers: [Player]
}

// MARK: - Game Mode Service

class GameModeService {

    // MARK: - Match Play Methods

    /// Calculate match play results for a game
    static func calculateMatchPlayResults(game: Game) -> MatchPlayResult {
        guard let players = game.players, let course = game.course else {
            return MatchPlayResult(holeResults: [], finalStatus: "No players", winner: nil)
        }

        var holeResults: [HoleResult] = []
        var finalStatus: String = ""
        
        // Calculate result for each hole
        for hole in 1...course.numberOfHoles {
            let holeWinner = getHoleWinner(game: game, hole: hole, players: players)
            var scores: [Player: Int] = [:]

            for player in players {
                if let score = game.getScore(for: player, hole: hole) {
                    scores[player] = score.strokes
                }
            }

            holeResults.append(HoleResult(holeNumber: hole, winner: holeWinner, scores: scores))
        }

        // Calculate match status
        let status = getMatchStatus(game: game, holeResults: holeResults)
        if status.contains("Win") { finalStatus = status }

        // Determine overall winner (most holes won)
        var holeWins: [Player: Int] = [:]
        for result in holeResults {
            if let winner = result.winner {
                holeWins[winner, default: 0] += 1
            }
        }

        let winner = holeWins.max(by: { $0.value < $1.value })?.key

        return MatchPlayResult(holeResults: holeResults, finalStatus: finalStatus, winner: winner)
    }

    /// Determine the winner of a specific hole
    static func getHoleWinner(game: Game, hole: Int, players: [Player]) -> Player? {
        var scores: [(Player, Int)] = []

        for player in players {
            if let score = game.getScore(for: player, hole: hole) {
                scores.append((player, score.strokes))
            }
        }

        guard !scores.isEmpty else { return nil }

        let minScore = scores.map { $0.1 }.min() ?? 0
        let winners = scores.filter { $0.1 == minScore }

        // If tie, return nil
        return winners.count == 1 ? winners[0].0 : nil
    }

    /// Get current match status string
    static func getMatchStatus(game: Game, holeResults: [HoleResult]) -> String {
        guard let players = game.players, players.count == 2 else {
            return getMultiPlayerMatchStatus(holeResults: holeResults)
        }

        var finalResult = ""
        // Two-player match play status
        let player1 = players[0]
        let player2 = players[1]

        var player1Wins = 0
        var player2Wins = 0

        for result in holeResults {
            if result.winner?.id == player1.id {
                player1Wins += 1
            } else if result.winner?.id == player2.id {
                player2Wins += 1
            }
        }

        let holesRemaining = (game.course?.numberOfHoles ?? 18) - holeResults.count
        let difference = abs(player1Wins - player2Wins)

        if player1Wins == player2Wins {
            return "All Square"
        } else if player1Wins > player2Wins {
            if difference > holesRemaining {
                finalResult = "\(player1.name) wins \(difference)&\(holesRemaining)"
                return finalResult
            } else {
                return "\(player1.name) is \(difference) up"
            }
        } else {
            if difference > holesRemaining {
                finalResult = "\(player2.name) wins \(difference)&\(holesRemaining)"
                return finalResult
            } else {
                return "\(player2.name) is \(difference) up"
            }
        }
    }

    /// Get match status for 3+ players
    private static func getMultiPlayerMatchStatus(holeResults: [HoleResult]) -> String {
        var holeWins: [Player: Int] = [:]

        for result in holeResults {
            if let winner = result.winner {
                holeWins[winner, default: 0] += 1
            }
        }

        if let leader = holeWins.max(by: { $0.value < $1.value }) {
            return "\(leader.key.name) leads with \(leader.value) holes won"
        }

        return "Match in Progress"
    }

    // MARK: - Team Match Play Methods

    /// Calculate team match play results
    static func calculateTeamMatchPlayResults(game: Game) -> TeamMatchPlayResult {
        guard let course = game.course,
              let teamFormat = game.teamFormat else {
            return TeamMatchPlayResult(
                holeResults: [],
                finalStatus: "Invalid team setup",
                winningTeam: nil,
                teamAPlayers: [],
                teamBPlayers: []
            )
        }

        let teamAPlayers = game.getTeamPlayers(team: "A")
        let teamBPlayers = game.getTeamPlayers(team: "B")

        var holeResults: [TeamHoleResult] = []

        // Calculate result for each hole
        for hole in 1...course.numberOfHoles {
            let teamAScore = calculateTeamScore(players: teamAPlayers, game: game, hole: hole, format: teamFormat)
            let teamBScore = calculateTeamScore(players: teamBPlayers, game: game, hole: hole, format: teamFormat)

            var winningTeam: String?
            if teamAScore < teamBScore {
                winningTeam = "A"
            } else if teamBScore < teamAScore {
                winningTeam = "B"
            }

            holeResults.append(TeamHoleResult(
                holeNumber: hole,
                winningTeam: winningTeam,
                teamAScore: teamAScore,
                teamBScore: teamBScore,
                teamAPlayers: teamAPlayers,
                teamBPlayers: teamBPlayers
            ))
        }

        // Calculate final status
        let status = getTeamMatchStatus(holeResults: holeResults, teamAPlayers: teamAPlayers, teamBPlayers: teamBPlayers)

        // Determine winning team
        var teamAWins = 0
        var teamBWins = 0

        for result in holeResults {
            if result.winningTeam == "A" {
                teamAWins += 1
            } else if result.winningTeam == "B" {
                teamBWins += 1
            }
        }

        var winningTeam: String?
        if teamAWins > teamBWins {
            winningTeam = "A"
        } else if teamBWins > teamAWins {
            winningTeam = "B"
        }

        return TeamMatchPlayResult(
            holeResults: holeResults,
            finalStatus: status,
            winningTeam: winningTeam,
            teamAPlayers: teamAPlayers,
            teamBPlayers: teamBPlayers
        )
    }

    /// Calculate team score for a specific hole based on format
    static func calculateTeamScore(players: [Player], game: Game, hole: Int, format: TeamFormat) -> Int {
        var scores: [Int] = []

        for player in players {
            if let score = game.getScore(for: player, hole: hole) {
                scores.append(score.strokes)
            }
        }

        guard !scores.isEmpty else { return 999 }  // High penalty if no scores

        switch format {
        case .bestBall:
            return scores.min() ?? 999
        case .combinedScores:
            return scores.reduce(0, +)
        }
    }

    /// Get team match status string
    static func getTeamMatchStatus(holeResults: [TeamHoleResult], teamAPlayers: [Player], teamBPlayers: [Player]) -> String {
        var teamAWins = 0
        var teamBWins = 0

        for result in holeResults {
            if result.winningTeam == "A" {
                teamAWins += 1
            } else if result.winningTeam == "B" {
                teamBWins += 1
            }
        }

        let difference = abs(teamAWins - teamBWins)

        if teamAWins == teamBWins {
            return "All Square"
        } else if teamAWins > teamBWins {
            return "Team A is \(difference) up"
        } else {
            return "Team B is \(difference) up"
        }
    }
}
