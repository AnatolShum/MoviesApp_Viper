//
//  Videos.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 08/09/2023.
//

import Foundation

struct Videos: Codable, Identifiable, Equatable, Hashable {
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    var id: String? {
        key
    }
}
