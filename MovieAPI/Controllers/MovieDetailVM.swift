//
//  MovieDetailVM.swift
//  MovieAPI
//
//  Created by ryan on 6/30/21.
//

import Foundation
import ReactiveSwift

class MovieDetailVM {

    private var disposes = CompositeDisposable()
    var movieDetail = MutableProperty<MovieDetail?>(nil)
    private var service: MovieServiceProtocol?

    init(service: MovieServiceProtocol) {
        self.service = service
    }

    func fetchMovieDetail(id: Int) {
        disposes += service?.fetchMovieDetail(id: id)
            .observe(on: UIScheduler())
            .startWithResult{ [weak self] (result) in
                switch result {
                case .success(let movieDetail):
                    self?.movieDetail.value = movieDetail
                case .failure(let error):
                    print(error)
                }
            }
    }

    func clearObservation() {
        disposes.dispose()
    }

    var id: Int {
        return movieDetail.value?.id ?? 0
    }

    var title: String {
        return movieDetail.value?.title ?? "No title"
    }

    var year: String {
        return movieDetail.value?.releaseDate ?? "unknown"
    }

    var titleAndYear: String {
        return "\(title) (\(year.components(separatedBy: "-")[0]))"
    }

    var detailImageUrl: String {
        return "https://image.tmdb.org/t/p/original\(movieDetail.value?.backdropPath ?? "")"
    }

    var overview: String {
        return movieDetail.value?.overview ?? "No overview"
    }

    var homepage: String {
        return movieDetail.value?.homepage ?? "No homepage"
    }

    var rating: Double {
        return movieDetail.value?.voteAverage ?? 0
    }
}
