import ResultInterface
import CoreLocation

extension RoundSummary {
    public static let sample = RoundSummary(
        distance: 1_200,
        formattedDistance: "1.2 km",
        actualLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        guessedLocation: CLLocationCoordinate2D(latitude: 48.863, longitude: 2.349),
        timeTaken: 87,
        formattedTime: "01:27"
    )
}
