import SwiftUI

struct StartButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text("Start exploring")
                    .font(.headline)
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(PrimaryCTAButtonStyle())
        .sensoryFeedback(.impact(weight: .light), trigger: false)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    StartButton {}
        .padding()
        .background(PaperTheme.background)
}
#endif
