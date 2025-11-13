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
                    
                    Button("\(score)") {
                        onSelect(score)
                        onDismiss()
                    }
                    .font(Font.system(size: 36, weight: .bold))
                    .frame(width: 90, height: 90)
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(score == selectedScore ? Color.green.opacity(0.6) : Color.black.opacity(0.15))
                    )   
                }
            }
            .padding(.vertical)

            Button("Cancel") {
                onDismiss()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.75))
            .cornerRadius(12)
        }
        .padding(30)
        .glassEffect()
    }
}

#Preview {
    ScorePickerView(
        selectedScore: .constant(2),
        onSelect: { _ in },
        onDismiss: { }
    )
}
