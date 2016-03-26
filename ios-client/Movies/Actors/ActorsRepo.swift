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
            return parseSingleActor(actorJson)
        }

        return Result.Success(ActorList(actors: actorsArray))
    }

    private func parseSingleActor(json: AnyObject) -> Actor? {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String else
        {
            return nil
        }

        return Actor(id: id, name: name)
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
