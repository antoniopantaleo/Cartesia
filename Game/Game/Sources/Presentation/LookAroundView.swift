@preconcurrency import MapKit
import SwiftUI
import GameInterface

struct LookAroundView: UIViewControllerRepresentable {
    @Binding var scene: MKLookAroundScene?
    @Binding var isNavigationEnabled: Bool
    @Binding var fullscreen: Bool
    let onAppear: () -> Void

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        print("✨", "Make UI View Controller")
        let vc = MKLookAroundViewController()
        vc.showsRoadLabels = false
        vc.badgePosition = .bottomTrailing
        vc.pointOfInterestFilter = .excludingAll
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        guard let scene else { return print("✨", "Update UI View Controller", "NO SCENE") }
        print("✨", "Update UI View Controller", scene)
        uiViewController.scene = scene
        uiViewController.isNavigationEnabled = isNavigationEnabled
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MKLookAroundViewControllerDelegate {
        private let parent: LookAroundView
        private var overlayWindow: UIWindow?

        init(_ parent: LookAroundView) {
            self.parent = parent
        }

        func lookAroundViewControllerWillPresentFullScreen(
            _ viewController: MKLookAroundViewController
        ) {
            print("✨", "Will present full screen")
            defer { parent.onAppear() }
            guard let windowScene = viewController.view.window?.windowScene else {
                return assertionFailure("No window scene detected")
            }
            let overlay = PassthroughWindow(windowScene: windowScene)
            overlay.windowLevel = .statusBar + 1
            overlay.backgroundColor = .clear
            let hosting = UIHostingController(rootView: GameOverlaySheet())
            hosting.view.backgroundColor = .clear
            hosting.sizingOptions = .intrinsicContentSize

            let container = UIViewController()
            container.view.backgroundColor = .clear
            container.addChild(hosting)
            container.view.addSubview(hosting.view)
            hosting.didMove(toParent: container)

            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hosting.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
                hosting.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor),
                hosting.view.bottomAnchor.constraint(equalTo: container.view.bottomAnchor)
            ])

            overlay.rootViewController = container
            overlay.isHidden = false
            overlayWindow = overlay
        }
        
        func lookAroundViewControllerWillDismissFullScreen(
            _ viewController: MKLookAroundViewController
        ) {
            print("✨", "Did will dismiss full screen")
        }

        func lookAroundViewControllerDidDismissFullScreen(
            _ viewController: MKLookAroundViewController
        ) {
            print("✨", "Did dismiss full screen")
            parent.fullscreen = false
        }

        func lookAroundViewControllerDidUpdateScene(
            _ viewController: MKLookAroundViewController
        ) {
            guard let scene = viewController.scene else { return print("✨", "Did update scene", "NO SCENE") }
            print("✨", "Did update scene", scene)
            parent.scene = scene
        }
    }
}


class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        if hitView == self || hitView == rootViewController?.view {
            return nil
        }
        return hitView
    }
}
