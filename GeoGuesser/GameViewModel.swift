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

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var cameraRegion: MKCoordinateRegion = .init(.world)
    @Published var scene: MKLookAroundScene?
    @Published private(set) var gameState: GameState = .notStarted
    @Published private(set) var currentLocation: Coordinates?
    @Published private(set) var isLoadingScene = false

    private let gameEngine: GameEngineProtocol
    private let lookAroundService: LookAroundServiceProtocol

    var isGameRunning: Bool {
        if case .running = gameState { return true }
        return false
    }

    var gameStartTime: Date? {
        if case .running(let startTime) = gameState { return startTime }
        return nil
    }

    init(
        gameEngine: GameEngineProtocol,
        lookAroundService: LookAroundServiceProtocol
    ) {
        self.gameEngine = gameEngine
        self.lookAroundService = lookAroundService

        Task { [weak self] in
            await self?.startNewGame()
        }
    }

    func startNewGame() async {
        await gameEngine.startNewGame()
        await MainActor.run {
            gameState = gameEngine.gameState
            currentLocation = gameEngine.currentLocation
            cameraRegion = .init(.world)
        }

        await loadScene()
        await MainActor.run {
            focusCameraOnCurrentLocation()
        }
    }

    private func loadScene() async {
        guard let location = currentLocation else { return }

        await MainActor.run { isLoadingScene = true }
        do {
            let sceneResult = try await lookAroundService.getScene(for: location)
            await MainActor.run {
                scene = sceneResult as? MKLookAroundScene
            }
        } catch {
            await MainActor.run {
                scene = nil
            }
        }
        await MainActor.run { isLoadingScene = false }
    }

    func confirmPosition(_ coordinates: Coordinates) async {
        await gameEngine.submitGuess(coordinates)
        await MainActor.run {
            gameState = gameEngine.gameState
            updateCamera(selectedLocation: coordinates)
        }
    }

    func focusCameraOnCurrentLocation() {
        guard let location = currentLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
        let coordinate = CLLocationCoordinate2D(coordinates: location)
        cameraRegion = MKCoordinateRegion(center: coordinate, span: span)
    }

    func updateCamera(selectedLocation: Coordinates) {
        guard let actualLocation = currentLocation else { return }

        let coordinates = [selectedLocation, actualLocation]
            .map { CLLocationCoordinate2D(coordinates: $0) }

        let minLat = coordinates.map(\.latitude).min() ?? actualLocation.latitude
        let maxLat = coordinates.map(\.latitude).max() ?? actualLocation.latitude
        let minLon = coordinates.map(\.longitude).min() ?? actualLocation.longitude
        let maxLon = coordinates.map(\.longitude).max() ?? actualLocation.longitude

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.8, 0.1),
            longitudeDelta: max((maxLon - minLon) * 1.8, 0.1)
        )

        cameraRegion = MKCoordinateRegion(center: center, span: span)
    }
}
