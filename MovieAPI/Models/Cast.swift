//
//  Cast.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import Foundation

struct Cast: Decodable {
    let castId: Int
    let character: String
    let creditId: String
    let gender: Int
    let id: Int
    let name: String
    let order: Int
    var profilePath: String?
    let date: Date
}
