import SwiftUI

struct ScorePickerView: View {
    @Binding var selectedScore: Int
    let onSelect: (Int) -> Void
    let onDismiss: () -> Void

    private let scores = Array(1...6)

    var body: some View {
        VStack(spacing: 24) {
            Text("Select Score")
                .font(.title2)
                .fontWeight(.semibold)

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
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 90, height: 90)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(score == selectedScore ? Color.blue.opacity(0.6) : Color.white.opacity(0.15))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)

            Button {
                onDismiss()
            } label: {
                Text("Cancel")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .padding(30)
        .background(.ultraThinMaterial)
        .presentationBackground(.clear)
    }
}

#Preview {
    ScorePickerView(
        selectedScore: .constant(2),
        onSelect: { _ in },
        onDismiss: { }
    )
}
