import SwiftUI
import SwiftData

struct PlayerFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PlayerFormViewModel?

    let player: Player?

    init(player: Player? = nil) {
        self.player = player
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Player Details") {
                    TextField("Player Name", text: Binding(
                        get: { viewModel?.name ?? "" },
                        set: { viewModel?.name = $0 }
                    ))
                }

                Section("Preferred Ball Color") {
                    Picker("Ball Color", selection: Binding(
                        get: { viewModel?.selectedBallColor },
                        set: { viewModel?.selectedBallColor = $0 }
                    )) {
                        Text("None").tag(nil as BallColor?)
                        ForEach(BallColor.allCases, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 20, height: 20)
                                Text(color.rawValue)
                            }
                            .tag(color as BallColor?)
                        }
                    }
                }
            }
            .navigationTitle(viewModel?.title ?? "Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel?.save()
                        dismiss()
                    }
                    .disabled(!(viewModel?.isValid ?? false))
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = PlayerFormViewModel(player: player, modelContext: modelContext)
                }
            }
        }
    }
}

#Preview {
    PlayerFormView()
        .modelContainer(for: Player.self, inMemory: true)
}
