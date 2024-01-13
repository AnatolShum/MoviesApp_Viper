//
//  Trailer.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 21/12/2023.
//

import Foundation
import UIKit
import SwiftData

@Model
class Trailer: Equatable, Hashable {
    var id: Int
    var title: String?
    var imageData: Data?
    var videoKey: String?
    
    init(id: Int, title: String?, imageData: Data?, videoKey: String?) {
        self.id = id
        self.title = title
        self.imageData = imageData
        self.videoKey = videoKey
    }
}
