//
//  MatchPlayScorecardTableView.swift
//  SimpleMiniGolfScorecard
//
//  Created by William Castellano on 11/18/25.
//

import SwiftUI
import SwiftData

// MARK: - Match Play Scorecard Table

struct MatchPlayScorecardTableView: View {
    let game: Game

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let course = game.course, let players = game.players, players.count == 2 {
                    let player1 = players[0]
                    let player2 = players[1]

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

                        Text(player1.initials.isEmpty ? player1.name : player1.initials)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)

                        Text("AS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 60)
                            .padding(.vertical, 8)

                        Text(player2.initials.isEmpty ? player2.name : player2.initials)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .background(Color(.secondarySystemBackground))

                    // Holes with match play status
                    ForEach(1...course.numberOfHoles, id: \.self) { hole in
                        // Check if this hole is complete (both players have scores)
                        let isHoleComplete = game.getScore(for: player1, hole: hole) != nil &&
                                           game.getScore(for: player2, hole: hole) != nil

                        let holeResults = calculateHoleResultsUpTo(hole: hole, player1: player1, player2: player2)
                        let matchStatus = getMatchStatusForHole(holeResults: holeResults)

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

                            // Player 1 status - only show if hole is complete
                            Group {
                                if isHoleComplete && matchStatus.leadingPlayer == player1.id && matchStatus.difference > 0 {
                                    Text("\(matchStatus.difference) UP")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                } else {
                                    Text("")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)

                            // AS Box (centered column) - only show if hole is complete
                            Group {
                                if isHoleComplete && matchStatus.isAllSquare {
                                    Text("AS")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                } else {
                                    Text("")
                                }
                            }
                            .frame(width: 60)
                            .padding(.vertical, 8)

                            // Player 2 status - only show if hole is complete
                            Group {
                                if isHoleComplete && matchStatus.leadingPlayer == player2.id && matchStatus.difference > 0 {
                                    Text("\(matchStatus.difference) UP")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                } else {
                                    Text("")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }

                        if hole < course.numberOfHoles {
                            Divider()
                        }
                    }

                    // Final Status row
                    let allHoleResults = calculateHoleResultsUpTo(hole: course.numberOfHoles, player1: player1, player2: player2)
                    let finalStatus = GameModeService.getMatchStatus(game: game, holeResults: allHoleResults)

                    HStack(spacing: 0) {
                        Text("Result")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 90)
                            .padding(.vertical, 8)

                        Spacer()

                        Text(finalStatus)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                            .padding(.vertical, 8)
                            .padding(.trailing, 8)
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .padding()
        }
    }

    // MARK: - Helper Methods

    private func calculateHoleResultsUpTo(hole: Int, player1: Player, player2: Player) -> [HoleResult] {
        guard let players = game.players else { return [] }

        return (1...hole).compactMap { h -> HoleResult? in
            let winner = GameModeService.getHoleWinner(game: game, hole: h, players: players)

            // Only include holes where both players have scores
            guard let score1 = game.getScore(for: player1, hole: h),
                  let score2 = game.getScore(for: player2, hole: h) else {
                return nil
            }

            var scores: [Player: Int] = [:]
            scores[player1] = score1.strokes
            scores[player2] = score2.strokes

            return HoleResult(holeNumber: h, winner: winner, scores: scores)
        }
    }

    private func getMatchStatusForHole(holeResults: [HoleResult]) -> MatchStatus {
        guard let players = game.players, players.count == 2 else {
            return MatchStatus(isAllSquare: true, leadingPlayer: nil, difference: 0)
        }

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

        let difference = abs(player1Wins - player2Wins)

        if player1Wins == player2Wins {
            return MatchStatus(isAllSquare: true, leadingPlayer: nil, difference: 0)
        } else if player1Wins > player2Wins {
            return MatchStatus(isAllSquare: false, leadingPlayer: player1.id, difference: difference)
        } else {
            return MatchStatus(isAllSquare: false, leadingPlayer: player2.id, difference: difference)
        }
    }
}

// MARK: - Supporting Types

struct MatchStatus {
    let isAllSquare: Bool
    let leadingPlayer: UUID?
    let difference: Int
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, Score.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 9)
    course.parPerHole = [3, 2, 2, 2, 2, 3, 2, 2, 3]

    let player1 = Player(name: "Alice", preferredBallColor: .red)
    let player2 = Player(name: "Bob", preferredBallColor: .blue)
    let game = Game(course: course, players: [player1, player2], gameMode: .matchPlay)

    // Create scores matching the example layout
    // Hole 1: Player 1 wins (1 UP)


    // Hole 2: Tie (AS)
    let score2_1 = Score(holeNumber: 2, strokes: 2, game: game, player: player1)
    let score2_2 = Score(holeNumber: 2, strokes: 2, game: game, player: player2)

    container.mainContext.insert(score2_1)
    container.mainContext.insert(score2_2)

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return MatchPlayScorecardTableView(game: game)
        .modelContainer(container)
}
