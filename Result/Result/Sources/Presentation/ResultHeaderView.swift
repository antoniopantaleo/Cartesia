import SwiftUI

struct ScoreHeroView: View {
    let score: Int
    var eyebrow: String = "Postcard from the field"
    var subtitle: String = "out of 11,000 points"

    var body: some View {
        VStack(spacing: 6) {
            Text(eyebrow)
                .eyebrowStyle()

            Text(score.formatted())
                .font(.system(size: 88, weight: .bold, design: .serif))
                .foregroundStyle(PaperTheme.inkPrimary)
                .contentTransition(.numericText(countsDown: false))
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(PaperTheme.inkSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    ScoreHeroView(score: 8_420)
        .padding()
        .background(PaperTheme.background)
}
#endif
