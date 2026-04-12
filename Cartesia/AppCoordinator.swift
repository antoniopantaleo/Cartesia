import Foundation
import GameInterface
import ResultInterface
import StartInterface

@Observable
final class AppCoordinator {
    enum Screen {
        case start
        case game
        case result(RoundSummary)
    }

    private(set) var currentScreen: Screen = .start

    func navigateToGame() {
        currentScreen = .game
    }

    func navigateToResult(_ summary: RoundSummary) {
        currentScreen = .result(summary)
    }

    func navigateToStart() {
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
        coordinator.navigateToGame()
    }

    func howToPlay() {
        // TODO: implement HowToPlay feature
    }
}

final class CartesiaGameRouter: GameRouter {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func didCompleteRound(_ result: GameResult) {
        let summary = RoundSummary(
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
        coordinator.navigateToResult(summary)
    }
}

final class CartesiaResultRouter: ResultRouter {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func playAgain() {
        coordinator.navigateToGame()
    }

    func backToStart() {
        coordinator.navigateToStart()
    }
}
