//
//  MoviesInteractor.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import Foundation
import UIKit
import Combine
import SwiftData

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
    private var dbService = DatabaseService.shared
    
    func fetchUpcoming(with page: Int) {
        let category: String = Category.upcoming.toString
        
        Network.Client.shared.get(.upcoming(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let tenMovies = Array(data.results.prefix(10))
                let entities = tenMovies.map { (movie: Movie) -> Entities in
                    let movieToSave = movie
                    movieToSave.category = category
                    
                    self.updateImage(movieToSave)
                    
                    return .movie(movieToSave)
                }
                
                self.output?.fetchUpcomingSuccess(upcomingMovies: entities)
                self.setTrailers(tenMovies)
            case .failure(let failure):
                print(failure)
                
                let predicate = #Predicate<Movie> { $0.category == category }
                self.dbService.fetchItems(predicate: predicate) { (result: Result<[Movie], Error>) in
                    switch result {
                    case .success(let movies):
                        print("Fetched movies from db \(movies.count)")
                        let entities = movies.map { (movie: Movie) -> Entities in
                            return .movie(movie)
                        }
                        self.output?.fetchUpcomingSuccess(upcomingMovies: entities)
                        self.loadTrailerFromDB()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    private func updateImage(_ movie: Movie) {
        let movieToSave = movie
        Network.Client.shared.fetchImage(with: movie.poster) { result in
            switch result {
            case .success(let image):
                movieToSave.imageData = image.toString()
                self.saveItemToDb(movieToSave)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func saveItemToDb(_ movie: Movie) {
        if !self.dbService.isItemExist(item: movie) {
            self.dbService.saveItem(movie)
        }
    }
    
    private func setTrailers(_ movies: [Movie]) {
        movies.forEach { movie in
            guard let id = movie.id else { return }
            let title = movie.title
            let trailer = Trailer(id: id, title: title, imagePath: nil, imageData: nil, videoKey: nil)
            if !self.dbService.isItemExist(item: trailer) {
                self.dbService.saveItem(trailer)
            }
            
            self.trailerGroup.enter()
            self.fetchPhotos(trailer)
            
            self.trailerGroup.enter()
            self.fetchVideos(trailer)
        }
        
        self.trailerGroup.notify(queue: .main) {
            self.loadTrailerFromDB()
        }
    }
    
    private func loadTrailerFromDB() {
        self.dbService.fetchItems(predicate: nil) { (result: Result<[Trailer], Error>) in
            switch result {
            case .success(let trailers):
                let entities = trailers.compactMap { (trailer: Trailer) -> Entities? in
                    if self.isTrailersFull(trailer) {
                        return .trailer(trailer)
                    } else {
                        self.dbService.deleteItems(trailer)
                        return nil
                    }
                }
                
                self.output?.fetchTrailersSuccess(trailers: entities)
            case .failure(let error):
                self.output?.fetchTrailersFailure(error: error)
                print(error)
            }
        }
    }
    
    private func isTrailersFull(_ trailer: Trailer) -> Bool {
        return trailer.title != nil && trailer.imagePath != nil && trailer.videoKey != nil
    }
    
    private func fetchPhotos(_ trailer: Trailer) {
        Network.Client.shared.get(.photos(id: trailer.id)) { [weak self] (result: Result<Network.Types.Response.Backdrops, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let trailerToSave = trailer
                let photos = data.backdrops
                let path = self.chooseFirstPhoto(photos)
                trailerToSave.imagePath = path
                
                Network.Client.shared.fetchImage(with: path) { result in
                    switch result {
                    case .success(let image):
                        let data = image.pngData()
                        trailerToSave.imageData = data
                        self.trailerGroup.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.trailerGroup.leave()
                    }
                }
            case .failure(let error):
                self.trailerGroup.leave()
                print(error.localizedDescription)
            }
        }
    }
    
    typealias PhotoPath = String?
    private func chooseFirstPhoto(_ photos: [Photos]) -> PhotoPath {
        return photos.first?.path
    }
    
    private func fetchVideos(_ trailer: Trailer) {
        Network.Client.shared.get(.videos(id: trailer.id)) { [weak self] (result: Result<Network.Types.Response.VideoResults, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let videos = data.results
                let key = self.videoKey(videos)
                let trailerToSave = trailer
                trailerToSave.videoKey = key
                self.trailerGroup.leave()
            case .failure(let error):
                self.trailerGroup.leave()
                print(error.localizedDescription)
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
        let category: String = Category.nowPlaying.toString
        Network.Client.shared.get(.nowPlaying(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let entities = data.results.map { (movie: Movie) -> Entities in
                    let movieToSave = movie
                    movieToSave.category = category
                    
                    self.updateImage(movieToSave)
                    
                    return .movie(movieToSave)
                }
                self.output?.fetchNowPlayingSuccess(nowPlayingMovies: entities)
            case .failure(let error):
                self.output?.fetchNowPlayingFailure(error: error)
                print(error.localizedDescription)
                
                let predicate = #Predicate<Movie> { $0.category == category }
                self.dbService.fetchItems(predicate: predicate) { (result: Result<[Movie], Error>) in
                    switch result {
                    case .success(let success):
                        let entities = success.map { (movie: Movie) -> Entities in
                            return .movie(movie)
                        }
                        
                        self.output?.fetchNowPlayingSuccess(nowPlayingMovies: entities)
                    case .failure(let error):
                        self.output?.fetchNowPlayingFailure(error: error)
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchTopRated(with page: Int) {
        let category: String = Category.topRated.toString
        Network.Client.shared.get(.topRated(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let entities = data.results.map { (movie: Movie) -> Entities in
                    let movieToSave = movie
                    movieToSave.category = category
                    
                    self.updateImage(movieToSave)
                    
                    return .movie(movieToSave)
                }
                self.output?.fetchTopRatedSuccess(topRatedMovies: entities)
            case .failure(let error):
                self.output?.fetchNowPlayingFailure(error: error)
                print(error.localizedDescription)
                
                let predicate = #Predicate<Movie> { $0.category == category }
                self.dbService.fetchItems(predicate: predicate) { (result: Result<[Movie], Error>) in
                    switch result {
                    case .success(let success):
                        let entities = success.map { (movie: Movie) -> Entities in
                            return .movie(movie)
                        }
                        self.output?.fetchTopRatedSuccess(topRatedMovies: entities)
                    case .failure(let error):
                        self.output?.fetchTopRatedFailure(error: error)
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchPopular(with page: Int) {
        let category: String = Category.popular.toString
        Network.Client.shared.get(.popular(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let entities = data.results.map { (movie: Movie) -> Entities in
                    let movieToSave = movie
                    movieToSave.category = category
                    
                    self.updateImage(movieToSave)
                    
                    return .movie(movieToSave)
                }
                self.output?.fetchPopularSuccess(popularMovies: entities)
            case .failure(let error):
                self.output?.fetchNowPlayingFailure(error: error)
                print(error.localizedDescription)
                
                let predicate = #Predicate<Movie> { $0.category == category }
                self.dbService.fetchItems(predicate: predicate) { (result: Result<[Movie], Error>) in
                    switch result {
                    case .success(let success):
                        let entities = success.map { (movie: Movie) -> Entities in
                            return .movie(movie)
                        }
                        self.output?.fetchPopularSuccess(popularMovies: entities)
                    case .failure(let error):
                        self.output?.fetchPopularFailure(error: error)
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchMovieById(id: Int) {
        let predicate = #Predicate<Movie> { $0.id == id }
        dbService.fetchItems(predicate: predicate) { [weak self] result in
            switch result {
            case .success(let movies):
                if movies.count > 0 {
                    self?.output?.fetchedMovieById(movie: movies.first!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
