import SwiftUI

struct TimerView: View {
    let startTime: Date?
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var elapsedTime: TimeInterval {
        guard let startTime = startTime else { return 0 }
        return currentTime.timeIntervalSince(startTime)
    }
    
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(.primary)
                .font(.system(size: 14))
            Text(formattedTime)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .contentTransition(.numericText(countsDown: true))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 3)
        .onReceive(timer) { time in
            currentTime = time
        }
        .onAppear {
            print("⏰ TimerView appeared with startTime: \(startTime?.description ?? "nil")")
        }
    }
}
