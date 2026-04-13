//
//  PrimaryCTAButtonStyle.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI

struct PrimaryCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 26)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.blue.opacity(0.45), radius: 18, x: 0, y: 14)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    Button("Button") {}
        .buttonStyle(PrimaryCTAButtonStyle())
}
#endif
