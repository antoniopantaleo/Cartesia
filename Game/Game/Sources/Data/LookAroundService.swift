import Foundation
@preconcurrency import MapKit
import GameInterface

public final class LookAroundService: LookAroundServiceProtocol, LookAroundSceneProviding {

    /// Scenes fetched for coverage checks, so the presentation layer
    /// reuses them without a second network request.
    private var cachedScenes: [String: MKLookAroundScene] = [:]

    public init() {}

    public func hasCoverage(at coordinates: Coordinates) async -> Bool {
        await scene(for: coordinates) != nil
    }

    public func scene(for coordinates: Coordinates) async -> MKLookAroundScene? {
        if let cached = cachedScenes[coordinates.id] {
            return cached
        }
        let request = MKLookAroundSceneRequest(
            coordinate: CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
        )
        guard let scene = try? await request.scene else { return nil }
        cachedScenes[coordinates.id] = scene
        return scene
    }
}
