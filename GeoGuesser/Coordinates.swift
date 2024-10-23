//
//  Coordinates.swift
//  GeoGuesser
//
//  Created by Antonio on 09/05/25.
//

import Foundation

struct Coordinates: Equatable, Identifiable {
    var id: String { latitude.description + longitude.description }
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

import CoreLocation

extension CLLocationCoordinate2D {
    init(coordinates: Coordinates) {
        self = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
