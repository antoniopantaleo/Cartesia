import SwiftUI
import StartInterface
import MapKit

struct HeroMapPreview: View {
    let regions: [SamplePin]
    @State private var cameraPosition: MapCameraPosition
    @State private var currentIndex = 0

    init(regions: [SamplePin]) {
        self.regions = regions
        let mkRegions = regions.map { pin in
            MKCoordinateRegion(
                center: pin.coordinate,
                span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
        let initialRegion = mkRegions.randomElement()
        _cameraPosition = State(initialValue: .region(initialRegion ?? .init(.world)))
    }

    var body: some View {
        Map(position: $cameraPosition, interactionModes: []) {
            ForEach(regions) { region in
                Annotation(region.title, coordinate: region.coordinate) {
                    Circle()
                        .fill(PaperTheme.warmRed)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
        .colorMultiply(Color(white: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(PaperTheme.inkHairline, lineWidth: 1)
        )
        .task {
            guard !regions.isEmpty else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                currentIndex = (currentIndex + 1) % regions.count
                let next = regions[currentIndex]
                let mkRegion = MKCoordinateRegion(
                    center: next.coordinate,
                    span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
                )
                withAnimation(.easeInOut(duration: 1.2)) {
                    cameraPosition = .region(mkRegion)
                }
            }
        }
    }
}

#if DEBUG
import StartTesting
#Preview(traits: .sizeThatFitsLayout) {
    HeroMapPreview(regions: SamplePin.examples)
        .frame(width: 280, height: 360)
        .padding()
        .background(PaperTheme.background)
}
#endif
