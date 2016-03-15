import XCTest
@testable import Movies

class ActorsRepoTest: XCTestCase {

    func testActorsRepo_hitsCorrectEndpoint() {
        let fakeHttp = FakeHttp()

        let actorsRepo = ActorsRepo(http: fakeHttp)
        actorsRepo.getAll()

        XCTAssertEqual(fakeHttp.get_args, "/actors")
    }

}
