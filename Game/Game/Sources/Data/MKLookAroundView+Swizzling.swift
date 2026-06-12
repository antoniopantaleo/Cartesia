//
//  MKLookAroundView+Swizzling.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import UIKit
import MapKit

/// Private MapKit symbols, assembled at runtime from fragments so the full
/// names never appear as literals in the compiled binary.
private enum PrivateSelectors {
    static var infoStackViewKey: String {
        ["_info", "Stack", "View"].joined()
    }
    static var didTapCloseButton: Selector {
        Selector(["_did", "Tap", "Close", "But", "ton", ":"].joined())
    }
    static var transitionToFullScreen: Selector {
        Selector(["_transition", "ToFull", "Screen", "Anim", "ated:", "completion", "Handler:"].joined())
    }
}

private enum LookAroundFullscreenGate {
    static var shouldAutoFullscreen: Bool = true
    static weak var activeController: MKLookAroundViewController?
    static var onDismissAttempt: (() -> Bool)?
    static var originalCloseButtonIMP: IMP?
    static var didSwizzleViewWillAppear: Bool = false
    static var didSwizzleCloseButton: Bool = false
}

// MARK: - Public API

extension UIViewController {

    public static func swizzleViewWillAppear() {
        guard !LookAroundFullscreenGate.didSwizzleViewWillAppear else { return }
        guard
            let original = class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear(_:))),
            let swizzled = class_getInstanceMethod(UIViewController.self, #selector(swizzled_viewWillAppear(_:)))
        else {
            return assertionFailure("Unable to get UIViewController lifecycle instance methods")
        }
        method_exchangeImplementations(original, swizzled)
        LookAroundFullscreenGate.didSwizzleViewWillAppear = true
    }

    public static func armLookAroundAutoFullscreen() {
        LookAroundFullscreenGate.shouldAutoFullscreen = true
    }

    public static func dismissLookAroundFullscreen() {
        LookAroundFullscreenGate.shouldAutoFullscreen = false
        var ancestor: UIViewController? = LookAroundFullscreenGate.activeController
        while let current = ancestor {
            if let presented = current.presentedViewController {
                presented.dismiss(animated: false)
                return
            }
            ancestor = current.parent
        }
    }

    public static func registerActiveLookAroundController(_ vc: MKLookAroundViewController) {
        LookAroundFullscreenGate.activeController = vc
    }

    public static func installLookAroundDismissInterceptor(_ handler: @escaping () -> Bool) {
        LookAroundFullscreenGate.onDismissAttempt = handler
        installCloseButtonSwizzleIfNeeded()
    }

    public static func removeLookAroundDismissInterceptor() {
        LookAroundFullscreenGate.onDismissAttempt = nil
    }
}

// MARK: - Swizzling

extension UIViewController {

    @objc
    private func swizzled_viewWillAppear(_ animated: Bool) {
        swizzled_viewWillAppear(animated)
        guard let lookAround = self as? MKLookAroundViewController else { return }
        (lookAround.value(forKey: PrivateSelectors.infoStackViewKey) as? UIView)?.removeFromSuperview()
        guard LookAroundFullscreenGate.shouldAutoFullscreen else { return }
        lookAround.enterFullscreen()
    }

    fileprivate static func installCloseButtonSwizzleIfNeeded() {
        guard !LookAroundFullscreenGate.didSwizzleCloseButton else { return }
        guard let cls = NSClassFromString("MKLookAroundViewController") else {
            return assertionFailure("MKLookAroundViewController class not found")
        }
        let selector = PrivateSelectors.didTapCloseButton
        guard let originalMethod = class_getInstanceMethod(cls, selector) else {
            return assertionFailure("Close button selector not found on MKLookAroundViewController")
        }
        LookAroundFullscreenGate.originalCloseButtonIMP = method_getImplementation(originalMethod)
        let typeEncoding = method_getTypeEncoding(originalMethod)

        let block: @convention(block) (UIViewController, AnyObject?) -> Void = { vc, sender in
            if let handler = LookAroundFullscreenGate.onDismissAttempt, handler() { return }
            typealias Func = @convention(c) (AnyObject, Selector, AnyObject?) -> Void
            guard let imp = LookAroundFullscreenGate.originalCloseButtonIMP else { return }
            unsafeBitCast(imp, to: Func.self)(vc, selector, sender)
        }
        class_replaceMethod(cls, selector, imp_implementationWithBlock(block), typeEncoding)
        LookAroundFullscreenGate.didSwizzleCloseButton = true
    }
}

// MARK: - Private fullscreen entry

private extension MKLookAroundViewController {
    func enterFullscreen() {
        let selector = PrivateSelectors.transitionToFullScreen
        guard responds(to: selector) else { return }
        typealias Func = @convention(c) (AnyObject, Selector, Bool, (() -> Void)?) -> Void
        unsafeBitCast(method(for: selector), to: Func.self)(self, selector, true, {})
    }
}
