import SwiftUI
import GameInterface

public struct GameScreen: View {
    private let router: GameRouter

    public init(router: GameRouter) {
        self.router = router
    }

    public var body: some View {
        let locationService = LocationService()
        let gameEngine = GameEngine(locationService: locationService)
        let lookAroundService = LookAroundService()
        let viewModel = GameViewModel(
            gameEngine: gameEngine,
            lookAroundService: lookAroundService
        )

        GameView(
            viewModel: viewModel,
            onResult: { result in
                router.didCompleteRound(result)
            }
        )
        .colorScheme(.dark)
    }
}
