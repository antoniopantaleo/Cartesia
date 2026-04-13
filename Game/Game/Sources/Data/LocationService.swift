import Foundation
import CoreLocation
import GameInterface

public final class LocationService: LocationServiceProtocol {

    public init() {}

    public func generateRandomLocation() async -> Coordinates {
        let coordinates: [String: Coordinates] = [
            "Tokyo": Coordinates(latitude: 35.6895, longitude: 139.6917),
            "Turin": Coordinates(latitude: 45.06935, longitude: 7.61494),
            "Oslo": Coordinates(latitude: 59.92485, longitude: 10.75918)
        ]
        return coordinates.values.randomElement()!
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
