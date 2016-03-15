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
            .mapError { _ in RepositoryError.FetchFailure }
            .flatMap { (actorNameData) -> Result<Actor, RepositoryError> in
                return self.parse(actorNameData)
            }
    }

    private func parse(data: NSData) -> Result<Actor, RepositoryError> {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            let actorDictionary = json as? [String: String],
            let actorName = actorDictionary["name"]
            else {
                return Result.Failure(RepositoryError.FetchFailure)
        }

        return Result.Success(Actor(name: actorName))
    }
}
