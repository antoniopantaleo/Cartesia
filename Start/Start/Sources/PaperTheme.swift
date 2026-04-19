import SwiftUI

enum PaperTheme {
    static let background = Color(red: 0.97, green: 0.95, blue: 0.92)
    static let inkPrimary = Color(white: 0.15)
    static let inkSecondary = Color(white: 0.50)
    static let inkHairline = Color(white: 0.85)
    static let warmRed = Color(red: 0.85, green: 0.35, blue: 0.25)
    static let warmOrange = Color(red: 0.92, green: 0.45, blue: 0.20)

    static let ctaGradient = LinearGradient(
        colors: [warmRed, warmOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    func eyebrowStyle() -> some View {
        font(.system(size: 10, weight: .semibold))
            .tracking(1.5)
            .textCase(.uppercase)
            .foregroundStyle(PaperTheme.inkSecondary)
    }
}
