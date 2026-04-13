import Foundation

public protocol LookAroundServiceProtocol: AnyObject {
    func getScene(for coordinates: Coordinates) async throws -> Any?
}
