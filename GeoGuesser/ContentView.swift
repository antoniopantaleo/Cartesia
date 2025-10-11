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
            if let viewModel = appState.gameViewModel {
                GameView(viewModel: viewModel)
                    .environmentObject(appState)
            }
        case .result(let result):
            GameResultView(result: result)
                .environmentObject(appState)
        }
    }
}
