//
//  MovieSearchVM.swift
//  MovieAPI
//
//  Created by ryan on 8/1/21.
//

import Foundation
import ReactiveSwift

enum SearchState {
    case begin
    case noResult
}

class MovieSearchVM {

    private var disposes = CompositeDisposable()
    private(set) var movies = MutableProperty<[Movie]>([])
    private let service: MovieServiceProtocol?
    var state: SearchState

    init(service: MovieServiceProtocol, state: SearchState) {
        self.service = service
        self.state = state
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        let numberOfRows = movies.value.count
        return numberOfRows
    }

    func movieAtIndex(_ index: Int) -> Movie {
        return movies.value[index]
    }

    func setTextResult() -> String {
        switch state {
        case .begin:
            return "Please type the movie you wanna search."
        case .noResult:
            return "There is no movie."
        }
    }

    func searchMovies(searchKey: String) {
        disposes += service?.searchMovies(searchKey)
            .observe(on: UIScheduler())
            .startWithResult{ [weak self] (result) in
                switch result {
                case .success(let movies):
                    let movieCount = self?.movies.value.count
                    if movieCount == 0 { self?.state = .noResult }
                    self?.movies.value = movies
                case .failure(let error):
                    print(error)
                }
            }
    }

    func clearObservation() {
        disposes.dispose()
    }
}
