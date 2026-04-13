import Foundation

public struct Coordinates: Equatable, Identifiable {
    public var id: String { latitude.description + longitude.description }
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
