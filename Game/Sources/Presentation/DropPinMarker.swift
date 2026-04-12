//
//  Pin.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let controlPoint = width * 0.45
        let tipHeight = height * 0.35
        let bulbHeight = height - tipHeight
        
        path.move(to: CGPoint(x: width / 2, y: height))
        path.addCurve(
            to: CGPoint(x: 0, y: bulbHeight * 0.55),
            control1: CGPoint(x: width / 2 - controlPoint, y: height * 0.82),
            control2: CGPoint(x: 0, y: bulbHeight * 0.85)
        )
        path.addArc(
            center: CGPoint(x: width / 2, y: bulbHeight * 0.55),
            radius: width / 2,
            startAngle: .degrees(180),
            endAngle: .zero,
            clockwise: false
        )
        path.addCurve(
            to: CGPoint(x: width / 2, y: height),
            control1: CGPoint(x: width, y: bulbHeight * 0.85),
            control2: CGPoint(x: width / 2 + controlPoint, y: height * 0.82)
        )
        path.closeSubpath()
        return path
    }
}

struct DropPinMarker: View {
    @State private var ripple = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.cyan.opacity(0.45), lineWidth: 3)
                .frame(width: 54, height: 54)
                .scaleEffect(ripple ? 1.4 : 0.9)
                .opacity(ripple ? 0 : 0.7)
            
            Circle()
                .fill(Color.cyan.opacity(0.18))
                .frame(width: 54, height: 54)
                .scaleEffect(ripple ? 1.2 : 0.9)
                .opacity(ripple ? 0 : 0.6)
            
            MapPinShape()
                .fill(
                    LinearGradient(
                        colors: [Color.cyan, Color.blue.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 42, height: 58)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 18, height: 18)
                        .offset(y: -10)
                )
                .shadow(color: .black.opacity(0.22), radius: 6, x: 0, y: 6)
            
            Ellipse()
                .fill(Color.black.opacity(0.25))
                .frame(width: 30, height: 8)
                .offset(y: 24)
                .blur(radius: 1.5)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false)) {
                ripple.toggle()
            }
        }
    }
}

#Preview {
    DropPinMarker()
        .frame(width: 80, height: 90)
        .padding()
        .background(.black)
}
