//
//  MoviesPresenter.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import Foundation
import UIKit

//Use movies / Images .. to bild cells

protocol MoviesPresenterProtocol: AnyObject {
    init(_ view: MoviesViewProtocol)
    var router: MoviesRouterProtocol? { get set }
    var interactor: MoviesInteractorProtocol? { get set }
    var view: MoviesViewProtocol? { get set }
    var upcomingPage: Int { get set }
    var nowPlayingPage: Int { get set }
    var topRatedPage: Int { get set }
    var popularPage: Int { get set }
    
    func showTrailers()
    func showMovieDetails(_ movie: Movie)
    func playTrailer(key: String)
    func getMovie(id: Int)
}

class MoviesPresenter: MoviesPresenterProtocol {
    var router: MoviesRouterProtocol?
    var interactor: MoviesInteractorProtocol? {
        didSet {
            self.interactor?.fetchUpcoming(with: upcomingPage)
            self.interactor?.fetchNowPlaying(with: nowPlayingPage)
            self.interactor?.fetchTopRated(with: topRatedPage)
            self.interactor?.fetchPopular(with: popularPage)
        }
    }
    
    var upcomingPage: Int = 1
    var nowPlayingPage: Int = 1
    var topRatedPage: Int = 1
    var popularPage: Int = 1
    
    var view: MoviesViewProtocol?
        
    required init(_ view: MoviesViewProtocol) {
        self.view = view
    }
    
    func showTrailers() {
        router?.openTrailersView()
    }
    
    func showMovieDetails(_ movie: Movie) {
        router?.openMovieDetailView(movie)
    }
    
    func playTrailer(key: String) {
        router?.playTrailer(key: key)
    }
    
    func getMovie(id: Int) {
        interactor?.fetchMovieById(id: id)
    }
    
}

extension MoviesPresenter: MoviesInteractorOutputProtocol {
    func fetchNowPlayingSuccess(nowPlayingMovies: [Entities]) {
        view?.nowPlayingMovies = nowPlayingMovies
        view?.moviesDataSource(.nowPlaying)
    }
    
    func fetchTopRatedSuccess(topRatedMovies: [Entities]) {
        view?.topRatedMovies = topRatedMovies
        view?.moviesDataSource(.topRated)
    }
    
    func fetchPopularSuccess(popularMovies: [Entities]) {
        view?.popularMovies = popularMovies
        view?.moviesDataSource(.popular)
    }
    
    func fetchUpcomingSuccess(upcomingMovies: [Entities]) {
//        print(upcomingMovies.first?.movie?.title)
    }
    
    func fetchedMovieById(movie: Movie) {
        self.view?.setMovie(movie)
    }
    
    func fetchTrailersSuccess(trailers: [Entities]) {
        view?.trailers = trailers
        view?.trailerDataSource()
    }
    
    func fetchTrailersFailure(error: Error) {
        
    }
    
    
    func fetchUpcomingFailure(error: Error) {
        
    }
   
    func fetchPopularFailure(error: Error) {
        
    }
    
    func fetchTopRatedFailure(error: Error) {
        
    }
    
    func fetchNowPlayingFailure(error: Error) {
        
    }
    
}
