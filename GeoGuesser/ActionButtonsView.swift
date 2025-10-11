//
//  ActionButtonsView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

struct ActionButtonsView: View {
    let onPlayAgain: () -> Void
    let onBackToStart: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onPlayAgain) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Play another round")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                }
                .font(.headline)
                .foregroundStyle(.white)
            }
            .buttonStyle(PrimaryActionButtonStyle())
            
            Button(action: onBackToStart) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("Return to home")
                    Spacer()
                }
                .font(.headline)
            }
            .buttonStyle(SecondaryActionButtonStyle())
        }
    }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    ActionButtonsView(onPlayAgain: {}, onBackToStart: {})
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
