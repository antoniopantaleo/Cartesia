//
//  HeroMapPreview.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI
import StartInterface
import MapKit

struct HeroMapPreview: View {
    let regions: [SamplePin]
    @State private var currentRegion: MKCoordinateRegion?
    @State private var cameraPosition: MapCameraPosition
    @State private var currentIndex = 0
    
    init(regions: [SamplePin]) {
        self.regions = regions
        let regions = regions.map { pin in
            MKCoordinateRegion(
                center: pin.coordinate,
                span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
        let initialRegion = regions.randomElement()
        self.currentRegion = initialRegion
        _cameraPosition = State(initialValue: .region(initialRegion ?? .init(.world)))
        
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(regions) { region in
                Annotation(region.title, coordinate: region.coordinate) {
                    Circle()
                        .fill(region.color)
                        .frame(width: 14, height: 14)
                }
            }
        }
        .mapStyle(.imagery(elevation: .flat))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .task {
            guard !regions.isEmpty else { return }
            while !Task.isCancelled {
                currentIndex = (currentIndex + 1) % regions.count
                let nextRegion = regions[currentIndex]
                let mkRegion = MKCoordinateRegion(
                    center: nextRegion.coordinate,
                    span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
                )
                cameraPosition = .region(mkRegion)
                try? await Task.sleep(for: .seconds(5))
            }
        }
        .animation(.easeInOut.speed(3), value: cameraPosition)
    }
}

#if DEBUG
import StartTesting
#Preview(traits: .sizeThatFitsLayout) {
    HeroMapPreview(regions: SamplePin.examples)
        .frame(width: 250, height: 300)
}
#endif
