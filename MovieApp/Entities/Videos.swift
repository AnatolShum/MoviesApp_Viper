//
//  Videos.swift
//  MoviesApp
//
//  Created by Anatolii Shumov on 08/09/2023.
//

import Foundation
import SwiftData

@Model
class Videos: Codable, Identifiable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case key
        case site
        case type
        case official
    }
    
    var key: String?
    var site: String?
    var type: String?
    var official: Bool?
    
    init(key: String?, site: String?, type: String?, official: Bool?) {
        self.key = key
        self.site = site
        self.type = type
        self.official = official
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String?.self, forKey: .key)
        site = try container.decode(String?.self, forKey: .site)
        type = try container.decode(String?.self, forKey: .type)
        official = try container.decode(Bool?.self, forKey: .official)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(site, forKey: .site)
        try container.encode(type, forKey: .type)
        try container.encode(official, forKey: .official)
    }
}
