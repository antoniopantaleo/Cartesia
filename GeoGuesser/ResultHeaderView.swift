//
//  ResultHeaderView.swift
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

struct ResultHeaderView: View {
    let score: Int
    @State private var animateScore = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
                .scaleEffect(animateScore ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatCount(3), value: animateScore)
            
            HStack(alignment: .lastTextBaseline) {
                Text("\(score)")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.yellow)
                
                Text("POINTS")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }

        .onAppear {
            animateScore = true
        }
    }
}
