//
//  GameViewModel.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import Foundation
@preconcurrency import MapKit

@Observable
@MainActor
final class GameViewModel: Sendable {
    
    let location = Coordinates(
        latitude: 35.6895,
        longitude: 139.6917
    )
    
    var cameraRegion: MKCoordinateRegion = .init(.world)
    var isGameRunning: Bool = true
    var scene: MKLookAroundScene?
    var fullscreen = true
    
    private(set) var measurement: String?
    
    init() {
        let request = MKLookAroundSceneRequest(
            coordinate: CLLocationCoordinate2D(coordinates: location)
        )
        Task.detached {
            let scene = try? await request.scene
            await MainActor.run { [weak self] in
                self?.scene = scene
            }
        }
    }
    
    func confirmPosition(_ coordinates: Coordinates) {
        isGameRunning = false
        let l1 = CLLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
        let l2 = CLLocation(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        let distance = l1.distance(from: l2)
        measurement = Measurement(value: distance, unit: UnitLength.meters).formatted()
    }
    
    func updateCamera(selectedLocation: Coordinates) {
        let coordinates = [
            selectedLocation,
            location
        ].map(CLLocationCoordinate2D.init(coordinates:))
        
        let minLat = coordinates.map(\.latitude).min()!
        let maxLat = coordinates.map(\.latitude).max()!
        let minLon = coordinates.map(\.longitude).min()!
        let maxLon = coordinates.map(\.longitude).max()!
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 2,
            longitudeDelta: (maxLon - minLon) * 2
        )

        cameraRegion = MKCoordinateRegion(center: center, span: span)
    }
}
