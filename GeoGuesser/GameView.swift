//
//  GameView.swift
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

struct GameView: View {
    @ObservedObject var gameSession: GameSession
    @EnvironmentObject var appState: AppState
    @State private var selected: Coordinates?
    @State private var camera: MapCameraPosition
    @State private var hiding = true
    
    init(gameSession: GameSession) {
        self.gameSession = gameSession
        self._camera = State(initialValue: .region(gameSession.viewModel.cameraRegion))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapReader { reader in
                Map(position: $camera) {
                    if let selected {
                        Annotation(
                            "Your guess",
                            coordinate: CLLocationCoordinate2D(coordinates: selected),
                            anchor: .bottom,
                            content: {
                                
                                VStack {
                                    Button("Confirm") {
                                        print("✨", "BUTTON PRESSED")
                                    }
                                        .buttonStyle(.borderedProminent)
                                        .highPriorityGesture(TapGesture().onEnded { /* consume tap to prevent map from receiving it */ })
                                    Pin()
                                        .frame(width: 50, height: 50)
                                }
                                .contentShape(Rectangle())
                                .highPriorityGesture(TapGesture().onEnded {
                                    Task {
                                                            await gameSession.viewModel.confirmPosition(selected)
                                    
                                                            if case .completed(let result) = gameSession.viewModel.gameState {
                                                                appState.showGameResult(result)
                                                            }
                                                        }
                                })
                            }
                        )
                    }
                }
                .onTapGesture { point in
                    guard let clLocationCoordinates = reader.convert(point, from: .local) else { return }
                    let coordinates = Coordinates(
                        latitude: clLocationCoordinates.latitude,
                        longitude: clLocationCoordinates.longitude
                    )
                    selected = coordinates
                }
            }
            
            HStack {
                Spacer()
                if gameSession.viewModel.isGameRunning {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            LookAroundView(
                                scene: $gameSession.viewModel.scene,
                                isNavigationEnabled: .constant(true),
                                fullscreen: $gameSession.viewModel.fullscreen,
                                onAppear: {
                                    print("✨", "appear")
                                }
                            )
                            .frame(
                                width: proxy.frame(in: .local).width,
                                height: proxy.frame(in: .local).height
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white, lineWidth: 2)
                            )
                            
                            Image(systemName: "map.fill")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                                .frame(
                                    width: proxy.frame(in: .local).width / 4,
                                    height: proxy.frame(in: .local).height
                                )
                                .background(.ultraThinMaterial)
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 20,
                                        bottomLeadingRadius: 20,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 0
                                    )
                                )
                                .opacity(hiding ? 1 : 0.5)
                                .blur(radius: hiding ? 0 : 5)

                                .onTapGesture {
                                    withAnimation {
                                        hiding.toggle()
                                    }
                                }
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding(.trailing, 10)
                    .offset(x: hiding ? 150 + 10 : 0)
                }
                
            }
        }
    }
}

#Preview {
    GameView(
        gameSession: GameSession(
            viewModel: GameViewModel(
                gameEngine: GameEngine(locationService: LocationService()),
                lookAroundService: LookAroundService()
            )
        )
    )
        .environmentObject(AppState())
}
