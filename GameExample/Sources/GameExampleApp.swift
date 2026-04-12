import SwiftUI
import Game
import GameTesting

@main
struct GameExampleApp: App {
    var body: some Scene {
        WindowGroup {
            GameScreen(router: FakeGameRouter())
                .colorScheme(.dark)
        }
    }
}
