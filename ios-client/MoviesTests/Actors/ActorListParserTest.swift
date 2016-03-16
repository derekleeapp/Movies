import XCTest
@testable import Movies

class ActorListParserTest: XCTestCase {

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

    func test_parseInvalidType_skipsInvalidActorJson() {
        let parser = ActorListParser()

        let actualActorList = parser.parse("{\"actors\":[{\"id\":\"one\",\"name\":\"Brad Pitt\"},{\"id\":2,\"name\":\"Sarah Silverman\"}]}".utf8EncodedData())

        XCTAssertEqual(actualActorList.value!.actors.count, 1)

        XCTAssertEqual(actualActorList.value!.actors.first?.id, 2)
        XCTAssertEqual(actualActorList.value!.actors.first?.name, "Sarah Silverman")
    }

    func test_parseIncompleteActorJson_skipsIncompleteActorJson() {
        let parser = ActorListParser()

        let actualActorList = parser.parse("{\"actors\":[{\"id\":1,\"name\":\"Brad Pitt\"},{\"id\":2}]}".utf8EncodedData())

        XCTAssertEqual(actualActorList.value!.actors.count, 1)

        XCTAssertEqual(actualActorList.value!.actors.first?.id, 1)
        XCTAssertEqual(actualActorList.value!.actors.first?.name, "Brad Pitt")
    }
    
}
