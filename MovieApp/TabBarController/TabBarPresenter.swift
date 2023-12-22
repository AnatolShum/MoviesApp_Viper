//
//  TabBarPresenter.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import Foundation
import UIKit

protocol TabBarPresenterProtocol: AnyObject {
    var router: TabBarRouterProtocol? { get set }
    var interactor: TabBarInteractorProtocol? { get set }
    var view: TabBarProtocol? { get set }
}

class TabBarPresenter: TabBarPresenterProtocol {
    var router: TabBarRouterProtocol?
    var interactor: TabBarInteractorProtocol?
    var view: TabBarProtocol?
    
}
