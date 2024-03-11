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
    var imagePath: String?
    var imageData: Data?
    var videoKey: String?
    
    init(id: Int, title: String?, imagePath: String?, imageData: Data?, videoKey: String?) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.imageData = imageData
        self.videoKey = videoKey
    }
    
    func getImage() -> UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
