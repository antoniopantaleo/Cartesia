//
//  ResultHeaderView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI

struct ResultHeaderView: View {
    let score: Int
    let distance: String
    let time: String
    let accuracy: Double
    @Binding var animate: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(alignment: .top, spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.9), Color.orange.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 84, height: 84)
                        .shadow(color: .yellow.opacity(0.4), radius: 20, x: 0, y: 12)
                        .scaleEffect(animate ? 1.05 : 0.8)
                        .rotationEffect(.degrees(animate ? 0 : -40))
                        .animation(.spring(response: 0.7, dampingFraction: 0.5).delay(0.1), value: animate)
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Round complete")
                        .font(.title2.bold())
                    Text("You just added \(score.formatted()) points to your travel log.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            HStack(spacing: 16) {
                SummaryMetricView(value: score.formatted(), icon: "target")
                SummaryMetricView(value: distance, icon: "location.fill")
                SummaryMetricView(value: accuracyText, icon: "scope")
                SummaryMetricView(value: time, icon: "clock.fill")
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(#colorLiteral(red: 0.118, green: 0.141, blue: 0.294, alpha: 1)), Color(#colorLiteral(red: 0.086, green: 0.114, blue: 0.227, alpha: 1))],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
    }
    
    private var accuracyText: String {
        String(format: "%.1f%%", accuracy)
    }
}

private struct SummaryMetricView: View {
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                )
            
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ResultHeaderView(
        score: 8_420,
        distance: "1.2 km",
        time: "01:27",
        accuracy: 96.8,
        animate: .constant(true)
    )
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
