//
//  TeamMatchPlayScorecardTable.swift
//  SimpleMiniGolfScorecard
//
//  Created by William Castellano on 11/18/25.
//

import SwiftUI
import SwiftData

// MARK: - Team Match Play Scorecard Table

struct TeamMatchPlayScorecardTable: View {
    let game: Game

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let course = game.course {
                    let teamAPlayers = game.getTeamPlayers(team: "A")
                    let teamBPlayers = game.getTeamPlayers(team: "B")

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

                        Text("Team A")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)

                        Text("Team B")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)

                        Text("Match")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 70)
                            .padding(.vertical, 8)
                    }
                    .background(Color(.secondarySystemBackground))

                    // Holes with team match status
                    ForEach(1...course.numberOfHoles, id: \.self) { hole in
                        // Check if hole is complete for both teams
                        let isHoleComplete = teamAPlayers.allSatisfy { player in
                            game.getScore(for: player, hole: hole) != nil
                        } && teamBPlayers.allSatisfy { player in
                            game.getScore(for: player, hole: hole) != nil
                        }

                        let holeResults = (1...hole).compactMap { h -> TeamHoleResult? in
                            guard let teamFormat = game.teamFormat else { return nil }

                            // Check if this hole is complete for both teams
                            let holeComplete = teamAPlayers.allSatisfy { player in
                                game.getScore(for: player, hole: h) != nil
                            } && teamBPlayers.allSatisfy { player in
                                game.getScore(for: player, hole: h) != nil
                            }
                            guard holeComplete else { return nil }

                            let teamAScore = GameModeService.calculateTeamScore(players: teamAPlayers, game: game, hole: h, format: teamFormat)
                            let teamBScore = GameModeService.calculateTeamScore(players: teamBPlayers, game: game, hole: h, format: teamFormat)

                            var winningTeam: String?
                            if teamAScore < teamBScore {
                                winningTeam = "A"
                            } else if teamBScore < teamAScore {
                                winningTeam = "B"
                            }

                            return TeamHoleResult(
                                holeNumber: h,
                                winningTeam: winningTeam,
                                teamAScore: teamAScore,
                                teamBScore: teamBScore,
                                teamAPlayers: teamAPlayers,
                                teamBPlayers: teamBPlayers
                            )
                        }

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

                            // Team A Score
                            if let teamFormat = game.teamFormat {
                                let teamAScore = GameModeService.calculateTeamScore(players: teamAPlayers, game: game, hole: hole, format: teamFormat)
                                let teamAText = teamAScore == 999 ? "-" : "\(teamAScore)"

                                Text(teamAText)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                            }

                            // Team B Score
                            if let teamFormat = game.teamFormat {
                                let teamBScore = GameModeService.calculateTeamScore(players: teamBPlayers, game: game, hole: hole, format: teamFormat)
                                let teamBText = teamBScore == 999 ? "-" : "\(teamBScore)"

                                Text(teamBText)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                            }

                            let matchStatusText = isHoleComplete ? getTeamMatchStatusForHole(holeResults: holeResults) : "-"

                            Text(matchStatusText)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                                .frame(width: 70)
                                .padding(.vertical, 8)
                        }
                        if hole < course.numberOfHoles {
                            Divider()
                        }
                    }

                    // Final Status row
                    let allHoleResults = (1...course.numberOfHoles).compactMap { hole -> TeamHoleResult? in
                        guard let teamFormat = game.teamFormat else { return nil }
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

                    HStack(spacing: 0) {
                        Text("Result")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 90)
                            .padding(.vertical, 8)

                        Spacer()

                        Text(GameModeService.getTeamMatchStatus(holeResults: allHoleResults, teamAPlayers: teamAPlayers, teamBPlayers: teamBPlayers))
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

    private func getTeamMatchStatusForHole(holeResults: [TeamHoleResult]) -> String {
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
            return "AS"
        } else if teamAWins > teamBWins {
            return "A \(difference)↑"
        } else {
            return "B \(difference)↑"
        }
    }
}
