import GameInterface

public final class FakeLocationService: LocationServiceProtocol {

    /// Locations dealt per call, in order. When exhausted, repeats the last one.
    public var locations: [Coordinates]
    public private(set) var generateCallCount = 0
    public var stubbedDistance: Double = 1_200
    public var stubbedFormattedDistance: String = "1.2 km"

    public init(locations: [Coordinates] = [Coordinates(latitude: 48.8584, longitude: 2.2945)]) {
        self.locations = locations
    }

    public func generateRandomLocation() async -> Coordinates {
        generateCallCount += 1
        guard locations.count > 1 else { return locations[0] }
        return locations.removeFirst()
    }

    public func calculateDistance(from: Coordinates, to: Coordinates) -> Double {
        stubbedDistance
    }

    public func formatDistance(_ distance: Double) -> String {
        stubbedFormattedDistance
    }
}
