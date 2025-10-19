import Foundation
@preconcurrency import MapKit
import GeoDomain

@MainActor
public final class LookAroundService: LookAroundServiceProtocol {
    
    public init() {}
    
    public func getScene(for coordinates: Coordinates) async throws -> Any? {
        let request = MKLookAroundSceneRequest(
            coordinate: CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
        )
        return try await request.scene
    }
}
