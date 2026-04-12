import SwiftUI
import StartInterface
import GameKit
import MapKit

public struct StartView: View {
    private let regions: [SamplePin]
    private let router: StartRouter
    @State private var alias = "Adventurer"
    
    public init(router: StartRouter, regions: [SamplePin]) {
        self.router = router
        self.regions = regions
    }
    
    private var appVersion: String? {
        let bundle = Bundle.main
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return nil
        }
        var appVersion = "v" + version
        if let buildNumber = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            appVersion += " (\(buildNumber))"
        }
        return appVersion
    }
    
    public var body: some View {
        ZStack {
            AnimatedGradientBackground()
            
            VStack(spacing: 28) {
                HeroSection(
                    alias: alias,
                    regions: regions
                )
                StartButton(action: router.startGame)
                Button {
                    router.howToPlay()
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text("How to play")
                                .fontWeight(.semibold)
                            Text("Learn the basics")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                        Text("?")
                            .font(.title.weight(.semibold))
                    }
                    .padding(.horizontal, 26)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        RoundedRectangle(cornerRadius: 23)
                            .foregroundStyle(.quinary)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 23)
                            .stroke(style: .init())
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: 23))
                .foregroundStyle(.primary)
                Spacer()
                if let appVersion {
                    Text(appVersion)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 24)
        }
        .task {
            refreshAlias()
            GKLocalPlayer.local.authenticateHandler = { _, _ in
                refreshAlias()
            }
        }
    }
    
    private func refreshAlias() {
        let trimmed = GKLocalPlayer.local.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        alias = trimmed.isEmpty ? "Adventurer" : trimmed
    }
}

// MARK: - Preview

#if DEBUG
import StartTesting
#Preview {
    StartView(router: FakeRouter(), regions: SamplePin.examples)
        .preferredColorScheme(.dark)
}
#endif
