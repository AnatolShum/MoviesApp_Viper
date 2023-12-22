//
//  FooterView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func pushTrailersController()
}

class FooterView: UICollectionReusableView {
    static let reuseIdentifier = "FooterView"
    
    weak var delegate: FooterViewDelegate?
    
    private let buttonTitle = "Browse trailers >"
    
    private let browseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        addSubview(browseButton)
        browseButton.setTitle(buttonTitle, for: .normal)
        browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            browseButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            browseButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            browseButton.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
            browseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc func browseButtonTapped() {
        delegate?.pushTrailersController()
    }
}
