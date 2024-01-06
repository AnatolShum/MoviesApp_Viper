//
//  MoviesTrailerCellDelegate.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 05/01/2024.
//

import Foundation

extension MoviesController: MovieTrailerCellDelegate {
    func playTrailer(key: String) {
        presenter?.playTrailer(key: key)
    }
}
