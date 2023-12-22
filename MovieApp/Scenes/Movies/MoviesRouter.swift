//
//  MoviesRouter.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import Foundation
import UIKit

protocol MoviesRouterProtocol: AnyObject {
    init(_ viewController: MoviesController)
    
    func openTrailersView()
    func openMovieDetailView(_ movie: Movie)
    func playTrailer()
}

class MoviesRouter: MoviesRouterProtocol {
    weak var viewController: MoviesController?
    
    private var trailersView: TrailersController!
    private var movieDetailView: MovieDetailController!
    
    required init(_ viewController: MoviesController) {
        self.viewController = viewController
    }
    
    func openTrailersView() {
        trailersView = TrailersController()
        viewController?.navigationController?.pushViewController(trailersView, animated: true)
    }
    
    func openMovieDetailView(_ movie: Movie) {
        movieDetailView = MovieDetailController(movie: movie)
        viewController?.navigationController?.pushViewController(movieDetailView, animated: true)
    }
    
    func playTrailer() {
        
    }
}
