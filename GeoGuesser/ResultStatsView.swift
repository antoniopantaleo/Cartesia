//
//  ResultStatsView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI
import Core
import GameEngine
import LocationServices
import StartScreen
import MapKit

struct ResultStatsView: View {
    let result: GameResult
    
    var body: some View {
        VStack(spacing: 20) {
            StatRowView(
                icon: "location.fill",
                label: "Distance",
                value: result.formattedDistance,
                color: .red
            )
            
            StatRowView(
                icon: "clock.fill",
                label: "Time",
                value: result.formattedTime,
                color: .blue
            )
            
            StatRowView(
                icon: "target",
                label: "Accuracy",
                value: accuracyText,
                color: .green
            )
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var accuracyText: String {
        let maxDistance: Double = 20037.5
        let accuracy = max(0, (1 - result.distance / maxDistance) * 100)
        return String(format: "%.1f%%", accuracy)
    }
}
