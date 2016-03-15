import XCTest
import BrightFutures
@testable import Movies

class ActorsRepoTest: XCTestCase {

    func testActorsRepo_hitsCorrectEndpoint() {
        let fakeHttp = FakeHttp()
        let actorsRepo = ActorsRepo(http: fakeHttp)

        actorsRepo.getAll()

        XCTAssertEqual(fakeHttp.get_args, "/actors")
    }

    func testActorsRepo_returnsActorName() {
        let fakeHttp = FakeHttp()
        let actorsRepo = ActorsRepo(http: fakeHttp)

        let promise = Promise<NSData, HttpError>()
        fakeHttp.get_returnValue = promise.future

        let testExpectation = expectationWithDescription("")


        var actualActorName = ""
        actorsRepo.getAll()
            .onSuccess { value in
                actualActorName = value
                testExpectation.fulfill()
            }

        promise.success("Joseph".dataUsingEncoding(NSUTF8StringEncoding)!)
        waitForExpectationsWithTimeout(0.01, handler: nil)

        XCTAssertEqual(actualActorName, "Joseph")
    }
}
