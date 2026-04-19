//
//  CompatibleTapGesture.swift
//  Cartesia
//
//  Created by Antonio on 18/04/26.
//

import SwiftUI

struct CompatibleTapGesture: ViewModifier {
    let action: (CGPoint) -> Void
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.simultaneousGesture(SpatialTapGesture().onEnded({ event in
                action(event.location)
            }))
        } else {
            content.onTapGesture { point in
                action(point)
            }
        }
    }
}
