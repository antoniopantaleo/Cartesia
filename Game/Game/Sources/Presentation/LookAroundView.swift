@preconcurrency import MapKit
import SwiftUI
import GameInterface

struct LookAroundView: UIViewControllerRepresentable {
    let scene: MKLookAroundScene?
    let isNavigationEnabled: Bool
    let onConfirmGuess: (Coordinates) -> ()
    let onLeaveRound: () -> Void

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let vc = MKLookAroundViewController()
        vc.showsRoadLabels = false
        vc.badgePosition = .bottomTrailing
        vc.pointOfInterestFilter = .excludingAll
        vc.delegate = context.coordinator
        UIViewController.registerActiveLookAroundController(vc)

        let coordinator = context.coordinator
        UIViewController.installLookAroundDismissInterceptor { [weak coordinator] in
            DispatchQueue.main.async { coordinator?.presentLeaveConfirmation() }
            return true
        }
        return vc
    }

    static func dismantleUIViewController(_ uiViewController: MKLookAroundViewController, coordinator: Coordinator) {
        UIViewController.removeLookAroundDismissInterceptor()
    }

    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        guard let scene, uiViewController.scene == nil else { return }
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
            guard let windowScene = viewController.view.window?.windowScene else {
                return assertionFailure("No window scene detected")
            }
            let overlay = PassthroughWindow(windowScene: windowScene)
            overlay.windowLevel = .statusBar + 1
            overlay.backgroundColor = .clear

            let hosting = UIHostingController(rootView: GameOverlaySheet { [weak self] coordinates in
                self?.parent.onConfirmGuess(coordinates)
            })
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
            overlayWindow?.isHidden = true
            overlayWindow = nil
        }

        func lookAroundViewControllerDidDismissFullScreen(
            _ viewController: MKLookAroundViewController
        ) {}

        func lookAroundViewControllerDidUpdateScene(
            _ viewController: MKLookAroundViewController
        ) {}

        func presentLeaveConfirmation() {
            guard let root = overlayWindow?.rootViewController else { return }
            var presenter: UIViewController = root
            while let next = presenter.presentedViewController { presenter = next }
            if presenter is UIAlertController { return }

            let alert = UIAlertController(
                title: "Leave this round?",
                message: "Your current guess will be lost.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Stay", style: .cancel))
            alert.addAction(UIAlertAction(title: "Leave", style: .destructive) { [weak self] _ in
                self?.parent.onLeaveRound()
            })
            presenter.present(alert, animated: true)
        }
    }
}

private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        if hitView == self || hitView == rootViewController?.view { return nil }
        return hitView
    }
}
