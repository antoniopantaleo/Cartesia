import ResultInterface
import CoreLocation

extension RoundSummary {
    public static let sample = RoundSummary(
        roundNumber: 1,
        totalRounds: 5,
        distance: 1_200,
        formattedDistance: "1.2 km",
        actualLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        guessedLocation: CLLocationCoordinate2D(latitude: 48.863, longitude: 2.349),
        timeTaken: 87,
        formattedTime: "01:27"
    )

    public static func sample(roundNumber: Int, totalRounds: Int = 5, distance: Double = 1_200) -> RoundSummary {
        RoundSummary(
            roundNumber: roundNumber,
            totalRounds: totalRounds,
            distance: distance,
            formattedDistance: "1.2 km",
            actualLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            guessedLocation: CLLocationCoordinate2D(latitude: 48.863, longitude: 2.349),
            timeTaken: 87,
            formattedTime: "01:27"
        )
    }
}

extension GameSummary {
    public static let sample = GameSummary(
        rounds: (1...5).map { RoundSummary.sample(roundNumber: $0) }
    )
}
