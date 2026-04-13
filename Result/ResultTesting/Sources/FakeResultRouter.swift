import ResultInterface

public final class FakeResultRouter: ResultRouter {
    public var playAgainCalled = false
    public var backToStartCalled = false

    public init() {}

    public func playAgain() {
        playAgainCalled = true
    }

    public func backToStart() {
        backToStartCalled = true
    }
}
