
//  FavouriteManager.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 11/09/2023.


import Foundation

protocol ProtocolFavouriteManager: AnyObject {
    var delegate: ProtocolIsFavourites? { get set }
    func checkFavourite()
    func toggleFavourites()
}

class FavouriteManager: ProtocolFavouriteManager {
    
    weak var delegate: ProtocolIsFavourites?
    
    func checkFavourite() {
       
    }
    
    func toggleFavourites() {

    }
    
    private func addMovie(movieID: Int, userID: String) {
       
    }
    
    private func deleteMovie(dbID: String, userID: String) {
       
    }
}
