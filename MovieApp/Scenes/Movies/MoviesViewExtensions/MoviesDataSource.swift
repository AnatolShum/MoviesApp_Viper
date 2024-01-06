//
//  MoviesDataSource.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 21/12/2023.
//

import Foundation
import UIKit

extension MoviesController {
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            
            switch section {
            case .trailer:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTrailerCell.reuseIdentifier, for: indexPath) as! MovieTrailerCell
                
                cell.configureCell(with: item.trailer!)
                cell.delegate = self
                
                return cell
            case .nowPlaying:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                
                cell.configureCell(with: item.nowPlaying!)
                
                return cell
            case .topRated:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                
                cell.configureCell(with: item.topRated!)
  
                return cell
            case .popular:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                
                cell.configureCell(with: item.popular!)
           
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.background:
                let backgroundView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.background, withReuseIdentifier: TrailerSectionDecorationView.reuseIdentifier, for: indexPath) as! TrailerSectionDecorationView
                
                return backgroundView
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionName: String!
                
                switch section {
                case .trailer:
                    sectionName = nil
                case .nowPlaying:
                    sectionName = "Now playing"
                case .topRated:
                    sectionName = "Top rated"
                case .popular:
                    sectionName = "Popular"
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SupplementaryViewKind.header,
                    withReuseIdentifier: HeaderView.reuseIdentifier,
                    for: indexPath) as! HeaderView
                headerView.setTitle(sectionName)
                
                return headerView
            case SupplementaryViewKind.footer:
                let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SupplementaryViewKind.footer,
                    withReuseIdentifier: FooterView.reuseIdentifier,
                    for: indexPath) as! FooterView
                footerView.delegate = self
                
                return footerView
            case SupplementaryViewKind.spacer:
                let spacerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SupplementaryViewKind.spacer,
                    withReuseIdentifier: SpaceView.reuseIdentifier,
                    for: indexPath) as! SpaceView
                
                return spacerView
            default:
                return nil
            }
        }
    }
    
    func applyDataSource() {
        snapshot.deleteSections([.trailer, .nowPlaying, .topRated, .popular])
        snapshot.deleteAllItems()
        
        snapshot.appendSections([.trailer, .nowPlaying, .topRated, .popular])
        snapshot.appendItems(Array(Item.trailers.values), toSection: .trailer)
        snapshot.appendItems(Item.nowPlayingMovies, toSection: .nowPlaying)
        snapshot.appendItems(Item.topRatedMovies, toSection: .topRated)
        snapshot.appendItems(Item.popularMovies, toSection: .popular)
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
