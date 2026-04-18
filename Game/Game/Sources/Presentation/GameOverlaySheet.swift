import SwiftUI
@preconcurrency import MapKit

struct GameOverlaySheet: View {
    @State private var selectedDetent: PresentationDetent = Self.collapsedDetent
    @State private var cameraPosition: MapCameraPosition = .region(.init(.world))
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    private static let collapsedDetent = PresentationDetent.height(72)

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .sheet(isPresented: .constant(true)) {
                sheetContent
                    .presentationDetents(
                        [Self.collapsedDetent, .medium, .large],
                        selection: $selectedDetent
                    )
                    .presentationDragIndicator(
                        selectedDetent == Self.collapsedDetent ? .hidden
                        : .visible)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationBackground(Color(red: 0.97, green: 0.95, blue: 0.92))
                    .interactiveDismissDisabled()
                    .environment(\.colorScheme, .light)
            }
    }

    // MARK: - Sheet Content

    @ViewBuilder
    private var sheetContent: some View {
        if selectedDetent == Self.collapsedDetent {
            collapsedBar
                .onTapGesture {
                    selectedDetent = .medium
                }
        } else {
            expandedContent
        }
    }

    // MARK: - Collapsed Bar

    private var collapsedBar: some View {
        HStack(spacing: 14) {
            mapThumbnail

            VStack(alignment: .leading, spacing: 2) {
                Text("WHERE ARE YOU?")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color(white: 0.5))
                Text("Drop a pin")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(white: 0.15))
            }

            Spacer()

            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.red)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    private var mapThumbnail: some View {
        Image(systemName: "map.fill")
            .font(.title3)
            .foregroundStyle(.teal)
            .frame(width: 42, height: 42)
            .background(Color.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(spacing: 0) {
            expandedHeader
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

            mapContent
                .padding(.horizontal, 20)

            Spacer(minLength: 12)

            bottomAction
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
        .padding(.top)
    }

    private var expandedHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("TAP TO PLACE YOUR GUESS")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color(white: 0.5))
                Text("Where in the world?")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color(white: 0.15))
            }

            Spacer()

            Button {
                selectedDetent = Self.collapsedDetent
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(white: 0.4))
                    .frame(width: 28, height: 28)
                    .background(Color(white: 0.88), in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var mapContent: some View {
        
        MapReader { reader in
            Map(position: $cameraPosition) {
                if let selected = selectedCoordinate {
                    Annotation("", coordinate: selected, anchor: .bottom) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .simultaneousGesture(
                SpatialTapGesture()
                    .onEnded { event in
                        if let coordinate = reader.convert(event.location, from: .local) {
                            selectedCoordinate = coordinate
                        }
                    }
            )
        }
    }

    // MARK: - Bottom Action

    @ViewBuilder
    private var bottomAction: some View {
        if selectedCoordinate != nil {
            Button {
                // TODO: confirm guess
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.body.weight(.semibold))
                    Text("Confirm guess")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.85, green: 0.35, blue: 0.25), Color(red: 0.92, green: 0.45, blue: 0.2)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .foregroundStyle(.white)
                .shadow(color: Color(red: 0.85, green: 0.35, blue: 0.25).opacity(0.35), radius: 12, y: 6)
            }
            .buttonStyle(.plain)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .opacity
            ))
        } else {
            Label("Tap the map to select a position", systemImage: "scope")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color(white: 0.45))
                .transition(.opacity)
        }
    }
}

#Preview {
    GameOverlaySheet()
}
