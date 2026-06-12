public protocol GameRouter {
    func didCompleteRound(_ result: GameResult)
    func didLeaveRound()
}
