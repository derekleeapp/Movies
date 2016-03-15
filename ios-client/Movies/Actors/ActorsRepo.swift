import BrightFutures
import Foundation
import Result

struct Actor {
    var name: String
}

struct ActorList {
    var actors: [Actor]
}

enum ActorParserError: ErrorType {
    case MalformedData
}

struct ActorListParser {
    func parse(data: NSData) -> Result<ActorList, ActorParserError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            let actorDictionary = json as? [String: String],
            let actorName = actorDictionary["name"]
            else {
                return Result.Failure(ActorParserError.MalformedData)
        }

        let actor = Actor(name: actorName)

        return Result.Success(ActorList(actors: [actor]))
    }
}

struct ActorsRepo {
    let http: Http
    let parser = ActorListParser()

    func getAll() -> Future<ActorList, RepositoryError> {
        return http.get("/actors") // Future<NSData, HttpError>
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { (actorNameData) -> Result<ActorList, RepositoryError> in
                return self.parser.parse(actorNameData)
                    .mapError { _ in return RepositoryError.FetchFailure }
            }
    }
}
