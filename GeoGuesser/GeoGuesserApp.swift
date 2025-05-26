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

@main
struct GeoGuesserApp: App {
    let viewModel: GameViewModel
    
    init() {
        UIViewController.swizzleViewWillAppear()
        
        let locationService = LocationService()
        let gameEngine = GameEngine(locationService: locationService)
        let lookAroundService = LookAroundService()
        
        self.viewModel = GameViewModel(
            gameEngine: gameEngine,
            lookAroundService: lookAroundService
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: viewModel
            )
        }
    }
}
