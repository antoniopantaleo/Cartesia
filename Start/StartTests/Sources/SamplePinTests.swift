import Testing
import StartInterface
import StartTesting

struct SamplePinTests {

    @Test func examplePinsHaveUniqueIdentifiers() {
        let ids = SamplePin.examples.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func examplePinsAreNotEmpty() {
        #expect(!SamplePin.examples.isEmpty)
    }
}
