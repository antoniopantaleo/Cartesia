//
//  StartButton.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI

struct StartButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start exploration")
                        .font(.title3.weight(.semibold))
                    Text("Five rounds · New itinerary every game")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(PrimaryCTAButtonStyle())
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    StartButton {}
}
#endif
