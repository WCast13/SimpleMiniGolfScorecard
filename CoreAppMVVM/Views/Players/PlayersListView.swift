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
                    NavigationLink(destination: PlayerStatsView(player: player)) {
                        
//                        VStack(alignment: .leading, spacing: 2) {
//                            Text(player.name)
//                                .font(.headline)
//                            
//                            Text("\(player.games?.count ?? 0) games")
//                                .font(.title3)
//                                .fontWeight(.semibold)
//                                .foregroundStyle(.primary)
//                        }
                        
                        
                        
                        HStack {
                            Text(player.name)
                                .font(.headline)
                                .bold()
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 2) {
                                Text("Games Played")
                                    .font(.caption)
                                Text("\(player.games?.count ?? 0)")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }
                            
                        }
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
