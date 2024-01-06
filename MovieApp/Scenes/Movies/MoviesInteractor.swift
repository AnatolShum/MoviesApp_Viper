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
}

class MoviesInteractor: MoviesInteractorProtocol {
    weak var presenter: MoviesPresenterProtocol?
    
    required init(_ presenter: MoviesPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchUpcoming(with page: Int) {
        Network.Client.shared.get(.upcoming(page: page)) { [weak self] (result: Result<Network.Types.Response.MovieResults, Network.Errors>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    let shortArray = Array(success.results.prefix(10))
                    self.setTrailers(shortArray)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setTrailers(_ movies: [Movie]) {
        movies.forEach { movie in
            guard let id = movie.id else { return }
            let title = movie.title
            let trailer = Trailer(title: title, trailerImage: nil, videoKey: nil)
            Item.trailers[id] = Item.trailer(trailer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchPhotos(id)
                self.fetchVideos(id)
            }
        }
        DispatchQueue.main.async {
            self.presenter?.interactorDidFetchMovies()
        }
    }
    
    private func fetchPhotos(_ id: Int) {
        Network.Client.shared.get(.photos(id: id)) { [weak self] (result: Result<Network.Types.Response.Backdrops, Network.Errors>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let photos = success.backdrops
                let path = self.chooseFirstPhoto(photos)
                self.fetchImage(path: path, id: id)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    typealias PhotoPath = String?
    private func chooseFirstPhoto(_ photos: [Photos]) -> PhotoPath {
        return photos.first?.path
    }
    
    private func fetchImage(path: String?, id: Int) {
        Task {
            do {
                let backdrop = try await Network.Client.shared.fetchImage(with: path)
                DispatchQueue.main.async {
                    guard var item = Item.trailers[id], var trailer = item.trailer else { return }
                    trailer.trailerImage = backdrop
                    item.updateTrailers(with: trailer)
                    Item.trailers[id] = item
                    
                    self.presenter?.interactorDidFetchImage()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchVideos(_ id: Int) {
        Network.Client.shared.get(.videos(id: id)) { [weak self] (result: Result<Network.Types.Response.VideoResults, Network.Errors>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    let videos = success.results
                    let key = self.videoKey(videos)
                    guard var item = Item.trailers[id], var trailer = item.trailer else { return }
                    trailer.videoKey = key
                    item.updateTrailers(with: trailer)
                    Item.trailers[id] = item
                }
            case .failure(let failure):
                print(failure.localizedDescription)
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
                        if !Item.nowPlayingMovies.contains(.nowPlaying(movie)) {
                            Item.nowPlayingMovies.append(.nowPlaying(movie))
                        }
                    }
                    self.presenter?.interactorDidFetchMovies()
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
                        if !Item.topRatedMovies.contains(.topRated(movie)) {
                            Item.topRatedMovies.append(.topRated(movie))
                        }
                    }
                    self.presenter?.interactorDidFetchMovies()
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
                        if !Item.popularMovies.contains(.popular(movie)) {
                            Item.popularMovies.append(.popular(movie))
                        }
                    }
                    self.presenter?.interactorDidFetchMovies()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
