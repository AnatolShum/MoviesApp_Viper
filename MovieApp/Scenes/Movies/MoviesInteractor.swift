//
//  MoviesInteractor.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import Foundation
import UIKit

//Fetch movies / fetch images for cells / fetch upcoming, fetch images and use 1
// open detail pages through router
//entity

protocol MoviesInteractorProtocol: AnyObject {
    init(_ presenter: MoviesPresenterProtocol)
    func fetchUpcoming(with page: Int)
    func fetchNowPlaying(with page: Int)
    func fetchTopRated(with page: Int)
    func fetchPopular(with page: Int)
    func fetchMovieById(id: Int)
}

protocol MoviesInteractorOutputProtocol: AnyObject {
    func fetchTrailersSuccess(trailers: [Entities])
    func fetchTrailersFailure(error: Error)
    func fetchUpcomingSuccess(upcomingMovies: [Entities])
    func fetchUpcomingFailure(error: Error)
    func fetchNowPlayingSuccess(nowPlayingMovies: [Entities])
    func fetchNowPlayingFailure(error: Error)
    func fetchTopRatedSuccess(topRatedMovies: [Entities])
    func fetchTopRatedFailure(error: Error)
    func fetchPopularSuccess(popularMovies: [Entities])
    func fetchPopularFailure(error: Error)
    func fetchedMovieById(movie: Movie)
}

class MoviesInteractor: MoviesInteractorProtocol {
    weak var presenter: MoviesPresenterProtocol?
    weak var output: MoviesInteractorOutputProtocol?
    
    required init(_ presenter: MoviesPresenterProtocol) {
        self.presenter = presenter
    }
    
    private var trailerGroup = DispatchGroup()
    
    private var service = DatabaseService.shared
    
    func fetchUpcoming(with page: Int) {
        Network.Client.shared.get(.upcoming(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self = self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        success.results.forEach { movie in
                            let movieToSave = movie
                            movieToSave.category = self.setMovieCategory(.upcoming)
                            if !self.service.checkIfItemInDb(category: .upcoming, id: movieToSave.id!) {
                                self.service.saveItem(.movie(movieToSave))
                            }
                        }
                        
                        self.service.fetchItems(category: .upcoming) { data, error in
                            if let error {
                                self.output?.fetchUpcomingFailure(error: error)
                            }
                            if let data {
                                let movies = data as! [Movie]
//                                movies.forEach { self.service.deleteItems(.movie($0)) }  /// Temp delete all DB items
                                var upcomingMovies: [Entities] = []
                                movies.forEach { upcomingMovies.append(.movie($0)) }
                                self.output?.fetchUpcomingSuccess(upcomingMovies: upcomingMovies)
                                let tenMovies = Array(movies.prefix(10))
                                self.setTrailers(tenMovies)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    private func setMovieCategory(_ category: Categories) -> String {
        return category.identifier
    }
    
    private func setTrailers(_ movies: [Movie]) {
            movies.forEach { movie in
                guard let id = movie.id else { return }
                let title = movie.title
                let trailer = Trailer(id: id, title: title, imageData: nil, videoKey: nil)
                DispatchQueue.main.async {
                    if !self.service.checkIfItemInDb(category: .trailers, id: id) {
                        self.service.saveItem(.trailer(trailer))
                    }
                }
                
                self.trailerGroup.enter()
                self.fetchPhotos(trailer)
                
                self.trailerGroup.enter()
                self.fetchVideos(trailer)
            }
        
        self.trailerGroup.wait()
        
        self.trailerGroup.notify(queue: .main) {
            self.service.fetchItems(category: .trailers) { data, error in /// check if it's need
            if let error {
                self.output?.fetchTrailersFailure(error: error)
            }
            if let data {
                let trailers = data as! [Trailer]
//                trailers.forEach { self.service.deleteItems(.trailer($0)) } /// Temp delete all DB items
                var entityTrailers: [Entities] = []
                trailers.forEach { trailer in
                    self.isTrailersFull(trailer) ? entityTrailers.append(.trailer(trailer)) : self.service.deleteItems(.trailer(trailer)) }
                self.output?.fetchTrailersSuccess(trailers: entityTrailers)
            }
        }
        }
    }
    
    private func isTrailersFull(_ trailer: Trailer) -> Bool {
        return trailer.title != nil && trailer.imageData != nil && trailer.videoKey != nil
    }
    
    private func fetchPhotos(_ trailer: Trailer) {
        let id = trailer.id
        Network.Client.shared.get(.photos(id: id)) { [weak self] (result: Result<Network.Types.Response.Backdrops, Network.Errors>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let photos = success.backdrops
                let path = self.chooseFirstPhoto(photos)
                self.fetchImage(path: path, trailer: trailer)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    typealias PhotoPath = String?
    private func chooseFirstPhoto(_ photos: [Photos]) -> PhotoPath {
        return photos.first?.path
    }
    
    private func fetchImage(path: String?, trailer: Trailer) {
        Task {
            do {
                let backdrop = try await Network.Client.shared.fetchImage(with: path)
                let data = backdrop.pngData()
                DispatchQueue.main.async {
                    self.service.updateTrailer(trailer: trailer, newImageData: data, newKey: nil)
                }
                self.trailerGroup.leave()
            } catch {
                print(error.localizedDescription)
                self.trailerGroup.leave()
            }
        }
    }
   
    private func fetchVideos(_ trailer: Trailer) {
        let id = trailer.id
        Network.Client.shared.get(.videos(id: id)) { [weak self] (result: Result<Network.Types.Response.VideoResults, Network.Errors>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let videos = success.results
                let key = self.videoKey(videos)
                DispatchQueue.main.async {
                    self.service.updateTrailer(trailer: trailer, newImageData: nil, newKey: key)
                }
                self.trailerGroup.leave()
            case .failure(let failure):
                print(failure.localizedDescription)
                self.trailerGroup.leave()
            }
        }
    }
    
    typealias TrailerKey = String?
    private func videoKey(_ videos: [Videos]) -> TrailerKey {
        guard !videos.isEmpty else {
            return nil }
        
        let firstVideo = videos.first
        let firstKey = firstVideo?.key
        guard firstVideo != nil else {
            return nil }
        
        let filteredVideo = videos.first { $0.official == true && $0.type == "Trailer" && $0.site == "YouTube" }
        guard filteredVideo != nil else { return firstKey }
        
        return filteredVideo?.key
    }
    
    func fetchNowPlaying(with page: Int) {
        Network.Client.shared.get(.nowPlaying(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                        success.results.forEach { movie in
                            let movieToSave = movie
                            movieToSave.category = self.setMovieCategory(.nowPlaying)
                            if !self.service.checkIfItemInDb(category: .nowPlaying, id: movieToSave.id!) {
                                self.service.saveItem(.movie(movieToSave))
                            }
                        }
                    
                    self.service.fetchItems(category: .nowPlaying) { data, error in
                        if let error {
                            self.output?.fetchNowPlayingFailure(error: error)
                        }
                        if let data {
                            let movies = data as! [Movie]
//                            movies.forEach { self.service.deleteItems(.movie($0)) }  /// Temp delete all DB items
                            var nowPlayingMovies: [Entities] = []
                            movies.forEach { nowPlayingMovies.append(.movie($0)) }
                            self.output?.fetchNowPlayingSuccess(nowPlayingMovies: nowPlayingMovies)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTopRated(with page: Int) {
        Network.Client.shared.get(.topRated(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                        success.results.forEach { movie in
                            let movieToSave = movie
                            movieToSave.category = self.setMovieCategory(.topRated)
                            if !self.service.checkIfItemInDb(category: .topRated, id: movieToSave.id!) {
                                self.service.saveItem(.movie(movieToSave))
                            }
                        }
                    
                    self.service.fetchItems(category: .topRated) { data, error in
                        if let error {
                            self.output?.fetchTopRatedFailure(error: error)
                        }
                        if let data {
                            let movies = data as! [Movie]
//                            movies.forEach { self.service.deleteItems(.movie($0)) }  /// Temp delete all DB items
                            var topRatedMovies: [Entities] = []
                            movies.forEach { topRatedMovies.append(.movie($0)) }
                            self.output?.fetchTopRatedSuccess(topRatedMovies: topRatedMovies)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchPopular(with page: Int) {
        Network.Client.shared.get(.popular(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                        success.results.forEach { movie in
                            let movieToSave = movie
                            movieToSave.category = self.setMovieCategory(.popular)
                            if !self.service.checkIfItemInDb(category: .popular, id: movieToSave.id!) {
                                self.service.saveItem(.movie(movieToSave))
                            }
                        }
                    
                    self.service.fetchItems(category: .popular) { data, error in
                        if let error {
                            self.output?.fetchPopularFailure(error: error)
                        }
                        if let data {
                            let movies = data as! [Movie]
//                            movies.forEach { self.service.deleteItems(.movie($0)) }  /// Temp delete all DB items
                            var popularMovies: [Entities] = []
                            movies.forEach { popularMovies.append(.movie($0)) }
                            self.output?.fetchPopularSuccess(popularMovies: popularMovies)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchMovieById(id: Int) {
        DispatchQueue.main.async {
            self.service.filterMovie(id: id) { [weak self] movies, error in
                if let error {
                    print(error)
                }
                if let movies {
                    if movies.count > 0 {
                        self?.output?.fetchedMovieById(movie: movies.first!)
                    }
                }
            }
        }
    }
    
}
