//
//  MovieService.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation
import ReactiveSwift

private let nowPlayingQuery = QueryLink.shared.nowPlaying
private var coverImageHeaderQuery = QueryLink.shared.coverImageHeader
private var detailImageHeaderQuery = QueryLink.shared.detailImageHeader
private let searchQuery = QueryLink.shared.search

struct Movies: Decodable {
    var results: [MovieResult]
}

struct MovieResult: Decodable {
    var id: Int
    var title: String
    var voteAverage: Double
    var posterPath: String?
    var backdropPath: String?
    var overview: String
    var releaseDate: String
}

enum MoviePropertyType {
    case detail
    case cast
    case image
}


protocol MovieServiceProtocol {
    func fetchMovies() -> SignalProducer<[Movie], Error>
    func searchMovies(_ searchKey: String) -> SignalProducer<[Movie], Error>
    func fetchMovieDetail(id: Int) -> SignalProducer<MovieDetail, Error>
    var currentMoviePage: Int { get set }
}

class MovieService: MovieServiceProtocol {

    private var resourceURL: URL?
    var currentMoviePage = 1

    fileprivate func handleURLSession(_ resourceURL: URL, _ observer: Signal<[Movie], Error>.Observer) {
        URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in

            if let data = data {
                var movies = [Movie]()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let jsonData = try decoder.decode(Movies.self, from: data)
                  
                    jsonData.results.forEach { (movieResult) in
                        var coverImageURL: String?

                        if let posterPath = movieResult.posterPath {
                            coverImageURL = coverImageHeaderQuery + posterPath
                        }


                        let movie = Movie(id: movieResult.id,
                                          title: movieResult.title,
                                          rating: movieResult.voteAverage,
                                          coverImageURL: coverImageURL ?? "",
                                          releaseDate: movieResult.releaseDate, isFavorite: false
                                          )

                        movies.append(movie)
                    }

                    observer.send(value: movies)
                    observer.sendCompleted()
                } catch {
                    observer.sendCompleted()
                }

            } else {
                observer.sendCompleted()
            }

        }.resume()
    }

    func fetchMovies() -> SignalProducer<[Movie], Error> {

        resourceURL = URL(string: nowPlayingQuery + "\(currentMoviePage)")

        return SignalProducer { [weak self] observer, _ in
            guard let resourceURL = self?.resourceURL else {
                observer.sendCompleted()
                return
            }
            self?.handleURLSession(resourceURL, observer)
        }
    }

    func searchMovies(_ searchKey: String) -> SignalProducer<[Movie], Error> {
        return SignalProducer { [weak self] observer, _ in
            let transformSearchKey = searchKey.replacingOccurrences(of: " ", with: "%20")

            guard let resourceURL = URL(string: searchQuery + transformSearchKey) else {
                observer.sendCompleted()
                return
            }

            self?.handleURLSession(resourceURL, observer)
        }
    }

    func fetchMovieDetail(id: Int) -> SignalProducer<MovieDetail, Error> {

        return SignalProducer { observer, _ in
            guard let resourceURL = URL(string: QueryLink.shared.movieDetail(id: id)) else {
                print("unvalid URL for movie detail")
                observer.sendCompleted()
                return
            }

            URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    observer.send(error: error)
                    observer.sendCompleted()
                }


                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                        observer.send(value: movieDetail)
                        observer.sendCompleted()
                    } catch {
                        observer.sendCompleted()
                    }

                } else {
                    observer.sendCompleted()
                }

            }.resume()
        }
    }
}
