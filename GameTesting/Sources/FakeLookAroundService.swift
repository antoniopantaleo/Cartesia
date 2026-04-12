import GameInterface

public final class FakeLookAroundService: LookAroundServiceProtocol {

    public init() {}

    public func getScene(for coordinates: Coordinates) async throws -> Any? {
        nil
    }
}
