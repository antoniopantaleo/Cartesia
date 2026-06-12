import SwiftUI
import ResultInterface

struct ResultView: View {
    let summary: RoundSummary
    private let onContinue: () -> Void
    private let onBackToStart: () -> Void
    @State private var animateScore = false

    private var distanceCaption: String {
        "You were \(summary.formattedDistance) off."
    }

    init(
        summary: RoundSummary,
        onContinue: @escaping () -> Void,
        onBackToStart: @escaping () -> Void
    ) {
        self.summary = summary
        self.onContinue = onContinue
        self.onBackToStart = onBackToStart
    }

    var body: some View {
        ZStack {
            PaperBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    TopBar(
                        title: "Round \(summary.roundNumber) of \(summary.totalRounds)",
                        onClose: onBackToStart
                    )

                    ScoreHeroView(score: animateScore ? summary.score : 0)

                    StampRowView(
                        accuracy: Scoring.accuracy(distance: summary.distance),
                        distance: summary.formattedDistance,
                        time: summary.formattedTime
                    )

                    ResultMapView(summary: summary, distanceCaption: distanceCaption)

                    ActionButtonsView(
                        primaryTitle: summary.isFinalRound ? "See final score" : "Next round",
                        primaryIcon: summary.isFinalRound ? "flag.checkered" : "arrow.right",
                        onPrimary: onContinue,
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

struct TopBar: View {
    var title: String = "Round Complete"
    let onClose: () -> Void

    var body: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(PaperTheme.inkPrimary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle().fill(PaperTheme.background)
                    )
                    .overlay(
                        Circle().stroke(PaperTheme.inkHairline, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            Text(title)
                .eyebrowStyle()

            Spacer()

            Color.clear.frame(width: 36, height: 36)
        }
    }
}

struct PaperBackground: View {
    var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()
            GeometryReader { proxy in
                Circle()
                    .fill(PaperTheme.warmOrange.opacity(0.08))
                    .frame(width: proxy.size.width * 0.9)
                    .offset(x: proxy.size.width * 0.3, y: -proxy.size.height * 0.2)
                    .blur(radius: 80)
            }
            .ignoresSafeArea()
        }
    }
}
