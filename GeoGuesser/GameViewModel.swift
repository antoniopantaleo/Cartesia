//
//  GameViewModel.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import Foundation
@preconcurrency import MapKit
import Core
import GameEngine
import LocationServices
import Observation

@Observable
@MainActor
final class GameViewModel: Sendable {
    
    var cameraRegion: MKCoordinateRegion = .init(.world)
    var scene: MKLookAroundScene?
    var fullscreen = true
    
    private let gameEngine: GameEngineProtocol
    private let lookAroundService: LookAroundServiceProtocol
    
    var gameState: GameState { gameEngine.gameState }
    var currentLocation: Coordinates? { gameEngine.currentLocation }
    
    var isGameRunning: Bool {
        switch gameState {
        case .running: return true
        default: return false
        }
    }
    
    var gameStartTime: Date? {
        switch gameState {
        case .running(let startTime): return startTime
        default: return nil
        }
    }
    
    var measurement: String? {
        switch gameState {
        case .completed(let result): return result.formattedDistance
        default: return nil
        }
    }
    
    init(
        gameEngine: GameEngineProtocol,
        lookAroundService: LookAroundServiceProtocol
    ) {
        self.gameEngine = gameEngine
        self.lookAroundService = lookAroundService
        
        Task {
            await startNewGame()
        }
    }
    
    func startNewGame() async {
        await gameEngine.startNewGame()
        print("🎮 Game started, gameStartTime: \(gameStartTime?.description ?? "nil")")
        UIViewController.updateTimerStartTime(gameStartTime)
        await loadScene()
    }
    
    private func loadScene() async {
        guard let location = currentLocation else { return }
        
        do {
            let sceneResult = try await lookAroundService.getScene(for: location)
            scene = sceneResult as? MKLookAroundScene
        } catch {
            print("Failed to load scene: \(error)")
        }
    }
    
    func confirmPosition(_ coordinates: Coordinates) async {
        await gameEngine.submitGuess(coordinates)
        print("🎯 Game ended, clearing timer")
        UIViewController.updateTimerStartTime(nil)
        updateCamera(selectedLocation: coordinates)
    }
    
    func updateCamera(selectedLocation: Coordinates) {
        guard let actualLocation = currentLocation else { return }
        
        let coordinates = [
            selectedLocation,
            actualLocation
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
            latitudeDelta: (maxLat - minLat) * 2,
            longitudeDelta: (maxLon - minLon) * 2
        )

        cameraRegion = MKCoordinateRegion(center: center, span: span)
    }
}
