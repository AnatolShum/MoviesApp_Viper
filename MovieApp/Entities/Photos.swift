//
//  Photos.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 07/09/2023.
//

import Foundation
import SwiftData

@Model
class Photos: Codable, Identifiable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case path = "file_path"
    }
    
    var path: String?
    
    init(path: String?) {
        self.path = path
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        path = try container.decode(String?.self, forKey: .path)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
    }
}
