//
//  NetworkURL.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 18/09/2023.
//

import Foundation

extension Network {
    
    enum Argument {
        case movie(id: Int?)
        case videos(id: Int?)
        case photos(id: Int?)
        case search(query: String)
        case nowPlaying(page: Int)
        case topRated(page: Int)
        case popular(page: Int)
        case upcoming(page: Int)
        
        var url: URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.themoviedb.org"
            let apiParameter = "api_key"
            let apiValue = "82494d16f78e0aa1a4a03a103791b923"
            let apiQueryItem = URLQueryItem(name: apiParameter, value: apiValue)
            switch self {
            case .movie(id: let id):
                guard let id = id else { return nil }
                urlComponents.path = "/3/movie/\(id)"
                urlComponents.queryItems = [apiQueryItem]
            case .videos(id: let id):
                guard let id = id else { return nil }
                urlComponents.path = "/3/movie/\(id)/videos"
                urlComponents.queryItems = [apiQueryItem]
            case .photos(id: let id):
                guard let id = id else { return nil }
                urlComponents.path = "/3/movie/\(id)/images"
                urlComponents.queryItems = [apiQueryItem]
            case .search(query: let query):
                urlComponents.path = "/3/search/movie"
                urlComponents.queryItems = [
                apiQueryItem,
                URLQueryItem(name: "query", value: query)
                ]
            case .nowPlaying(page: let page):
                urlComponents.path = "/3/movie/now_playing"
                urlComponents.queryItems = [
                apiQueryItem,
                URLQueryItem(name: "page", value: "\(page)")
                ]
            case .topRated(page: let page):
                urlComponents.path = "/3/movie/top_rated"
                urlComponents.queryItems = [
                apiQueryItem,
                URLQueryItem(name: "page", value: "\(page)")
                ]
            case .popular(page: let page):
                urlComponents.path = "/3/movie/popular"
                urlComponents.queryItems = [
                apiQueryItem,
                URLQueryItem(name: "page", value: "\(page)")
                ]
            case .upcoming(page: let page):
                urlComponents.path = "/3/movie/upcoming"
                urlComponents.queryItems = [
                apiQueryItem,
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "sort_by", value: "release_date.desc"),
                URLQueryItem(name: "page", value: "\(page)"),
                ]
            }
            
            return urlComponents.url!
        }
    }
}


