import SwiftUI

struct PaperBackground: View {
    var body: some View {
        ZStack {
            PaperTheme.background
                .ignoresSafeArea()

            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(PaperTheme.warmOrange.opacity(0.10))
                        .frame(width: proxy.size.width * 0.9)
                        .offset(x: -proxy.size.width * 0.3, y: -proxy.size.height * 0.25)
                        .blur(radius: 80)

                    Circle()
                        .fill(PaperTheme.warmRed.opacity(0.08))
                        .frame(width: proxy.size.width * 0.7)
                        .offset(x: proxy.size.width * 0.35, y: proxy.size.height * 0.35)
                        .blur(radius: 90)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#if DEBUG
#Preview {
    PaperBackground()
}
#endif
