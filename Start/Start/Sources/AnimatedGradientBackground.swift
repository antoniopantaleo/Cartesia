//
//  AnimatedGradientBackground.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    
    var body: some View {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 0.066, green: 0.058, blue: 0.118, alpha: 1)), Color(#colorLiteral(red: 0.047, green: 0.094, blue: 0.2, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.25))
                    .frame(width: 600, height: 600)
                    .phaseAnimator([true, false], content: { content, isAnimating in
                        content.offset(
                            x: isAnimating ? -120 : -40,
                            y: isAnimating ? -200 : -120
                        )
                    }, animation: { _ in .bouncy.speed(0.07)})
                
                Circle()
                    .fill(Color.purple.opacity(0.22))
                    .frame(width: 520, height: 520)
                    .phaseAnimator([true, false], content: { content, isAnimating in
                        content.offset(
                            x: isAnimating ? 150 : 60,
                            y: isAnimating ? -20 : 200
                        )
                    }, animation: { _ in .bouncy.speed(0.05)})
            }
            .blur(radius: 100)
        )
    }
}

#if DEBUG
#Preview {
    AnimatedGradientBackground()
}
#endif
