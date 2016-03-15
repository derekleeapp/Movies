import BrightFutures

struct ActorsRepo {
    let http: Http

    func getAll() -> Future<String, RepositoryError> {
        http.get("/actors")
        return Future<String, RepositoryError>(value: "Joe")
    }
}
