import SwiftUI

struct ActionButtonsView: View {
    var primaryTitle: String = "Play another round"
    var primaryIcon: String = "arrow.clockwise"
    let onPrimary: () -> Void
    let onBackToStart: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onPrimary) {
                HStack(spacing: 10) {
                    Image(systemName: primaryIcon)
                        .font(.subheadline.weight(.bold))
                    Text(primaryTitle)
                        .font(.headline)
                }
                .foregroundStyle(.white)
            }
            .buttonStyle(PrimaryActionButtonStyle())

            Button(action: onBackToStart) {
                HStack(spacing: 6) {
                    Image(systemName: "house")
                        .font(.subheadline)
                    Text("Return to home")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(PaperTheme.inkSecondary)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(PaperTheme.ctaGradient)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: PaperTheme.warmRed.opacity(0.30), radius: 16, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    ActionButtonsView(onPrimary: {}, onBackToStart: {})
        .padding()
        .background(PaperTheme.background)
}
#endif
