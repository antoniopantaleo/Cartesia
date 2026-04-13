import Foundation

public protocol LocationServiceProtocol: AnyObject {
    func generateRandomLocation() async -> Coordinates
    func calculateDistance(from: Coordinates, to: Coordinates) -> Double
    func formatDistance(_ distance: Double) -> String
}
