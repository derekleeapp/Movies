struct ActorsRepo {
    let http: Http

    func getAll() {
        http.get("/actors")
    }
}
