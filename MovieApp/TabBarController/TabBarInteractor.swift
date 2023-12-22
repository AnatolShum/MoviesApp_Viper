//
//  TabBarInteractor.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import Foundation
import UIKit

protocol TabBarInteractorProtocol: AnyObject {
    var presenter: TabBarPresenterProtocol? { get set }
}

class TabBarInteractor: TabBarInteractorProtocol {
    var presenter: TabBarPresenterProtocol?
    
}
