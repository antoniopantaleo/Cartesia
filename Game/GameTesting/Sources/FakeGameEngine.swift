import GameInterface

public final class FakeGameEngine: GameEngineProtocol {
    public var gameState: GameState = .notStarted
    public var currentLocation: Coordinates?

    public init() {}

    public func startNewGame() async {
        currentLocation = Coordinates(latitude: 48.8584, longitude: 2.2945)
        gameState = .running(startTime: .now)
    }

    public func submitGuess(_ coordinates: Coordinates) async {
        let result = GameResult(
            distance: 1_200,
            formattedDistance: "1.2 km",
            actualLocation: currentLocation ?? Coordinates(latitude: 48.8584, longitude: 2.2945),
            guessedLocation: coordinates,
            timeTaken: 87,
            formattedTime: "01:27"
        )
        gameState = .completed(result: result)
    }

    public func resetGame() {
        gameState = .notStarted
        currentLocation = nil
    }
}
