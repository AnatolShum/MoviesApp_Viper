//
//  HeaderView.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    let hStack = HStack()
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "poweron")
        image.tintColor = .systemYellow
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hStack)
        hStack.spacing = 5
        hStack.alignment = .leading
        hStack.addArrangedSubview(headerImage)
        hStack.addArrangedSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            hStack.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 30),
            headerImage.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        headerLabel.text = title
    }
    
}
