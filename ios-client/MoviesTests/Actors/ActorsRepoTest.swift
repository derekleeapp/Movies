import XCTest
import BrightFutures
@testable import Movies

class ActorsRepoTest: XCTestCase {

    let fakeHttp = FakeHttp()
    var actorsRepo: ActorsRepo!
    var promise: Promise<NSData, HttpError>!

    override func setUp() {
        self.actorsRepo = ActorsRepo(http: fakeHttp)

        self.promise = Promise<NSData, HttpError>()
        self.fakeHttp.get_returnValue = promise.future
    }

    func test_getAll_hitsCorrectEndpoint() {
        actorsRepo.getAll()

        XCTAssertEqual(fakeHttp.get_args, "/actors")
    }

    func test_getAll_returnsActorList() {
        let testExpectation = expectationWithDescription("")


        var actualActorList = ActorList(actors: [])
        actorsRepo.getAll()
            .onSuccess { value in
                actualActorList = value
                testExpectation.fulfill()
            }


        promise.success("{\"actors\":[{\"id\":1,\"name\":\"Brad Pitt\"},{\"id\":2,\"name\":\"Sarah Silverman\"}]}".dataUsingEncoding(NSUTF8StringEncoding)!)
        waitForExpectationsWithTimeout(0.1, handler: nil)

        XCTAssertEqual(actualActorList.actors.count, 2)
        XCTAssertEqual(actualActorList.actors.first?.name, "Brad Pitt")
        XCTAssertEqual(actualActorList.actors.last?.name, "Sarah Silverman")
    }

    func test_getAll_mapsHttpErrorToRepoError() {
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
