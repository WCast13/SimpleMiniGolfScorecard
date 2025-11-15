import SwiftUI
import SwiftData

struct PlayersListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.name) private var players: [Player]
    @State private var showingAddPlayer = false
    @State private var playerToEdit: Player?

    var body: some View {
        NavigationStack {
            List {
                ForEach(players) { player in
                    HStack {
                        if let ballColor = player.ballColor {
                            Circle()
                                .fill(ballColor.color)
                                .frame(width: 24, height: 24)
                        }
                        VStack(alignment: .leading) {
                            Text(player.name)
                                .font(.headline)
                            if let ballColor = player.ballColor {
                                Text("Ball: \(ballColor.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        playerToEdit = player
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            playerToEdit = player
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete(perform: deletePlayers)
            }
            .navigationTitle("Players")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPlayer = true }) {
                        Label("Add Player", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPlayer) {
                PlayerFormView()
            }
            .sheet(item: $playerToEdit) { player in
                PlayerFormView(player: player)
            }
            .overlay {
                if players.isEmpty {
                    ContentUnavailableView(
                        "No Players",
                        systemImage: "person.fill",
                        description: Text("Add players to track their scores")
                    )
                }
            }
        }
    }

    private func deletePlayers(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(players[index])
        }
    }
}

#Preview {
    PlayersListView()
        .modelContainer(for: Player.self, inMemory: true)
}
