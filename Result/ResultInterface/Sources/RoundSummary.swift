import Foundation
import CoreLocation

public struct RoundSummary {
    public let roundNumber: Int
    public let totalRounds: Int
    public let distance: Double
    public let formattedDistance: String
    public let actualLocation: CLLocationCoordinate2D
    public let guessedLocation: CLLocationCoordinate2D
    public let timeTaken: TimeInterval
    public let formattedTime: String

    public init(
        roundNumber: Int,
        totalRounds: Int,
        distance: Double,
        formattedDistance: String,
        actualLocation: CLLocationCoordinate2D,
        guessedLocation: CLLocationCoordinate2D,
        timeTaken: TimeInterval,
        formattedTime: String
    ) {
        self.roundNumber = roundNumber
        self.totalRounds = totalRounds
        self.distance = distance
        self.formattedDistance = formattedDistance
        self.actualLocation = actualLocation
        self.guessedLocation = guessedLocation
        self.timeTaken = timeTaken
        self.formattedTime = formattedTime
    }

    public var isFinalRound: Bool {
        roundNumber == totalRounds
    }

    public var score: Int {
        Scoring.score(distance: distance, timeTaken: timeTaken)
    }
}
