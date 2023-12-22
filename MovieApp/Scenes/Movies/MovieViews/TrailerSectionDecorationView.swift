//
//  TrailerSectionDecorationView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 21/12/2023.
//

import UIKit

class TrailerSectionDecorationView: UICollectionReusableView {
    static let reuseIdentifier = "TrailerSectionDecorationView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
