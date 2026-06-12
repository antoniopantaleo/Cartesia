import SwiftUI

public struct HowToPlayView: View {

    public init() {}

    public var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Field guide")
                        .eyebrowStyle()
                    Text("How to play")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(PaperTheme.inkPrimary)
                }
                .padding(.top, 28)

                VStack(alignment: .leading, spacing: 22) {
                    HowToPlayStep(
                        icon: "binoculars.fill",
                        title: "Look around",
                        text: "You've been dropped somewhere in the world. Explore the streets for clues."
                    )
                    HowToPlayStep(
                        icon: "mappin.and.ellipse",
                        title: "Drop a pin",
                        text: "Swipe up the map and tap where you think you are, then confirm your guess."
                    )
                    HowToPlayStep(
                        icon: "star.fill",
                        title: "Score points",
                        text: "Earn up to 11,000 points per round. The closer and faster, the better."
                    )
                    HowToPlayStep(
                        icon: "flag.checkered",
                        title: "Five rounds",
                        text: "A game is five places. Add them up and beat your best total."
                    )
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .environment(\.colorScheme, .light)
    }
}

private struct HowToPlayStep: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(PaperTheme.warmRed)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(PaperTheme.warmRed.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(PaperTheme.inkPrimary)
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(PaperTheme.inkSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#if DEBUG
#Preview {
    HowToPlayView()
}
#endif
