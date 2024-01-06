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
    
    func interactorDidFetchMovies()
    func interactorDidFetchImage()
    func showTrailers()
    func showMovieDetails(_ movie: Movie)
    func showTrailerDetails(_ trailer: Trailer)
    func playTrailer(key: String)
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
    var view: MoviesViewProtocol?
    
    var upcomingPage: Int = 1
    var nowPlayingPage: Int = 1
    var topRatedPage: Int = 1
    var popularPage: Int = 1
    
    required init(_ view: MoviesViewProtocol) {
        self.view = view
    }
    
    func interactorDidFetchMovies() {
        self.view?.applyDataSource()
    }
    
    func interactorDidFetchImage() {
        self.view?.snapshot.deleteItems(Array(Item.trailers.values))
        self.view?.snapshot.deleteSections([.trailer])
        self.view?.snapshot.insertSections([.trailer], beforeSection: .nowPlaying)
        self.view?.snapshot.appendItems(Array(Item.trailers.values), toSection: .trailer)
        self.view?.dataSource.apply(self.view!.snapshot)
    }
    
    func showTrailers() {
        router?.openTrailersView()
    }
    
    func showMovieDetails(_ movie: Movie) {
        router?.openMovieDetailView(movie)
    }
    
    func showTrailerDetails(_ trailer: Trailer) {
        router?.openTrailerDetails(trailer)
    }
    
    func playTrailer(key: String) {
        router?.playTrailer(key: key)
    }
    
}
