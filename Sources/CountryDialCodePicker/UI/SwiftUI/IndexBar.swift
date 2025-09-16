import SwiftUI

struct IndexBar: View {
    let letters: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(spacing: 2) {
            ForEach(letters, id: \.self) { letter in
                Button(action: { onTap(letter) }) {
                    Text(letter)
                        .font(.caption2)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                }
            }
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .accessibilityHidden(true)
    }
}
