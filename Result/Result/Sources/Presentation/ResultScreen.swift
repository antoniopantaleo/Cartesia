import SwiftUI
import ResultInterface

public struct ResultScreen: View {
    private let summary: RoundSummary
    private let router: ResultRouter

    public init(summary: RoundSummary, router: ResultRouter) {
        self.summary = summary
        self.router = router
    }

    public var body: some View {
        ResultView(
            summary: summary,
            onPlayAgain: router.playAgain,
            onBackToStart: router.backToStart
        )
        .colorScheme(.dark)
    }
}
