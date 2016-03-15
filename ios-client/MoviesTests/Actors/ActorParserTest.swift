import XCTest
@testable import Movies

class ActorParserTest: XCTestCase {

    func test_parse_returnsActor() {
        let parser = ActorParser()

        let result = parser.parse("{ \"name\": \"Joseph\" }".dataUsingEncoding(NSUTF8StringEncoding)!)

        XCTAssertEqual(result.value?.name, "Joseph")
    }

    func test_parse_handlesInvalidJson() {
        let parser = ActorParser()

        let result = parser.parse("{".dataUsingEncoding(NSUTF8StringEncoding)!)

        XCTAssertEqual(result.error, RepositoryError.FetchFailure)
    }

    func testActorsRepo_handlesInvalidValue() {
        let parser = ActorParser()

        let result = parser.parse("{ \"name\": 12345 }".dataUsingEncoding(NSUTF8StringEncoding)!)

        XCTAssertEqual(result.error, RepositoryError.FetchFailure)
    }

    func testActorsRepo_handlesInvalidKey() {
        let parser = ActorParser()

        let result = parser.parse("{ \"id\": \"12345\" }".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        XCTAssertEqual(result.error, RepositoryError.FetchFailure)
    }

}
