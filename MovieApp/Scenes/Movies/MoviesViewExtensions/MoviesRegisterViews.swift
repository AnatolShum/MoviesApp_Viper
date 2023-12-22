//
//  MoviesRegisterViews.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 22/12/2023.
//

import Foundation

extension MoviesController {
    func registerViews() {
        collectionView.register(
            TrailerSectionDecorationView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.background,
            withReuseIdentifier: TrailerSectionDecorationView.reuseIdentifier)
        collectionView.register(MovieTrailerCell.self, forCellWithReuseIdentifier: MovieTrailerCell.reuseIdentifier)
        collectionView.register(
            FooterView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.footer,
            withReuseIdentifier: FooterView.reuseIdentifier)
        collectionView.register(
            SpaceView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.spacer,
            withReuseIdentifier: SpaceView.reuseIdentifier)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.header,
            withReuseIdentifier: HeaderView.reuseIdentifier)
    }
}
