import Foundation

public protocol GameEngineProtocol: AnyObject {
    var gameState: GameState { get }
    var currentLocation: Coordinates? { get }
    
    func startNewGame() async
    func submitGuess(_ coordinates: Coordinates) async
    func resetGame()
}
 
public protocol LocationServiceProtocol: AnyObject {
    func generateRandomLocation() async -> Coordinates
    func calculateDistance(from: Coordinates, to: Coordinates) -> Double
    func formatDistance(_ distance: Double) -> String
}

public protocol LookAroundServiceProtocol: AnyObject {
    func getScene(for coordinates: Coordinates) async throws -> Any?
}
