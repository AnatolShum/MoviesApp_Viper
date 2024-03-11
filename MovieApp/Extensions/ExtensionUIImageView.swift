//
//  ExtensionUIImageView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 11.03.2024.
//

import Foundation
import UIKit

extension UIImageView {
    public var subscribeImage: UIImage? {
        get {
            return self.image
        }
        set {
            self.image = newValue
        }
    }
}
