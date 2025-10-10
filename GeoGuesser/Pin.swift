//
//  Pin.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

struct Pin: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = rect.width / 4
        path.addArc(
            center: .init(x: rect.midX, y: radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: .init(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
