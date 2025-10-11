//
//  ResultMapView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI
import Core
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
        
        let minLat = coordinates.map(\.latitude).min() ?? result.actualLocation.latitude
        let maxLat = coordinates.map(\.latitude).max() ?? result.actualLocation.latitude
        let minLon = coordinates.map(\.longitude).min() ?? result.actualLocation.longitude
        let maxLon = coordinates.map(\.longitude).max() ?? result.actualLocation.longitude
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.8, 0.04),
            longitudeDelta: max((maxLon - minLon) * 1.8, 0.04)
        )
        
        let region = MKCoordinateRegion(center: center, span: span)
        _camera = State(initialValue: .region(region))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How close you were")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Map(position: $camera) {
                Annotation(
                    "Your guess",
                    coordinate: CLLocationCoordinate2D(coordinates: result.guessedLocation),
                    anchor: .bottom
                ) {
                    DropPinMarker()
                        .frame(width: 56, height: 56)
                }
                
                Annotation(
                    "Actual location",
                    coordinate: CLLocationCoordinate2D(coordinates: result.actualLocation),
                    anchor: .bottom
                ) {
                    ActualLocationMarker()
                        .frame(width: 48, height: 48)
                }
                
                MapPolyline(
                    coordinates: [result.guessedLocation, result.actualLocation]
                        .map(CLLocationCoordinate2D.init(coordinates:)),
                    contourStyle: .straight
                )
                .stroke(
                    LinearGradient(
                        colors: [Color.cyan, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 4, dash: [6, 8])
                )
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct LegendItem: View {
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(title)
        }
    }
}

private struct ActualLocationMarker: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.red, Color.orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 40, height: 46)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 6)
            Image(systemName: "flag.fill")
                .font(.title3.bold())
                .foregroundStyle(.white)
        }
        .overlay(
            Circle()
                .fill(Color.black.opacity(0.25))
                .frame(width: 18, height: 6)
                .offset(y: 28)
        )
    }
}

#Preview {
    ResultMapView(
        result: GameResult(
            distance: 8_500,
            formattedDistance: "8.5 km",
            actualLocation: Coordinates(latitude: 40.7128, longitude: -74.0060),
            guessedLocation: Coordinates(latitude: 40.68, longitude: -73.9),
            timeTaken: 110,
            formattedTime: "01:50"
        )
    )
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
