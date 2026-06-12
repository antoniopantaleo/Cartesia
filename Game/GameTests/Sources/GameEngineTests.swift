import Testing
import Game
import GameInterface
import GameTesting

struct GameEngineTests {

    private let locations = [
        Coordinates(latitude: 1, longitude: 1),
        Coordinates(latitude: 2, longitude: 2),
        Coordinates(latitude: 3, longitude: 3),
        Coordinates(latitude: 4, longitude: 4)
    ]

    @Test func startsRunningWhenFirstLocationHasCoverage() async {
        let locationService = FakeLocationService(locations: locations)
        let lookAroundService = FakeLookAroundService(coverageResults: [true])
        let engine = GameEngine(locationService: locationService, lookAroundService: lookAroundService)

        await engine.startNewGame()

        guard case .running(let location, _) = engine.gameState else {
            Issue.record("Expected running state, got \(engine.gameState)")
            return
        }
        #expect(location == locations[0])
        #expect(locationService.generateCallCount == 1)
    }

    @Test func retriesWithNewLocationsUntilCoverageIsFound() async {
        let locationService = FakeLocationService(locations: locations)
        let lookAroundService = FakeLookAroundService(coverageResults: [false, false, true])
        let engine = GameEngine(locationService: locationService, lookAroundService: lookAroundService)

        await engine.startNewGame()

        guard case .running(let location, _) = engine.gameState else {
            Issue.record("Expected running state, got \(engine.gameState)")
            return
        }
        #expect(location == locations[2])
        #expect(locationService.generateCallCount == 3)
        #expect(lookAroundService.requestedCoordinates == Array(locations.prefix(3)))
    }

    @Test func failsWhenNoLocationHasCoverage() async {
        let locationService = FakeLocationService(locations: locations)
        let lookAroundService = FakeLookAroundService(coverageResults: [])
        let engine = GameEngine(locationService: locationService, lookAroundService: lookAroundService)

        await engine.startNewGame()

        guard case .failed = engine.gameState else {
            Issue.record("Expected failed state, got \(engine.gameState)")
            return
        }
        #expect(locationService.generateCallCount == 4)
        #expect(engine.currentLocation == nil)
    }

    @Test func submittingGuessCompletesRoundWithDistance() async {
        let locationService = FakeLocationService(locations: locations)
        locationService.stubbedDistance = 1_200
        let lookAroundService = FakeLookAroundService(coverageResults: [true])
        let engine = GameEngine(locationService: locationService, lookAroundService: lookAroundService)

        await engine.startNewGame()
        await engine.submitGuess(Coordinates(latitude: 9, longitude: 9))

        guard case .completed(let result) = engine.gameState else {
            Issue.record("Expected completed state, got \(engine.gameState)")
            return
        }
        #expect(result.distance == 1_200)
        #expect(result.actualLocation == locations[0])
        #expect(result.guessedLocation == Coordinates(latitude: 9, longitude: 9))
    }

    @Test func retryAfterFailureStartsFreshAttempts() async {
        let locationService = FakeLocationService(locations: locations)
        let lookAroundService = FakeLookAroundService(coverageResults: [])
        let engine = GameEngine(locationService: locationService, lookAroundService: lookAroundService)

        await engine.startNewGame()
        lookAroundService.coverageResults = [true]
        await engine.startNewGame()

        guard case .running = engine.gameState else {
            Issue.record("Expected running state after retry, got \(engine.gameState)")
            return
        }
    }
}
