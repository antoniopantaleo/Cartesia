import GameInterface

extension GameResult {
    public static let sample = GameResult(
        distance: 1_200,
        formattedDistance: "1.2 km",
        actualLocation: Coordinates(latitude: 48.8566, longitude: 2.3522),
        guessedLocation: Coordinates(latitude: 48.863, longitude: 2.349),
        timeTaken: 87,
        formattedTime: "01:27"
    )
}
