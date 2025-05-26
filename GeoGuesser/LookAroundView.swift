//
//  LookAroundView.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

@preconcurrency import MapKit
import SwiftUI
import Core
import LocationServices

extension MKLookAroundScene: @retroactive @unchecked Sendable {}

struct LookAroundView: UIViewControllerRepresentable {
    @Binding var scene: MKLookAroundScene?
    @Binding var isNavigationEnabled: Bool
    @Binding var fullscreen: Bool
    
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
        if fullscreen { 
            uiViewController.fullscreen() 
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @MainActor
    final class Coordinator: NSObject, @preconcurrency MKLookAroundViewControllerDelegate {
        private let parent: LookAroundView
        
        init(_ parent: LookAroundView) {
            self.parent = parent
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

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State
    var scene: MKLookAroundScene?
    
    LookAroundView(
        scene: $scene,
        isNavigationEnabled: .constant(true),
        fullscreen: .constant(false)
    )
    .frame(width: 400, height: 400)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .task {
        let request = MKLookAroundSceneRequest(coordinate: CLLocationCoordinate2D(
                latitude: 35.6895,
                longitude: 139.6917
            )
        )
        scene = try? await request.scene
    }
}
