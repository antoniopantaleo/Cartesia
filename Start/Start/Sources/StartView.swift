import SwiftUI
import StartInterface

public struct StartView: View {
    private let regions: [SamplePin]
    private let router: StartRouter
    private let alias = "Adventurer"

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
            PaperBackground()

            VStack(spacing: 28) {
                HeroSection(alias: alias, regions: regions)

                Spacer(minLength: 12)

                VStack(spacing: 14) {
                    StartButton(action: router.startGame)

                    Button(action: router.howToPlay) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.subheadline)
                            Text("How to play")
                                .font(.subheadline.weight(.medium))
                        }
                    }
                    .buttonStyle(GhostButtonStyle())
                }

                if let appVersion {
                    Text(appVersion)
                        .font(.caption2)
                        .foregroundStyle(PaperTheme.inkSecondary.opacity(0.6))
                        .padding(.top, 4)
                }
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 24)
        }
        .environment(\.colorScheme, .light)
    }
}

#if DEBUG
import StartTesting
#Preview {
    StartView(router: FakeRouter(), regions: SamplePin.examples)
}
#endif
