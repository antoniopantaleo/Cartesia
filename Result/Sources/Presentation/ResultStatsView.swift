import SwiftUI
import ResultInterface

struct ResultStatsView: View {
    let summary: RoundSummary
    let score: Int

    private var averageSpeed: String {
        guard summary.timeTaken > 0 else { return "\u{2013}" }
        let metersPerSecond = summary.distance / summary.timeTaken
        let kmPerHour = metersPerSecond * 3.6
        return String(format: "%.1f km/h", kmPerHour)
    }

    private var distanceKilometers: String {
        String(format: "%.2f km", summary.distance / 1_000)
    }

    private var accuracyPercentage: String {
        let maxDistance: Double = 20_037_500
        let ratio = max(0, 1 - min(summary.distance / maxDistance, 1.0))
        return String(format: "%.1f%%", ratio * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Round insights")
                .font(.headline)
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                StatCardView(
                    icon: "chart.bar.fill",
                    title: "Score",
                    value: score.formatted(),
                    detail: "Combined distance + time bonus",
                    color: .blue
                )
                StatCardView(
                    icon: "location.circle.fill",
                    title: "Distance",
                    value: distanceKilometers,
                    detail: summary.formattedDistance,
                    color: .purple
                )
                StatCardView(
                    icon: "target",
                    title: "Accuracy",
                    value: accuracyPercentage,
                    detail: "Closer is always better",
                    color: .green
                )
                StatCardView(
                    icon: "speedometer",
                    title: "Avg. speed",
                    value: averageSpeed,
                    detail: summary.formattedTime,
                    color: .orange
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let detail: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .padding(12)
                .background(color.opacity(0.3), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)

            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .tracking(1)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(color.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(color.opacity(0.35), lineWidth: 1)
        )
    }
}
