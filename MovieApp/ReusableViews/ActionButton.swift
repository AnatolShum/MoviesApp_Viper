//
//  ActionButton.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    let title: String
    let color: UIColor
    
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = color
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
