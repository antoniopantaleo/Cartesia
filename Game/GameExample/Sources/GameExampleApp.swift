import SwiftUI
import Game
import GameInterface
import GameTesting

@main
struct GameExampleApp: App {
    private static let lookAroundService = LookAroundService()
    @ObservedObject var gameVM = GameViewModel(
        gameEngine: GameEngine(
            locationService: LocationService(),
            lookAroundService: lookAroundService
        ),
        sceneProvider: lookAroundService
    )
    @State private var result: GameResult?
    
    var body: some Scene {
        WindowGroup {
            GameScreen(
                router: FakeGameRouter { result = $0 },
                viewModel: gameVM
            )
                .colorScheme(.dark)
                .sheet(item: $result) { result in
                    Text("Result screen")
                }
        }
    }
}

extension GameResult: Identifiable {
    public var id: UUID { UUID() }
    
}
