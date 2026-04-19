import Foundation

public enum GameState {
    case notStarted
    case loading
    case running(location: Coordinates, startTime: Date)
    case completed(result: GameResult)
    case failed
}
