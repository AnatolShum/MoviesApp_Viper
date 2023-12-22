//
//  TabBarController.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 02/10/2023.
//

import UIKit

protocol TabBarProtocol: AnyObject {
    var presenter: TabBarPresenterProtocol? { get set }
}

class TabBarController: UITabBarController, TabBarProtocol {
    var presenter: TabBarPresenterProtocol?
    
    private var moviesController: MoviesController!
    private var tvSeriesController: TVSeriesController!
    private var favouritesController: FavouritesController!
    private var searchController: SearchController!
    
    private var moviesNavigationController: UINavigationController!
    private var tvSeriesNavigationController: UINavigationController!
    private var favouritesNavigationController: UINavigationController!
    private var searchNavigationController: UINavigationController!
    
    private var navigationControllers: [UINavigationController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureTabBar()
        configureNavigationBars()
    }
    
    private func configureTabBar() {
        moviesController = MoviesController(collectionViewLayout: UICollectionViewFlowLayout())
        tvSeriesController = TVSeriesController(collectionViewLayout: UICollectionViewFlowLayout())
        favouritesController = FavouritesController(collectionViewLayout: UICollectionViewFlowLayout())
        searchController = SearchController()

        moviesNavigationController = UINavigationController(rootViewController: moviesController)
        tvSeriesNavigationController = UINavigationController(rootViewController: tvSeriesController)
        favouritesNavigationController = UINavigationController(rootViewController: favouritesController)
        searchNavigationController = UINavigationController(rootViewController: searchController)
        
        navigationControllers = [
            moviesNavigationController,
            tvSeriesNavigationController,
            favouritesNavigationController,
            searchNavigationController,
        ]
        
        self.viewControllers = navigationControllers
        
        let movieTabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), tag: 0)
        let tvSeriesTabBarItem = UITabBarItem(title: "TV Series", image: UIImage(systemName: "play.tv"), tag: 1)
        let favouritesTabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star"), tag: 2)
        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        moviesNavigationController.tabBarItem = movieTabBarItem
        tvSeriesNavigationController.tabBarItem = tvSeriesTabBarItem
        favouritesNavigationController.tabBarItem = favouritesTabBarItem
        searchNavigationController.tabBarItem = searchTabBarItem
    }
    
    private func configureNavigationBars() {
        navigationControllers.forEach { navigationController in
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
