//
//  GameResultView.swift
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

struct GameResultView: View {
    let result: GameResult
    @EnvironmentObject var appState: AppState
    @State private var showingScore = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
        ScrollView {
            VStack(spacing: 30) {
                Spacer()
                
                ResultHeaderView(score: calculateScore())
                
                VStack(spacing: 20) {
                    ResultMapView(result: result)
                        .opacity(showingScore ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.3), value: showingScore)
                    
                    ResultStatsView(result: result)
                        .opacity(showingScore ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.5), value: showingScore)
                }
                
                Spacer()
                
                ActionButtonsView {
                    appState.startNewGame()
                } onBackToStart: {
                    appState.endGame()
                }
                .opacity(showingScore ? 1 : 0)
                .animation(.easeInOut(duration: 0.8).delay(1.0), value: showingScore)
                
                Spacer()
            }.padding()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        }
        .onAppear {
            showingScore = true
        }
    }
    
    private func calculateScore() -> Int {
        let maxDistance: Double = 20037.5
        let distanceRatio = min(result.distance / maxDistance, 1.0)
        let baseScore = max(0, Int(1000 * (1 - distanceRatio)))
        
        let timeBonus = max(0, Int(100 * max(0, 1 - result.timeTaken / 300)))
        
        return baseScore + timeBonus
    }
}
