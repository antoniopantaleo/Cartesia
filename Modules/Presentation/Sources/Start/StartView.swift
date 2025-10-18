import SwiftUI
import GameKit
import MapKit

public struct StartView: View {
    private let startGameAction: () -> Void
    @State private var alias = "Adventurer"
    @State private var isAnimating = false
    
    private let spotlightRegions: [MKCoordinateRegion] = [
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
        )
    ]
    
    public init(startGameAction: @escaping () -> Void) {
        self.startGameAction = startGameAction
    }
    
    public var body: some View {
            ZStack {
                AnimatedGradientBackground(isAnimating: $isAnimating)
                
                VStack(spacing: 28) {
                    HeroSection(alias: alias, regions: spotlightRegions)
                    StartButton(action: startGameAction)
                    Button("How to play") {
                        
                    }
                    .padding(.horizontal, 26)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(style: .init())
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 23))
                    Spacer()
                    PlayerFooter(alias: alias)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                
            }
        .task {
            refreshAlias()
            GKLocalPlayer.local.authenticateHandler = { _, _ in
                refreshAlias()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
    
    private func refreshAlias() {
        let trimmed = GKLocalPlayer.local.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        alias = trimmed.isEmpty ? "Adventurer" : trimmed
    }
}

private struct AnimatedGradientBackground: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 0.066, green: 0.058, blue: 0.118, alpha: 1)), Color(#colorLiteral(red: 0.047, green: 0.094, blue: 0.2, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.25))
                    .frame(width: 600, height: 600)
                    .offset(x: isAnimating ? -120 : -40, y: isAnimating ? -200 : -120)
                
                Circle()
                    .fill(Color.purple.opacity(0.22))
                    .frame(width: 520, height: 520)
                    .offset(x: isAnimating ? 150 : 60, y: isAnimating ? 220 : 140)
            }
            .blur(radius: 160)
        )
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: isAnimating)
    }
}

private struct HeroSection: View {
    let alias: String
    let regions: [MKCoordinateRegion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome back, \(alias)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Text("Where will you drop a pin today?")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
            }
            
            HeroMapPreview(regions: regions)
                .frame(height: 200)
           
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.38), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
    }
}

private struct HeroMapPreview: View {
    let regions: [MKCoordinateRegion]
    @State private var currentRegion: MKCoordinateRegion?
    @State private var cameraPosition: MapCameraPosition
    @State private var currentIndex = 0
    
    init(regions: [MKCoordinateRegion]) {
        self.regions = regions
        self.currentRegion = regions.first
        _cameraPosition = State(initialValue: .region(.init(.world)))
        
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(regions, id: \.center.latitude) { region in
            
                Annotation("City", coordinate: region.center) {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 14, height: 14)
                        .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 2)
                }
            }
        }
        .mapStyle(.imagery(elevation: .realistic))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            LinearGradient(
                colors: [.clear, .black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        )
        .task {
            guard regions.count > 1 else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                currentIndex = (currentIndex + 1) % regions.count
                let nextRegion = regions[currentIndex]
                cameraPosition = .region(nextRegion)
            }
        }
        .animation(.bouncy, value: cameraPosition)
    }
}

private struct SamplePin: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let color: Color
    
    static let examples: [SamplePin] = [
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

private struct FeatureHighlights: View {
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private let features = FeatureItem.examples
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(features) { feature in
                FeatureTile(feature: feature)
            }
        }
    }
}

private struct FeatureItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color
    
    static let examples: [FeatureItem] = [
        FeatureItem(
            title: "Immersive scenes",
            subtitle: "Dive into 360º street imagery with one tap.",
            icon: "viewfinder.circle.fill",
            tint: .blue
        ),
        FeatureItem(
            title: "Adaptive rounds",
            subtitle: "Tailored difficulty keeps each guess rewarding.",
            icon: "sparkles",
            tint: .purple
        ),
        FeatureItem(
            title: "Speed bonuses",
            subtitle: "Race the clock to climb the global leaderboard.",
            icon: "bolt.fill",
            tint: .orange
        ),
        FeatureItem(
            title: "Travel log",
            subtitle: "Track every pin you drop around the globe.",
            icon: "map.fill",
            tint: .green
        )
    ]
}

private struct FeatureTile: View {
    let feature: FeatureItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: feature.icon)
                .font(.title2)
                .foregroundStyle(feature.tint)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(feature.tint.opacity(0.16))
                )
            
            Text(feature.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(feature.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(feature.tint.opacity(0.25), lineWidth: 1)
        )
    }
}

private struct StartButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start exploration")
                        .font(.title3.weight(.semibold))
                    Text("Five rounds · New itinerary every game")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
        }
        .buttonStyle(PrimaryCTAButtonStyle())
    }
}

private struct PrimaryCTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 26)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color.blue.opacity(0.45), radius: 18, x: 0, y: 14)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct PlayerFooter: View {
    let alias: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.4))
            
            Label("Signed in as \(alias)", systemImage: "person.crop.circle.fill")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
            
            Text("Complete five rounds to unlock the weekly World Tour challenge.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    StartView { }
        .preferredColorScheme(.dark)
}

#Preview("Hero Map", traits: .sizeThatFitsLayout) {
    HeroMapPreview(regions: [
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
            span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        ),
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            span: MKCoordinateSpan(latitudeDelta: 18, longitudeDelta: 18)
        )
    ])
    .frame(width: 300, height: 300)
}
