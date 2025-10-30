//
//  HeroSection.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI
import MapKit

struct HeroSection: View {
    let alias: String
    let regions: [MKCoordinateRegion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome back, \(alias)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Where will you drop a pin today?")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
            }
            
            HeroMapPreview(regions: regions)
                .frame(height: 200)
           
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.38), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    HeroSection(
        alias: "Test",
        regions: []
    )
}
#endif
