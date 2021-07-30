//
//  QueryLink.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation

struct QueryLink {
    static let shared = QueryLink()
    private init() {}

    let nowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=f2f24e86fbed06fc3104ffa456c7d483&page="
    let search = "https://api.themoviedb.org/3/search/movie?api_key=f2f24e86fbed06fc3104ffa456c7d483&query="
    let coverImageHeader = "https://image.tmdb.org/t/p/w200"
    let detailImageHeader = "https://image.tmdb.org/t/p/original"

    func movieDetail(id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)?api_key=f2f24e86fbed06fc3104ffa456c7d483"
    }

}
