//
//  MovieDetail.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let status: String
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let backdropPath: String
    let genres: [Genres]
    let homepage: String
}

struct Genres: Decodable {
    let id: Int
    let name: String
}
