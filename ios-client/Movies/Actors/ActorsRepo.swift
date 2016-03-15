import BrightFutures
import Foundation

struct ActorsRepo {
    let http: Http

    func getAll() -> Future<String, RepositoryError> {
        return http.get("/actors") // Future<NSData, HttpError>
            .map { (actorNameData) -> String in
                return String(data: actorNameData, encoding: NSUTF8StringEncoding)!
            }
            .mapError { error in
                return RepositoryError.FetchFailure
            }
    }
}
