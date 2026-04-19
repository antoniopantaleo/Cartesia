import Testing
import ResultInterface
import ResultTesting

struct GameSummaryTests {

    @Test func totalScoreIsSumOfRoundScores() {
        let rounds = [
            RoundSummary.sample(roundNumber: 1, distance: 0),
            RoundSummary.sample(roundNumber: 2, distance: 500_000),
            RoundSummary.sample(roundNumber: 3, distance: Scoring.maxDistanceMeters)
        ]
        let summary = GameSummary(rounds: rounds)
        #expect(summary.totalScore == rounds.reduce(0) { $0 + $1.score })
    }

    @Test func maxPossibleScoreIsElevenThousandPerRound() {
        #expect(GameSummary.sample.maxPossibleScore == 55_000)
    }

    @Test func finalRoundIsDetectedFromRoundNumber() {
        #expect(!RoundSummary.sample(roundNumber: 4).isFinalRound)
        #expect(RoundSummary.sample(roundNumber: 5).isFinalRound)
    }
}
