//
//  Movie.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let rating: Double
    let coverImageURL: String
    let releaseDate: String
    var isFavorite: Bool
}
