import SwiftUI
import SwiftData

struct GamesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Game.date, order: .reverse) private var games: [Game]
    @State private var showingNewGame = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink {
                        if game.isComplete {
                            GameResultsView(game: game)
                        } else {
                            ScorecardView(game: game)
                        }
                    } label: {
                        GameListRow(game: game)
                    }
                }
                .onDelete(perform: deleteGames)
            }
            .navigationTitle("Games")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewGame = true }) {
                        Label("New Game", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewGame) {
                NewGameView()
            }
            .overlay {
                if games.isEmpty {
                    ContentUnavailableView(
                        "No Games",
                        systemImage: "sportscourt.fill",
                        description: Text("Start a new game to begin tracking scores")
                    )
                }
            }
        }
    }

    private func deleteGames(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(games[index])
        }
    }
}

struct GameListRow: View {
    let game: Game

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.course?.name ?? "Unknown Course")
                .font(.headline)

            HStack {
                if let players = game.players, !players.isEmpty {
                    Text(players.map { $0.name }.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if game.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
            }

            Text(dateFormatter.string(from: game.date))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, Course.self, Player.self, configurations: config)

    let course = Course(name: "Test Course", numberOfHoles: 18)
    let player1 = Player(name: "Player 1")
    let player2 = Player(name: "Player 2")
    let game = Game(course: course, players: [player1, player2])

    container.mainContext.insert(course)
    container.mainContext.insert(player1)
    container.mainContext.insert(player2)
    container.mainContext.insert(game)

    return GamesListView()
        .modelContainer(container)
}
