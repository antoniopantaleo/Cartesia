import SwiftUI
import Result
import ResultTesting

@main
struct ResultExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ResultScreen(
                summary: .sample,
                router: FakeResultRouter()
            )
            .colorScheme(.dark)
        }
    }
}
