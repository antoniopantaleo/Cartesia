//
//  GeoGuesserApp.swift
//  GeoGuesser
//
//  Created by Antonio on 19/10/24.
//

import SwiftUI
import Core
import GameEngine
import LocationServices
import StartScreen

@main
struct GeoGuesserApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        UIViewController.swizzleViewWillAppear()
    }
    
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
    @Published var gameSession: GameSession?
    
    private let locationService = LocationService()
    private let gameEngine: GameEngine
    private let lookAroundService = LookAroundService()
    
    init() {
        self.gameEngine = GameEngine(locationService: locationService)
    }
    
    func startNewGame() {
        let viewModel = GameViewModel(
            gameEngine: gameEngine,
            lookAroundService: lookAroundService
        )
        gameSession = GameSession(viewModel: viewModel)
        currentScreen = .game
    }
    
    func endGame() {
        gameSession = nil
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

class GameSession: ObservableObject {
    var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
}
