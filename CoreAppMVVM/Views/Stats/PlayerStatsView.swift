import SwiftUI
import SwiftData

struct PlayerStatsView: View {
    @Environment(\.modelContext) private var modelContext
    let player: Player

    @State private var stats: PlayerStats?

    var body: some View {
        List {
            if let stats = stats {
                // Overall stats section
                Section("Overall Statistics") {
                    HStack {
                        Text("Total Games Played")
                        Spacer()
                        Text("\(stats.totalGamesPlayed)")
                            .fontWeight(.semibold)
                    }

                    if stats.totalGamesPlayed > 0 {
                        HStack {
                            Text("Overall Average Score")
                            Spacer()
                            Text(String(format: "%.1f", stats.overallAverageScore))
                                .fontWeight(.semibold)
                        }
                    }
                }

                // Stats by course
                if !stats.courseStats.isEmpty {
                    ForEach(stats.courseStats, id: \.course.id) { courseStats in
                        Section {
                            CourseStatsSection(courseStats: courseStats)
                        } header: {
                            Text(courseStats.course.name)
                        }
                    }
                } else {
                    Section {
                        ContentUnavailableView(
                            "No Stats Yet",
                            systemImage: "chart.bar",
                            description: Text("Play some games to see statistics")
                        )
                    }
                }
            } else {
                Section {
                    ProgressView("Loading statistics...")
                }
            }
        }
        .navigationTitle("\(player.name) Stats")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadStats()
        }
    }

    private func loadStats() {
        stats = StatsService.calculatePlayerStats(player: player, modelContext: modelContext)
    }
}

struct CourseStatsSection: View {
    let courseStats: CourseStats

    @State private var showHoleBreakdown = false

    var body: some View {
        VStack(spacing: 12) {
            // Summary stats
            HStack {
                Text("Games Played")
                Spacer()
                Text("\(courseStats.gamesPlayed)")
                    .fontWeight(.semibold)
            }

            HStack {
                Text("Average Score")
                Spacer()
                Text(String(format: "%.1f", courseStats.averageScore))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }

            HStack {
                Text("Best Score")
                Spacer()
                Text("\(courseStats.bestScore)")
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }

            HStack {
                Text("Worst Score")
                Spacer()
                Text("\(courseStats.worstScore)")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }

            // Hole breakdown toggle
            Button(action: {
                withAnimation {
                    showHoleBreakdown.toggle()
                }
            }) {
                HStack {
                    Text("Hole-by-Hole Average")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: showHoleBreakdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if showHoleBreakdown {
                HoleBreakdownView(holeAverages: courseStats.holeAverages, numberOfHoles: courseStats.course.numberOfHoles)
            }
        }
    }
}

struct HoleBreakdownView: View {
    let holeAverages: [Int: Double]
    let numberOfHoles: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(1...numberOfHoles, id: \.self) { hole in
                HStack {
                    Text("Hole \(hole)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    if let average = holeAverages[hole] {
                        Text(String(format: "%.2f", average))
                            .font(.caption)
                            .fontWeight(.medium)
                    } else {
                        Text("--")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        PlayerStatsView(player: Player(name: "Test Player"))
            .modelContainer(for: [Player.self, Game.self, Course.self, Score.self], inMemory: true)
    }
}
