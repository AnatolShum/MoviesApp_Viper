//
//  Movie.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 04/09/2023.
//

import Foundation
import SwiftData

@Model
class Movie: Codable, Identifiable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case backdrop = "backdrop_path"
        case poster = "poster_path"
        case releaseDate = "release_date"
        case overview
        case vote = "vote_average"
    }
    
    var title: String?
    var id: Int?
    var backdrop: String?
    var poster: String?
    var releaseDate: String?
    var overview: String?
    var vote: Double?
    var category: String?
    
    init(title: String?, id: Int?, backdrop: String?, poster: String?, releaseDate: String?, overview: String?, vote: Double?) {
        self.title = title
        self.id = id
        self.backdrop = backdrop
        self.poster = poster
        self.releaseDate = releaseDate
        self.overview = overview
        self.vote = vote
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String?.self, forKey: .title)
        id = try container.decode(Int?.self, forKey: .id)
        backdrop = try container.decode(String?.self, forKey: .backdrop)
        poster = try container.decode(String?.self, forKey: .poster)
        releaseDate = try container.decode(String?.self, forKey: .releaseDate)
        overview = try container.decode(String?.self, forKey: .overview)
        vote = try container.decode(Double?.self, forKey: .vote)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(backdrop, forKey: .backdrop)
        try container.encode(poster, forKey: .poster)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(overview, forKey: .overview)
        try container.encode(vote, forKey: .vote)
    }
    
}
