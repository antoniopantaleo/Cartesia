import SwiftUI
import MapKit
import GameInterface

public struct GameScreen: View {

    private let router: GameRouter
    @ObservedObject private var viewModel: GameViewModel

    public init(router: GameRouter, viewModel: GameViewModel) {
        self.router = router
        self.viewModel = viewModel
        UIViewController.swizzleViewWillAppear()
    }

    @ViewBuilder
    public var body: some View {
        switch viewModel.gameState {
        case .notStarted:
            PreparingPlaceholderView()
        case .loading:
            LoadingPlaceholderView()
        case .running:
            LookAroundView(
                scene: viewModel.scene,
                isNavigationEnabled: true,
                onConfirmGuess: { coordinates in
                    Task { @MainActor in
                        UIViewController.dismissLookAroundFullscreen()
                        await self.viewModel.confirmPosition(coordinates)
                        guard case let .completed(result) = self.viewModel.gameState else { return }
                        self.router.didCompleteRound(result)
                    }
                },
                onLeaveRound: {
                    UIViewController.dismissLookAroundFullscreen()
                    self.router.didLeaveRound()
                }
            )
            .ignoresSafeArea(.all, edges: .all)
            .colorScheme(.dark)
            .onAppear { UIViewController.armLookAroundAutoFullscreen() }
        case .completed:
            CompletingPlaceholderView()
        case .failed:
            SceneUnavailableView(
                onRetry: { Task { await viewModel.startNewGame() } },
                onLeave: { router.didLeaveRound() }
            )
        }
    }
}

// MARK: - Placeholders

private struct PreparingPlaceholderView: View {
    var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()
            Text("Preparing")
                .eyebrowStyle()
        }
        .environment(\.colorScheme, .light)
    }
}

private struct LoadingPlaceholderView: View {
    private static let captions = [
        "Packing the camera…",
        "Booking the flight…",
        "Unfolding the map…",
        "Sharpening pencils…"
    ]
    @State private var captionIndex = 0
    @State private var pulse = false

    var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 64, weight: .regular))
                    .foregroundStyle(PaperTheme.warmRed)
                    .symbolEffect(
                        .variableColor.iterative.reversing,
                        options: .repeating
                    )
                    .scaleEffect(pulse ? 1.04 : 0.98)
                    .animation(
                        .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                        value: pulse
                    )

                VStack(spacing: 8) {
                    Text("Finding a place")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(PaperTheme.inkPrimary)

                    Text(Self.captions[captionIndex])
                        .eyebrowStyle()
                        .id(captionIndex)
                        .transition(.blurReplace)
                }
            }
            .padding(.horizontal, 24)
        }
        .environment(\.colorScheme, .light)
        .onAppear { pulse = true }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1.6))
                withAnimation(.smooth(duration: 0.4)) {
                    captionIndex = (captionIndex + 1) % Self.captions.count
                }
            }
        }
    }
}

private struct SceneUnavailableView: View {
    let onRetry: () -> Void
    let onLeave: () -> Void

    var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 52, weight: .regular))
                    .foregroundStyle(PaperTheme.warmRed)

                VStack(spacing: 8) {
                    Text("Couldn't find a place to explore")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(PaperTheme.inkPrimary)
                        .multilineTextAlignment(.center)

                    Text("Check your connection and try again")
                        .eyebrowStyle()
                }

                VStack(spacing: 12) {
                    Button(action: onRetry) {
                        Label("Retry", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(PaperTheme.warmRed)
                            )
                    }
                    .buttonStyle(.plain)

                    Button(action: onLeave) {
                        Text("Return to home")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PaperTheme.inkSecondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 32)
        }
        .environment(\.colorScheme, .light)
    }
}

private struct CompletingPlaceholderView: View {
    @State private var appeared = false

    var body: some View {
        ZStack {
            PaperTheme.background.ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(PaperTheme.warmRed)
                    .symbolEffect(.bounce, options: .nonRepeating, value: appeared)

                Text("Round complete")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(PaperTheme.inkPrimary)
            }
        }
        .environment(\.colorScheme, .light)
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear { appeared = true }
    }
}
