//
//  NetworkErrors.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 18/09/2023.
//

import Foundation

extension Network {
    
    enum Errors: Error, LocalizedError {
        case urlNotFound
        case responseError
        case imageNotFound
        case modelNotFound
        case pathNotFound
        case couldNotEncode
        case couldNotDecode
        case couldNotFetchData
    }
}
