//
//  TabBarRouter.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import UIKit

typealias Entry = UITabBarController

protocol TabBarRouterProtocol: AnyObject {
    var entry: Entry? { get }
    
    static func start() -> TabBarRouterProtocol
}

class TabBarRouter: TabBarRouterProtocol {
    var entry: Entry?
    
    static func start() -> TabBarRouterProtocol {
        let router = TabBarRouter()
        
        let view: TabBarProtocol = TabBarController()
        let presenter: TabBarPresenterProtocol = TabBarPresenter()
        let interactor: TabBarInteractorProtocol = TabBarInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = view
        
        router.entry = view as? Entry
        
        return router
    }
    
}
