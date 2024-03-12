//
//  LoadingView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 12.03.2024.
//

import UIKit

class LoadingView: UIViewController {
    let colorView = ColorView()
    
    private let indicator: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.style = .medium
        progress.color = .white
        progress.startAnimating()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        colorView.gradientLayer.frame = colorView.bounds
    }
    
    private func createUI() {
        view = colorView
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
