import Foundation
import Game
import GameInterface
import ResultInterface
import StartInterface

@Observable
final class AppCoordinator {
    enum Screen {
        case start
        case game
        case roundResult(RoundSummary)
        case finalResult(GameSummary)
    }

    private(set) var currentScreen: Screen = .start
    private(set) var session = GameSession()
    /// One shuffled location deck per game session, so the 5 rounds never repeat a place.
    private(set) var sessionLocationService: LocationServiceProtocol = LocationService()
    /// Forces GameScreen recreation between rounds via `.id()`.
    private(set) var roundID: Int = 0
    var isHowToPlayPresented = false

    func startNewSession() {
        session = GameSession()
        sessionLocationService = LocationService()
        roundID += 1
        currentScreen = .game
    }

    func advanceToNextRound() {
        roundID += 1
        currentScreen = .game
    }

    func completeRound(_ summary: RoundSummary) {
        session.record(summary)
        currentScreen = .roundResult(summary)
    }

    func showFinalResult() {
        currentScreen = .finalResult(session.summary)
    }

    func navigateToStart() {
        session = GameSession()
        currentScreen = .start
    }
}

// MARK: - Router Implementations

final class CartesiaStartRouter: StartRouter {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func startGame() {
        coordinator.startNewSession()
    }

    func howToPlay() {
        coordinator.isHowToPlayPresented = true
    }
}

final class CartesiaGameRouter: GameRouter {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func didCompleteRound(_ result: GameResult) {
        let summary = RoundSummary(
            roundNumber: coordinator.session.currentRoundNumber,
            totalRounds: GameSession.roundsPerGame,
            distance: result.distance,
            formattedDistance: result.formattedDistance,
            actualLocation: .init(
                latitude: result.actualLocation.latitude,
                longitude: result.actualLocation.longitude
            ),
            guessedLocation: .init(
                latitude: result.guessedLocation.latitude,
                longitude: result.guessedLocation.longitude
            ),
            timeTaken: result.timeTaken,
            formattedTime: result.formattedTime
        )
        coordinator.completeRound(summary)
    }

    func didLeaveRound() {
        coordinator.navigateToStart()
    }
}

final class CartesiaResultRouter: ResultRouter {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func nextRound() {
        if coordinator.session.isComplete {
            coordinator.showFinalResult()
        } else {
            coordinator.advanceToNextRound()
        }
    }

    func playAgain() {
        coordinator.startNewSession()
    }

    func backToStart() {
        coordinator.navigateToStart()
    }
}
