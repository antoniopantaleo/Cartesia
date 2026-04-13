import SwiftUI
import ResultInterface

struct ResultView: View {
    let summary: RoundSummary
    private let onPlayAgain: () -> Void
    private let onBackToStart: () -> Void
    @State private var animateSummary = false

    private var score: Int {
        let maxDistance: Double = 20_037_500
        let distanceRatio = min(summary.distance / maxDistance, 1.0)
        let baseScore = max(0, Int(10_000 * (1 - distanceRatio)))
        let timeBonus = max(0, Int(1_000 * max(0, 1 - summary.timeTaken / 180)))
        return baseScore + timeBonus
    }

    private var accuracyPercentage: Double {
        let maxDistance: Double = 20_037_500
        let ratio = max(0, 1 - min(summary.distance / maxDistance, 1.0))
        return ratio * 100
    }

    init(
        summary: RoundSummary,
        onPlayAgain: @escaping () -> Void,
        onBackToStart: @escaping () -> Void
    ) {
        self.summary = summary
        self.onPlayAgain = onPlayAgain
        self.onBackToStart = onBackToStart
    }

    var body: some View {
        ZStack {
            ResultBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    ResultHeaderView(
                        score: score,
                        distance: summary.formattedDistance,
                        time: summary.formattedTime,
                        accuracy: accuracyPercentage,
                        animate: $animateSummary
                    )

                    ResultMapView(summary: summary)

                    ActionButtonsView(
                        onPlayAgain: onPlayAgain,
                        onBackToStart: onBackToStart
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 36)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateSummary = true
            }
        }
    }
}

private struct ResultBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 0.031, green: 0.035, blue: 0.089, alpha: 1)), Color(#colorLiteral(red: 0.1, green: 0.086, blue: 0.2, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.18))
                    .frame(width: 600, height: 600)
                    .offset(x: -160, y: -260)
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 540, height: 540)
                    .offset(x: 200, y: 240)
            }
            .blur(radius: 200)
        )
    }
}
