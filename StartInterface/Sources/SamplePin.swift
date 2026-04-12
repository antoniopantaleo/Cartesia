//
//  SamplePin.swift
//  Cartesia
//
//  Created by Antonio on 29/10/25.
//

import SwiftUI
import CoreLocation

public struct SamplePin: Identifiable {
    
    public let id = UUID()
    public let title: String
    public let coordinate: CLLocationCoordinate2D
    public let color: Color
    
    public init(title: String, coordinate: CLLocationCoordinate2D, color: Color) {
        self.title = title
        self.coordinate = coordinate
        self.color = color
    }
}
