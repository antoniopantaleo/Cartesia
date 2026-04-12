import GameInterface

public final class FakeLocationService: LocationServiceProtocol {

    public init() {}

    public func generateRandomLocation() async -> Coordinates {
        Coordinates(latitude: 48.8584, longitude: 2.2945)
    }

    public func calculateDistance(from: Coordinates, to: Coordinates) -> Double {
        1_200
    }

    public func formatDistance(_ distance: Double) -> String {
        "1.2 km"
    }
}
