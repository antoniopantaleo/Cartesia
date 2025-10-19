//
//  GameResultView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI
import Domain

public struct GameResultView: View {
    public let result: GameResult
    private let onPlayAgain: () -> Void
    private let onBackToStart: () -> Void
    @State private var animateSummary = false
    
    private var score: Int {
        let maxDistance: Double = 20_037_500 // meters (half Earth's circumference)
        let distanceRatio = min(result.distance / maxDistance, 1.0)
        let baseScore = max(0, Int(10_000 * (1 - distanceRatio)))
        let timeBonus = max(0, Int(1_000 * max(0, 1 - result.timeTaken / 180)))
        return baseScore + timeBonus
    }
    
    private var accuracyPercentage: Double {
        let maxDistance: Double = 20_037_500
        let ratio = max(0, 1 - min(result.distance / maxDistance, 1.0))
        return ratio * 100
    }
    
    public init(
        result: GameResult,
        onPlayAgain: @escaping () -> Void,
        onBackToStart: @escaping () -> Void
    ) {
        self.result = result
        self.onPlayAgain = onPlayAgain
        self.onBackToStart = onBackToStart
    }
    
    public var body: some View {
        ZStack {
            ResultBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    ResultHeaderView(
                        score: score,
                        distance: result.formattedDistance,
                        time: result.formattedTime,
                        accuracy: accuracyPercentage,
                        animate: $animateSummary
                    )
                    
                    ResultMapView(result: result)
                    
                    ActionButtonsView(
                        onPlayAgain: onPlayAgain,
                        onBackToStart: onBackToStart
                    )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 36)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateSummary = true
            }
        }
    }
}

private struct ResultBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 0.031, green: 0.035, blue: 0.089, alpha: 1)), Color(#colorLiteral(red: 0.1, green: 0.086, blue: 0.2, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.18))
                    .frame(width: 600, height: 600)
                    .offset(x: -160, y: -260)
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 540, height: 540)
                    .offset(x: 200, y: 240)
            }
            .blur(radius: 200)
        )
    }
}

#Preview {
    GameResultView(
        result: GameResult(
            distance: 1_200,
            formattedDistance: "1.2 km",
            actualLocation: Coordinates(latitude: 48.8566, longitude: 2.3522),
            guessedLocation: Coordinates(latitude: 48.863, longitude: 2.349),
            timeTaken: 87,
            formattedTime: "01:27"
        ),
        onPlayAgain: {},
        onBackToStart: {}
    )
    .preferredColorScheme(.dark)
}
