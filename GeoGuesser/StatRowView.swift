//
//  StatRowView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

struct StatRowView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
                .frame(width: 30)
            
            Text(label)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }
}
