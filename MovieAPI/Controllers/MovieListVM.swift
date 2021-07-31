//
//  MovieListVM.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation
import ReactiveSwift

class MovieListVM {

    private var disposes = CompositeDisposable()
    private(set) var movies = MutableProperty<[Movie]>([])
    private var service: MovieServiceProtocol?
    private(set) var isPaginating = true

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return movies.value.count
    }

    func movieAtIndex(_ index: Int) -> Movie {
        return movies.value[index]
    }

    func setIsPaginating(value: Bool) {
        isPaginating = value
    }

    func fetchMovies() {
        service?.currentMoviePage = 1
        disposes += service?.fetchMovies()
            .observe(on: UIScheduler())
            .startWithResult{ [weak self] (result) in
                switch result {
                case .success(let movies):
                    self?.movies.value = movies
                    self?.isPaginating = false
                case .failure(let error):
                    print(error)

                }
            }
    }

    func fetchMoreMovies() {
        service?.currentMoviePage += 1
        disposes += service?.fetchMovies()
            .observe(on: UIScheduler())
            .startWithResult{ [weak self] (result) in
                switch result {
                case .success(let movies):
                    self?.movies.value.append(contentsOf: movies)
                    self?.isPaginating = false

                case .failure(let error):
                    print(error)
                }
            }
    }

    func clearObservation() {
        disposes.dispose()
    }
}

struct MovieVM {
    private(set) var movie: Movie

    var title: String {
        return movie.title
    }

    var rating: String {
        return "\(movie.rating)"
    }

    var releaseDate: String {
        return movie.releaseDate
    }

    var coverImageURL: String {
        return movie.coverImageURL
    }
}







