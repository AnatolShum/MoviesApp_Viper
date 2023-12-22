//
//  MoviesFooterDelegate.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 22/12/2023.
//

import Foundation

extension MoviesController: FooterViewDelegate {
    func pushTrailersController() {
        presenter?.showTrailers()
    }
}
