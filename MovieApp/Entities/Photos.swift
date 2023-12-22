//
//  Photos.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 07/09/2023.
//

import Foundation

struct Photos: Codable, Identifiable, Equatable, Hashable {
    let path: String?
    var id: String? {
        path
    }
    
    enum CodingKeys: String, CodingKey {
        case path = "file_path"
    }
}
