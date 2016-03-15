import BrightFutures
import Foundation
import Result

struct Actor {
    var name: String
}

struct ActorsRepo {
    let http: Http

    func getAll() -> Future<Actor, RepositoryError> {
        return http.get("/actors") // Future<NSData, HttpError>
            .flatMap { (actorNameData) -> Result<Actor, HttpError> in
                guard let actorDictionary = try? NSJSONSerialization.JSONObjectWithData(actorNameData, options: [])
                else {
                    return Result.Failure(HttpError.BadRequest)
                }
                let actorName = actorDictionary["name"] as! String
                return Result.Success(Actor(name: actorName))
            }
            .mapError { _ in RepositoryError.FetchFailure }
    }
}
