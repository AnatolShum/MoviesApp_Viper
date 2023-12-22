//
//  Trailer.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 21/12/2023.
//

import Foundation
import UIKit

struct Trailer: Equatable, Hashable {
    let title: String?
    var trailerImage: UIImage?
    var videoKey: String?
    var noTrailerImage: UIImage? {
        videoKey == nil ? UIImage(systemName: "play.slash.fill")! : nil
    }
}
