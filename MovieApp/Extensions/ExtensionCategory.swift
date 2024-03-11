//
//  ExtensionCategory.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 11.03.2024.
//

import Foundation

extension MoviesInteractor {
    enum Category: String {
        case upcoming = "upcoming"
        case nowPlaying = "nowPlaying"
        case topRated = "topRated"
        case popular = "popular"
        
        var toString: String {
            return rawValue
        }
    }
}
