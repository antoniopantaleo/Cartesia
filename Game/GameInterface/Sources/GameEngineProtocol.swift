import Foundation

public protocol GameEngineProtocol: AnyObject {
    var gameState: GameState { get }
    var currentLocation: Coordinates? { get }

    func startNewGame() async
    func submitGuess(_ coordinates: Coordinates) async
    func resetGame()
}
