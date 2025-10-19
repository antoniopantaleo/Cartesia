//
//  GeoGuesserApp.swift
//  GeoGuesser
//
//  Created by Antonio on 19/10/24.
//

import SwiftUI
import UIKit
import GeoDomain
import GeoApplication
import GeoInfrastructure
import GeoPresentation

@main
struct GeoGuesserApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

@MainActor
class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .start
    @Published var gameViewModel: GameViewModel?
    
    private let locationService: LocationServiceProtocol
    private let gameEngine: GameEngineProtocol
    private let lookAroundService: LookAroundServiceProtocol
    
    init(
        locationService: LocationServiceProtocol = LocationService(),
        lookAroundService: LookAroundServiceProtocol = LookAroundService()
    ) {
        self.locationService = locationService
        self.lookAroundService = lookAroundService
        self.gameEngine = GameEngine(locationService: locationService)
        UIViewController.swizzleViewWillAppear()
    }
    
    func startNewGame() {
        let viewModel = GameViewModel(
            gameEngine: gameEngine,
            lookAroundService: lookAroundService
        )
        gameViewModel = viewModel
        currentScreen = .game
    }
    
    func endGame() {
        gameViewModel = nil
        currentScreen = .start
    }
    
    func showGameResult(_ result: GameResult) {
        currentScreen = .result(result)
    }
}

enum AppScreen: Equatable {
    case start
    case game
    case result(GameResult)

    static func == (lhs: AppScreen, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start), (.game, .game):
            return true
        case (.result(let lhsResult), .result(let rhsResult)):
            return lhsResult.distance == rhsResult.distance &&
                   lhsResult.timeTaken == rhsResult.timeTaken &&
                   lhsResult.actualLocation == rhsResult.actualLocation &&
                   lhsResult.guessedLocation == rhsResult.guessedLocation
        default:
            return false
        }
    }
}
