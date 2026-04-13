import GameInterface

public final class FakeGameRouter: GameRouter {
    public var lastResult: GameResult?

    public init() {}

    public func didCompleteRound(_ result: GameResult) {
        lastResult = result
    }
}
