//
//  Entities.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 04/10/2023.
//

import Foundation

enum Entities: Hashable {
    case movie(Movie)
    case photo(Photos)
    case video(Videos)
    case trailer(Trailer)
    
    var movie: Movie? {
        if case .movie(let movie) = self {
            return movie
        } else {
            return nil
        }
    }
    
    var photo: Photos? {
        if case .photo(let photo) = self {
            return photo
        } else {
            return nil
        }
    }
    
    var video: Videos? {
        if case .video(let video) = self {
            return video
        } else {
            return nil
        }
    }
    
    var trailer: Trailer? {
        if case .trailer(let trailer) = self {
            return trailer
        } else {
            return nil
        }
    }
}

enum Categories: String {
    case upcoming = "Upcoming movies"
    case nowPlaying = "Now playing movies"
    case topRated = "Top rated movies"
    case popular = "Popular movies"
    case photos
    case videos
    case trailers
    
    var identifier: String {
        return rawValue
    }
}
