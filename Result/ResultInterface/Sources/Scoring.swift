import Foundation

public enum Scoring {
    /// Half of Earth's circumference: the farthest any guess can be.
    public static let maxDistanceMeters: Double = 20_037_500
    public static let maxRoundScore = 11_000

    public static func score(distance: Double, timeTaken: TimeInterval) -> Int {
        let distanceRatio = min(distance / maxDistanceMeters, 1.0)
        let baseScore = max(0, Int(10_000 * (1 - distanceRatio)))
        let timeBonus = max(0, Int(1_000 * max(0, 1 - timeTaken / 180)))
        return baseScore + timeBonus
    }

    public static func accuracy(distance: Double) -> Double {
        max(0, 1 - min(distance / maxDistanceMeters, 1.0)) * 100
    }
}
