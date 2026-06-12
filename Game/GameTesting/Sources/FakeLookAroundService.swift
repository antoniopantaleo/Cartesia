import GameInterface

public final class FakeLookAroundService: LookAroundServiceProtocol {

    /// Coverage answers returned per call, in order. When exhausted, returns `false`.
    public var coverageResults: [Bool]
    public private(set) var requestedCoordinates: [Coordinates] = []

    public init(coverageResults: [Bool] = []) {
        self.coverageResults = coverageResults
    }

    public func hasCoverage(at coordinates: Coordinates) async -> Bool {
        requestedCoordinates.append(coordinates)
        guard !coverageResults.isEmpty else { return false }
        return coverageResults.removeFirst()
    }
}
