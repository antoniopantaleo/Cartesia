import SwiftUI
import ResultInterface

public struct FinalResultScreen: View {
    private let summary: GameSummary
    private let router: ResultRouter

    public init(summary: GameSummary, router: ResultRouter) {
        self.summary = summary
        self.router = router
    }

    public var body: some View {
        FinalResultView(
            summary: summary,
            onPlayAgain: router.playAgain,
            onBackToStart: router.backToStart
        )
        .colorScheme(.dark)
    }
}
