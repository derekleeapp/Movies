import BrightFutures
import Foundation
import Result

struct Actor {
    var id: Int
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
            let actorListDictionary = json as? [String: AnyObject],
            let actorJsonArray = actorListDictionary["actors"] as? [AnyObject]
            else {
                return Result.Failure(ActorParserError.MalformedData)
        }

        let actorsArray: [Actor] = actorJsonArray.flatMap { actorJson in
            guard
                let id = actorJson["id"] as? Int,
                let name = actorJson["name"] as? String else
            {
                return nil
            }

            return Actor(id: id, name: name)
        }

        return Result.Success(ActorList(actors: actorsArray))
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
