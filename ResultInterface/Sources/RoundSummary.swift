import Foundation
import CoreLocation

public struct RoundSummary {
    public let distance: Double
    public let formattedDistance: String
    public let actualLocation: CLLocationCoordinate2D
    public let guessedLocation: CLLocationCoordinate2D
    public let timeTaken: TimeInterval
    public let formattedTime: String

    public init(
        distance: Double,
        formattedDistance: String,
        actualLocation: CLLocationCoordinate2D,
        guessedLocation: CLLocationCoordinate2D,
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
