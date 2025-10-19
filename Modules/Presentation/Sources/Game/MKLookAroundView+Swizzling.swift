//
//  MKLookAroundView+Swizzling.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import UIKit
import MapKit
import SwiftUI

// Global reference to track timer start time
@MainActor private var timerStartTime: Date?
@MainActor private var timerWindow: UIWindow?

extension UIViewController {
    public static func swizzleViewWillAppear() {
        // Swizzle viewWillAppear
        guard
            let originalWillAppear = class_getInstanceMethod(
                UIViewController.self,
                #selector(viewWillAppear(_:))
            ),
            let swizzledWillAppear = class_getInstanceMethod(
                UIViewController.self,
                #selector(swizzled_viewWillAppear(_:))
            )
        else { return }
        method_exchangeImplementations(originalWillAppear, swizzledWillAppear)
    }
    
    @objc
    private func swizzled_viewWillAppear(_ animated: Bool) {
        // Call original implementation (now points to the swizzled method)
        swizzled_viewWillAppear(animated)
        
        let typeOfSelf = String(describing: type(of: self))
        guard typeOfSelf.contains("MKLookAroundViewController") else { return }
        
        print("🎯 MKLookAroundViewController viewWillAppear detected")
        
        // Remove info stack view
        let stackView = self.value(forKey: "_infoStackView") as? UIView
        stackView?.removeFromSuperview()
    }
    
    static func updateTimerStartTime(_ startTime: Date?) {
        timerStartTime = startTime
        print("📝 Timer start time updated to: \(startTime?.description ?? "nil")")
        
        if startTime != nil {
            showWindowOverlayTimer()
        } else {
            hideWindowOverlayTimer()
        }
        
        // Also refresh existing overlays
        DispatchQueue.main.async {
            refreshAllTimerOverlays()
        }
    }
    
    static func showWindowOverlayTimer() {
        hideWindowOverlayTimer() // Remove existing if any
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.backgroundColor = .clear
        window.isUserInteractionEnabled = false
        window.isHidden = false
        
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = .clear
        mainViewController.view.isUserInteractionEnabled = false
        let timerView = TimerView(startTime: timerStartTime)
        let hostingController = UIHostingController(rootView: timerView)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainViewController.addChild(hostingController)
        mainViewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: mainViewController)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor
                .constraint(
                    equalTo: mainViewController.view.safeAreaLayoutGuide.topAnchor
                ),
            hostingController.view.centerXAnchor
                .constraint(equalTo: mainViewController.view.safeAreaLayoutGuide.centerXAnchor)
        ]
)
        
        window.rootViewController = mainViewController
        
        
        timerWindow = window
        print("🪟 Created window overlay timer")
    }

    static func hideWindowOverlayTimer() {
        timerWindow?.isHidden = true
        timerWindow = nil
        print("🗑️ Removed window overlay timer")
    }
    
    static func refreshAllTimerOverlays() {
        // Find all MKLookAroundViewController instances and refresh their overlays
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        func findLookAroundViewControllers(in view: UIView) -> [MKLookAroundViewController] {
            var controllers: [MKLookAroundViewController] = []
            
            if let vc = view.next as? MKLookAroundViewController {
                controllers.append(vc)
            }
            
            for subview in view.subviews {
                controllers.append(contentsOf: findLookAroundViewControllers(in: subview))
            }
            
            return controllers
        }
        
        let lookAroundControllers = findLookAroundViewControllers(in: keyWindow)
        print("🔄 Found \(lookAroundControllers.count) MKLookAroundViewController instances to refresh")
    }
}


extension MKLookAroundViewController {
    func fullscreen() {
        let selector = NSSelectorFromString("_transitionToFullScreenAnimated:completionHandler:")
        guard responds(to: selector) else { return }
        
        let imp = method(for: selector)
        typealias Func = @convention(c) (AnyObject, Selector, Bool, (() -> Void)?) -> Void
        let funcImp = unsafeBitCast(imp, to: Func.self)
        
        print("🔄 Transitioning to fullscreen")
        funcImp(self, selector, true, {})
    }
}
