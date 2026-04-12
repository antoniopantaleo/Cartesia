import Foundation

public enum GameState {
    case notStarted
    case running(startTime: Date)
    case completed(result: GameResult)
}
