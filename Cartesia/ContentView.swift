//
//  ContentView.swift
//  GeoGuesser
//
//  Created by Antonio on 19/10/24.
//

import SwiftUI
import Presentation
import Start

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch appState.currentScreen {
        case .start:
                StartView(regions: []) {
                appState.startNewGame()
            }
        case .game:
            if let viewModel = appState.gameViewModel {
                GameView(
                    viewModel: viewModel,
                    onResult: { appState.showGameResult($0) }
                )
            }
        case .result(let result):
            GameResultView(
                result: result,
                onPlayAgain: appState.startNewGame,
                onBackToStart: appState.endGame
            )
        }
    }
}
