import Foundation
import CoreLocation
import Core

@MainActor
public final class LocationService: LocationServiceProtocol {
    
    public init() {}
    
    public func generateRandomLocation() async -> Coordinates {
        // For now, return Tokyo coordinates - can be enhanced to generate random locations
        return Coordinates(latitude: 35.6895, longitude: 139.6917)
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

public extension CLLocationCoordinate2D {
    init(coordinates: Coordinates) {
        self = CLLocationCoordinate2D(
            latitude: coordinates.latitude, 
            longitude: coordinates.longitude
        )
    }
}