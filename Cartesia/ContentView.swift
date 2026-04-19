import SwiftUI
import Start
import StartInterface
import Game
import Result
import ResultInterface

struct ContentView: View {
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .start:
                StartView(
                    router: CartesiaStartRouter(coordinator: coordinator),
                    regions: []
                )
            case .game:
                let lookAroundService = LookAroundService()
                GameScreen(
                    router: CartesiaGameRouter(coordinator: coordinator),
                    viewModel: GameViewModel(
                        gameEngine: GameEngine(
                            locationService: coordinator.sessionLocationService,
                            lookAroundService: lookAroundService
                        ),
                        sceneProvider: lookAroundService
                    )
                )
                .id(coordinator.roundID)
            case .roundResult(let summary):
                ResultScreen(
                    summary: summary,
                    router: CartesiaResultRouter(coordinator: coordinator)
                )
            case .finalResult(let summary):
                FinalResultScreen(
                    summary: summary,
                    router: CartesiaResultRouter(coordinator: coordinator)
                )
            }
        }
        .sheet(isPresented: $coordinator.isHowToPlayPresented) {
            HowToPlayView()
                .presentationDetents([.medium, .large])
        }
    }
}
