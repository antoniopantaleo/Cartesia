import ResultInterface

struct GameSession {
    static let roundsPerGame = 5

    private(set) var rounds: [RoundSummary] = []

    var currentRoundNumber: Int {
        rounds.count + 1
    }

    var isComplete: Bool {
        rounds.count >= Self.roundsPerGame
    }

    var summary: GameSummary {
        GameSummary(rounds: rounds)
    }

    mutating func record(_ summary: RoundSummary) {
        rounds.append(summary)
    }
}
