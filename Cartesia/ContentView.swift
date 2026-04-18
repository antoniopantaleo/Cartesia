import SwiftUI
import Start
import StartInterface
import Game
import Result
import ResultInterface

let gameVM = GameViewModel(
    gameEngine: GameEngine(
        locationService: LocationService()
    ),
    lookAroundService: LookAroundService()
)

struct ContentView: View {
    let coordinator: AppCoordinator
    
    var body: some View {
        switch coordinator.currentScreen {
        case .start:
            StartView(
                router: CartesiaStartRouter(coordinator: coordinator),
                regions: []
            )
        case .game:
            GameScreen(
                router: CartesiaGameRouter(
                    coordinator: coordinator
                ),
                viewModel: gameVM
            )
        case .result(let summary):
            ResultScreen(
                summary: summary,
                router: CartesiaResultRouter(coordinator: coordinator)
            )
        }
    }
}
