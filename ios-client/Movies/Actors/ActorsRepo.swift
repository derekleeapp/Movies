import BrightFutures
import Foundation
import Result

struct Actor {
    var name: String
}

enum ActorParserError: ErrorType {
    case MalformedData
}

struct ActorParser {
    func parse(data: NSData) -> Result<Actor, ActorParserError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            let actorDictionary = json as? [String: String],
            let actorName = actorDictionary["name"]
            else {
                return Result.Failure(ActorParserError.MalformedData)
        }

        return Result.Success(Actor(name: actorName))
    }
}

struct ActorsRepo {
    let http: Http
    let parser = ActorParser()

    func getAll() -> Future<Actor, RepositoryError> {
        return http.get("/actors") // Future<NSData, HttpError>
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { (actorNameData) -> Result<Actor, RepositoryError> in
                return self.parser.parse(actorNameData)
                    .mapError { _ in return RepositoryError.FetchFailure }
            }
    }
}
