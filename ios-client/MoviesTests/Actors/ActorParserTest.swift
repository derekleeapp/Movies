import XCTest
@testable import Movies

class ActorParserTest: XCTestCase {

    func test_parse_returnsActor() {
        let parser = ActorListParser()

        let result = parser.parse("{ \"name\": \"Joseph\" }".utf8EncodedData())

        XCTAssertEqual(result.value?.actors.first?.name, "Joseph")
    }

    func test_parse_handlesInvalidJson() {
        let parser = ActorListParser()

        let result = parser.parse("{".utf8EncodedData())

        XCTAssertEqual(result.error, ActorParserError.MalformedData)
    }

    func testActorsRepo_handlesInvalidValue() {
        let parser = ActorListParser()

        let result = parser.parse("{ \"name\": 12345 }".utf8EncodedData())

        XCTAssertEqual(result.error, ActorParserError.MalformedData)
    }

    func testActorsRepo_handlesInvalidKey() {
        let parser = ActorListParser()

        let result = parser.parse("{ \"id\": \"12345\" }".utf8EncodedData())
        
        XCTAssertEqual(result.error, ActorParserError.MalformedData)
    }

}
