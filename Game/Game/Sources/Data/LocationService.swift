import Foundation
import CoreLocation
import GameInterface

public final class LocationService: LocationServiceProtocol {

    /// Shuffled deck dealt without repetition, so locations never repeat
    /// within the lifetime of this service (one game session).
    private var deck: [CuratedLocation]

    public init() {
        deck = CuratedLocations.all.shuffled()
    }

    public func generateRandomLocation() async -> Coordinates {
        if deck.isEmpty {
            deck = CuratedLocations.all.shuffled()
        }
        return deck.removeLast().coordinates
    }

    public func calculateDistance(from: Coordinates, to: Coordinates) -> Double {
        let location1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let location2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return location1.distance(from: location2)
    }

    public func formatDistance(_ distance: Double) -> String {
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        return measurement.formatted()
    }
}
