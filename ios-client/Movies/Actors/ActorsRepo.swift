import BrightFutures
import Foundation

struct Actor {
    var name: String
}

struct ActorsRepo {
    let http: Http

    func getAll() -> Future<Actor, RepositoryError> {
        return http.get("/actors") // Future<NSData, HttpError>
            .map { (actorNameData) -> Actor in
                let actorName = String(data: actorNameData, encoding: NSUTF8StringEncoding)!
                return Actor(name: actorName)
            }
            .mapError { _ in RepositoryError.FetchFailure }
    }
}
