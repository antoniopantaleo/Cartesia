//
//  ActionButtonsView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

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
