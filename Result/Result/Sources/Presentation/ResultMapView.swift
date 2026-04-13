import SwiftUI
import ResultInterface
import MapKit

struct ResultMapView: View {
    let summary: RoundSummary
    @State private var camera: MapCameraPosition

    init(summary: RoundSummary) {
        self.summary = summary

        let coordinates = [summary.guessedLocation, summary.actualLocation]

        let minLat = coordinates.map(\.latitude).min() ?? summary.actualLocation.latitude
        let maxLat = coordinates.map(\.latitude).max() ?? summary.actualLocation.latitude
        let minLon = coordinates.map(\.longitude).min() ?? summary.actualLocation.longitude
        let maxLon = coordinates.map(\.longitude).max() ?? summary.actualLocation.longitude

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
                    coordinate: summary.guessedLocation,
                    anchor: .bottom
                ) {
                    DropPinMarker()
                        .frame(width: 56, height: 56)
                }

                Annotation(
                    "Actual location",
                    coordinate: summary.actualLocation,
                    anchor: .bottom
                ) {
                    ActualLocationMarker()
                        .frame(width: 48, height: 48)
                }

                MapPolyline(
                    coordinates: [summary.guessedLocation, summary.actualLocation],
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
