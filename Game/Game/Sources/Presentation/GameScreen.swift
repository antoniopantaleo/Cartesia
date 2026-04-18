import SwiftUI
import GameInterface

public struct GameScreen: View {
    
    private let router: GameRouter
    @ObservedObject private var viewModel: GameViewModel
    
    public init(router: GameRouter, viewModel: GameViewModel) {
        self.router = router
        self.viewModel = viewModel
        UIViewController.swizzleViewWillAppear()
    }
    

    public var body: some View {
        VStack {
            LookAroundView(
                scene: $viewModel.scene,
                isNavigationEnabled: .constant(true),
                fullscreen: .constant(true),
                onAppear: {
                    print("✨", "On appear")
                }
            )
            .overlay {
                Rectangle()
            }
        }
        .ignoresSafeArea(.all, edges: .all)
            .colorScheme(.dark)
//        GameView(
//            viewModel: viewModel,
//            onResult: { result in
//                router.didCompleteRound(result)
//            }
//        )
    }
}
