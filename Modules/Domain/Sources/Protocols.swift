import Foundation

@MainActor
public protocol GameEngineProtocol: AnyObject, Sendable {
    var gameState: GameState { get }
    var currentLocation: Coordinates? { get }
    
    func startNewGame() async
    func submitGuess(_ coordinates: Coordinates) async
    func resetGame()
}

@MainActor 
public protocol LocationServiceProtocol: AnyObject, Sendable {
    func generateRandomLocation() async -> Coordinates
    func calculateDistance(from: Coordinates, to: Coordinates) -> Double
    func formatDistance(_ distance: Double) -> String
}

@MainActor
public protocol LookAroundServiceProtocol: AnyObject, Sendable {
    func getScene(for coordinates: Coordinates) async throws -> Any?
}