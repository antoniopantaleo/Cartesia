import Foundation

public protocol LookAroundServiceProtocol: AnyObject {
    func hasCoverage(at coordinates: Coordinates) async -> Bool
}
