import Foundation
import GameInterface
import Observation

@Observable
public final class GameEngine: GameEngineProtocol {
    public private(set) var gameState: GameState = .notStarted
    public private(set) var currentLocation: Coordinates?

    private let locationService: LocationServiceProtocol

    public init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }

    public func startNewGame() async {
        currentLocation = await locationService.generateRandomLocation()
        gameState = .running(startTime: Date())
    }

    public func submitGuess(_ guessedCoordinates: Coordinates) async {
        guard let actualLocation = currentLocation,
              case .running(let startTime) = gameState else { return }

        let timeTaken = Date().timeIntervalSince(startTime)
        let formattedTime = formatTime(timeTaken)

        let distance = locationService.calculateDistance(
            from: guessedCoordinates,
            to: actualLocation
        )

        let formattedDistance = locationService.formatDistance(distance)

        let result = GameResult(
            distance: distance,
            formattedDistance: formattedDistance,
            actualLocation: actualLocation,
            guessedLocation: guessedCoordinates,
            timeTaken: timeTaken,
            formattedTime: formattedTime
        )

        gameState = .completed(result: result)
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    public func resetGame() {
        gameState = .notStarted
        currentLocation = nil
    }
}
