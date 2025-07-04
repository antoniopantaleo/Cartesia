//
//  ContentView.swift
//  GeoGuesser
//
//  Created by Antonio on 19/10/24.
//

import SwiftUI
import MapKit
import Combine
import UIKit
import Core
import GameEngine
import LocationServices
import StartScreen

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch appState.currentScreen {
        case .start:
            StartView {
                appState.startNewGame()
            }
        case .game:
            if let gameSession = appState.gameSession {
                GameView(gameSession: gameSession)
                    .environmentObject(appState)
            }
        case .result(let result):
            GameResultView(result: result)
                .environmentObject(appState)
        }
    }
}

struct GameView: View {
    @ObservedObject var gameSession: GameSession
    @EnvironmentObject var appState: AppState
    @State private var selected: Coordinates?
    @State private var camera: MapCameraPosition
    
    init(gameSession: GameSession) {
        self.gameSession = gameSession
        self._camera = State(initialValue: .region(gameSession.viewModel.cameraRegion))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapReader { reader in
                Map(position: $camera) {
                    if let selected {
                        Marker(
                            "Your guess",
                            systemImage: "mappin",
                            coordinate: CLLocationCoordinate2D(coordinates: selected)
                        )
                        if let currentLocation = gameSession.viewModel.currentLocation {
                            MapPolyline(
                                coordinates: [selected, currentLocation]
                                    .map(CLLocationCoordinate2D.init(coordinates:)),
                                contourStyle: .straight
                            )
                            .stroke(.blue, lineWidth: 5)
                            Marker(
                                "Real location",
                                systemImage: "flag.pattern.checkered",
                                coordinate: CLLocationCoordinate2D(coordinates: currentLocation)
                            )
                        }
                    }
                }
                .onTapGesture { point in
                    guard let clLocationCoordinates = reader.convert(point, from: .local) else { return }
                    let coordinates = Coordinates(
                        latitude: clLocationCoordinates.latitude,
                        longitude: clLocationCoordinates.longitude
                    )
                    Task {
                        await gameSession.viewModel.confirmPosition(coordinates)
                        
                        if case .completed(let result) = gameSession.viewModel.gameState {
                            appState.showGameResult(result)
                        }
                    }
                    selected = coordinates
                }
                .onChange(of: selected) { _, newValue in
                    guard let newValue else { return }
                    withAnimation {
                        gameSession.viewModel.updateCamera(selectedLocation: newValue)
                        camera = .region(gameSession.viewModel.cameraRegion)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    VStack(spacing: 15) {
                        if gameSession.viewModel.isGameRunning {
                            LookAroundView(
                                scene: $gameSession.viewModel.scene,
                                isNavigationEnabled: .constant(true),
                                fullscreen: $gameSession.viewModel.fullscreen
                            )
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}


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

struct ResultMapView: View {
    let result: GameResult
    @State private var camera: MapCameraPosition
    
    init(result: GameResult) {
        self.result = result
        
        let coordinates = [
            result.guessedLocation,
            result.actualLocation
        ].map { CLLocationCoordinate2D(coordinates: $0) }
        
        let minLat = coordinates.map(\.latitude).min()!
        let maxLat = coordinates.map(\.latitude).max()!
        let minLon = coordinates.map(\.longitude).min()!
        let maxLon = coordinates.map(\.longitude).max()!
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.01)
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        self._camera = State(initialValue: .region(region))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            Map(position: $camera) {
                Marker(
                    "Your Guess",
                    systemImage: "mappin.circle.fill",
                    coordinate: CLLocationCoordinate2D(coordinates: result.guessedLocation)
                )
                .tint(.blue)
                
                Marker(
                    "Actual Location",
                    systemImage: "flag.circle.fill",
                    coordinate: CLLocationCoordinate2D(coordinates: result.actualLocation)
                )
                .tint(.red)
                
                MapPolyline(
                    coordinates: [result.guessedLocation, result.actualLocation]
                        .map(CLLocationCoordinate2D.init(coordinates:)),
                    contourStyle: .straight
                )
                .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [5, 5]))
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

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

struct StatRowView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
                .frame(width: 30)
            
            Text(label)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }
}

struct ActionButtonsView: View {
    let onPlayAgain: () -> Void
    let onBackToStart: () -> Void
    
    var body: some View {
            HStack(spacing: 20) {
                Button(action: onPlayAgain) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Play Again")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                    )
                }
                
                Button(action: onBackToStart) {
                    HStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray)
                    )
                }
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
