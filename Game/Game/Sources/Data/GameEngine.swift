import Foundation
import GameInterface
import Observation

@Observable
public final class GameEngine: GameEngineProtocol {
    public private(set) var gameState: GameState = .notStarted
    public private(set) var currentLocation: Coordinates?

    private let locationService: LocationServiceProtocol
    private let lookAroundService: LookAroundServiceProtocol
    private let maxLocationAttempts = 4

    public init(
        locationService: LocationServiceProtocol,
        lookAroundService: LookAroundServiceProtocol
    ) {
        self.locationService = locationService
        self.lookAroundService = lookAroundService
    }

    public func startNewGame() async {
        gameState = .loading
        currentLocation = nil

        for _ in 0..<maxLocationAttempts {
            let location = await locationService.generateRandomLocation()
            guard await lookAroundService.hasCoverage(at: location) else { continue }
            currentLocation = location
            gameState = .running(location: location, startTime: Date())
            return
        }
        gameState = .failed
    }

    public func submitGuess(_ guessedCoordinates: Coordinates) async {
        guard let actualLocation = currentLocation, case .running(_, let startTime) = gameState else { return }

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
