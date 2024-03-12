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
                
                cell.configureCell(with: item.movie!)
                
                return cell
            case .topRated:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                
                cell.configureCell(with: item.movie!)
  
                return cell
            case .popular:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                
                cell.configureCell(with: item.movie!)
           
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
    
    func trailerDataSource() {
        DispatchQueue.main.async {
            self.stopShowingLoadingView()
            let trailerSection: [MoviesSections] = [.trailer]
            let allCasesCount = MoviesSections.allCases.count
            let sectionCount = allCasesCount - trailerSection.count
            if self.snapshot.sectionIdentifiers.isEmpty {
                self.snapshot.appendSections(trailerSection)
            } else if self.snapshot.sectionIdentifiers.count == sectionCount {
                self.snapshot.insertSections(trailerSection, beforeSection: .nowPlaying)
            }
            
            self.snapshot.appendItems(self.trailers, toSection: .trailer)
            self.sections = self.snapshot.sectionIdentifiers
            self.dataSource.apply(self.snapshot)
        }
    }
    
    func moviesDataSource(_ section: MoviesSections) {
        DispatchQueue.main.async {
            let moviesSections: [MoviesSections] = [.nowPlaying, .topRated, .popular]
            let allCasesCount = MoviesSections.allCases.count
            let sectionCount = allCasesCount - moviesSections.count
            if self.snapshot.sectionIdentifiers.isEmpty {
                self.snapshot.appendSections(moviesSections)
            } else if self.snapshot.sectionIdentifiers.count == sectionCount {
                self.snapshot.insertSections(moviesSections, afterSection: .trailer)
            }
            
            switch section {
            case .nowPlaying:
                self.snapshot.appendItems(self.nowPlayingMovies, toSection: .nowPlaying)
            case .topRated:
                self.snapshot.appendItems(self.topRatedMovies, toSection: .topRated)
            case .popular:
                self.snapshot.appendItems(self.popularMovies, toSection: .popular)
            default:
                break
            }
            
            self.sections = self.snapshot.sectionIdentifiers
            self.dataSource.apply(self.snapshot)
        }
    }
    
}
