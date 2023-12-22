//
//  ViewController.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 15/12/2023.
//

import UIKit

protocol MoviesViewProtocol {
    var presenter: MoviesPresenterProtocol? { get set }
    var sections: [MoviesSections] { get set }
    var dataSource: UICollectionViewDiffableDataSource<MoviesSections, Item>! { get set }
    var snapshot: NSDiffableDataSourceSnapshot<MoviesSections, Item> { get set }
    var nowPlayingPage: Int { get set }
    var topRatedPage: Int { get set }
    var popularPage: Int { get set }
    
    func applyDataSource()
}

class MoviesController: UICollectionViewController, MoviesViewProtocol {
    var presenter: MoviesPresenterProtocol?
    
    var sections = [MoviesSections]()
    var dataSource: UICollectionViewDiffableDataSource<MoviesSections, Item>!
    var snapshot = NSDiffableDataSourceSnapshot<MoviesSections, Item>()
    var nowPlayingPage: Int = 1
    var topRatedPage: Int = 1
    var popularPage: Int = 1
    
    private let assembly: MoviesAssemblyProtocol = MoviesAssembly()
    private let colorView = ColorView()
    
    
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
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        colorView.gradientLayer.frame = colorView.bounds
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        var movie: Movie?
        switch indexPath.section {
        case 1:
            movie = item?.nowPlaying
        case 2:
            movie = item?.topRated
        case 3:
            movie = item?.popular
        default:
            break
        }
        guard let movie = movie else { return }
        presenter?.showMovieDetails(movie)
    }
    
}

