//
//  ResultMapView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI
import Core
import GameEngine
import LocationServices
import StartScreen
import MapKit

struct ResultMapView: View {
    let result: GameResult
    @State private var camera: MapCameraPosition
    
    init(result: GameResult) {
        self.result = result
        
        let coordinates = [
            result.guessedLocation,
            result.actualLocation
        ].map { CLLocationCoordinate2D(coordinates: $0) }
        
        let minLat = coordinates.map(\.latitude).min()!
        let maxLat = coordinates.map(\.latitude).max()!
        let minLon = coordinates.map(\.longitude).min()!
        let maxLon = coordinates.map(\.longitude).max()!
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.5, 0.01),
            longitudeDelta: max((maxLon - minLon) * 1.5, 0.01)
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        self._camera = State(initialValue: .region(region))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            
            Map(position: $camera) {
                Marker(
                    "Your Guess",
                    systemImage: "mappin.circle.fill",
                    coordinate: CLLocationCoordinate2D(coordinates: result.guessedLocation)
                )
                .tint(.blue)
                
                Marker(
                    "Actual Location",
                    systemImage: "flag.circle.fill",
                    coordinate: CLLocationCoordinate2D(coordinates: result.actualLocation)
                )
                .tint(.red)
                
                MapPolyline(
                    coordinates: [result.guessedLocation, result.actualLocation]
                        .map(CLLocationCoordinate2D.init(coordinates:)),
                    contourStyle: .straight
                )
                .stroke(.red, style: StrokeStyle(lineWidth: 3, dash: [5, 5]))
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
