//
//  MoviesAssembly.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 20/12/2023.
//

import Foundation
import UIKit

protocol MoviesAssemblyProtocol: AnyObject {
    func configure(viewController: MoviesController)
}

class MoviesAssembly: MoviesAssemblyProtocol {
    func configure(viewController: MoviesController) {
        let presenter = MoviesPresenter(viewController)
        let interactor = MoviesInteractor(presenter)
        let router = MoviesRouter(viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        presenter.router = router
    }
    
}
