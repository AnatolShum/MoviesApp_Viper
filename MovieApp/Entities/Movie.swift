//
//  Movie.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 04/09/2023.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable, Hashable {
    let title: String?
    let id: Int?
    let backdrop: String?
    let poster: String?
    let releaseDate: String?
    let overview: String?
    let vote: Double?
    
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case releaseDate = "release_date"
        case overview
        case vote = "vote_average"
    }
}
