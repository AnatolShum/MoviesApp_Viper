//
//  Item.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 04/10/2023.
//

import Foundation

    enum Item: Hashable {
        case nowPlaying(Movie)
        case topRated(Movie)
        case popular(Movie)
        case trailer(Trailer)
        
        var nowPlaying: Movie? {
            if case .nowPlaying(let nowPlaying) = self {
                return nowPlaying
            } else {
                return nil
            }
        }
        
        var topRated: Movie? {
            if case .topRated(let topRated) = self {
                return topRated
            } else {
                return nil
            }
        }
        
        var popular: Movie? {
            if case .popular(let popular) = self {
                return popular
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
        
        static var nowPlayingMovies: [Item] = []
        static var topRatedMovies: [Item] = []
        static var popularMovies: [Item] = []
        typealias ID = Int
        static var trailers: [ID: Item] = [:]
        
        mutating func updateTrailers(with newTrailer: Trailer) {
            if case .trailer = self {
                self = .trailer(newTrailer)
            }
        }
    }
