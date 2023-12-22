//
//  HStack.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import Foundation
import UIKit

class HStack: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alignment = .leading
        self.axis = .horizontal
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
