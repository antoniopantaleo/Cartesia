import Testing
import ResultInterface

struct ScoringTests {

    @Test func perfectGuessWithFullTimeBonusScoresMaximum() {
        #expect(Scoring.score(distance: 0, timeTaken: 0) == 11_000)
    }

    @Test func perfectGuessAfterThreeMinutesGetsNoTimeBonus() {
        #expect(Scoring.score(distance: 0, timeTaken: 180) == 10_000)
    }

    @Test func maximumDistanceScoresOnlyTimeBonus() {
        #expect(Scoring.score(distance: Scoring.maxDistanceMeters, timeTaken: 180) == 0)
    }

    @Test func distanceBeyondMaximumIsClamped() {
        #expect(Scoring.score(distance: Scoring.maxDistanceMeters * 2, timeTaken: 200) == 0)
    }

    @Test func scoreIsNeverNegative() {
        #expect(Scoring.score(distance: Scoring.maxDistanceMeters * 10, timeTaken: 10_000) >= 0)
    }

    @Test func closerGuessScoresHigher() {
        let close = Scoring.score(distance: 1_000, timeTaken: 60)
        let far = Scoring.score(distance: 1_000_000, timeTaken: 60)
        #expect(close > far)
    }

    @Test func accuracyIsFullForPerfectGuess() {
        #expect(Scoring.accuracy(distance: 0) == 100)
    }

    @Test func accuracyIsZeroAtMaximumDistance() {
        #expect(Scoring.accuracy(distance: Scoring.maxDistanceMeters) == 0)
    }

    @Test func accuracyStaysWithinBounds() {
        let accuracy = Scoring.accuracy(distance: Scoring.maxDistanceMeters * 3)
        #expect(accuracy >= 0 && accuracy <= 100)
    }
}
