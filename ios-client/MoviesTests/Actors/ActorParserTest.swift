import XCTest
@testable import Movies

class ActorParserTest: XCTestCase {

    func test_parse_returnsActor() {
        let parser = ActorListParser()

        let actualActorList = parser.parse("{\"actors\":[{\"id\":1,\"name\":\"Brad Pitt\"},{\"id\":2,\"name\":\"Sarah Silverman\"}]}".utf8EncodedData())

        XCTAssertEqual(actualActorList.value!.actors.count, 2)
        XCTAssertEqual(actualActorList.value!.actors.first?.id, 1)
        XCTAssertEqual(actualActorList.value!.actors.first?.name, "Brad Pitt")

        XCTAssertEqual(actualActorList.value!.actors.last?.id, 2)
        XCTAssertEqual(actualActorList.value!.actors.last?.name, "Sarah Silverman")
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
