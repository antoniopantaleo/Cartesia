//
//  HeroMapPreview.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI
import MapKit

struct HeroMapPreview: View {
    let regions: [MKCoordinateRegion]
    @State private var currentRegion: MKCoordinateRegion?
    @State private var cameraPosition: MapCameraPosition
    @State private var currentIndex = 0
    
    init(regions: [MKCoordinateRegion]) {
        self.regions = regions
        self.currentRegion = regions.first
        _cameraPosition = State(initialValue: .region(.init(.world)))
        
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(regions, id: \.center.latitude) { region in
            
                Annotation("City", coordinate: region.center) {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 14, height: 14)
                        .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 2)
                }
            }
        }
        .mapStyle(.imagery(elevation: .realistic))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            LinearGradient(
                colors: [.clear, .black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        )
        .task {
            guard regions.count > 1 else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                currentIndex = (currentIndex + 1) % regions.count
                let nextRegion = regions[currentIndex]
                cameraPosition = .region(nextRegion)
            }
        }
        .animation(.bouncy, value: cameraPosition)
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    HeroMapPreview(regions: [])
}
#endif
