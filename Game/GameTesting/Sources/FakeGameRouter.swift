import GameInterface

public final class FakeGameRouter: GameRouter {
    public func didLeaveRound() {
    }

    public var lastResult: GameResult?
    public let onResult: (GameResult) -> Void

    public init(onResult: @escaping (GameResult) -> Void) {
        self.onResult = onResult
    }

    public func didCompleteRound(_ result: GameResult) {
        lastResult = result
        onResult(result)
    }
}
