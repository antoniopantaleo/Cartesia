@preconcurrency import MapKit
import SwiftUI
import GameInterface

struct LookAroundView: UIViewControllerRepresentable {
    @Binding var scene: MKLookAroundScene?
    @Binding var isNavigationEnabled: Bool
    @Binding var fullscreen: Bool
    let onAppear: () -> Void

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let vc = MKLookAroundViewController()
        vc.showsRoadLabels = false
        vc.badgePosition = .bottomTrailing
        vc.pointOfInterestFilter = .excludingAll
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        guard let scene else { return }
        uiViewController.scene = scene
        uiViewController.isNavigationEnabled = isNavigationEnabled
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, @preconcurrency MKLookAroundViewControllerDelegate {
        private let parent: LookAroundView

        init(_ parent: LookAroundView) {
            self.parent = parent
        }

        func lookAroundViewControllerWillPresentFullScreen(
            _ viewController: MKLookAroundViewController
        ) {
            parent.onAppear()
        }

        func lookAroundViewControllerDidDismissFullScreen(
            _ viewController: MKLookAroundViewController
        ) {
            parent.fullscreen = false
        }

        func lookAroundViewControllerDidUpdateScene(
            _ viewController: MKLookAroundViewController
        ) {
            guard let scene = viewController.scene else { return }
            parent.scene = scene
        }
    }
}
