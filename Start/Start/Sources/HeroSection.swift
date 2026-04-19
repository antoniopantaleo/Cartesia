import SwiftUI
import StartInterface

struct HeroSection: View {
    let alias: String
    let regions: [SamplePin]
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack(spacing: 8) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(PaperTheme.warmRed)
                    .symbolEffect(.bounce, options: .nonRepeating, value: appeared)
                Text("Field Journal · Vol. I")
                    .eyebrowStyle()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Hello,")
                    .font(.title2.weight(.regular))
                    .foregroundStyle(PaperTheme.inkSecondary)
                Text("\(alias).")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(PaperTheme.inkPrimary)
                    .contentTransition(.opacity)
            }

            HeroMapPreview(regions: regions)
                .aspectRatio(4.0/5.0, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    JournalStamp(text: "Where to today?")
                        .padding(14)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { appeared = true }
    }
}

private struct JournalStamp: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .tracking(1.2)
            .textCase(.uppercase)
            .foregroundStyle(PaperTheme.warmRed)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(PaperTheme.background.opacity(0.92))
            )
            .overlay(
                Capsule()
                    .stroke(PaperTheme.warmRed.opacity(0.5), lineWidth: 1)
            )
            .rotationEffect(.degrees(-4))
    }
}

#if DEBUG
import StartTesting
#Preview(traits: .sizeThatFitsLayout) {
    HeroSection(alias: "Antonio", regions: SamplePin.examples)
        .padding()
        .background(PaperTheme.background)
}
#endif
