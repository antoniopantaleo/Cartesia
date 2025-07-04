import SwiftUI
import GameKit

public struct StartView: View {
    
    private let startGameAction: () -> Void
    @State private var isAnimating = false
    
    public init(startGameAction: @escaping () -> Void) {
        self.startGameAction = startGameAction
    }
    
    public var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                GameTitleView(isAnimating: $isAnimating)
                
                Spacer()
                
                PlayButtonView(action: startGameAction)
                
                Spacer()
                
                PlayerInfoView()
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
        .task {
            GKLocalPlayer.local.authenticateHandler = { _, error in
                print("✨", GKLocalPlayer.local.alias)
            }
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea(.container, edges: .all)
                .scaledToFill()
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

struct GameTitleView: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Text("GeoGuesser")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            Text("Explore the world and test your geography skills!")
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct PlayButtonView: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.title2)
                Text("Start Adventure")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }
    }
}

struct PlayerInfoView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading) {
                Text("Welcome, \(GKLocalPlayer.local.displayName)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Ready to explore?")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    StartView { }
}
