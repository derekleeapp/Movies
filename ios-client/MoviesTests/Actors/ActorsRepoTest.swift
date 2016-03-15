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


        var actualActor = Actor(name: "")
        actorsRepo.getAll()
            .onSuccess { value in
                actualActor = value
                testExpectation.fulfill()
            }

        promise.success("Joseph".dataUsingEncoding(NSUTF8StringEncoding)!)
        waitForExpectationsWithTimeout(0.01, handler: nil)

        XCTAssertEqual(actualActor.name, "Joseph")
    }

    func testActorsRepo_mapsHttpErrorToRepoError() {
        let fakeHttp = FakeHttp()
        let actorsRepo = ActorsRepo(http: fakeHttp)

        let promise = Promise<NSData, HttpError>()
        fakeHttp.get_returnValue = promise.future

        let testExpectation = expectationWithDescription("")

        var actualError: RepositoryError?
        actorsRepo.getAll()
            .onFailure { error in
                actualError = error
                testExpectation.fulfill()
        }

        promise.failure(HttpError.BadRequest)
        waitForExpectationsWithTimeout(0.01, handler: nil)

        XCTAssertEqual(actualError, RepositoryError.FetchFailure)
    }
}
