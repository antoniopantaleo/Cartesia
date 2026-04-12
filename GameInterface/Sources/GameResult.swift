import Foundation

public struct GameResult {
    public let distance: Double
    public let formattedDistance: String
    public let actualLocation: Coordinates
    public let guessedLocation: Coordinates
    public let timeTaken: TimeInterval
    public let formattedTime: String

    public init(
        distance: Double,
        formattedDistance: String,
        actualLocation: Coordinates,
        guessedLocation: Coordinates,
        timeTaken: TimeInterval,
        formattedTime: String
    ) {
        self.distance = distance
        self.formattedDistance = formattedDistance
        self.actualLocation = actualLocation
        self.guessedLocation = guessedLocation
        self.timeTaken = timeTaken
        self.formattedTime = formattedTime
    }
}
