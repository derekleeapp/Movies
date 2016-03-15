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
                let actorDictionary = try! NSJSONSerialization.JSONObjectWithData(actorNameData, options: [])
                let actorName = actorDictionary["name"] as! String
                return Actor(name: actorName)
            }
            .mapError { _ in RepositoryError.FetchFailure }
    }
}
