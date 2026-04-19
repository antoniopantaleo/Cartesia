import SwiftUI
import ResultInterface

struct FinalResultView: View {
    let summary: GameSummary
    private let onPlayAgain: () -> Void
    private let onBackToStart: () -> Void
    @State private var animateScore = false

    init(
        summary: GameSummary,
        onPlayAgain: @escaping () -> Void,
        onBackToStart: @escaping () -> Void
    ) {
        self.summary = summary
        self.onPlayAgain = onPlayAgain
        self.onBackToStart = onBackToStart
    }

    var body: some View {
        ZStack {
            PaperBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    TopBar(title: "Game Complete", onClose: onBackToStart)

                    ScoreHeroView(
                        score: animateScore ? summary.totalScore : 0,
                        eyebrow: "Journey's end",
                        subtitle: "out of \(summary.maxPossibleScore.formatted()) points"
                    )

                    RoundRecapList(rounds: summary.rounds)

                    ActionButtonsView(
                        primaryTitle: "Play again",
                        primaryIcon: "arrow.clockwise",
                        onPrimary: onPlayAgain,
                        onBackToStart: onBackToStart
                    )

                    Color.clear.frame(height: 12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .environment(\.colorScheme, .light)
        .sensoryFeedback(.success, trigger: animateScore)
        .onAppear {
            withAnimation(.smooth(duration: 1.2)) {
                animateScore = true
            }
        }
    }
}

private struct RoundRecapList: View {
    let rounds: [RoundSummary]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rounds.enumerated()), id: \.offset) { index, round in
                RoundRecapRow(round: round)
                if index < rounds.count - 1 {
                    Rectangle()
                        .fill(PaperTheme.inkHairline)
                        .frame(height: 1)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(PaperTheme.inkHairline, lineWidth: 1)
        )
    }
}

private struct RoundRecapRow: View {
    let round: RoundSummary

    var body: some View {
        HStack(spacing: 12) {
            Text("\(round.roundNumber)")
                .font(.footnote.weight(.bold))
                .foregroundStyle(PaperTheme.warmRed)
                .frame(width: 24, height: 24)
                .background(
                    Circle().fill(PaperTheme.warmRed.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(round.formattedDistance)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(PaperTheme.inkPrimary)
                Text(round.formattedTime)
                    .font(.caption)
                    .foregroundStyle(PaperTheme.inkSecondary)
            }

            Spacer()

            Text(round.score.formatted())
                .font(.callout.weight(.bold))
                .foregroundStyle(PaperTheme.inkPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#if DEBUG
import ResultTesting

#Preview {
    FinalResultView(
        summary: .sample,
        onPlayAgain: {},
        onBackToStart: {}
    )
}
#endif
