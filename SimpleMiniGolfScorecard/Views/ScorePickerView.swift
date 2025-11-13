import SwiftUI

struct ScorePickerView: View {
    @Binding var selectedScore: Int
    let onSelect: (Int) -> Void
    let onDismiss: () -> Void

    private let scores = Array(1...6)

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            // Score picker with glass effect
            VStack(spacing: 20) {
                Text("Select Score")
                    .font(.headline)
                    .foregroundStyle(.white)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(scores, id: \.self) { score in
                        Button {
                            selectedScore = score
                            onSelect(score)
                            onDismiss()
                        } label: {
                            Text("\(score)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 80, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(score == selectedScore ? Color.blue.opacity(0.5) : Color.white.opacity(0.2))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }

                Button("Cancel") {
                    onDismiss()
                }
                .foregroundStyle(.white)
                .padding()
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
        .transition(.opacity)
    }
}

#Preview {
    ScorePickerView(
        selectedScore: .constant(2),
        onSelect: { _ in },
        onDismiss: { }
    )
}
