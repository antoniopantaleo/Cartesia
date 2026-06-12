import SwiftUI
import ResultInterface
import MapKit

struct ResultMapView: View {
    let summary: RoundSummary
    let distanceCaption: String
    @State private var camera: MapCameraPosition
    @State private var lineProgress: CGFloat = 0

    init(summary: RoundSummary, distanceCaption: String) {
        self.summary = summary
        self.distanceCaption = distanceCaption

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
        _camera = State(initialValue: .region(MKCoordinateRegion(center: center, span: span)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("How close you were")
                    .eyebrowStyle()
                Spacer()
            }

            Map(position: $camera, interactionModes: [.pan, .zoom]) {
                Annotation("Your guess", coordinate: summary.guessedLocation, anchor: .center) {
                    GuessMarker()
                }

                Annotation("Actual", coordinate: summary.actualLocation, anchor: .center) {
                    ActualMarker()
                }

                MapPolyline(
                    coordinates: [summary.guessedLocation, summary.actualLocation],
                    contourStyle: .geodesic
                )
                .stroke(
                    PaperTheme.warmRed.opacity(0.85),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [6, 5])
                )
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
            .colorMultiply(Color(white: 0.96))
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(PaperTheme.inkHairline, lineWidth: 1)
            )

            Text(distanceCaption)
                .font(.subheadline)
                .foregroundStyle(PaperTheme.inkSecondary)
        }
    }
}

private struct ActualMarker: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(PaperTheme.warmRed)
                .frame(width: 24, height: 24)
                .shadow(color: PaperTheme.warmRed.opacity(0.4), radius: 6, y: 2)
            Image(systemName: "mappin")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
        }
    }
}

private struct GuessMarker: View {
    var body: some View {
        Circle()
            .stroke(PaperTheme.inkPrimary, lineWidth: 2)
            .background(Circle().fill(PaperTheme.background))
            .frame(width: 22, height: 22)
            .overlay(
                Circle()
                    .fill(PaperTheme.inkPrimary)
                    .frame(width: 6, height: 6)
            )
    }
}
