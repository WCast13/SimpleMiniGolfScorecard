//
//  DetailedScorecard.swift
//  SimpleMiniGolfScorecard
//
//  Created by William Castellano on 11/13/25.
//

import SwiftUI

struct DetailedScorecard: View {
    let game: Game
    let course: Course
    let players: [Player]

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            HStack(alignment: .top, spacing: 0) {
                VStack(spacing: 0) {
                    Text("Hole")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 60)
                        .padding(.vertical, 8)

                    ForEach(1...course.numberOfHoles, id: \.self) { hole in
                        HStack(spacing: 4) {
                            Text("\(hole)")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("(\(course.parPerHole[hole - 1]))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 50)
                        .padding(.vertical, 8)
                    }

                    Text("Total")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 60)
                        .padding(.vertical, 8)
                }
                .background(Color(.secondarySystemBackground))

                ForEach(players) { player in
                    VStack(spacing: 0) {
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
