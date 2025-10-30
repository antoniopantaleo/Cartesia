//
//  SamplePin+Example.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import StartInterface
import CoreLocation

extension SamplePin {
    public static let examples: [SamplePin] = [
        SamplePin(
            title: "Paris",
            coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            color: .cyan
        ),
        SamplePin(
            title: "Sydney",
            coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            color: .orange
        ),
        SamplePin(
            title: "New York",
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            color: .pink
        ),
        SamplePin(
            title: "Tokyo",
            coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            color: .green
        )
    ]
}
