import Testing
import ResultInterface
import ResultTesting
@testable import Cartesia

@MainActor
struct GameSessionTests {

    @Test func roundNumberProgressesAsRoundsAreRecorded() {
        var session = GameSession()
        #expect(session.currentRoundNumber == 1)
        for round in 1...5 {
            session.record(.sample(roundNumber: round))
            #expect(session.currentRoundNumber == round + 1)
        }
    }

    @Test func isCompleteOnlyAfterFiveRounds() {
        var session = GameSession()
        for round in 1...4 {
            session.record(.sample(roundNumber: round))
            #expect(!session.isComplete)
        }
        session.record(.sample(roundNumber: 5))
        #expect(session.isComplete)
    }

    @Test func summaryContainsAllRecordedRounds() {
        var session = GameSession()
        for round in 1...5 {
            session.record(.sample(roundNumber: round))
        }
        #expect(session.summary.rounds.count == 5)
    }
}
