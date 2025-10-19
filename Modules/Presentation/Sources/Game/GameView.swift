//
//  GameView.swift
//  GeoGuesser
//
//  Created by Antonio on 10/10/25.
//

import SwiftUI
import Combine
import Domain
@preconcurrency import MapKit
import UIKit

public struct GameView: View {
    @ObservedObject private var viewModel: GameViewModel
    private let onResult: (GameResult) -> Void
    @State private var selectedCoordinates: Coordinates?
    @State private var cameraPosition: MapCameraPosition
    @State private var lookAroundExpanded = true
    @State private var isSubmittingGuess = false
    @State private var showInstructionBadge = true
    
    public init(
        viewModel: GameViewModel,
        onResult: @escaping (GameResult) -> Void
    ) {
        self.viewModel = viewModel
        self.onResult = onResult
        _cameraPosition = State(initialValue: .region(viewModel.cameraRegion))
    }
    
    public var body: some View {
        ZStack {
            mapLayer
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .overlay(alignment: .bottom) { bottomControls.padding(.bottom) }
        .overlay(alignment: .top) {
            VStack(spacing: 12) {
                if !viewModel.isLoading {
                    if showInstructionBadge, selectedCoordinates == nil {
                        InstructionBadge()
                            .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity))
                    }
                }
            }
            .padding(.top, 12)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.ultraThinMaterial)
                    )
            }
        }
        .onReceive(viewModel.$cameraRegion.dropFirst()) { region in
            cameraPosition = .region(region)
        }
        .onReceive(viewModel.$gameState.dropFirst()) { state in
            if case .running = state {
                withAnimation(.spring()) {
                    selectedCoordinates = nil
                    isSubmittingGuess = false
                }
            }
        }
        .task {
            guard showInstructionBadge else { return }
            try? await Task.sleep(for: .seconds(8))
            withAnimation(.easeInOut(duration: 0.4)) {
                showInstructionBadge = false
            }
        }
        .disabled(viewModel.isLoading)
    }
    
    private var mapLayer: some View {
        MapReader { reader in
            Map(position: $cameraPosition) {
                if let selected = selectedCoordinates {
                    Annotation(
                        "Your guess",
                        coordinate: CLLocationCoordinate2D(
                            latitude: selected.latitude,
                            longitude: selected.longitude
                        ),
                        anchor: .bottom
                    ) {
                        DropPinMarker()
                            .frame(width: 64, height: 64)
                    }
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .modifier(CompatibleTapGesture { point in
                guard let location = reader.convert(point, from: .local) else { return }
                dropPin(at: location)
            })
        }
    }
    
    private var topControls: some View {
        HStack(spacing: 12) {
            TimerView(startTime: viewModel.gameStartTime)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Round in progress")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Drop a pin where you think the scene is.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: recenterCamera) {
                Image(systemName: "scope")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }
    
    private var confBinging: Binding<Bool> {
        .init(
            get: { !lookAroundExpanded },
            set: { value in
                lookAroundExpanded = !value
            }
        )
    }
    
    private var bottomControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let selectedCoordinates {
                GuessConfirmationCard(
                    coordinates: selectedCoordinates,
                    isSubmitting: isSubmittingGuess,
                    isExpanded: confBinging,
                    confirmAction: confirmGuess,
                    clearAction: { withAnimation(.spring()) { self.selectedCoordinates = nil } }
                )
            }
            LookAroundPanel(
                scene: $viewModel.scene,
                isLoading: viewModel.isLoadingScene,
                isExpanded: $lookAroundExpanded
            )
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    private func dropPin(at coordinate: CLLocationCoordinate2D) {
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            lookAroundExpanded = false
            selectedCoordinates = coordinates
            showInstructionBadge = false
        }
    }
    
    private func recenterCamera() {
        withAnimation(.easeInOut(duration: 0.8)) {
            viewModel.focusCameraOnCurrentLocation()
        }
    }
    
    private func confirmGuess() {
        guard let guess = selectedCoordinates, !isSubmittingGuess else { return }
        Task {
            isSubmittingGuess = true
            await viewModel.confirmPosition(guess)
            isSubmittingGuess = false
            if case .completed(let result) = viewModel.gameState {
                onResult(result)
            }
        }
    }
}

private struct CompatibleTapGesture: ViewModifier {
    let action: (CGPoint) -> Void
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.simultaneousGesture(SpatialTapGesture().onEnded({ event in
                action(event.location)
            }))
        } else {
            content.onTapGesture { point in
                action(point)
                
            }
        }
    }
}

private struct InstructionBadge: View {
    var body: some View {
        Label("Tap the map to drop your guess", systemImage: "hand.tap.fill")
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 6)
    }
}

private struct GuessConfirmationCard: View {
    let coordinates: Coordinates
    let isSubmitting: Bool
    @Binding var isExpanded: Bool
    let confirmAction: () -> Void
    let clearAction: () -> Void
    
    @State private var name: String?
    @Namespace private var animation
    
    var body: some View {
        Group {
            if isExpanded {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Label(name ?? "...", systemImage: "mappin.and.ellipse")
                            .font(.headline)
                            .contentTransition(.interpolate)
                            .matchedGeometryEffect(id: "block", in: animation)
                        Spacer()
                        Button(action: clearAction) {
                            Text("Reset")
                                .font(.subheadline.weight(.semibold))
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    HStack(spacing: 24) {
                        coordinateItem(title: "Latitude", value: latitudeText)
                        coordinateItem(title: "Longitude", value: longitudeText)
                    }
                    .contentTransition(.numericText())
                    
                    Button(action: confirmAction) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(isSubmitting ? "Submitting…" : "Confirm guess")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryGuessButtonStyle(isLoading: isSubmitting))
                    .disabled(isSubmitting)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(maxWidth: 20, maxHeight: 20, alignment: .leading)
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .matchedGeometryEffect(id: "block", in: animation)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = true
                        }
                    }
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
        .onChange(of: coordinates) { 
            Task { await calculateName() }
        }
        .task { await calculateName() }
    }
    
    private func calculateName() async {
        if #available(iOS 26.0, *) {
            let location = CLLocation(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
            guard let request = MKReverseGeocodingRequest(location: location), let items = try? await request.mapItems, let cityName = items.first?.addressRepresentations?.cityName, !cityName.isEmpty else {
                return name = "Your guess"
            }
            name = cityName
        }
    }
    
    private var latitudeText: String {
        String(format: "%0.4f°", coordinates.latitude)
    }
    
    private var longitudeText: String {
        String(format: "%0.4f°", coordinates.longitude)
    }
    
    @ViewBuilder
    private func coordinateItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.monospaced())
        }
    }
}

private struct PrimaryGuessButtonStyle: ButtonStyle {
    let isLoading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(
                LinearGradient(
                    colors: [Color.green, Color.blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(isLoading ? 0.7 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed && !isLoading ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct LookAroundPanel: View {
    @Binding var scene: MKLookAroundScene?
    let isLoading: Bool
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(spacing: isExpanded ? 16 : 0) {
            HStack {
                Label("Immersive look around", systemImage: "viewfinder.circle")
                    .font(.headline)
                Spacer()
                Button(action: toggleExpanded) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(8)
                }
                .buttonStyle(.plain)
            }
            
            ZStack {
                if isLoading {
                    ProgressView("Loading scene…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if scene != nil {
                    LookAroundView(
                        scene: $scene,
                        isNavigationEnabled: .constant(true),
                        fullscreen: .constant(false),
                        onAppear: {}
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text("No street imagery available here.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: isExpanded ? 260 : 0)
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
    }
    
    private func toggleExpanded() {
        withAnimation(.easeInOut) {
            isExpanded.toggle()
        }
    }
}

#Preview {
    GameView(
        viewModel: GameViewModel(
            gameEngine: PreviewGameEngine(),
            lookAroundService: PreviewLookAroundService()
        ),
        onResult: { _ in }
    )
    .preferredColorScheme(.dark)
}

// MARK: - Preview Helpers

private final class PreviewGameEngine: GameEngineProtocol {
    var gameState: GameState = .running(startTime: .now)
    var currentLocation: Coordinates? = .init(latitude: 48.8584, longitude: 2.2945)
    
    func startNewGame() async {
        currentLocation = .init(latitude: 48.8584, longitude: 2.2945)
        gameState = .running(startTime: .now)
    }
    
    func submitGuess(_ coordinates: Coordinates) async {
        let result = GameResult(
            distance: 1_200,
            formattedDistance: "1.2 km",
            actualLocation: currentLocation ?? Coordinates(latitude: 48.8584, longitude: 2.2945),
            guessedLocation: coordinates,
            timeTaken: 87,
            formattedTime: "01:27"
        )
        gameState = .completed(result: result)
    }
    
    func resetGame() {
        gameState = .notStarted
        currentLocation = nil
    }
}

private final class PreviewLookAroundService: LookAroundServiceProtocol {
    func getScene(for coordinates: Coordinates) async throws -> Any? {
        nil
    }
}
