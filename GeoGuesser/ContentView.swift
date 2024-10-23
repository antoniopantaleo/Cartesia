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

struct ContentView: View {
    
    @State private var selected: Coordinates?
    @State private var camera: MapCameraPosition
    @State private var viewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        camera = .region(viewModel.cameraRegion)
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapReader { reader in
                Map(position: $camera) {
                    if let selected {
                        Marker(
                            "Your guess",
                            systemImage: "mappin",
                            coordinate: CLLocationCoordinate2D(coordinates: selected)
                        )
                        MapPolyline(
                            coordinates: [selected, viewModel.location]
                                .map(CLLocationCoordinate2D.init(coordinates:)),
                            contourStyle: .straight
                        )
                        .stroke(.blue, lineWidth: 5)
                        Marker(
                            "The real location",
                            systemImage: "flag.pattern.checkered",
                            coordinate: CLLocationCoordinate2D(coordinates: viewModel.location)
                        )
                    }
                }
                .onTapGesture { point in
                    guard let clLocationCoordinates = reader.convert(point, from: .local) else { return }
                    let coordinates = Coordinates(
                        latitude: clLocationCoordinates.latitude,
                        longitude: clLocationCoordinates.longitude
                    )
                    viewModel.confirmPosition(coordinates)
                    selected = coordinates
                }
                .onChange(of: selected) { _, newValue in
                    guard let newValue else { return }
                    withAnimation {
                        viewModel.updateCamera(selectedLocation: newValue)
                        camera = .region(viewModel.cameraRegion)
                    }
                }
            }
            
            LookAroundView(
                scene: $viewModel.scene,
                isNavigationEnabled: $viewModel.isGameRunning,
                fullscreen: $viewModel.fullscreen
            )
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .safeAreaPadding(.horizontal)
            .onAppear {
                viewModel.fullscreen = true
            }
        }
    }
    
}

#Preview {
    ContentView(
        viewModel: GameViewModel()
    )
}
