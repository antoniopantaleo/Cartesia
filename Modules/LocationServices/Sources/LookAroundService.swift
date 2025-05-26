import Foundation
@preconcurrency import MapKit
import Core

@MainActor
public final class LookAroundService: LookAroundServiceProtocol {
    
    public init() {}
    
    public func getScene(for coordinates: Coordinates) async throws -> Any? {
        let request = MKLookAroundSceneRequest(
            coordinate: CLLocationCoordinate2D(coordinates: coordinates)
        )
        return try await request.scene
    }
}
