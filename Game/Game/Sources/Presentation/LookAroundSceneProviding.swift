@preconcurrency import MapKit
import GameInterface

/// Presentation-layer access to the LookAround scene for a location.
/// Kept out of GameInterface so the domain never depends on MapKit types.
public protocol LookAroundSceneProviding: AnyObject {
    func scene(for coordinates: Coordinates) async -> MKLookAroundScene?
}
