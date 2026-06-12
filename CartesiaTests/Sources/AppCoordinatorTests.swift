import Testing
import ResultInterface
import ResultTesting
@testable import Cartesia

@MainActor
struct AppCoordinatorTests {

    @Test func startingSessionShowsGameAndBumpsRoundID() {
        let coordinator = AppCoordinator()
        let initialRoundID = coordinator.roundID

        coordinator.startNewSession()

        guard case .game = coordinator.currentScreen else {
            Issue.record("Expected game screen")
            return
        }
        #expect(coordinator.roundID == initialRoundID + 1)
    }

    @Test func nextRoundAdvancesToGameWhileSessionIncomplete() {
        let coordinator = AppCoordinator()
        let router = CartesiaResultRouter(coordinator: coordinator)
        coordinator.startNewSession()
        coordinator.completeRound(.sample(roundNumber: 1))

        router.nextRound()

        guard case .game = coordinator.currentScreen else {
            Issue.record("Expected game screen for round 2")
            return
        }
    }

    @Test func nextRoundShowsFinalResultAfterFifthRound() {
        let coordinator = AppCoordinator()
        let router = CartesiaResultRouter(coordinator: coordinator)
        coordinator.startNewSession()
        for round in 1...5 {
            coordinator.completeRound(.sample(roundNumber: round))
        }

        router.nextRound()

        guard case .finalResult(let summary) = coordinator.currentScreen else {
            Issue.record("Expected final result screen")
            return
        }
        #expect(summary.rounds.count == 5)
    }

    @Test func completingRoundShowsRoundResult() {
        let coordinator = AppCoordinator()
        coordinator.startNewSession()

        coordinator.completeRound(.sample(roundNumber: 1))

        guard case .roundResult(let summary) = coordinator.currentScreen else {
            Issue.record("Expected round result screen")
            return
        }
        #expect(summary.roundNumber == 1)
        #expect(coordinator.session.currentRoundNumber == 2)
    }

    @Test func returningToStartResetsSession() {
        let coordinator = AppCoordinator()
        coordinator.startNewSession()
        coordinator.completeRound(.sample(roundNumber: 1))

        coordinator.navigateToStart()

        guard case .start = coordinator.currentScreen else {
            Issue.record("Expected start screen")
            return
        }
        #expect(coordinator.session.currentRoundNumber == 1)
    }

    @Test func playAgainStartsFreshSession() {
        let coordinator = AppCoordinator()
        let router = CartesiaResultRouter(coordinator: coordinator)
        coordinator.startNewSession()
        for round in 1...5 {
            coordinator.completeRound(.sample(roundNumber: round))
        }

        router.playAgain()

        guard case .game = coordinator.currentScreen else {
            Issue.record("Expected game screen")
            return
        }
        #expect(coordinator.session.currentRoundNumber == 1)
    }
}
