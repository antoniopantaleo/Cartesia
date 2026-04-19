import Foundation
@preconcurrency import MapKit
import GameInterface

@MainActor
public final class GameViewModel: ObservableObject {

    @Published public private(set) var gameState: GameState = .notStarted
    @Published public private(set) var currentLocation: Coordinates?
    @Published public private(set) var scene: MKLookAroundScene?

    private let gameEngine: GameEngineProtocol
    private let sceneProvider: LookAroundSceneProviding

    public var isGameRunning: Bool {
        if case .running = gameState { return true }
        return false
    }

    public var gameStartTime: Date? {
        if case .running(_, let startTime) = gameState { return startTime }
        return nil
    }

    public init(gameEngine: GameEngineProtocol, sceneProvider: LookAroundSceneProviding) {
        self.gameEngine = gameEngine
        self.sceneProvider = sceneProvider

        Task { [weak self] in
            await self?.startNewGame()
        }
    }

    public func startNewGame() async {
        gameState = .loading
        scene = nil
        await gameEngine.startNewGame()
        guard case .running(let location, _) = gameEngine.gameState else {
            gameState = gameEngine.gameState
            return
        }
        scene = await sceneProvider.scene(for: location)
        gameState = scene == nil ? .failed : gameEngine.gameState
    }

    public func confirmPosition(_ coordinates: Coordinates) async {
        await gameEngine.submitGuess(coordinates)
        gameState = gameEngine.gameState
    }
}
