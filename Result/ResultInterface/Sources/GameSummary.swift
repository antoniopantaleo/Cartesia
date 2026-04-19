public struct GameSummary {
    public let rounds: [RoundSummary]

    public init(rounds: [RoundSummary]) {
        self.rounds = rounds
    }

    public var totalScore: Int {
        rounds.reduce(0) { $0 + $1.score }
    }

    public var maxPossibleScore: Int {
        rounds.count * Scoring.maxRoundScore
    }
}
