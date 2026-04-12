import SwiftUI
import StartInterface

@main
struct GeoGuesserApp: App {
    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView(coordinator: coordinator)
                .colorScheme(.dark)
        }
    }
}
