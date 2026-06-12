import Testing
@testable import Game

struct LocationServiceTests {

    @Test func curatedListIsLargeEnough() {
        #expect(CuratedLocations.all.count >= 100)
    }

    @Test func curatedListHasNoDuplicateCoordinates() {
        let ids = CuratedLocations.all.map(\.coordinates.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func dealsEveryLocationWithoutRepetition() async {
        let service = LocationService()
        var seen = Set<String>()
        for _ in 0..<CuratedLocations.all.count {
            let coordinates = await service.generateRandomLocation()
            seen.insert(coordinates.id)
        }
        #expect(seen.count == CuratedLocations.all.count)
    }

    @Test func refillsDeckAfterExhaustion() async {
        let service = LocationService()
        for _ in 0...(CuratedLocations.all.count) {
            _ = await service.generateRandomLocation()
        }
        // Drawing past the deck size refills it instead of crashing.
        let coordinates = await service.generateRandomLocation()
        #expect(CuratedLocations.all.contains { $0.coordinates == coordinates })
    }
}
