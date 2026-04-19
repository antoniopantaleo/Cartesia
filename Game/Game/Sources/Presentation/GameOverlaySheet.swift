import SwiftUI
import GameInterface
@preconcurrency import MapKit

protocol ReverseGeocodingProtocol {
    func getCityName(from coordinates: Coordinates) async throws -> String
}

struct FakeReverseGeocoding: ReverseGeocodingProtocol {
    func getCityName(from coordinates: Coordinates) async throws -> String {
        "Mocked"
    }
}

struct MKReverseGeocoding: ReverseGeocodingProtocol {
    func getCityName(from coordinates: Coordinates) async throws -> String {
        let location = CLLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
        if #available(iOS 26.0, *) {
            let request = MKReverseGeocodingRequest(location: location)
            let items = try await request?.mapItems
            return items?.first?.addressRepresentations?.cityName ?? "ERROR"
        } else {
            return ""
        }
    }
}

@Observable final class GameOverlaySheetViewModel {
    
    private let reverseGeocoder: ReverseGeocodingProtocol = MKReverseGeocoding()
    
    var selectedCoordinate: Coordinates?
    var selectedCityName: String?
    
    func didSelectCoordinate(_ coordinate: Coordinates) {
        selectedCoordinate = coordinate
        Task {
            selectedCityName = try? await reverseGeocoder
                .getCityName(from: coordinate)
        }
    }
}

struct GameOverlaySheet: View {
    @State private var selectedDetent: PresentationDetent = Self.collapsedDetent
    @State private var cameraPosition: MapCameraPosition = .region(.init(.world))
    @State private var viewModel = GameOverlaySheetViewModel()
    
    @Namespace private var hero

    private static let collapsedDetent = PresentationDetent.height(72)
    let didConfirmPosition: (Coordinates) -> ()

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .sheet(isPresented: .constant(true)) {
                sheetContent
                    .presentationDetents(
                        [Self.collapsedDetent, .medium, .large],
                        selection: $selectedDetent
                    )
                    .presentationDragIndicator(selectedDetent == Self.collapsedDetent ? .hidden : .visible)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationBackground(Color(red: 0.97, green: 0.95, blue: 0.92))
                    .interactiveDismissDisabled()
                    .environment(\.colorScheme, .light)
            }
    }

    // MARK: - Sheet Content

    @ViewBuilder
    private var sheetContent: some View {
        ViewThatFits(in: .vertical) {
            expandedContent
            VStack {
                collapsedBar
                Spacer()
            }
            .onTapGesture {
                selectedDetent = .medium
            }
        }
    }

    // MARK: - Collapsed Bar

    private var collapsedBar: some View {
        HStack(spacing: 14) {
            mapThumbnail

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.selectedCoordinate != nil ? "YOUR GUESS" : "WHERE ARE YOU?")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color(white: 0.5))
                    .matchedGeometryEffect(id: "guess", in: hero)
                Text(viewModel.selectedCityName ?? "Drop a pin")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(white: 0.15))
                    .matchedGeometryEffect(id: "city", in: hero)
            }
            .animation(.default, value: viewModel.selectedCityName)
            Spacer()

            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.red)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .contentShape(Capsule())
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
                Text(viewModel.selectedCityName == nil ? "TAP TO PLACE YOUR GUESS" : "YOUR GUESS")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Color(white: 0.5))
                    .matchedGeometryEffect(id: "guess", in: hero)
                Text(viewModel.selectedCityName ?? "Where in the world?")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color(white: 0.15))
                    .matchedGeometryEffect(id: "city", in: hero)
            }
            .contentTransition(.numericText())
            .animation(.default, value: viewModel.selectedCityName)

            Spacer()

            Button { selectedDetent = Self.collapsedDetent } label: {
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
                if let selected = viewModel.selectedCoordinate {
                    let cl = CLLocationCoordinate2D(
                        latitude: selected.latitude,
                        longitude: selected.longitude
                    )
                    Annotation("", coordinate: cl, anchor: .bottom) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                    }
                }
            }
            .onMapCameraChange { context in
                cameraPosition = .region(context.region)
            }
            .mapStyle(
                .hybrid(
                    elevation: .flat,
                    pointsOfInterest: .all,
                    showsTraffic: false
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .simultaneousGesture(
                SpatialTapGesture()
                    .onEnded { event in
                        if let coordinate = reader.convert(event.location, from: .local) {
                            let m = Coordinates(
                                latitude: coordinate.latitude,
                                longitude: coordinate.longitude
                            )
                            viewModel.didSelectCoordinate(m)
                        }
                    }
            )
        }
    }

    // MARK: - Bottom Action

    @ViewBuilder
    private var bottomAction: some View {
        if let selectedCoordinate = viewModel.selectedCoordinate {
            Button {
                let coordinates = Coordinates(
                    latitude: selectedCoordinate.latitude,
                    longitude: selectedCoordinate.longitude
                )
                didConfirmPosition(coordinates)
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
        } else {
            Label("Tap the map to select a position", systemImage: "scope")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color(white: 0.45))
                .transition(.opacity)
        }
    }
}

#Preview {
    GameOverlaySheet { _ in }
}
