import SwiftUI

struct StampRowView: View {
    let accuracy: Double
    let distance: String
    let time: String

    private var accuracyText: String {
        String(format: "%.0f%%", accuracy)
    }

    var body: some View {
        HStack(spacing: 10) {
            StampPill(icon: "scope", value: accuracyText)
            StampPill(icon: "location", value: distance)
            StampPill(icon: "clock", value: time)
        }
    }
}

private struct StampPill: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(PaperTheme.warmRed)
            Text(value)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(PaperTheme.inkPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            Capsule().fill(.white.opacity(0.5))
        )
        .overlay(
            Capsule().stroke(PaperTheme.inkHairline, lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    StampRowView(accuracy: 96.8, distance: "1.2 km", time: "01:27")
        .padding()
        .background(PaperTheme.background)
}
#endif
