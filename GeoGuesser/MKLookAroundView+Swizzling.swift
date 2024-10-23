//
//  MKLookAroundView+Swizzling.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import UIKit
import MapKit

extension UIViewController {
    static func swizzleViewWillAppear() {
        guard
            let originalMethod1 = class_getInstanceMethod(
                UIViewController.self,
                #selector(viewWillAppear(_:))
            ),
            let swizzledMethod1 = class_getInstanceMethod(
                UIViewController.self,
                #selector(
                    swizzled_viewWillAppear(_:))
            )
        else { return }
        method_exchangeImplementations(originalMethod1, swizzledMethod1)
    }
    
    @objc
    private func swizzled_viewWillAppear(_ animated: Bool) {
        let typeOfSelf = String(describing: type(of: self))
        guard typeOfSelf.contains("MKLookAroundViewController") else { return }
        let stackView = self.value(forKey: "_infoStackView") as? UIView
        stackView?.removeFromSuperview()
    }
}

extension MKLookAroundViewController {
    func fullscreen() {
        let selector = NSSelectorFromString("_transitionToFullScreenAnimated:completionHandler:")
        guard responds(to: selector) else { return }
        
        let imp = method(for: selector)
        typealias Func = @convention(c) (AnyObject, Selector, Bool, (() -> Void)?) -> Void
        let funcImp = unsafeBitCast(imp, to: Func.self)
        funcImp(self, selector, true, {})
    }
}
