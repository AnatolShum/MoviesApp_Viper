//
//  ViewController.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import UIKit

protocol MoviesViewProtocol {
    var presenter: MoviesPresenterProtocol? { get set }
    var trailers: [Entities] { get set }
    var nowPlayingMovies: [Entities] { get set }
    var topRatedMovies: [Entities] { get set }
    var popularMovies: [Entities] { get set }
    
    func trailerDataSource()
    func moviesDataSource(_ section: MoviesSections)
    func setMovie(_ movie: Movie)
}

class MoviesController: UICollectionViewController, MoviesViewProtocol {
    var presenter: MoviesPresenterProtocol?
    
    var sections = [MoviesSections]()
    var dataSource: UICollectionViewDiffableDataSource<MoviesSections, Entities>!
    var snapshot = NSDiffableDataSourceSnapshot<MoviesSections, Entities>()
    var filteredMovie: Movie? = nil
    
    private let assembly: MoviesAssemblyProtocol = MoviesAssembly()
    private let colorView = ColorView()
    
    var trailers: [Entities] = []
    var nowPlayingMovies: [Entities] = []
    var topRatedMovies: [Entities] = []
    var popularMovies: [Entities] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Movies"
        assembly.configure(viewController: self)
        collectionView.backgroundView = colorView
        collectionView.collectionViewLayout = createLayout()
        registerViews()
        configureDataSource()
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        colorView.gradientLayer.frame = colorView.bounds
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        var movie: Movie?
        switch indexPath.section {
        case 0:
            getMovie(item?.trailer)
            
            movie = self.filteredMovie
        case 1:
            movie = item?.movie
        case 2:
            movie = item?.movie
        case 3:
            movie = item?.movie
        default:
            break
        }
        guard let movie = movie else { return }
        presenter?.showMovieDetails(movie)
    }
    
    private func getMovie(_ trailer: Trailer?) {
        guard let id = trailer?.id else { return }
        presenter?.interactor?.fetchMovieById(id: id)
    }
    
    func setMovie(_ movie: Movie) {
        filteredMovie = movie
    }
   
}

