import Foundation
@preconcurrency import MapKit
import GameInterface

public final class GameViewModel: ObservableObject {
    @Published public private(set) var cameraRegion: MKCoordinateRegion = .init(.world)
    @Published public var scene: MKLookAroundScene?
    @Published public private(set) var gameState: GameState = .notStarted
    @Published public private(set) var currentLocation: Coordinates?
    @Published public private(set) var isLoadingScene = false
    @Published public private(set) var isLoading = true

    private let gameEngine: GameEngineProtocol
    private let lookAroundService: LookAroundServiceProtocol

    public var isGameRunning: Bool {
        if case .running = gameState { return true }
        return false
    }

    public var gameStartTime: Date? {
        if case .running(let startTime) = gameState { return startTime }
        return nil
    }

    public init(
        gameEngine: GameEngineProtocol,
        lookAroundService: LookAroundServiceProtocol
    ) {
        self.gameEngine = gameEngine
        self.lookAroundService = lookAroundService

        Task { [weak self] in
            await self?.startNewGame()
        }
    }

    public func startNewGame() async {
        isLoading = true
        defer { isLoading = false }
        await gameEngine.startNewGame()
        gameState = gameEngine.gameState
        currentLocation = gameEngine.currentLocation
        cameraRegion = .init(.world)

        await loadScene()
    }

    private func loadScene() async {
        guard let location = currentLocation else { return }
        isLoadingScene = true
        do {
            let sceneResult = try await lookAroundService.getScene(for: location)
            scene = sceneResult as? MKLookAroundScene
        } catch {
            scene = nil
        }
        isLoadingScene = false
    }

    public func confirmPosition(_ coordinates: Coordinates) async {
        await gameEngine.submitGuess(coordinates)
        gameState = gameEngine.gameState
        updateCamera(selectedLocation: coordinates)
    }

    public func focusCameraOnCurrentLocation() {
        guard let location = currentLocation else { return }
        let span = MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
        let coordinate = CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
        cameraRegion = MKCoordinateRegion(center: coordinate, span: span)
    }

    public func updateCamera(selectedLocation: Coordinates) {
        guard let actualLocation = currentLocation else { return }

        let coordinates = [selectedLocation, actualLocation]
            .map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }

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
